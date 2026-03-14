import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_service.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/profile/controllers/profile_controller.dart';
import 'package:navid_e_commerce/presentations/splash/controllers/common_controller.dart';

class CustomHomeAppbar extends StatelessWidget {
  final Function()? onActionTap;
  const CustomHomeAppbar({
    super.key,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.kPrimaryColor,
      foregroundColor: AppColors.kWhiteColor,
      title: CommonController.to.isLoggedIn.value
          ? Row(
              spacing: 12.w,
              children: [
                Obx(() {
                  debugPrint(
                      'user image:  ${ApiService().baseUrl}${ProfileController.to.userModel.value.img ?? ''}   ');
                  return CustomNetworkImage(
                    imageUrl:
                        '${ApiService().baseUrl}${ProfileController.to.userModel.value.img ?? ''}',
                    boxShape: BoxShape.circle,
                    height: kToolbarHeight - 6,
                    width: kToolbarHeight - 6,
                  );
                }),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return CustomText(
                          text: ProfileController.to.userModel.value.name ?? 'user name',
                          color: AppColors.kWhiteColor,
                          maxLines: 1,
                        );
                      }),
                      Obx(() {
                        return CustomText(
                          text: ProfileController.to.userModel.value.email ?? 'user@gmail.com',
                          color: AppColors.kWhiteColor,
                          style: poppinsRegular,
                          fontSize: getFontSizeSmall(),
                          maxLines: 1,
                        );
                      })
                    ],
                  ),
                )
              ],
            )
          : CustomText(
              text: "Log in first...",
              color: AppColors.kWhiteColor,
              style: poppinsMedium,
              fontSize: getFontSizeDefault(),
            ),
      actions: [IconButton(onPressed: onActionTap, icon: SvgPicture.asset(drawerIcon))],
    );
  }
}
