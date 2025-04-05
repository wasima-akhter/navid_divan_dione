import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_endpoints.dart';
import 'package:navid_e_commerce/presentations/product/model/product_model.dart';

import '../../../core/api-client/api_service.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/hive_boxes.dart';
import '../../../core/utils/variable.dart';


class ProductController extends GetxController {
  static ProductController get to => Get.find();
  Rx<PageController> pageController = PageController(initialPage: 0,keepPage: true).obs;
RxInt cartQuantity =0.obs;
  RxString selectedTime = ''.obs;
  Rx<TextEditingController> dateController =
      TextEditingController(text: kDebugMode ? '2025-01-22' : '').obs;
  RxBool isLoadingProductDetails = false.obs;
Rx<ProductModel> productModel = ProductModel().obs;
RxList<ProductModel> relatedProductList = <ProductModel>[].obs;
  Rx<String?> selectedColor = Rx<String?>(null);
  RxList<String> currentBannerImages=<String>[].obs;

  ///------------------------------ get Product Details method -------------------------///

  Future<void> getProductDetailsRequest({required String productID}) async {
    try {
      isLoadingProductDetails.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService()
          .request(endpoint: '$productDetailsEndPoint$productID', method: 'GET');
      isLoadingProductDetails.value = false;
      if (response['success'] == true) {
        logger.d(response);
        productModel.value = ProductModel.fromJson(response['data']);
        relatedProductList.value = (response['related_product'] as List).map((e)=>ProductModel.fromJson(e)).toList();
        initializeBannerImages();
      } /*else if (response['message'] == AppStaticStrings.noInternet) {
        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
          noInternet: true,
          retryTap: () {
            getUserProfileRequest();
          },
        );
      }*/ else {
        logger.e(response);
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingProductDetails.value = false;
    }
  }

  void initializeBannerImages() {
    final product =productModel.value;

    // If there's a default banner, use it
    if (product.banner != null && product.banner!.isNotEmpty) {
     currentBannerImages.value = product.banner!;
     selectedColor.value = null;
    }
    // Otherwise, try to use the first color's variant images
    else if (product.variantColors != null &&
        product.variantColors!.isNotEmpty) {
     selectedColor.value = product.variantColors!.first;
     currentBannerImages.value =
          product.variantImages?[ProductController.to.selectedColor.value] ??
              [];
    } else {
     currentBannerImages.value = [];
     selectedColor.value = null;
    }
  }

  void onColorSelected(String color) {
    final product =productModel.value;

   selectedColor.value = color;
    logger.d(selectedColor.value);

    // Update banner images based on selected color
   currentBannerImages.value =
        product.variantImages?[color] ?? [];

  }
}
