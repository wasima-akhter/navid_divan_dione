
import 'package:flutter/material.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
class UserInfoText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final TextStyle? style;
  const UserInfoText({
    super.key,
    required this.text,
    this.fontSize,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return CustomText(
        text: text,
        fontSize: fontSize ?? getFontSizeSmall(),
        style: style ?? poppinsMedium);
  }
}
