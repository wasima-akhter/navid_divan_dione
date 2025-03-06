import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
class CategoryCardItemWidget extends StatelessWidget {
  const CategoryCardItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding8,
      decoration: BoxDecoration(
        color: AppColors.kPrimaryExtraLightColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        spacing: 8.h,
        children: [
          Expanded(child: CustomNetworkImage(imageUrl: dummyCatImg)),
          CustomText(text: 'Cigar'),
        ],
      ),
    );
  }
}
