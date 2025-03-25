import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_textfield.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';
import 'package:navid_e_commerce/presentations/settings/controllers/settings_controller.dart';
import 'package:navid_e_commerce/presentations/settings/controllers/settings_controller.dart';
import 'package:navid_e_commerce/presentations/settings/controllers/settings_controller.dart';
import 'package:navid_e_commerce/presentations/settings/controllers/settings_controller.dart';

class ChangePassPage extends StatelessWidget {
  static const String routeName = '/chang-pass';
  ChangePassPage({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldStructureWidget(
        appBarTitle: AppStaticStrings.settings,
        children: [
          Form(
            key: formKey,
            child: Column(
              spacing: 8.h,
              children: [
                CustomTextField(
                  title: AppStaticStrings.currentPass,
                  textEditingController:
                      SettingsController.to.currentPasswordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStaticStrings.passRequired;
                    }
                    if (value.length < 6) {
                      return AppStaticStrings.passMustbe6;
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  title: AppStaticStrings.newPass,
                  isPassword: true,
                  textEditingController:
                      SettingsController.to.newPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStaticStrings.passRequired;
                    } else if (value.length < 8) {
                      return AppStaticStrings.passMustbe6;
                    } else if (!value.contains(RegExp(r'[A-Z]'))) {
                      return AppStaticStrings.passMustContain;
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  title: AppStaticStrings.confirmPassword,
                  isPassword: true,
                  textEditingController:
                      SettingsController.to.confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStaticStrings.passRequired;
                    }
                    if (value !=
                        SettingsController
                            .to.newPasswordController.value.text) {
                      return AppStaticStrings.passNotMatch;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          space16H,
          Obx(() {
            return CustomButton(
              isLoading: SettingsController.to.isLoadingChangePass.value,
              onTap: () {

                if (formKey.currentState!.validate()) {
                  SettingsController.to.changePassRequest();
                }
              },
              title: AppStaticStrings.save,
            );
          })
        ]);
  }
}
