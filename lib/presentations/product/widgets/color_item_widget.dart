import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
class ColorItemWidget extends StatelessWidget {
  const ColorItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
              color: AppColors.kPrimaryLightColor, width: 2)),
      child: CustomText(
        text: 'Blue',
        style: poppinsRegular,
        fontSize: getFontSizeSmall(),
        color: AppColors.kPrimaryColor,
      ),
    );
  }
}
