import 'package:better_player_plus/better_player_plus.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_endpoints.dart';
import 'package:navid_e_commerce/presentations/product/model/product_model.dart';

import '../../../core/api-client/api_service.dart';
import '../../../core/helper/helper_function.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../splash/controllers/common_controller.dart';
import '../model/product_details_model.dart';

class ProductController extends GetxController {
  static ProductController get to => Get.find();
  Rx<PageController> pageController = PageController(initialPage: 0, keepPage: true).obs;
  RxInt cartQuantity = 1.obs;
/////////////////////
// Loading states for product detail counter
  RxBool isCartIncreLoading = false.obs;
  RxBool isCartDecreLoading = false.obs;

  void incrementCartQuantity() {
    cartQuantity.value++;
  }

  void decrementCartQuantity() {
    if (cartQuantity.value <= 1) return;
    cartQuantity.value--;
  }

// Call after product details load
  void syncQuantityFromCart() {
    if (!CommonController.to.isLoggedIn.value) return;
    final item = CartController.to.cartList.firstWhereOrNull(
      (e) => e.product?.sId == productId.value,
    );
    cartQuantity.value = item?.quantity ?? 1;
  }

////////////////////////////

  RxString selectedTime = ''.obs;

  Rx<TextEditingController> dateController =
      TextEditingController(text: kDebugMode ? '2025-01-22' : '').obs;
  RxBool isLoadingProductDetails = false.obs;

  Rx<ProductDetailsModel> productDetailsModel = ProductDetailsModel().obs;
  RxList<ProductModel> relatedProductList = <ProductModel>[].obs;
  Rx<String?> selectedColor = Rx<String?>(null);
  Rx<String?> selectedSize = Rx<String?>(null);
  RxList<String> currentBannerImages = <String>[].obs;
  RxList<String> sizes = <String>[].obs;
  Rxn<int> quantity = Rxn<int>();
  RxMap<String, bool> isLoadingDeleteAddress = <String, bool>{}.obs;

  final Rxn<ChewieController> chewieController = Rxn<ChewieController>();

  // tracks the currently visible page
  final RxInt currentPreviewPage = 0.obs;

  void setupPageListener() {
    pageController.value.addListener(() {
      final page = pageController.value.page?.round() ?? 0;
      if (currentPreviewPage.value != page) {
        currentPreviewPage.value = page;
      }
    });
  }

  final productId = ''.obs;

  @override
  void onInit() async {
    super.onInit(); // call super first

    // Arguments / productId setup
    final arguments = Get.arguments;
    if (arguments != null && arguments is String) {
      productId.value = arguments;
      print("arguments aka productId : ${productId.value}");
    }

    // Setup page listener BEFORE fetching product details
    setupPageListener(); // ✅ Add this here

    await getProductDetailsRequest(productID: productId.value);
  }

  /// Call this to get the variant to use for Add to Cart
  ProductVariantModel? getSelectedVariantForCart() {
    final variants = productDetailsModel.value.variants;
    if (variants == null || variants.isEmpty) return null;

    // Return selected variant if exists, otherwise default to first variant
    return selectedColor.value != null
        ? variants.firstWhere(
            (v) => v.color == selectedColor.value,
            orElse: () => variants.first,
          )
        : variants.first;
  }

  ///------------------------------ get Product Details method -------------------------///

  Future<void> getProductDetailsRequest({required String productID}) async {
    // Dispose existing video before loading new product
    // disposePlayer();
    try {
      isLoadingProductDetails.value = true;

      debugPrint(
          ' product details url : ${ApiService().baseUrl}/$productDetailsEndPoint$productID ');
      debugPrint(
          'postman product details url : https://api.divandione.com/product/get-details/699eac4b4503db9654af30dd');

      final response = await ApiService().request(
          endpoint: '$productDetailsEndPoint$productID',
          method: 'GET',
          useAuth: CommonController.to.isLoggedIn.value);

      debugPrint('productID: from product Ctrl  : ${productID}');
      debugPrint('response: from product Ctrl  : ${response}');

      if (response['success'] == true) {
        //   logger.d(response);
        debugPrint('response[data]: from product Ctrl  : ${response['data']}');

        productDetailsModel.value = ProductDetailsModel.fromJson(response['data']);
        debugPrint(
            'parsed data: Details : id: from product Ctrl  : ${productDetailsModel.value.id}');

        relatedProductList.value =
            (response['related_product'] as List).map((e) => ProductModel.fromJson(e)).toList();
        debugPrint(
            'parsed data: relatedProduct : id: from product Ctrl  : ${relatedProductList.value.first.id}');
        debugPrint('  relatedProductList.value : ${relatedProductList.value.toString()}');

        ///
        initializeBannerImages();

        ///
        syncQuantityFromCart();

        ///
        debugPrint(
            'video url in Ctrl :  ${ApiService().baseUrl}${productDetailsModel.value.video ?? ''}');
        initializeBetterPlayerOnce(); // CALL THE VIDEO INIT

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
        //   logger.e(response);
        showCustomSnackbar(
            title: 'Failed', message: response['message'], type: SnackBarType.failed);
        isLoadingProductDetails.value = false;
      }
    } catch (e) {
      //   logger.e(e.toString());
      isLoadingProductDetails.value = false;
    }
  }

//--------------------------   init video player ------------------------///
// Rx controller for BetterPlayer
  Rxn<BetterPlayerController> betterPlayerController = Rxn<BetterPlayerController>();

  // Initialize BetterPlayer with HLS link

  void initializeBetterPlayerOnce() {
    final videoPath = productDetailsModel.value.video;
    if (videoPath == null || videoPath.isEmpty) return;

    // if (betterPlayerController.value != null) return;
    betterPlayerController.value?.dispose(); // dispose old safely

    betterPlayerController.value = null;

    //
    final fullUrl = "${ApiService().baseUrl}$videoPath";

    debugPrint('fullUrl  : $fullUrl');

    final config = BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      autoPlay: false,
      looping: false,
      fit: BoxFit.contain,
      handleLifecycle: true,
      controlsConfiguration: const BetterPlayerControlsConfiguration(
        enableFullscreen: true,
        enableSkips: true,
      ),
    );

    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,

      "https://api.divandione.com/uploads/hls/c9f4312d-4add-4b61-9602-8f3ce13a32a9/index.m3u8",
      headers: {
        "User-Agent": "Mozilla/5.0 (Mobile; Flutter)",
        "Accept": "*/*",
      },
      // fullUrl,
      // headers: {
      //   "User-Agent": "Mozilla/5.0 (Mobile; Flutter)",
      // },
      useAsmsSubtitles: false,
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
      ),
    );

    final controller = BetterPlayerController(
      config,
      betterPlayerDataSource: dataSource,
    );
    controller.setupDataSource(dataSource);

    betterPlayerController.value = controller;

    //

    controller.addEventsListener((event) {
      debugPrint('BetterPlayer Event: ${event.betterPlayerEventType}');

      if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
        debugPrint("Video playback exception: ${event.parameters.toString()}");
      }
    });
  }

  void disposePlayer() {
    betterPlayerController.value?.dispose();
    betterPlayerController.value = null;
  }

  @override
  void onClose() {
    disposePlayer();
    super.onClose();
  }

  void initializeBannerImages() {
    final product = productDetailsModel.value;

    // No color selected initially
    selectedColor.value = null;
    selectedSize.value = null;

    // Default images = product banners
    currentBannerImages.value = product.banners ?? [];
  }

//
  void onColorSelected(String color) {
    final product = productDetailsModel.value;

    selectedColor.value = color;

    // Find selected variant
    final selectedVariant = product.variants?.firstWhere(
      (v) => v.color == color,
      orElse: () => product.variants!.first,
    );

    // Use variant images if available
    if (selectedVariant != null && selectedVariant.img != null && selectedVariant.img!.isNotEmpty) {
      currentBannerImages.value = selectedVariant.img!; // ✅ update reactively
    } else {
      currentBannerImages.value = product.banners ?? [];
    }

    // Reset page to 0 whenever color changes
    pageController.value.jumpToPage(0);
    currentPreviewPage.value = 0;
  }

  ///

  @override
  void dispose() {
    // ✅ Guard — controller may already be gone during navigation
    if (Get.isRegistered<ProductController>()) {
      if (ProductController.to.chewieController.value != null) {
        // ProductController.to.chewieController.value!.dispose();
      }
    }
    super.dispose();
  }
//
}
