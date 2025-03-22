import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_button_tap.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';

import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/presentations/auth/controllers/auth_controller.dart';
import 'package:navid_e_commerce/presentations/auth/views/signup_page.dart';
import 'package:navid_e_commerce/presentations/navigation/controllers/navigation_controller.dart';
import 'package:navid_e_commerce/presentations/profile/views/profile_page.dart';
import 'package:navid_e_commerce/presentations/settings/views/feedback_page.dart';
import 'package:navid_e_commerce/presentations/settings/views/privacy_terms_page.dart';
import 'package:navid_e_commerce/presentations/settings/views/settings_page.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.sizeOf(context).width / 1.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: AppColors.kSplashBackgroundColor),
                        child: Padding(
                          padding: padding16,
                          child: Image.asset(drawerImg),
                        )),
                    DrawerContentWidget(
                      icon: profileIcon,
                      text: AppStaticStrings.myProfile,
                      onTap: () {
                        Navigator.pop(context);
                        Get.toNamed(ProfilePage.routeName);
                      },
                    ),
                    DrawerContentWidget(
                      onTap: () {
                        Navigator.pop(context);
                        Get.toNamed(SettingPage.routeName);
                      },
                      icon: settingsIcon,
                      text: AppStaticStrings.settings,
                    ),
                    DrawerContentWidget(
                      onTap: () {
                        Navigator.pop(context);
                        Get.toNamed(FeedbackPage.routeName);
                      },
                      icon: feedbackIcon,
                      text: AppStaticStrings.feedback,
                    ),
                    DrawerContentWidget(
                      onTap: () {
                        Navigator.pop(context);
                        Get.toNamed(PrivacyTermsPage.routeName,
                            arguments: 'privacy');
                      },
                      icon: privacyIcon,
                      text: AppStaticStrings.privacyPolicy,
                    ),
                    DrawerContentWidget(
                      onTap: () {
                        Navigator.pop(context);
                        Get.toNamed(PrivacyTermsPage.routeName,
                            arguments: 'terms');
                      },
                      icon: termsIcon,
                      text: AppStaticStrings.termsOfUse,
                    ),
                  ],
                ),
              ),
            ),
            NavigationController.to.isLoadingLogout.value?
            DefaultProgressIndicator(color: AppColors.kPrimaryColor,)
                :   ButtonTapWidget(
              onTap: () {
               NavigationController.to.logoutRequest();
              },
              child: Padding(
                padding: padding12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      logoutIcon,
                      height: 14.w,
                      width: 14.w,
                    ),
                    space8W,
                    CustomText(
                      textAlign: TextAlign.center,
                      text: AppStaticStrings.logOut,
                      fontSize: getFontSizeSmall(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerContentWidget extends StatelessWidget {
  final String icon;
  final String text;
  final Function()? onTap;
  const DrawerContentWidget({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTapWidget(
      onTap: onTap ?? () {},
      child: Column(
        children: [
          Padding(
            padding: padding16,
            child: Row(
              children: [
                SvgPicture.asset(
                  icon,
                  height: 14.w,
                  width: 14.w,
                ),
                space16W,
                Expanded(
                  child: CustomText(
                    text: text,
                    fontSize: getFontSizeSmall(),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Color(0xffEEEEEE),
          )
        ],
      ),
    );
  }
}
