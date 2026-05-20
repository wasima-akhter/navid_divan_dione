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

import '../../../core/helper/helper_function.dart';

class ProductCardItemWidget extends StatelessWidget {
  final ProductModel product;
  const ProductCardItemWidget({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    String imgUrl = product.image ?? '';

    String productName = product.name ?? 'N/A';

    String productPrice = (product.priceAfterDiscount ?? 0).toStringAsFixed(2);
    String productPreviousPrice = (product.price ?? 0).toString();
    String discount = (product.discount ?? 0).toString();
    String finalImageUrl = "${ApiService().baseUrl}${product.image ?? ''}";

    var productColors = product.colors ?? [];

    debugPrint('Product Price: ${product.priceAfterDiscount}');
    debugPrint('Product previousPrice: ${product.price}');
    debugPrint('Product discount: ${product.discount}');
    debugPrint('Product finalImageUrl: ${finalImageUrl}');

    //
    return DefaultFadeContainerWidget(
      child: ButtonTapWidget(
        onTap: () {
          // ✅ Delete existing instance so onInit runs again with new arguments
          Get.delete<ProductController>(force: true);

          // debugPrint('productID: from product Card item Widget : ${product.id}');
          Get.toNamed(
            ProductDetailsPage.routeName,
            arguments: product.id ?? '',
            preventDuplicates: false, // <--- important!
          );
        },
        child: Container(
          // color: Colors.amber,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///===================dynamic img=================///
              Expanded(
                child: CustomNetworkImage(
                  imageUrl: finalImageUrl,
                  // imageUrl:
                  //     "https://api.divandione.com/uploads/img/1770620018344-brick-whitewashed-wall-with-t-shirt-hanger.jpg",
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 6.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///================ dynamic product name ==================///
                      Container(
                        child: CustomText(
                          text: productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.kPrimaryTextDarkColor,
                        ),
                      ),

                      // Colors
                      if (productColors.isNotEmpty)
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: productColors.map((colorHex) {
                            return Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                color: hexToColor(colorHex),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                            );
                          }).toList(),
                        ),

                      ///================ dynamic product price ==================///
                      PriceTextWidget(
                        price: productPrice,
                        previousPrice: productPreviousPrice,
                        discount: discount,
                      ),
                    ],
                  ),
                ),
              ),

              //
              //

              // CommonController.to.isLoggedIn.value
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
  final String? discount;
  const PriceTextWidget({
    super.key,
    this.fontSize,
    this.previousPriceFontSize,
    this.price,
    this.previousPrice,
    this.discount,
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
          if (discount != '0.0')
            TextSpan(
                text: '\$$previousPrice',
                style: poppinsRegular.copyWith(
                    color: Colors.red,
                    fontSize: previousPriceFontSize ?? getFontSizeSmall(),
                    decoration: TextDecoration.lineThrough)),
        ]));
  }
}
