import 'package:flutter/material.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final Color? textColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderSide? border;
  final double? borderRadius;
  final double? fontSize;
  const CustomTextButton({
    super.key,
    required this.title,
    this.onPressed,
    this.textColor = AppColors.kLightTextColor,
    this.backgroundColor,
    this.padding,
    this.border,
    this.borderRadius,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: backgroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
            side: border ?? BorderSide.none,
          ),
        ),
        onPressed: onPressed ?? () {},
        child: Text(title,
            style: poppinsRegular.copyWith(
              fontSize: fontSize ?? getFontSizeSemiSmall(),
            )));
  }
}
