import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/api-client/api_endpoints.dart';
import '../../../core/export/ui_export.dart';
import '../../../core/utils/hive_boxes.dart';
import '../../../core/utils/variable.dart';
import '../../product/model/product_model.dart';
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
  void onInit() async {
    pagingController.addPageRequestListener((pageKey) {
      getProductListRequest(pageKey);
    });

    await getCategoryListRequest();
    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
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

  final selectedType = RxBool(false);
  Future<void> getProductListRequest(int pageKey) async {
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
}
