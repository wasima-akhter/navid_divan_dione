import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/core/components/custom_button_tap.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
class BlueContainerWithIcon extends StatelessWidget {
  final Widget? child;
  final IconData? icon;
  const BlueContainerWithIcon({
    super.key,
    this.child,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.kPrimaryLightColor,
            borderRadius: BorderRadius.circular(8.r)),
        child: child ??
            ButtonTapWidget(
              radius: 8.r,
              onTap: () {},
              child: Padding(
                padding: padding6,
                child: Icon(
                  icon ?? CupertinoIcons.minus,
                  color: AppColors.kPrimaryDarkColor,
                  size: 15.sp,
                ),
              ),
            ));
  }
}
