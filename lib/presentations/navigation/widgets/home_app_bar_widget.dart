import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/auth/views/login_page.dart';
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
      title: Obx(() {
        return CommonController.to.isLoggedIn.value
            ? Row(
                spacing: 12.w,
                children: [
                  Obx(() {
                    debugPrint(
                        'user image:   ${ProfileController.to.userModel.value.img ?? ''}   ');
                    return CustomNetworkImage(
                      imageUrl:
                          '${ProfileController.to.userModel.value.img ?? ''}',
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
                            text: ProfileController.to.userModel.value.name ??
                                'user name',
                            color: AppColors.kWhiteColor,
                            maxLines: 1,
                          );
                        }),
                        Obx(() {
                          return CustomText(
                            text: ProfileController.to.userModel.value.email ??
                                'user@gmail.com',
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
            : GestureDetector(
                onTap: () {
                  Get.toNamed(LoginPage.routeName);
                },
                child: Row(
                  spacing: 12.w,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.r),
                      child: Image.asset(
                        'assets/icons/app_logo.png',
                        height: 35.h,
                        width: 32.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            text: "Welcome to Divandione",
                            color: AppColors.kWhiteColor,
                            style: poppinsMedium,
                            fontSize: getFontSizeDefault(),
                            maxLines: 1,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 4.w,
                            children: [
                              CustomText(
                                text: "Log in first...",
                                color: AppColors.kWhiteColor.withOpacity(0.8),
                                style: poppinsRegular,
                                fontSize: getFontSizeSmall(),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: AppColors.kWhiteColor.withOpacity(0.8),
                                size: 10.w,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
      }),
      actions: [
        IconButton(onPressed: onActionTap, icon: SvgPicture.asset(drawerIcon))
      ],
    );
  }
}
