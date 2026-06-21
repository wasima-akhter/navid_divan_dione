import 'dart:async';

import 'package:better_player_plus/better_player_plus.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_endpoints.dart';
import 'package:navid_e_commerce/presentations/product/model/product_model.dart';

import '../../../core/api-client/api_service.dart';
import '../../../core/constants/app_static_strings.dart';
import '../../../core/helper/helper_function.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../splash/controllers/common_controller.dart';
import '../model/product_details_model.dart';
import '../widgets/prod_det_video_player_sec.dart';

class ProductController extends GetxController {
  static ProductController get to => Get.find();
  Rx<PageController> pageController =
      PageController(initialPage: 0, keepPage: true).obs;
  RxInt cartQuantity = 1.obs;
/////////////////////
// Loading states for product detail counter
  RxBool isCartIncreLoading = false.obs;
  RxBool isCartDecreLoading = false.obs;

  void incrementCartQuantity() {
    final variant = getSelectedVariantForCart();
    if (variant == null) return;

    final stock = variant.quantity ?? 0;

    if (cartQuantity.value >= stock) {
      showCustomSnackbar(
        title: "Stock Limit",
        message: "Only $stock item(s) available",
      );
      return;
    }

    cartQuantity.value++;
    refreshCartState();
  }

  void decrementCartQuantity() {
    if (cartQuantity.value > 1) {
      cartQuantity.value--;
      refreshCartState();
    }
  }

// Call after product details load
  void syncQuantityFromCart() {
    if (!CommonController.to.isLoggedIn.value) return;

    final variant = getSelectedVariantForCart();
    if (variant == null) return;

    final item = CartController.to.cartList.firstWhereOrNull(
      (e) => e.variant?.sId == variant.id,
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

  // @override
  // void onInit() async {
  //   super.onInit(); // call super first

  //   // Arguments / productId setup
  //   final arguments = Get.arguments;
  //   if (arguments != null && arguments is String) {
  //     productId.value = arguments;
  //     print("arguments aka productId : ${productId.value}");
  //   }

  //   // Setup page listener BEFORE fetching product details
  //   setupPageListener(); // ✅ Add this here

  //   await getProductDetailsRequest(productID: productId.value);
  // }

  @override
  void onInit() async {
    super.onInit();

    final arguments = Get.arguments;

    if (arguments is String && arguments.isNotEmpty) {
      productId.value = arguments;
    } else {
      return; // 🚨 STOP if no productId
    }

    setupPageListener();

    await getProductDetailsRequest(productID: productId.value);
  }

  /// Call this to get the variant to use for Add to Cart
  ProductVariantModel? getSelectedVariantForCart() {
    final variants = productDetailsModel.value.variants;
    if (variants.isEmpty) return null;

    // Return selected variant if exists, otherwise default to first variant
    return selectedColor.value != null
        ? variants.firstWhere(
            (v) => v.color == selectedColor.value,
            orElse: () => variants.first,
          )
        : variants.first;
  }

  ///------------------------------ get Product Details method -------------------------///
  bool _isFetching = false;
  Future<void> getProductDetailsRequest({required String productID}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Dispose existing video before loading new product
    // disposePlayer();
    try {
      isLoadingProductDetails.value = true;

      debugPrint(' product details url : $productDetailsEndPoint$productID ');
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

        productDetailsModel.value =
            ProductDetailsModel.fromJson(response['data']);
        debugPrint(
            'parsed data: Details : id: from product Ctrl  : ${productDetailsModel.value.id}');

        // debugPrint(
        //     '---> price after discount : ${productDetailsModel.value.variants?.first.priceAfterDiscount}');

        relatedProductList.value = (response['related_product'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        debugPrint(
            'parsed data: relatedProduct : id: from product Ctrl  : ${relatedProductList.value.first.id}');
        debugPrint(
            '  relatedProductList.value : ${relatedProductList.value.toString()}');

        ///
        initializeBannerImages();

        ///
        syncQuantityFromCart();

        refreshCartState();

        ///
        debugPrint(
            'video url in Ctrl :  ${ApiService().baseUrl}${productDetailsModel.value.video ?? ''}');
        initializeBetterPlayerOnce(); // CALL THE VIDEO INIT

        setInitialVariant(productDetailsModel.value.variants ?? []);

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
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
        isLoadingProductDetails.value = false;
      }
    } catch (e) {
      //   logger.e(e.toString());
      isLoadingProductDetails.value = false;
    } finally {
      _isFetching = false;
    }
  }

//--------------------------   init video player ------------------------///
// Rx controller for BetterPlayer
  Rxn<BetterPlayerController> betterPlayerController =
      Rxn<BetterPlayerController>();

  // Initialize BetterPlayer with HLS link
  void initializeBetterPlayerOnce() {
    final videoPath = productDetailsModel.value.video;
    if (videoPath.isEmpty) return;

    // ✅ Guard: don't reinitialize if already set
    if (betterPlayerController.value != null) return;

    final normalizedPath =
        videoPath.startsWith('/') ? videoPath.substring(1) : videoPath;

    final fullUrl = videoPath.startsWith('http')
        ? videoPath
        : '${ApiService().baseUrl}/$normalizedPath';

    debugPrint('fullUrl  : $fullUrl');
    debugPrint('videoPath  : $videoPath');

    final config = BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      autoPlay: false,
      looping: false,
      fit: BoxFit.contain,
      handleLifecycle: true,
      expandToFill: true,
      allowedScreenSleep: false,
      deviceOrientationsOnFullScreen: const [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      systemOverlaysAfterFullScreen: SystemUiOverlay.values,
      deviceOrientationsAfterFullScreen: const [
        DeviceOrientation.portraitUp,
      ],
      controlsConfiguration: const BetterPlayerControlsConfiguration(
        enableFullscreen: true,
        enableSkips: true,
        enablePlayPause: true,
        enableProgressText: true,
      ),
      placeholder: Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
      showPlaceholderUntilPlay: true,
      errorBuilder: (context, errorMessage) {
        return VideoErrorWidget(
          isUnsupported: videoUnsupported.value,
          onRetry: () => retryVideoPlayer(),
        );
      },
    );

    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      fullUrl,
      headers: {
        "User-Agent": "Mozilla/5.0 (Mobile; Flutter)",
        "Accept": "*/*",
      },
      useAsmsSubtitles: false,
      // ✅ FIXED: showNotification false to avoid ImageWorker crash on real devices
      notificationConfiguration: const BetterPlayerNotificationConfiguration(
        showNotification: false,
      ),
      // ✅ Explicitly tell ExoPlayer it's a plain MP4
      videoFormat: BetterPlayerVideoFormat.other,
      videoExtension: "mp4",
      // ✅ Add buffering config for slower real devices
      bufferingConfiguration: const BetterPlayerBufferingConfiguration(
        minBufferMs: 2000,
        maxBufferMs: 10000,
        bufferForPlaybackMs: 1000,
        bufferForPlaybackAfterRebufferMs: 2000,
      ),
    );

    // ✅ Don't call setupDataSource separately — pass it in constructor only
    final controller = BetterPlayerController(
      config,
      betterPlayerDataSource: dataSource,
    );

    controller.addEventsListener((event) {
      debugPrint('BetterPlayer Event: ${event.betterPlayerEventType}');
      if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
        final errorMsg = event.parameters?['exception']?.toString() ?? '';
        debugPrint("❌ Video EXCEPTION: $errorMsg");
        debugPrint("Video exception: ${event.parameters}");

        // Detect unsupported format specifically
        if (errorMsg.contains('NO_EXCEEDS_CAPABILITIES') ||
            errorMsg.contains('DecoderInitializationException') ||
            errorMsg.contains('format_supported=NO')) {
          videoUnsupported.value = true;
        }
        videoHasError.value = true; // ✅ trigger error UI
      }
//

      // ✅ Also catch bufferingStart stuck — real devices sometimes buffer forever
      if (event.betterPlayerEventType == BetterPlayerEventType.bufferingStart) {
        _startBufferingTimeout(); // see below
      }
      if (event.betterPlayerEventType == BetterPlayerEventType.bufferingEnd ||
          event.betterPlayerEventType == BetterPlayerEventType.play) {
        _cancelBufferingTimeout();
      }
      //

      // ✅ Log track details when initialized
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        // ✅ Log video dimensions from videoPlayerController
        final value =
            betterPlayerController.value?.videoPlayerController?.value;
        debugPrint("✅ Video initialized: "
            "size=${value?.size}, "
            "duration=${value?.duration}, "
            "aspectRatio=${value?.aspectRatio}");
      }
    });

    betterPlayerController.value = controller;
    videoHasError.value = false;
  }

// ✅ New: error state + retry
  RxBool videoHasError = false.obs;
  // Add this alongside videoHasError
  RxBool videoUnsupported = false.obs;

  void retryVideoPlayer() {
    disposePlayer();
    videoHasError.value = false;
    videoUnsupported.value = false; // ✅ reset
    initializeBetterPlayerOnce();
  }

  void disposePlayer() {
    _cancelBufferingTimeout();
    betterPlayerController.value?.dispose();
    betterPlayerController.value = null;
    videoUnsupported.value = false; // ✅ reset
  }
// In ProductController

  Timer? _bufferingTimer;

  void _startBufferingTimeout() {
    _cancelBufferingTimeout();
    _bufferingTimer = Timer(const Duration(seconds: 15), () {
      debugPrint("⚠️ Buffering timeout — triggering error UI");
      videoHasError.value = true;
    });
  }

  void _cancelBufferingTimeout() {
    _bufferingTimer?.cancel();
    _bufferingTimer = null;
  }

  // void initializeBetterPlayerOnce() {
  //   final videoPath = productDetailsModel.value.video;
  //   if (videoPath == null || videoPath.isEmpty) return;

  //   // if (betterPlayerController.value != null) return;
  //   betterPlayerController.value?.dispose(); // dispose old safely

  //   betterPlayerController.value = null;

  //   //
  //   final fullUrl = videoPath.startsWith("http")
  //       ? videoPath
  //       : "${ApiService().baseUrl}$videoPath";

  //   debugPrint('fullUrl  : $fullUrl');

  //   final config = BetterPlayerConfiguration(
  //     aspectRatio: 16 / 9,
  //     autoPlay: false,
  //     looping: false,
  //     fit: BoxFit.contain,
  //     handleLifecycle: true,
  //     controlsConfiguration: const BetterPlayerControlsConfiguration(
  //       enableFullscreen: true,
  //       enableSkips: true,
  //     ),
  //   );

  //   final dataSource = BetterPlayerDataSource(
  //     BetterPlayerDataSourceType.network,

  //     fullUrl,
  //     headers: {
  //       "User-Agent": "Mozilla/5.0 (Mobile; Flutter)",
  //       "Accept": "*/*",
  //     },
  //     // fullUrl,
  //     // headers: {
  //     //   "User-Agent": "Mozilla/5.0 (Mobile; Flutter)",
  //     // },
  //     useAsmsSubtitles: false,
  //     notificationConfiguration: BetterPlayerNotificationConfiguration(
  //       showNotification: true,
  //     ),
  //   );

  //   final controller = BetterPlayerController(
  //     config,
  //     betterPlayerDataSource: dataSource,
  //   );
  //   controller.setupDataSource(dataSource);

  //   betterPlayerController.value = controller;

  //   //

  //   controller.addEventsListener((event) {
  //     debugPrint('BetterPlayer Event: ${event.betterPlayerEventType}');

  //     if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
  //       debugPrint("Video playback exception: ${event.parameters.toString()}");
  //     }
  //   });
  // }

  @override
  void onClose() {
    disposePlayer();
    super.onClose();
  }

  //
  Rx<ProductVariantModel?> selectedVariant = Rx<ProductVariantModel?>(null);
  void setInitialVariant(List<ProductVariantModel> variants) {
    if (variants.isEmpty) return;

    selectedVariant.value = variants.first;
    selectedColor.value = variants.first.color;
    selectedSize.value = variants.first.size;
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
/*
  void onColorSelected(String color, List<ProductVariantModel> variants) {
    final product = productDetailsModel.value;

    selectedColor.value = color;

    // Find selected variant
    final variant = variants.firstWhere(
      (v) => v.color == color,
      orElse: () => variants.first,
    );

    selectedVariant.value = variant;
    selectedSize.value = variant.size;

    // Use variant images if available
    if (variant.img.isNotEmpty) {
      currentBannerImages.value = variant.img; // ✅ update reactively
    } else {
      currentBannerImages.value = product.banners ?? [];
    }

    refreshCartState();
    // Reset page to 0 whenever color changes
    pageController.value.jumpToPage(0);
    currentPreviewPage.value = 0;
  }
*/
  void onColorSelected(String color, List<ProductVariantModel> variants) {
    final product = productDetailsModel.value;

    selectedColor.value = color;

    final variant = variants.firstWhere(
      (v) => v.color == color,
      orElse: () => variants.first,
    );

    selectedVariant.value = variant;
    selectedSize.value = variant.size;

    if (variant.img.isNotEmpty) {
      currentBannerImages.value = variant.img;
    } else {
      currentBannerImages.value = product.banners ?? [];
    }

    refreshCartState();

    // ✅ If video exists, first image is at page 1; otherwise page 0
    final hasVideo = productDetailsModel.value.video.isNotEmpty;
    final targetPage = hasVideo ? 1 : 0;

    currentPreviewPage.value = targetPage;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.value.hasClients) {
        pageController.value.jumpToPage(targetPage);
      }
    });
  }

  RxString cartButtonLabel = AppStaticStrings.addToCard.obs;
  // void refreshCartState() {
  //   final variant = getSelectedVariantForCart();

  //   if (variant == null) {
  //     cartButtonLabel.value = AppStaticStrings.addToCard;
  //     return;
  //   }

  //   final exists = CartController.to.cartList.any(
  //     (item) => (item.variant?.sId ?? '') == variant.id,
  //   );

  //   cartButtonLabel.value = exists ? "Update Cart" : AppStaticStrings.addToCard;
  // }

  void refreshCartState() {
    if (!Get.isRegistered<CartController>()) return;

    final variant = getSelectedVariantForCart();

    if (variant == null) {
      cartButtonLabel.value = AppStaticStrings.addToCard;
      return;
    }

    final cartController = CartController.to;

    final exists = cartController.cartList.any(
      (item) => (item.variant?.sId ?? '') == variant.id,
    );

    cartButtonLabel.value = exists ? "Update Cart" : AppStaticStrings.addToCard;
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
