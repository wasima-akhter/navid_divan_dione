import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_textfield.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/core/helper/helper_function.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';
import 'package:navid_e_commerce/presentations/settings/views/change_pass_page.dart';
import 'package:navid_e_commerce/presentations/settings/widgets/setting_card_item_widget.dart';

class SettingPage extends StatelessWidget {
  static const String routeName = '/settings';
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldStructureWidget(
        appBarTitle: AppStaticStrings.settings, children: [
      SettingCardItemWidget(
        onTap: () {
          Get.toNamed(ChangePassPage.routeName);
        },
        title: AppStaticStrings.changePass,
        icon: changePassIcon,
      ), SettingCardItemWidget(
        onTap: () {
          defaultAlertDialog(context,
              title: AppStaticStrings.deleteAcc,
              backgroundColor: AppColors.kWhiteColor,
              child:Column(
                spacing: 12.h,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(

                    title: AppStaticStrings.confirmPass,
                    isPassword: true,
                  ),Row(
                    spacing: 16.w,
                    children: [
                      Expanded(
                          child: CustomButton(

                            onTap:
                                () {
                              Navigator.pop(context);
                            },
                            // height: 44.h,
                            width: 92.w,
                            title:  AppStaticStrings.yes,
                            textColor: AppColors.kWhiteColor,
                            borderColor: Colors.red,
                            fillColor: Colors.red,
                          )),
                      Expanded(
                          child: CustomButton(
                            onTap:
                                () {
                              Navigator.pop(context);
                            },
                            // height: 44.h,
                            width: 92.w,
                            title:  AppStaticStrings.no,
                            textColor: AppColors.kWhiteColor,
                            borderColor: AppColors.kPrimaryColor,
                            fillColor: AppColors.kPrimaryColor,
                          )),
                    ],
                  ),
                  space16H,
                ],

              ));
        },
        title: AppStaticStrings.deleteAcc,
        icon: deleteIcon,
      ),
    ]);
  }
}
