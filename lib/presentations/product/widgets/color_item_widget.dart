import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';

class ColorItemWidget extends StatelessWidget {
  final String color;
  final Color? textColor;
  final Color? containerColor;
  const ColorItemWidget({
    super.key,
    required this.color,
    this.textColor,
    this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding8,
      decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
              color: Colors.grey.shade300,
              // AppColors.kPrimaryLightColor,
              width: 1)),
      child: CustomText(
        text: color,
        style: poppinsMedium,
        fontSize: getFontSizeSmall(),
        color: textColor,
      ),
    );
  }
}
