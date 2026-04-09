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
import '../model/product_details_model.dart';
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
        controller.getProductDetailsRequest(productID: controller.productId.value);
      },
      appBarTitle: AppStaticStrings.productDetails,
      action: [
        GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // Get.offAllNamed destroys the stack and recreates controllers
              Get.until((route) => route.settings.name == NavigationPage.routeName);
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
                  Get.until((route) => route.settings.name == NavigationPage.routeName);
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
          final variants = <ProductVariantModel>[] ?? controller.productDetailsModel.value.variants;

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
          return Column(spacing: 12.h, crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                              '${ApiService().baseUrl}${controller.currentBannerImages[imageIndex]}',
                          width: double.infinity,
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            // Preview images

            Builder(builder: (context) {
              // if (variants == null || variants!.isEmpty) {
              //   return const SizedBox.shrink();
              // }

              /// 🔥 Find selected variant based on selected color
              final selectedVariant = variants != null && variants.isNotEmpty
                  ? variants!.firstWhere(
                      (v) => v.color == controller.selectedColor.value,
                    )
                  : ProductVariantModel();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12.h,
                children: [
                  ProdDetPreviewRow(
                    controller: controller,
                  ),

                  // select color:
                  variants!.isNotEmpty
                      ? ProdDetSelectedClrSection(controller: controller, variants: variants)
                      : Row(
                          children: [
                            CustomText(
                              text: "No color options",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),

                  //   size  section
                  variants.isNotEmpty
                      ? ProdDetSizeRow(controller: controller, selectedVariant: variants.first)
                      : Row(
                          children: [
                            CustomText(
                              text: "No size options",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),

                  ///     Select Color row

                  // Price + Cart Row
                  variants.isNotEmpty
                      ? ProdDetPriceCartRow(controller: controller, selectedVariant: variants.first)
                      : Row(
                          children: [
                            CustomText(
                              text: "No Price options",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),

                  //  ProdDetPriceCartRow(
                  //           controller: controller,
                  //           selectedVariant: selectedVariant,
                  //         ),
                  4.verticalSpace,

                  variants.isNotEmpty
                      ? ProdDetPriceCartRow(controller: controller, selectedVariant: variants.first)
                      : Row(
                          children: [
                            CustomText(
                              text: "No Price options",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),

                  // Row of Product name = type + quantity

                  variants.isNotEmpty
                      ? ProdDetProdNameDesQuantity(
                          productName: product.name ?? '',
                          productDes: product.description ?? '',
                          productQuantity: (selectedVariant.quantity ?? 0).toString(),
                        )
                      : Row(
                          children: [
                            CustomText(
                              text: "No product quantity options",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),

                  // Obx(() => CommonController.to.isLoggedIn.value
                  //     ? ProdDetBuyCartBtnRow(productId: product.id ?? '')
                  //     : const SizedBox.shrink()),

                  4.verticalSpace,
////////////   Related Product section
                  ///
                  ProductDetRelatedProducts()
                ],
              );
            }),
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
}
