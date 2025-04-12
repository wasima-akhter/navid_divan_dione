import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_refresh_indicator.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/helper/helper_function.dart';
import 'package:navid_e_commerce/presentations/cart/controllers/cart_controller.dart';
import 'package:navid_e_commerce/presentations/cart/widgets/cart_item_widget.dart';
import 'package:navid_e_commerce/presentations/product/controllers/product_controller.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicatorWidget(
      onRefresh: () async {
        await CartController.to.getCartListRequest();
      },
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: padding12,
                child: Obx(() {
                  return CartController.to.cartList.isEmpty
                      ? Padding(
                        padding: padding12V,
                        child: CustomText(text: "Cart List is Empty!!"),
                      )
                      : Column(
                          spacing: 12.h,
                          children: [
                            ...List.generate(
                              CartController.to.cartList.length,
                              (index) => CartItemWidget(
                                cartModel: CartController.to.cartList[index],
                              ),
                            ),
                          ],
                        );
                }),
              ),
            ),
          ),
          Padding(
            padding: padding12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: AppStaticStrings.totalAmount,
                  style: poppinsMedium,
                  fontSize: getFontSizeDefault(),
                ),

                ///--------------------- dynamic price--------------------///
                Obx(() {
                  return CustomText(
                    text: '\$${CartController.to.totalPrice.value}',
                    style: poppinsMedium,
                    fontSize: getFontSizeDefault(),
                  );
                }),
              ],
            ),
          ),
          Padding(
            padding: padding12.copyWith(top: 0),
            child: CustomButton(
              onTap: () {
buyProductDialog(context,isFromCart: true);
              },
              title: AppStaticStrings.checkout,
            ),
          )
        ],
      ),
    );
  }
}
