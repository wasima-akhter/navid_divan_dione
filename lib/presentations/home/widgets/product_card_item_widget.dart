import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_service.dart';
import 'package:navid_e_commerce/core/components/custom_button_tap.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';

import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/product/controllers/product_controller.dart';
import 'package:navid_e_commerce/presentations/product/model/product_model.dart';
import 'package:navid_e_commerce/presentations/product/views/product_details_page.dart';

class ProductCardItemWidget extends StatelessWidget {
  final ProductModel product;
  const ProductCardItemWidget({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    String imgUrl = product.banner != null && product.banner!.isNotEmpty
        ? product.banner!.first.toString()
        : '';
    // String size = product.variantImages != null && product.variantImages!.isNotEmpty
    //     ? '${product.variantImages..toString()}'
    //     : '';
    String productName = product.name ?? 'n/a';
    String productPrice = product.price.toString();
    String productPreviousPrice = product.previousPrice.toString();
    String productQuantity = product.quantity.toString();
    return DefaultFadeContainerWidget(
      child: ButtonTapWidget(
        onTap: () {
          Get.lazyPut(
            () => ProductController(),
          );
          ProductController.to
              .getProductDetailsRequest(productID: product.id ?? '');
          Get.toNamed(ProductDetailsPage.routeName);
        },
        child: Column(
          children: [
            Expanded(flex: 2,

                ///===================dynamic img=================///
                child: CustomNetworkImage(
              imageUrl: "${ApiService().baseUrl}/$imgUrl",
            )),
            Expanded(
                child: Column(
              spacing: 6.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ///================ dynamic product name ==================///
                Row(
                  children: [
                    Expanded(
                        child: CustomText(
                      text: productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      color: AppColors.kPrimaryTextDarkColor,
                    )),
                    CustomText(
                      text: '$productQuantity pis',
                      fontSize: getFontSizeSmall(),
                      style: poppinsLight,
                    )
                  ],
                ),

                ///================ dynamic product price ==================///
                PriceTextWidget(
                  price: productPrice,
                  previousPrice: productPreviousPrice,
                ),


              ],
            )),
            // CommonController.to.isLoggedIn
            //     ? Obx(() {
            //   final isLoading =
            //   (CartController.to.isLoadingAddCart[productId] ??
            //       false);
            //   return CustomButton(
            //     padding: padding8,
            //     radius: 40.r,
            //     isLoading: isLoading,
            //     fillColor: AppColors.kPrimaryDarkColor,
            //     onTap: () {
            //       Get.lazyPut(() => CartController());
            //       CartController.to.addToCart(
            //           productId: productId,
            //           size: product.,
            //           quantity: 1,
            //           price: int.parse(productPrice),
            //           variant: imgUrl);
            //     },
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       children: [
            //         CustomText(
            //           text: AppStaticStrings.addToCard,
            //           style: poppinsRegular,
            //           fontSize: getFontSizeSmall(),
            //           color: AppColors.kWhiteColor,
            //         ),
            //         SvgPicture.asset(
            //           cartIcon,
            //           colorFilter: ColorFilter.mode(
            //               AppColors.kWhiteColor, BlendMode.srcIn),
            //         )
            //       ],
            //     ),
            //   );
            // })
            //     : CustomButton(
            //   onTap: () {
            //     Get.toNamed(LoginPage.routeName);
            //   },
            //   height: 35.h,
            //   padding: padding2,
            //   title: AppStaticStrings.signIn,
            // )
          ],
        ),
      ),
    );
  }
}

class DefaultFadeContainerWidget extends StatelessWidget {
  final Widget child;
  const DefaultFadeContainerWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding8,
      decoration: BoxDecoration(
        color: AppColors.kTextFieldColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: child,
    );
  }
}

class PriceTextWidget extends StatelessWidget {
  final double? fontSize;
  final double? previousPriceFontSize;
  final String? price;
  final String? previousPrice;
  const PriceTextWidget({
    super.key,
    this.fontSize,
    this.previousPriceFontSize,
    this.price,
    this.previousPrice,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(children: [
          TextSpan(
              text: 'price: \$$price  ',
              style: poppinsMedium.copyWith(
                  color: AppColors.kPrimaryTextDarkColor,
                  fontSize: fontSize ?? getFontSizeSemiSmall())),
          if (previousPrice != '0.0'&&previousPrice!=price)
            TextSpan(
                text: '\$$previousPrice',
                style: poppinsRegular.copyWith(
                    color: Colors.red,
                    fontSize: previousPriceFontSize ?? getFontSizeSmall(),
                    decoration: TextDecoration.lineThrough)),
        ]));
  }
}
