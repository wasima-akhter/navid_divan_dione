import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
class CustomHomeAppbar extends StatelessWidget {
  const CustomHomeAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.kPrimaryColor,
      foregroundColor: AppColors.kWhiteColor,
      title: Row(
        spacing: 12.w,
        children: [
          CustomNetworkImage(
            imageUrl: dummyProfile,
            boxShape: BoxShape.circle,
            height: kToolbarHeight-6,
            width: kToolbarHeight-6,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Md Masud rana',
                  color: AppColors.kWhiteColor,
                  maxLines: 1,
                ), CustomText(
                  text: 'Syracuse, Connecticut',
                  color: AppColors.kWhiteColor,
                  style: poppinsRegular,
                  fontSize: getFontSizeSmall(),
                  maxLines: 1,
                )
              ],
            ),
          )
        ],
      ),
      actions: [
        IconButton(onPressed: () {

        }, icon: SvgPicture.asset(drawerIcon))
      ],
    );
  }
}
