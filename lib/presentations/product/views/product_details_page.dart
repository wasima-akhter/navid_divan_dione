import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_service.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/cart/controllers/cart_controller.dart';
import 'package:navid_e_commerce/presentations/cart/widgets/cart_item_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/product_card_item_widget.dart';
import 'package:navid_e_commerce/presentations/product/controllers/product_controller.dart';
import 'package:navid_e_commerce/presentations/product/widgets/color_item_widget.dart';
import 'package:navid_e_commerce/presentations/product/widgets/expand_able_text.dart';
import 'package:navid_e_commerce/presentations/profile/widgets/custom_loading_widget.dart';
import 'package:video_player/video_player.dart';

import '../../../core/helper/helper_function.dart';

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
      appBarTitle: AppStaticStrings.productDetails,
      spacing: 12.h,
      children: [
        Obx(() {
          final product = controller.productModel.value;
          if (controller.isLoadingProductDetails.value) {
            return CustomLoadingWidget();
          }
         else if(product.id==null){
           return CustomText(text: "Product Details is Empty!!");
          }
          return Column(spacing: 12.h, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Obx(
              () {
                if (controller.currentBannerImages.isEmpty) {
                  return SizedBox.shrink();
                }
                return SizedBox(
                  height: 150.h,
                  child: PageView.builder(
                    controller: controller.pageController.value,
                    itemCount: controller.currentBannerImages.length,
                    itemBuilder: (context, index) => (controller.selectedColor.value == "video" /*&& _controller!=null*/)
                        ?
                        // VideoPlayer(controller)
                        GestureDetector(

                          onTap: () {
                      if (ProductController.to.videoController.value != null &&
                  ProductController.to.videoController.value!.value.isInitialized) {
                showDialog(
                context: context,
                builder: (context) => AlertDialog(
                scrollable: true,
                content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                AspectRatio(
                aspectRatio: ProductController.to.videoController.value!.value.aspectRatio,
                child: VideoPlayer(ProductController.to.videoController.value!),
                ),
                IconButton(
                onPressed: () {
                if (ProductController.to.videoController.value!.value.isCompleted) {
                ProductController.to.videoController.value!.seekTo(Duration.zero);
                ProductController.to.videoController.value!.play();
                }

                ProductController.to.videoController.value!.value.isPlaying
                ? ProductController.to.videoController.value!.pause()
                    : ProductController.to.videoController.value!.play();
                },
                icon: ValueListenableBuilder(
                valueListenable: ProductController.to.videoController.value!,
                builder: (context, value, _) {
                return Icon(
                color: AppColors.kPrimaryColor,
                value.isPlaying ? Icons.pause : Icons.play_arrow,
                );
                },
                ),
                ),
                ],
                ),
                ),
                );
                }
                },
                          child: Container(
                              height: 150.h,
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(

                                  color: AppColors.kWhiteColor.withValues(alpha: .5),
                                  image: DecorationImage(image: AssetImage("assets/icons/video.png",),fit: BoxFit.fitHeight,alignment: Alignment.center)),

                            ),
                        )
                        : CustomNetworkImage(
                            imageUrl: '${ApiService().baseUrl}/${controller.currentBannerImages[index]}',
                            height: 150.h,
                            width: double.infinity,
                          ),
                  ),
                );
              },
            ),
            Obx(
              () {
                if (product.variantColors?.isEmpty ?? true) {
                  return SizedBox.shrink();
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 12.w,
                    children: [
                      CustomText(text: AppStaticStrings.selectColor),
                      ...product.variantColors!.map((color) => GestureDetector(
                            onTap: () {
                              controller.onColorSelected(color);
                            },
                            child: ColorItemWidget(
                              textColor: controller.selectedColor.value == color ? AppColors.kWhiteColor : AppColors.kPrimaryColor,
                              containerColor: controller.selectedColor.value == color ? AppColors.kPrimaryColor : Colors.transparent,
                              color: color,
                            ),
                          )),
                    ],
                  ),
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: PriceTextWidget(
                    previousPrice: (product.previousPrice ?? 0.0).toString(),
                    price: (product.price ?? 0.0).toString(),
                    fontSize: getFontSizeExtraLarge(),
                    previousPriceFontSize: getFontSizeDefault(),
                  ),
                ),
                CartCounterWidget(
                  count: ProductController.to.cartQuantity,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    text: product.name ?? '',
                    fontSize: getFontSizeDefault(),
                    color: AppColors.kPrimaryTextDarkColor,
                  ),
                ),
                CustomText(
                  text: '${product.quantity ?? ''} pis',
                  style: poppinsRegular,
                )
              ],
            ),
            ExpandableText(
              text: product.description ?? '',
              maxLines: 3,
            ),
            Row(
              spacing: 12.w,
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      buyProductDialog(context);
                    },
                    title: AppStaticStrings.buyNow,
                  ),
                ),
                Expanded(child: Obx(() {
                  final isLoading = CartController.to.isLoadingAddCart[product.id] ?? false;

                  return CustomButton(
                    loadingColor: AppColors.kPrimaryColor,
                    onTap: () {
                      CartController.to.addToCart(
                          variant: controller.currentBannerImages[0],
                          productId: product.id ?? '',
                          quantity: ProductController.to.cartQuantity.value,
                          price: ProductController.to.cartQuantity.value * int.parse(product.price.toString()));
                    },
                    isLoading: isLoading,
                    title: AppStaticStrings.addToCard,
                    fillColor: Colors.transparent,
                    textColor: AppColors.kPrimaryColor,
                  );
                }))
              ],
            ),
            CustomText(
              text: 'Related Products',
              fontSize: getFontSizeDefault(),
              color: AppColors.kPrimaryTextDarkColor,
            ),
            SizedBox(
              height: 250,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 12.w,
                  children: List.generate(
                    ProductController.to.relatedProductList.length,
                    (index) => SizedBox(
                        width: 200.w,
                        // height: 200.w,
                        child: ProductCardItemWidget(
                          product: ProductController.to.relatedProductList[index],
                        )),
                  ),
                ),
              ),
            )
          ]);
        })
      ],
    );
  }

  @override
  void dispose() {
    ProductController.to.videoController.value!.dispose();
    super.dispose();
  }
}
