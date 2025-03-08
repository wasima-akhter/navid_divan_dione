import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/cart/widgets/cart_item_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/product_card_item_widget.dart';
import 'package:navid_e_commerce/presentations/product/widgets/color_item_widget.dart';
import 'package:navid_e_commerce/presentations/product/widgets/expand_able_text.dart';

class ProductDetailsPage extends StatelessWidget {
  static const String routeName = '/product-details';
  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldStructureWidget(
        appBarTitle: AppStaticStrings.productDetails,
        spacing: 12.h,
        children: [
          CustomNetworkImage(
            imageUrl: dummyCatImg,
            height: 170.h,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 12.w,
              children: [
                CustomText(text: AppStaticStrings.selectColor),
                ...List.generate(
                  6,
                  (index) => ColorItemWidget(),
                )
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: PriceTextWidget(
                  fontSize: getFontSizeExtraLarge(),
                  previousPriceFontSize: getFontSizeDefault(),
                ),
              ),
              CartCounterWidget()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  text: 'THC Gummy',
                  fontSize: getFontSizeDefault(),
                  color: AppColors.kPrimaryTextDarkColor,
                ),
              ),
              CustomText(
                text: '12 pis',
                style: poppinsRegular,
              )
            ],
          ),
          ExpandableText(
            text: dummyDesc,
            maxLines: 3,
          ),
          CustomButton(
            onTap: () {},
            title: AppStaticStrings.buyNow,
          ),
          CustomText(
            text: 'Related Products',
            fontSize: getFontSizeDefault(),
            color: AppColors.kPrimaryTextDarkColor,
          ),
          SizedBox(
            height: 300,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 12.w,
                children: List.generate(
                  5,
                  (index) => SizedBox(
                      width: 200.w,
                      // height: 200.w,
                      child: ProductCardItemWidget()),
                ),
              ),
            ),
          )
        ]);
  }
}
