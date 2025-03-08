import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';

import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';

class ProductCardItemWidget extends StatelessWidget {
  const ProductCardItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultFadeContainerWidget(
      child: Column(
        children: [
          Expanded(

              ///===================dynamic img=================///
              child: CustomNetworkImage(
            imageUrl: dummyCatImg,
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
                    text: 'Thc gummy' * 5,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    color: AppColors.kPrimaryTextDarkColor,
                  )),
                  CustomText(
                    text: '12 pis',
                    fontSize: getFontSizeSmall(),
                    style: poppinsLight,
                  )
                ],
              ),

              ///================ dynamic product price ==================///
              PriceTextWidget(),

              CustomButton(
                padding: padding8,
                radius: 40.r,
                fillColor: AppColors.kPrimaryDarkColor,
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomText(
                      text: AppStaticStrings.addToCard,
                      style: poppinsRegular,
                      fontSize: getFontSizeSmall(),
                      color: AppColors.kWhiteColor,
                    ),
                    SvgPicture.asset(
                      cartIcon,
                      colorFilter: ColorFilter.mode(
                          AppColors.kWhiteColor, BlendMode.srcIn),
                    )
                  ],
                ),
              )
            ],
          ))
        ],
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
  const PriceTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(children: [
          TextSpan(
              text: 'price: \$120  ',
              style: poppinsMedium.copyWith(
                  color: AppColors.kPrimaryTextDarkColor,
                  fontSize: getFontSizeSemiSmall())),
          TextSpan(
              text: '\$150',
              style: poppinsRegular.copyWith(
                  color: Colors.red,
                  fontSize: getFontSizeSmall(),
                  decoration: TextDecoration.lineThrough)),
        ]));
  }
}
