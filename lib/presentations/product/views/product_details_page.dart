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
import 'package:navid_e_commerce/presentations/product/views/deliver_address_page.dart';
import 'package:navid_e_commerce/presentations/product/views/pickup_address_page.dart';
import 'package:navid_e_commerce/presentations/product/widgets/color_item_widget.dart';
import 'package:navid_e_commerce/presentations/product/widgets/expand_able_text.dart';
import 'package:navid_e_commerce/presentations/profile/widgets/custom_loading_widget.dart';

class ProductDetailsPage extends StatelessWidget {
  static const String routeName = '/product-details';
  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.to;
    return DefaultScaffoldStructureWidget(
      appBarTitle: AppStaticStrings.productDetails,
      spacing: 12.h,
      children: [
        Obx(() {
          if (controller.isLoadingProductDetails.value) {
            return CustomLoadingWidget();
          }
          final product = controller.productModel.value;
          return Column(
              spacing: 12.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        itemBuilder: (context, index) => CustomNetworkImage(
                          imageUrl:
                              '${ApiService().baseUrl}/${controller.currentBannerImages[index]}',
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
                          ...product.variantColors!.map((color) =>
                              GestureDetector(
                                onTap: () => controller.onColorSelected(color),
                                child: ColorItemWidget(
                                  textColor:
                                      controller.selectedColor.value == color
                                          ? AppColors.kWhiteColor
                                          : AppColors.kPrimaryColor,
                                  containerColor:
                                      controller.selectedColor.value == color
                                          ? AppColors.kPrimaryColor
                                          : Colors.transparent,
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
                        previousPrice:
                            (product.previousPrice ?? 0.0).toString(),
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
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Column(
                                spacing: 6.h,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomButton(
                                    onTap: () {
                                      Get.toNamed(PickupAddressPage.routeName);
                                    },
                                    title: AppStaticStrings.pickUp,
                                  ),
                                  CustomText(text: 'or'),
                                  CustomButton(
                                    onTap: () {
                                      Get.toNamed(DeliverAddressPage.routeName);
                                    },
                                    fillColor: AppColors.kPrimaryDarkColor,
                                    borderColor: AppColors.kPrimaryDarkColor,
                                    title: AppStaticStrings.deliveryAddress,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        title: AppStaticStrings.buyNow,
                      ),
                    ),
                    Expanded(child: Obx(() {
                      final isLoading =
                          CartController.to.isLoadingAddCart[product.id] ??
                              false;

                      return CustomButton(
                        loadingColor: AppColors.kPrimaryColor,
                        onTap: () {
                          CartController.to.addToCart(variant: controller.currentBannerImages[0],
                              productId: product.id ?? '',
                              quantity: ProductController.to.cartQuantity.value,
                              price: ProductController.to.cartQuantity.value *
                                  int.parse(product.price.toString()));
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
                              product: ProductController
                                  .to.relatedProductList[index],
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
}
