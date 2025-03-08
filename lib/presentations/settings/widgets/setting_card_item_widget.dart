import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';


class SettingCardItemWidget extends StatelessWidget {
  final String title;
  final String icon;
  final Function()? onTap;
  const SettingCardItemWidget({
    super.key,
    required this.title,
    required this.icon, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:onTap?? () {},
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            spacing: 8.w,
            children: [
              SvgPicture.asset(
                icon,
                height: 24.w,

              ),
              CustomText(text: title)
            ],
          ),
        ),
      ),
    );
  }
}
