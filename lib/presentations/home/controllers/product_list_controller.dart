import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/api-client/api_endpoints.dart';
import '../../../core/export/ui_export.dart';
import '../../../core/utils/hive_boxes.dart';
import '../../../core/utils/variable.dart';
import '../../product/model/product_model.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../splash/controllers/common_controller.dart';
import '../model/category_model.dart';

class ProductListController extends GetxController {
  static ProductListController get to => Get.find();
  //
  final PagingController<int, ProductModel> pagingController =
      PagingController(firstPageKey: 1);

  /// ✅ search + filter
  String searchQuery = "";
  String? selectedCategory;
  String? selectedSubCategory;

  final RxBool hasFilter = false.obs;

  /// ✅ controller
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void onInit() {
    pagingController.addPageRequestListener((pageKey) {
      getProductListRequest(pageKey);
    });

    getCategoryListRequest();

    // ✅ Reset wholesale toggle for guests
    if (!CommonController.to.isLoggedIn.value) {
      selectedType.value = false;
    }

    //
    // ✅ Only listen for tax ID changes when logged in
    if (CommonController.to.isLoggedIn.value) {
      ever(ProfileController.to.taxIdUpdateTrigger, (_) {
        onTaxIdUpdated();
      });
    }
    super.onInit();
  }

  void resetAndReload() {
    selectedType.value = false;

    searchQuery = "";
    selectedCategory = null;
    selectedSubCategory = null;
    hasFilter.value = false;

    pagingController.refresh();
    getCategoryListRequest();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  final taxIDUpdated = false.obs;
  void onTaxIdUpdated() {
    taxIDUpdated.value = true;

    selectedType.value = false; // or recompute wholesale flag

    pagingController.refresh(); // 🔥 reload products

    searchQuery = "";
    selectedCategory = null;
    selectedSubCategory = null;
    hasFilter.value = false;
  }

  void applyFilters({
    String? search,
    String? category,
    String? subCategory,
  }) {
    searchQuery = search ?? "";
    selectedCategory = category;
    selectedSubCategory = subCategory;

    hasFilter.value = searchQuery.isNotEmpty ||
        selectedCategory != null ||
        selectedSubCategory != null;

    pagingController.refresh();
  }

  void clearFilters() {
    searchQuery = "";
    selectedCategory = null;
    selectedSubCategory = null;

    hasFilter.value = false;

    pagingController.refresh();
  }

  RxList<CategoryModel> catList = <CategoryModel>[].obs;
  final RxBool isLoadingMore = false.obs;
  RxBool isLoadingCategory = false.obs;
  RxBool isLoadingSubCategory = false.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalCategoryPages = 5.obs;
  final RxInt itemsPerPage = 10.obs;

  RxList<SubCategoryModel> subCategoryList = <SubCategoryModel>[].obs;

  Future<void> getCategoryListRequest({bool loadMore = false}) async {
    try {
      if (loadMore && currentPage.value >= totalCategoryPages.value) {
        return;
      }

      if (loadMore) {
        currentPage.value++;
        isLoadingMore.value = true;
      } else {
        isLoadingCategory.value = true;
        currentPage.value = 1;
      }
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService()
          .request(endpoint: catGetAllEndPoint, method: 'GET', queryParams: {
        'page': currentPage.value.toString(),
        'limit': itemsPerPage.value.toString(),
        'sort': 'updatedAt',
        'order': 'desc',
      });

      isLoadingCategory.value = false;
      isLoadingMore.value = false;
      if (response['success'] == true) {
        if (response['pagination'] != null) {
          currentPage.value = response['pagination']['currentPage'] ?? 1;
          totalCategoryPages.value =
              response['pagination']['totalPages'] ?? 1; // Add this line

          itemsPerPage.value = response['pagination']['itemsPerPage'] ?? 10;
        }
        final newCategories = (response['data'] as List)
            .map((e) => CategoryModel.fromJson(e))
            .toList();

        if (loadMore) {
          catList.addAll(newCategories); // Append for load more
        } else {
          catList.value = newCategories; // Replace for refresh
        }
        // logger.d(response);
      } else if (response['message'] == AppStaticStrings.noInternet) {
        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
          noInternet: true,
          retryTap: () {
            getCategoryListRequest();
          },
        );
      } else {
        //   logger.e(response);
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      //   logger.e(e.toString());
      isLoadingCategory.value = false;
    }
  }

  Future<void> getSubCategoryRequest({required CategoryModel category}) async {
    try {
      category.isLoadingSub.value = true; // 👈 only this category

      final response = await ApiService().request(
        endpoint: subCateGetAllEndPoint,
        method: 'GET',
        queryParams: {"category": category.sId ?? ''},
      );

      if (response['success'] == true) {
        subCategoryList.value = (response["data"] as List)
            .map((e) => SubCategoryModel.fromJson(e))
            .toList();
      } else {
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      // handle error if needed
    } finally {
      category.isLoadingSub.value = false; // 👈 reset only this
    }
  }

//

  Future<void> onRefresh() async {
    _requestGeneration++;
    selectedType.value = false;
    searchQuery = "";
    selectedCategory = null;
    selectedSubCategory = null;
    hasFilter.value = false;
    pagingController.refresh();
    await getCategoryListRequest();
  }

  final selectedType = RxBool(false);

// Add this to ProductListController
  int _requestGeneration = 0;

  void onTypeChanged(bool value) async {
    selectedType.value = value;

    // ✅ Invalidate any in-flight requests
    _requestGeneration++;
    final myGeneration = _requestGeneration;

    pagingController.refresh();

    if (value == true && !CommonController.to.isLoggedIn.value) {
      await Future.delayed(const Duration(milliseconds: 100));
      // ✅ Only set error if no newer request has started
      if (myGeneration == _requestGeneration) {
        pagingController.error = 'Please login to view wholesale products.';
      }
      return;
    }
  }

/*
  Future<void> getProductListRequest(int pageKey) async {
    debugPrint('📡 getProductListRequest called — pageKey: $pageKey');
    debugPrint('🛒 selectedType: ${selectedType.value}');
    debugPrint('🔐 isLoggedIn: ${CommonController.to.isLoggedIn.value}');
    debugPrint('📡 getProductListRequest called — pageKey: $pageKey');

    // ✅ Bail immediately — error will be set by onTypeChanged
    if (selectedType.value == true && !CommonController.to.isLoggedIn.value) {
      debugPrint('🚫 bailing out — not logged in');
      return;
    }

    //
    final response = await ApiService().request(
      endpoint: productGetAllEndPoint,
      method: 'GET',
      useAuth: CommonController.to.isLoggedIn.value,
      queryParams: {
        if (CommonController.to.isLoggedIn.value)
          "whole_sale": selectedType.value.toString(),
        'page': pageKey.toString(),
        'limit': '10',
        if (searchQuery.isNotEmpty) 'search': searchQuery,
        if (selectedCategory != null) 'category': selectedCategory!,
        if (selectedSubCategory != null) 'sub_category': selectedSubCategory!,
      },
    );

    /// 🔴 NULL RESPONSE
    if (response == null) {
      pagingController.error = 'No result found. Please try again.';
      return;
    }

    final success = response['success'] == true || response['status'] == true;

    /// 🔴 API FAILED
    if (!success) {
      pagingController.error =
          response['message'] ?? 'Something went wrong. Try again.';
      return;
    }
    final data = response['data'];

    /// 🔴 DATA IS NULL
    if (data == null) {
      pagingController.error = 'No result found. Please try again.';
      return;
    }

    /// 🟡 EMPTY LIST
    if (data is List && data.isEmpty) {
      pagingController.appendLastPage([]);
      return;
    }

    /// 🟢 VALID DATA
    final newItems =
        (data as List).map((e) => ProductModel.fromJson(e)).toList();

    final isLastPage =
        pageKey >= ((response['pagination']?['totalPages'] ?? 1) as int);

    if (isLastPage) {
      pagingController.appendLastPage(newItems);
    } else {
      pagingController.appendPage(newItems, pageKey + 1);
    }
  }
*/
  Future<void> getProductListRequest(int pageKey) async {
    // ✅ Capture generation at start of this request
    final myGeneration = _requestGeneration;

    if (selectedType.value == true && !CommonController.to.isLoggedIn.value) {
      return;
    }

    final response = await ApiService().request(
      endpoint: productGetAllEndPoint,
      method: 'GET',
      useAuth: CommonController.to.isLoggedIn.value,
      queryParams: {
        if (CommonController.to.isLoggedIn.value)
          "whole_sale": selectedType.value.toString(),
        'page': pageKey.toString(),
        'limit': '10',
        if (searchQuery.isNotEmpty) 'search': searchQuery,
        if (selectedCategory != null) 'category': selectedCategory!,
        if (selectedSubCategory != null) 'sub_category': selectedSubCategory!,
      },
    );

    // ✅ Discard response if a newer request has taken over
    if (myGeneration != _requestGeneration) {
      debugPrint('🗑 Discarding stale response for generation $myGeneration');
      return;
    }

    if (response == null) {
      pagingController.error = 'No result found. Please try again.';
      return;
    }

    final success = response['success'] == true || response['status'] == true;
    if (!success) {
      pagingController.error =
          response['message'] ?? 'Something went wrong. Try again.';
      return;
    }

    final data = response['data'];
    if (data == null) {
      pagingController.error = 'No result found. Please try again.';
      return;
    }

    if (data is List && data.isEmpty) {
      pagingController.appendLastPage([]);
      return;
    }

    final newItems =
        (data as List).map((e) => ProductModel.fromJson(e)).toList();

    final isLastPage =
        pageKey >= ((response['pagination']?['totalPages'] ?? 1) as int);

    if (isLastPage) {
      pagingController.appendLastPage(newItems);
    } else {
      pagingController.appendPage(newItems, pageKey + 1);
    }
  }
}
