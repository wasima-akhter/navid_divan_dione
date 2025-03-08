import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
class RowButton extends StatelessWidget {
  const RowButton({
    super.key,
    this.borderColor,
    this.radius,
    this.firstButtonText,
    this.textColor,
    this.secendtButtonText, this.secondButtonTap, this.firstButtonTap, this.isLoading,
  });

  final Color? borderColor;
  final double? radius;
  final bool? isLoading;
  final String? firstButtonText;
  final Color? textColor;
  final Function()? secondButtonTap;
  final Function()? firstButtonTap;
  final String? secendtButtonText;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      children: [
        Expanded(
          child: CustomButton(
            onTap: firstButtonTap ??
                    () {
                  Navigator.pop(context);
                },
            fillColor: Colors.transparent,
            borderColor: borderColor ?? AppColors.kPrimaryColor,
            radius: radius,
            title: firstButtonText ?? AppStaticStrings.cancel,
            textColor: textColor ?? AppColors.kPrimaryColor,
          ),
        ),
        Expanded(
          child: CustomButton(
            fillColor: AppColors.kPrimaryColor,
            isLoading: isLoading,
            radius: radius,
            textColor: AppColors.kWhiteColor,
            onTap: secondButtonTap ??
                    () {
                  // Navigator.pop(context);
                },
            title: secendtButtonText ?? AppStaticStrings.save,
          ),
        )
      ],
    );
  }
}