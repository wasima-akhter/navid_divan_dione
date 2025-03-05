import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navid_e_commerce/core/components/custom_textfield.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
class SearchTextFieldWidget extends StatelessWidget {
  const SearchTextFieldWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      prefixIcon: Padding(
        padding: padding8,
        child: SvgPicture.asset(searchIcon),
      ),
      fillColor: AppColors.kPrimaryExtraLightColor,
      hintText: 'Search here...',
      hintStyle: poppinsMedium.copyWith(
          color: AppColors.kPrimaryTextDarkColor,
          fontSize: getFontSizeSmall()),
    );
  }
}
