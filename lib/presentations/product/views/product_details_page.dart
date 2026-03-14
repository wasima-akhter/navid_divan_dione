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

    final productId = controller.productId.value;
    return DefaultScaffoldStructureWidget(
      onRefresh: () async {
        controller.getProductDetailsRequest(productID: controller.productId.value);
      },
      appBarTitle: AppStaticStrings.productDetails,
      spacing: 12.h,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Obx(
        () => CartController.to.cartList.isNotEmpty
            ? GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  NavigationController.to.currentNavIndex.value = 1;
                  Get.toNamed(NavigationPage.routeName);
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
          return Column(spacing: 12.h, crossAxisAlignment: CrossAxisAlignment.start, children: [
            /////////     video play section

            ////////////////////////////////
            Obx(
              () {
                debugPrint(
                    'currentBannerImages[index] :  ${controller.currentBannerImages.toString()} ');
                if (controller.currentBannerImages.isEmpty) {
                  return SizedBox.shrink();
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
              if (variants == null || variants!.isEmpty) {
                return const SizedBox.shrink();
              }

              /// 🔥 Find selected variant based on selected color
              final selectedVariant = variants!.firstWhere(
                (v) => v.color == controller.selectedColor.value,
                orElse: () => variants!.first,
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12.h,
                children: [
                  ProdDetPreviewRow(controller: controller, selectedVariant: selectedVariant),
                  // select color:
                  ProdDetSelectedClrSection(controller: controller, variants: variants),
                  //   size  section
                  ProdDetSizeRow(
                    controller: controller,
                    selectedVariant: selectedVariant,
                  ),

                  ///     Select Color row
                  ProdDetPriceCartRow(
                    controller: controller,
                    selectedVariant: selectedVariant,
                  ),
                  4.verticalSpace,

                  // Row of Product name = type + quantity
                  ProdDetProdNameDesQuantity(
                    productName: product.name ?? '',
                    productDes: product.description ?? '',
                    productQuantity: (selectedVariant.quantity ?? 0).toString(),
                  ),
                  Obx(() => CommonController.to.isLoggedIn.value
                      ? ProdDetBuyCartBtnRow(productId: product.id ?? '')
                      : const SizedBox.shrink()),

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
      ProductController.to.chewieController.value!.dispose();
    }
    super.dispose();
  }
}
