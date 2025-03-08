import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_button_tap.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/cart/widgets/blue_container_widget.dart';
import 'package:navid_e_commerce/presentations/cart/widgets/cart_item_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/product_card_item_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: padding12,
              child: Column(
                spacing: 12.h,
                children: [
                  ...List.generate(
                    3,
                    (index) => CartItemWidget(),
                  ),
                ],
              ),
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
              CustomText(
                text: '\$12324',
                style: poppinsMedium,
                fontSize: getFontSizeDefault(),
              ),
            ],
          ),
        ),
        Padding(
          padding: padding12.copyWith(top: 0),
          child: CustomButton(

            onTap: () {},
            title: AppStaticStrings.checkout,
          ),
        )
      ],
    );
  }
}

