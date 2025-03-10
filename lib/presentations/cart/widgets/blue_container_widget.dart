import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navid_e_commerce/core/components/custom_button_tap.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';

class BlueContainerWithIcon extends StatelessWidget {
  final Widget? child;
  final String? icon;
  final Function()? onTap;
  const BlueContainerWithIcon({
    super.key,
    this.child,
    this.icon, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(height: 32.w ,
        decoration: BoxDecoration(
            color: AppColors.kPrimaryCartColor,
            borderRadius: BorderRadius.circular(8.r)),
        child: child ??
            ButtonTapWidget(
              radius: 8.r,
              onTap:onTap?? () {},
              child: Padding(
                padding: padding8,
                child: SvgPicture.asset(
                  icon ?? '',
                  // height: 15.w,
                  width: 15.w,
                ),
              ),
            ));
  }
}
