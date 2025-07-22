import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/padding_constant.dart';

class PaginationLoadingWidget extends StatelessWidget {
  final double? size;
  const PaginationLoadingWidget({
    super.key, this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding12,
        child: SizedBox(
          height: size??10.w,
          width: size??10.w,
          child: CircularProgressIndicator(
            color: AppColors.kPrimaryColor,
            strokeWidth: 2.sp,
          ),
        ),
      ),
    );
  }
}
