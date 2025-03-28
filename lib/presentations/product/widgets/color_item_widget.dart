import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
class ColorItemWidget extends StatelessWidget {
  final String color;
  final bool isSelected;
  const ColorItemWidget({
    super.key, required this.color, required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding8,
      decoration: BoxDecoration(
        color: isSelected?AppColors.kPrimaryColor:Colors.transparent,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
              color: AppColors.kPrimaryLightColor, width: 2)),
      child: CustomText(
        text: color,
        style: poppinsRegular,
        fontSize: getFontSizeSmall(),
        color:isSelected?AppColors.kWhiteColor: AppColors.kPrimaryColor,
      ),
    );
  }
}
