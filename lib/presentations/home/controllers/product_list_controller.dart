import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/api-client/api_endpoints.dart';
import '../../../core/export/ui_export.dart';
import '../../../core/utils/hive_boxes.dart';
import '../../../core/utils/variable.dart';
import '../../product/model/product_model.dart';
import '../model/category_model.dart';

class ProductListController extends GetxController {
  static ProductListController get to => Get.find();
  //
  final PagingController<int, ProductModel> pagingController = PagingController(firstPageKey: 1);

  /// ✅ search + filter
  String searchQuery = "";
  String? selectedCategory;
  String? selectedSubCategory;

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

    pagingController.refresh(); // 🔥 reload API
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

      final response =
          await ApiService().request(endpoint: catGetAllEndPoint, method: 'GET', queryParams: {
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
          totalCategoryPages.value = response['pagination']['totalPages'] ?? 1; // Add this line

          itemsPerPage.value = response['pagination']['itemsPerPage'] ?? 10;
        }
        final newCategories =
            (response['data'] as List).map((e) => CategoryModel.fromJson(e)).toList();

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
            title: 'Failed', message: response['message'], type: SnackBarType.failed);
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
        subCategoryList.value =
            (response["data"] as List).map((e) => SubCategoryModel.fromJson(e)).toList();
      } else {
        showCustomSnackbar(
            title: 'Failed', message: response['message'], type: SnackBarType.failed);
      }
    } catch (e) {
      // handle error if needed
    } finally {
      category.isLoadingSub.value = false; // 👈 reset only this
    }
  }

  Future<void> getProductListRequest(int pageKey) async {
    final response = await ApiService().request(
      endpoint: productGetAllEndPoint,
      method: 'GET',
      queryParams: {
        'page': pageKey.toString(),
        'limit': '10',
        if (searchQuery.isNotEmpty) 'search': searchQuery,
        if (selectedCategory != null) 'category': selectedCategory!,
        if (selectedSubCategory != null) 'sub_category': selectedSubCategory!,
      },
    );

    if (response['success']) {
      final newItems = (response['data'] as List).map((e) => ProductModel.fromJson(e)).toList();

      final isLastPage = pageKey >= (response['pagination']?['totalPages'] ?? 1);

      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        pagingController.appendPage(newItems, pageKey + 1);
      }
    } else {
      pagingController.error = response['message'];
    }
  }
}
