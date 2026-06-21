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

  final String _instanceId = DateTime.now().millisecondsSinceEpoch.toString();

  //
  int _requestGeneration = 0; // 👈 single source of truth, already exists

  // 👇 centralize: every refresh-triggering action bumps generation FIRST
  void _bumpGenerationAndRefresh() {
    _requestGeneration++;
    debugPrint(
        '🔄 Generation bumped to $_requestGeneration — caller refresh triggered');
    pagingController.refresh();
  }

  //
  final PagingController<int, ProductModel> pagingController =
      PagingController(firstPageKey: 1);

  /// ✅ search + filter
  String searchQuery = "";
  String? selectedCategory;
  String? selectedSubCategory;

  final RxBool hasFilter = false.obs;

  // 👇 sort order state — 'asc' or 'dsc' (matches backend's exact spelling)
  final RxString sortOrder = 'dsc'.obs; // default: newest first

  bool _listenerAttached = false; // 👈 guard

  void toggleSortOrder() {
    sortOrder.value = sortOrder.value == 'dsc' ? 'asc' : 'dsc';
    _bumpGenerationAndRefresh(); // 👈 fix missing bump
  }

  /// ✅ controller
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void onInit() {
    if (!_listenerAttached) {
      pagingController.addPageRequestListener((pageKey) {
        getProductListRequest(pageKey);
      });
      _listenerAttached = true;
    }

    getCategoryListRequest();

    if (!CommonController.to.isLoggedIn.value) {
      selectedType.value = false;
    }

    if (CommonController.to.isLoggedIn.value) {
      ever(ProfileController.to.taxIdUpdateTrigger, (_) {
        onTaxIdUpdated();
      });
    }

    debugPrint('🆕 ProductListController instance created: $_instanceId');
    super.onInit();
  }

  void resetAndReload() {
    selectedType.value = false;

    searchQuery = "";
    selectedCategory = null;
    selectedSubCategory = null;
    hasFilter.value = false;

    // pagingController.refresh();
    _bumpGenerationAndRefresh(); // 👈 was: pagingController.refresh();
    getCategoryListRequest();
  }

  @override
  void onClose() {
    debugPrint('🗑 ProductListController instance closed: $_instanceId');
    pagingController.dispose();
    super.onClose();
  }

  final taxIDUpdated = false.obs;
  void onTaxIdUpdated() {
    taxIDUpdated.value = true;

    selectedType.value = false; // or recompute wholesale flag

    // pagingController.refresh(); // 🔥 reload products
    _bumpGenerationAndRefresh(); // 👈 was: pagingController.refresh();

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

    // pagingController.refresh();
    _bumpGenerationAndRefresh(); // 👈 was: pagingController.refresh();
  }

  void clearFilters() {
    searchQuery = "";
    selectedCategory = null;
    selectedSubCategory = null;

    hasFilter.value = false;

    // pagingController.refresh();
    _bumpGenerationAndRefresh(); // 👈 was: pagingController.refresh();
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
    // pagingController.refresh();
    _bumpGenerationAndRefresh(); // 👈 was: pagingController.refresh();
    await getCategoryListRequest();
  }

  final selectedType = RxBool(false);

  void onTypeChanged(bool value) async {
    selectedType.value = value;
    final myGeneration = ++_requestGeneration; // bump first, capture after
    pagingController.refresh();

    if (value == true && !CommonController.to.isLoggedIn.value) {
      await Future.delayed(const Duration(milliseconds: 100));
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
    final myGeneration = _requestGeneration;
    debugPrint('📡 Request started — page $pageKey, generation $myGeneration');

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
        'sort': 'createdAt',
        'order': sortOrder.value, // 👈 now dynamic
      },
    );

    // 👇 THIS is the actual guard that stops stale responses from being applied
    if (myGeneration != _requestGeneration) {
      debugPrint(
          '🗑 Discarding stale response for generation $myGeneration (page $pageKey)');
      return;
    }
    debugPrint('✅ ACCEPTED — page $pageKey, generation $myGeneration');

    //
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
