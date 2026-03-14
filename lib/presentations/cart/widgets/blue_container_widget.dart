import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navid_e_commerce/core/components/custom_button_tap.dart';
import 'package:navid_e_commerce/core/components/loading.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';

class BlueContainerWithIcon extends StatelessWidget {
  final Widget? child; // keeps the custom child feature
  final String? icon;
  final Function()? onTap;
  final bool? isLoading; // normal bool, reactive outside

  const BlueContainerWithIcon({
    super.key,
    this.child,
    this.icon,
    this.onTap,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.w,
      decoration: BoxDecoration(
        color: AppColors.kPrimaryCartColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: child ??
          ButtonTapWidget(
            radius: 8.r,
            onTap: isLoading == true ? null : onTap,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: isLoading == true
                  ? SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: const Loading(),
                    )
                  : SvgPicture.asset(
                      icon ?? '',
                      width: 15.w,
                    ),
            ),
          ),
    );
  }
}
