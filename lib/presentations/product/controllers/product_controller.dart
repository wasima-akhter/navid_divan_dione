import 'package:chewie/chewie.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_endpoints.dart';
import 'package:navid_e_commerce/presentations/product/model/pick_address_model.dart';
import 'package:navid_e_commerce/presentations/product/model/product_model.dart';
import 'package:video_player/video_player.dart';

import '../../../core/api-client/api_service.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/variable.dart';
import '../../navigation/views/navigation_page.dart';
import '../../splash/controllers/common_controller.dart';
import '../views/payment_page.dart';

class ProductController extends GetxController {
  static ProductController get to => Get.find();
  Rx<PageController> pageController =
      PageController(initialPage: 0, keepPage: true).obs;
  RxInt cartQuantity = 1.obs;
  RxString selectedTime = ''.obs;
  RxString orderId = ''.obs;
  RxString selectedPickAddress = ''.obs;
  RxString selectedShippingAddress = ''.obs;
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> phoneController = TextEditingController().obs;
  TextEditingController nameAddressController = TextEditingController();
  TextEditingController contactAddressController = TextEditingController();
  TextEditingController deliveryAddressController = TextEditingController();
  Rx<TextEditingController> dateController =
      TextEditingController(text: kDebugMode ? '2025-01-22' : '').obs;
  RxBool isLoadingProductDetails = false.obs;
  RxBool isLoadingPickUpAddress = false.obs;
  RxBool isLoadingShippingAddress = false.obs;
  RxBool isLoadingAddShippingAddress = false.obs;
  RxBool isLoadingOrder = false.obs;
  Rx<ProductModel> productModel = ProductModel().obs;
  RxList<ProductModel> relatedProductList = <ProductModel>[].obs;
  RxList<PickAddressModel> pickAddressList = <PickAddressModel>[].obs;
  RxList<PickAddressModel> shippingAddressList = <PickAddressModel>[].obs;
  Rx<String?> selectedColor = Rx<String?>(null);
  Rx<String?> selectedSize = Rx<String?>(null);
  RxList<String> currentBannerImages = <String>[].obs;
  RxList<String> sizes= <String>[].obs;
  Rxn<int> quantity = Rxn<int>();
  RxMap<String, bool> isLoadingDeleteAddress = <String, bool>{}.obs;
  RxBool isPaymentLoading = false.obs;
  // final Rxn<VideoPlayerController> videoController =
  //     Rxn<VideoPlayerController>();
  final Rxn<ChewieController> chewieController = Rxn<ChewieController>();
  @override
  void onInit() {
    if (CommonController.to.isLoggedIn) {
      getPickUpAddressRequest();
      getShippingAddressRequest();
    }
    super.onInit();
  }

  fetchPickUpAddress() {
    for (PickAddressModel pickAddressModel in pickAddressList) {
      if (pickAddressModel.sId == selectedPickAddress.value) {
        nameController.value.text = pickAddressModel.name.toString();

        phoneController.value.text = pickAddressModel.phone.toString();
      }
    }
  }

  ///------------------------------ get Product Details method -------------------------///

  Future<void> getProductDetailsRequest({required String productID}) async {
    try {
      isLoadingProductDetails.value = true;

      final response = await ApiService().request(
          endpoint: '$productDetailsEndPoint$productID',
          method: 'GET',
          useAuth: CommonController.to.isLoggedIn);
      if (response['success'] == true) {
        logger.d(response);
        productModel.value = ProductModel.fromJson(response['data']);
        relatedProductList.value = (response['related_product'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        initializeBannerImages();
        if (productModel.value.variantImages != null &&
            productModel.value.variantImages!["video"] != null &&
            productModel.value.variantImages!["video"]?.img != null) {
          logger.d(
              "${ApiService().baseUrl}/${productModel.value.variantImages!["video"]?.img?.first}");
          final String rawPath =
              productModel.value.variantImages!["video"]!.img!.first;
          final videoPlayerController = VideoPlayerController.networkUrl(
              Uri.parse("${ApiService().baseUrl}/$rawPath"));

          await videoPlayerController.initialize();

          final chewie = ChewieController(
            videoPlayerController: videoPlayerController,
            autoPlay: true,
            looping: true,
          );

          // videoController.value = videoPlayerController;
          chewieController.value = chewie;
          update();
        }
        isLoadingProductDetails.value = false;
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
      }*/
      else {
        logger.e(response);
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
        isLoadingProductDetails.value = false;
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingProductDetails.value = false;
    }
  }

  ///-------------------- get pick up addresses method ---------------------///

  Future<void> getPickUpAddressRequest() async {
    try {
      isLoadingPickUpAddress.value = true;

      final response = await ApiService()
          .request(endpoint: pickAddressEndPoint, method: 'GET');

      if (response['success'] == true) {
        logger.d(response);
        pickAddressList.value = (response["data"] as List)
            .map(
              (e) => PickAddressModel.fromJson(e),
            )
            .toList();
        selectedPickAddress.value = pickAddressList[0].sId.toString();
        fetchPickUpAddress();
      } else {
        logger.e(response);
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      logger.e(e.toString());
    } finally {
      isLoadingPickUpAddress.value = false;
    }
  }

  ///-------------------- get shipping addresses method ---------------------///

  Future<void> getShippingAddressRequest() async {
    try {
      isLoadingShippingAddress.value = true;

      final response = await ApiService()
          .request(endpoint: shippingAddressGetEndPoint, method: 'GET');
      isLoadingShippingAddress.value = false;
      if (response['success'] == true) {
        logger.d(response);
        shippingAddressList.value = (response["data"] as List)
            .map(
              (e) => PickAddressModel.fromJson(e),
            )
            .toList();
        selectedShippingAddress.value = shippingAddressList[0].sId.toString();
      } else {
        logger.e(response);
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingShippingAddress.value = false;
    }
  }

  ///------------------------------- add shipping address ----------------------------///

  Future<void> addShippingAddressRequest({
    required String address,
    required String phone,
    required String name,
  }) async {
    try {
      isLoadingAddShippingAddress.value = true;
      final response = await ApiService().request(
          endpoint: shippingAddressCreateEndPoint,
          method: 'POST',
          body: {"address": address, "phone": phone, "name": name});
      isLoadingAddShippingAddress.value = false;
      if (response['success'] == true) {
        logger.d(response);
        getShippingAddressRequest();
        showCustomSnackbar(
          title: 'Success',
          message: response['message'],
        );
      } else {
        logger.e(response);
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      isLoadingAddShippingAddress.value = false;
      logger.e(e.toString());
    }
  }

  ///------------------------------- order Product ----------------------------///

  Future<void> orderRequest(
      {required String totalAmount,
      required List<Map<String, dynamic>> item,
      required List<Map<String, dynamic>> productList,
      String? pickupAddress,
      String? deliveryAddress,
      String? note}) async {
    try {
      isLoadingOrder.value = true;
      final response = await ApiService()
          .request(endpoint: orderCreateEndPoint, method: 'POST', body: {
        "items": item,
        "total_amount": totalAmount,
        "delivery_address": deliveryAddress,
        "pick_up_address": pickupAddress,
        "notes": note ?? ""
      });
      isLoadingOrder.value = false;
      if (response['success'] == true) {
        orderId.value = response['data'][0]["_id"];
        logger.d(orderId.value);
        logger.d(response);
        if (response['data'][0]["_id"].isNotEmpty) {
          paymentRequest(
              products: productList, orderId: response['data'][0]["_id"]);
        }
        // Get.offAllNamed(NavigationPage.routeName);
        showCustomSnackbar(
          title: 'Success',
          message: response['message'],
        );
      } else {
        logger.e(response);
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      isLoadingOrder.value = false;
      logger.e(e.toString());
    }
  }

  ///----------------------- Delete address item ----------------------///

  Future<void> deleteAddress({required String id}) async {
    try {
      isLoadingDeleteAddress[id] = true;
      final response = await ApiService().request(
        endpoint: "$deletesShippingAddressEndPoint$id",
        method: 'DELETE',
      );
      isLoadingDeleteAddress[id] = false;
      if (response['success'] == true) {
        logger.d(response);
        getShippingAddressRequest();
        if (shippingAddressList.isEmpty) {
          selectedShippingAddress.value = "";
        }
        showCustomSnackbar(
          title: 'Success',
          message: response['message'],
        );
      } else {
        logger.e(response);
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      isLoadingDeleteAddress[id] = false;
      logger.e(e.toString());
    }
  }

  ///------------------------------- payment ----------------------------///

  Future<void> paymentRequest(
      {required List<Map<String, dynamic>> products,
      required String orderId}) async {
    try {
      isPaymentLoading.value = true;
      final response = await ApiService()
          .request(endpoint: paymentCreateEndPoint, method: 'POST', body: {
        "price_data": products,
        "_id": orderId
        // "purpose": "buy_product"
        // "currency": "USD"
      });
      isPaymentLoading.value = false;
      if (response['success'] == true) {
        CommonController.to.stripeUrl.value = response["url"];
        Get.toNamed(PaymentScreen.routeName);
        logger.d(response);
        showCustomSnackbar(
          title: 'Success',
          message: response['message'],
        );
      } else {
        logger.e(response);
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      isPaymentLoading.value = false;
      logger.e(e.toString());
    }
  }

  void initializeBannerImages() {
    final product = productModel.value;

    // If there's a default banner, use it
    if (product.banner != null && product.banner!.isNotEmpty) {
      currentBannerImages.value = product.banner!;
      selectedColor.value = null;
    }
    // Otherwise, try to use the first color's variant images
    else if (product.variantColors != null &&
        product.variantColors!.isNotEmpty) {
      selectedColor.value = product.variantColors!.first;
      currentBannerImages.value = product
              .variantImages?[ProductController.to.selectedColor.value]?.img ??
          [];
    } else {
      currentBannerImages.value = [];
      selectedColor.value = null;
    }
  }

  void onColorSelected(String color) {
    final product = productModel.value;

    selectedColor.value = color;
    logger.d(selectedColor.value);

    // Update banner images based on selected color
    currentBannerImages.value = product.variantImages?[color]?.img ?? [];
    sizes.value = product.variantImages?[color]?.size ?? [];
    quantity.value = product.variantImages?[color]!.quantity??0 ;
  }
}
