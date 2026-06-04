import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:navid_e_commerce/presentations/home/model/category_model.dart';
import 'package:navid_e_commerce/presentations/product/model/product_model.dart';
import 'package:navid_e_commerce/presentations/splash/controllers/common_controller.dart';

import '../../../core/api-client/api_endpoints.dart';
import '../../../core/api-client/api_service.dart';
import '../../../core/constants/app_static_strings.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/hive_boxes.dart';
import '../../../core/utils/variable.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  RxBool isLoadingCategory = false.obs;
  RxBool isLoadingSubCategory = false.obs;
  RxBool isLoadingBanner = false.obs;
  RxBool isLoadingProduct = false.obs;
  final int pageSize = 10; // items per page
  // String? selectedCategory;
  // String? selectedSubCategory;
  // String searchQuery = "";

  final RxnString selectedCategory = RxnString();
  final RxnString selectedSubCategory = RxnString();
  final RxString searchQuery = "".obs;
  final PagingController<int, ProductModel> pagingController =
      PagingController(firstPageKey: 1);

  ///=======================dynamic list==========================///

  RxList<CategoryModel> catList = <CategoryModel>[].obs;
  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxList<BannerModel> bannerList = <BannerModel>[].obs;
  RxList<SubCategoryModel> subCategoryList = <SubCategoryModel>[].obs;

  ///====================category pagination variable========================///

  final RxInt currentPage = 1.obs;
  final RxInt itemsPerPage = 10.obs;
  final RxInt totalCategoryPages = 5.obs;
  final RxBool isLoadingMore = false.obs;

  ///====================product pagination variable========================///

  final RxInt currentProductPage = 1.obs;
  final RxInt itemsProductPerPage = 10.obs;
  final RxInt totalProductPages = 5.obs;
  final RxBool isProductLoadingMore = false.obs;

  ///=======================search controller============================///

  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<FocusNode> searchFocusNode = FocusNode().obs;
  Rx<PageController> pageController = PageController(initialPage: 0).obs;
  @override
  void onInit() async {
    pagingController.addPageRequestListener((pageKey) {
      getProductListRequest(pageKey: pageKey);
    });

    fetchInitialData();

    super.onInit();
  }

  void fetchInitialData() async {
    // isLoadingCategory.value = true;
    // isLoadingProduct.value = true;

    Future.wait([
      getBannerRequest(),
      getCategoryListRequest(),
    ]);

    // isLoadingCategory.value = false;
    // isLoadingProduct.value = false;
  }

  Future<void> refreshCall() async {
    searchController.value.clear();

    selectedCategory.value = null;
    selectedSubCategory.value = null;
    searchQuery.value = "";

    await getCategoryListRequest();
    await getBannerRequest();

    pagingController.refresh();
  }

  ///------------------------------ get category list method -------------------------///

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

  //------------------------------ apply filters method -------------------------///

  // void applyFilters({String? category, String? subCategory, String? search}) {
  //   selectedCategory = category;
  //   selectedSubCategory = subCategory;
  //   searchQuery = search ?? "";
  //   pagingController.refresh(); // reload data with filters
  // }

  void applyFilters({
    String? category,
    String? subCategory,
    String? search,
  }) {
    selectedCategory.value = category;
    selectedSubCategory.value = subCategory;
    searchQuery.value = search ?? "";

    pagingController.refresh();
  }

  ///-------------------- get sub category list method ---------------------///

  // Future<void> getSubCategoryRequest({required String catId}) async {
  //   try {
  //     isLoadingSubCategory.value = true;

  //     final response = await ApiService().request(
  //         endpoint: subCateGetAllEndPoint, method: 'GET', queryParams: {"category": catId});

  //     if (response['success'] == true) {
  //       //   logger.d(response);
  //       subCategoryList.value = (response["data"] as List)
  //           .map(
  //             (e) => SubCategoryModel.fromJson(e),
  //           )
  //           .toList();
  //     } else {
  //       //   logger.e(response);
  //       showCustomSnackbar(
  //           title: 'Failed', message: response['message'], type: SnackBarType.failed);
  //     }
  //   } catch (e) {
  //     //   logger.e(e.toString());
  //   } finally {
  //     isLoadingSubCategory.value = false;
  //   }
  // }

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

  ///-------------------- get banner list method ---------------------///

  Future<void> getBannerRequest() async {
    try {
      isLoadingBanner.value = true;

      final response = await ApiService()
          .request(endpoint: bannerGetAllEndPoint, method: 'GET');

      debugPrint("Banner Response: ${response}");

      if (response['success'] == true) {
        // logger.d(response);
        bannerList.value = (response["data"] as List)
            .map(
              (e) => BannerModel.fromJson(e),
            )
            .toList();

        debugPrint("bannerList : ${bannerList[0].img}");
      } else {
        //   logger.e(response);
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      //   logger.e(e.toString());
    } finally {
      isLoadingBanner.value = false;
    }
  }

  ///------------------------------ get product list method -------------------------///

  Future<void> getProductListRequest({required int pageKey}) async {
    debugPrint(' calling  getProductListRequest....: ');
    try {
      bool hasTax = false;
      if (CommonController.to.isLoggedIn.value) {
        ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
        hasTax = (await Boxes.getUserData().get("hasTax")) ?? false;
      }

      final response = await ApiService().request(
        endpoint: productGetAllEndPoint,
        method: 'GET',
        useAuth: CommonController.to.isLoggedIn.value,
        queryParams: {
          if (CommonController.to.isLoggedIn.value)
            "whole_sale": false.toString(),
          //  hasTax.toString(),
          'page': pageKey.toString(),
          'limit': itemsProductPerPage.value.toString(),
          if (searchQuery.value.isNotEmpty) 'search': searchQuery.value,
          'category': selectedCategory.value ?? "",
          'sub_category': selectedSubCategory.value ?? "",
        },
      );

      debugPrint(' response in home Contr product list : $response');

      log("response of list : ${JsonEncoder.withIndent('').convert(response)}");
      if (response['success'] == true) {
        final rawData = response['data'];

        if (rawData == null || rawData is! List) {
          pagingController.error = 'Invalid data format';
          return;
        }

        final newProducts =
            (rawData).map((e) => ProductModel.fromJson(e)).toList();

        final isLastPage =
            pageKey >= (response['pagination']?['totalPages'] ?? 1);

        if (isLastPage) {
          pagingController.appendLastPage(newProducts);
        } else {
          pagingController.appendPage(newProducts, pageKey + 1);
        }
      }
//       if (response['success'] == true) {
//         final newProducts = (response['data'] as List)
//             .map((e) => ProductModel.fromJson(e))
//             .toList();

// // // 👇 duplicate for testing
// //         final expandedList = List.generate(
// //           5, // multiply factor
// //           (_) => newProducts,
// //         ).expand((e) => e).toList();

//         final isLastPage =
//             pageKey >= (response['pagination']?['totalPages'] ?? 1);

//         if (isLastPage) {
//           pagingController.appendLastPage(newProducts);
//         } else {
//           final nextPageKey = pageKey + 1;
//           pagingController.appendPage(newProducts, nextPageKey);
//         }
//       } else {
//         pagingController.error = response['message'];
//       }
    } catch (e, st) {
      debugPrint('Product list exception: $e\n$st');
      pagingController.error = e.toString(); // convert to String
    }
  }
}
