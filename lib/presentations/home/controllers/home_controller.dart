import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/presentations/home/model/category_model.dart';
import 'package:navid_e_commerce/presentations/product/model/product_model.dart';
import 'package:navid_e_commerce/presentations/profile/controllers/profile_controller.dart';
import '../../../core/api-client/api_endpoints.dart';

import '../../../core/api-client/api_service.dart';
import '../../../core/constants/app_static_strings.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/hive_boxes.dart';
import '../../../core/utils/variable.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  RxString category = ''.obs;
  RxBool isLoadingCategory = false.obs;
  RxBool isLoadingProduct = false.obs;

  ///=======================dynamic list==========================///

  RxList<CategoryModel> catList = <CategoryModel>[].obs;
  RxList<ProductModel> productList = <ProductModel>[].obs;

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
  @override
  void onInit() async{
fetchInitialData();
    super.onInit();
  }
  void fetchInitialData() async {
    isLoadingCategory.value = true;
    isLoadingProduct.value = true;

    await Future.wait([
      getCategoryListRequest(),
      ProfileController.to.getUserProfileRequest(),
      getProductListRequest(),
    ]);

    isLoadingCategory.value = false;
    isLoadingProduct.value = false;
  }
  Future<void> refreshCall() async {

    searchController.value.clear();
    category.value = '';
    await getCategoryListRequest();
    await getProductListRequest();
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

      final response = await ApiService().request(endpoint: catGetAllEndPoint, method: 'GET', queryParams: {
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
        final newCategories = (response['data'] as List).map((e) => CategoryModel.fromJson(e)).toList();

        if (loadMore) {
          catList.addAll(newCategories); // Append for load more
        } else {
          catList.value = newCategories; // Replace for refresh
        }
        logger.d(response);
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
        logger.e(response);
        showCustomSnackbar(title: 'Failed', message: response['message'], type: SnackBarType.failed);
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingCategory.value = false;
    }
  }

  ///------------------------------ get product list method -------------------------///

  Future<void> getProductListRequest({
    bool loadMore = false,
  })
  async {
    try {
      // Don't load more if we've reached the last page
      if (loadMore && currentProductPage.value >= totalProductPages.value) {
        return;
      }

      if (loadMore) {

        isProductLoadingMore.value = true;
        currentProductPage.value++;
        // Don't increment page here - we'll do it after successful response
      } else {
        isLoadingProduct.value = true;
        currentProductPage.value = 1;
      }

      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      final response = await ApiService().request(
        endpoint: productGetAllEndPoint,
        method: 'GET',
        queryParams: {
          "whole_sale": ProfileController.to.userModel.value.taxId!=null? "true":"false",
          'page': currentProductPage.value.toString(),
          'limit': itemsProductPerPage.value.toString(),
          'search': searchController.value.text,
          'category': category.value
        },
      );

      isLoadingProduct.value = false;
      isProductLoadingMore.value = false;

      if (response['success'] == true) {
        if (response['pagination'] != null) {
          currentProductPage.value = response['pagination']['currentPage'] ?? 1;
          totalProductPages.value = response['pagination']['totalPages'] ?? 1; // Add this line
          itemsProductPerPage.value = response['pagination']['itemsPerPage'] ?? 10;
        }

        final newProducts = (response['data'] as List).map((e) => ProductModel.fromJson(e)).toList();

        if (loadMore) {
          // Only increment page after successful load

          productList.addAll(newProducts);
        } else {
          productList.value = newProducts;
        }
        logger.d(response);
      } else {
        logger.e(response);
        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingProduct.value = false;
      isProductLoadingMore.value = false;
    }
  }
}
