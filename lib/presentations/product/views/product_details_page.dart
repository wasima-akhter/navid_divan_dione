import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:navid_e_commerce/presentations/cart/controllers/cart_controller.dart';
import 'package:navid_e_commerce/presentations/product/widgets/prod_det_preview_row.dart';
import 'package:navid_e_commerce/presentations/product/widgets/prod_det_price_cart_row.dart';
import 'package:navid_e_commerce/presentations/product/widgets/prod_det_selected_clr_section.dart';
import 'package:navid_e_commerce/presentations/product/widgets/prod_det_size_row.dart';
import 'package:navid_e_commerce/presentations/product/widgets/prod_det_video_player_sec.dart';

import '../../../core/constants/image_constants.dart';
import '../../navigation/controllers/navigation_controller.dart';
import '../../navigation/views/navigation_page.dart';
import '../widgets/product_det_export.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/product-details';

  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final controller = ProductController.to;

    return DefaultScaffoldStructureWidget(
      onRefresh: () async {
        // ✅ use controller.productId.value, not the snapshotted local variable
        controller.getProductDetailsRequest(
            productID: controller.productId.value);
      },
      appBarTitle: AppStaticStrings.productDetails,
      action: [
        GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // Get.offAllNamed destroys the stack and recreates controllers
              Get.until(
                  (route) => route.settings.name == NavigationPage.routeName);
              NavigationController.to.currentNavIndex.value = 0; // cart tab
            },
            child: Icon(Icons.home)),
        SizedBox(
          width: 20.w,
        )
      ],
      spacing: 12.h,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Obx(
        () => CartController.to.cartList.isNotEmpty
            ? GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // ✅ Go back to NavigationPage (already in stack), then switch tab
                  // Get.offAllNamed destroys the stack and recreates controllers
                  Get.until((route) =>
                      route.settings.name == NavigationPage.routeName);
                  NavigationController.to.currentNavIndex.value = 1; // cart tab
                },
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColors.kPrimaryColor.withOpacity(0.3),
                  child: SvgPicture.asset(
                    cartFillIcon,
                    height: 24.w,
                    width: 24.w,
                  ),
                ).marginOnly(bottom: 1.sh * 0.05),
              )
            : const SizedBox.shrink(),
      ),
      children: [
        Obx(() {
          final product = controller.productDetailsModel.value;
          final variants = controller.productDetailsModel.value.variants;

          if (controller.isLoadingProductDetails.value) {
            return CustomLoadingWidget();
          } else if (product.id == null) {
            return SizedBox(
              height: 300,
              child: Center(
                child: CustomText(
                  text: "Product Details is Empty!!",
                ),
              ),
            );
          }
          return Column(
              spacing: 12.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /////////     video play section

                ////////////////////////////////
                Obx(
                  () {
                    debugPrint(
                        'currentBannerImages[index] :  ${controller.currentBannerImages.toString()} ');
                    if (controller.currentBannerImages.isEmpty) {
                      // Still show video even if no images
                      return const AspectRatio(
                        aspectRatio: 1,
                        child: ProdDetVideoPlayerSec(),
                      );
                    }

                    return AspectRatio(
                      aspectRatio: 1,
                      child: PageView.builder(
                        controller: controller.pageController.value,
                        itemCount: controller.currentBannerImages.length + 1,
                        itemBuilder: (context, index) {
                          // VIDEO PAGE
                          if (index == 0) {
                            return const ProdDetVideoPlayerSec();
                          }

                          // IMAGE PAGE
                          final imageIndex = index - 1;

                          return InteractiveViewer(
                            panEnabled: false,
                            boundaryMargin: const EdgeInsets.all(100),
                            minScale: 0.5,
                            maxScale: 2,
                            child: CustomNetworkImage(
                              isPreview: true,
                              imageUrl:
                                  '${controller.currentBannerImages[imageIndex]}',
                              width: double.infinity,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                // Preview images

                Obx(() {
                  final hasVariants = variants != null && variants.isNotEmpty;

                  final selectedVariant = hasVariants
                      ? variants.firstWhere(
                          (v) => v.color == controller.selectedColor.value,
                          orElse: () => variants.first,
                        )
                      : null;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Preview
                      ProdDetPreviewRow(controller: controller),

                      12.verticalSpace,

                      /// Color
                      hasVariants
                          ? ProdDetSelectedClrSection(
                              controller: controller,
                              variants: variants,
                            )
                          : _emptyPlaceholder("No color options available"),

                      /// Size
                      hasVariants
                          ? ProdDetSizeRow(
                              controller: controller,
                              selectedVariant: selectedVariant!,
                            )
                          : _emptyPlaceholder("No size options available"),

                      /// Price + Cart
                      hasVariants
                          ? Column(
                              children: [
                                4.verticalSpace,
                                ProdDetPriceCartRow(
                                  controller: controller,
                                  selectedVariant: selectedVariant!,
                                ),
                              ],
                            )
                          : _emptyPlaceholder("Price not available"),

                      /// Product Info
                      hasVariants
                          ? ProdDetProdNameDesQuantity(
                              productName: product.name ?? '',
                              productDes: product.description ?? '',
                              productQuantity:
                                  (selectedVariant?.quantity ?? 0).toString(),
                            )
                          : _emptyPlaceholder("Stock unavailable"),

                      8.verticalSpace,

                      /// Buy Button (IMPORTANT BUSINESS LOGIC)
                      if (hasVariants && (selectedVariant?.quantity ?? 0) > 0)
                        // Obx(() => CommonController.to.isLoggedIn.value
                        //     ? ProdDetBuyCartBtnRow(productId: product.id ?? '')
                        //     : const SizedBox.shrink())

                        ProdDetBuyCartBtnRow(productId: product.id ?? '')
                      else
                        _emptyPlaceholder("Out of stock — can't order"),

                      4.verticalSpace,
////////////   Related Product section
                      ///
                      ProductDetRelatedProducts(),

                      // Temporary debug widget — remove before release
                      if (kDebugMode)
                        ElevatedButton(
                          onPressed: () {
                            final val = ProductController
                                .to
                                .betterPlayerController
                                .value
                                ?.videoPlayerController
                                ?.value;

                            debugPrint("=== VIDEO DEBUG ===");
                            debugPrint("initialized: ${val?.initialized}");
                            debugPrint("size: ${val?.size}");
                            debugPrint("duration: ${val?.duration}");
                            debugPrint("hasError: ${val?.hasError}");
                            debugPrint(
                                "errorDescription: ${val?.errorDescription}");
                            debugPrint("isBuffering: ${val?.isBuffering}");
                            debugPrint("isPlaying: ${val?.isPlaying}");
                          },
                          child: const Text("DEBUG VIDEO"),
                        ),
                    ],
                  );
                })
              ]);
        })
      ],
    );
  }

  @override
  void dispose() {
    if (ProductController.to.chewieController.value != null) {
      // ProductController.to.chewieController.value!.dispose();
    }
    super.dispose();
  }

  //
  Widget _emptyPlaceholder(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16.sp, color: Colors.grey),
          6.horizontalSpace,
          CustomText(
            text: text,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
