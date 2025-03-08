import 'package:flutter/material.dart';
import 'package:navid_e_commerce/core/components/custom_textfield.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';

class ChangePassPage extends StatelessWidget {
  static const String routeName = '/chang-pass';
  const ChangePassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldStructureWidget(
        appBarTitle: AppStaticStrings.settings,
        children: [
          CustomTextField(
            title: AppStaticStrings.currentPass,
            // textEditingController:
            //     ProfileController.to.currentPasswordController.value,
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
            // textEditingController:
            //     ProfileController.to.newPasswordController.value,
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
            title: AppStaticStrings.confirmPassword,
            isPassword: true,
            // textEditingController:
            //     ProfileController.to.confirmPasswordController.value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStaticStrings.passRequired;
              }
              // if (value !=
              //     ProfileController.to.newPasswordController.value.text) {
              //   return AppStaticStrings.passNotMatch;
              // }
              return null;
            },
          ),
        ]);
  }
}
