
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: ScreenUtil().screenHeight -
            (kToolbarHeight +
                MediaQuery.of(context).viewPadding.top),
        child: Center(
            child: Image.asset(
              loadingImg,
              height: 100.w,
            )));
  }
}