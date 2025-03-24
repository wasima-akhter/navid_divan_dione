import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/auth/controllers/auth_controller.dart';
import 'package:navid_e_commerce/presentations/auth/views/login_page.dart';
import 'package:navid_e_commerce/presentations/auth/widgets/auth_scaffold_structure_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navid_e_commerce/core/components/custom_textfield.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';

import '../../../core/utils/hive_boxes.dart';

class SetNewPasswordPage extends StatelessWidget {
  static const String routeName = '/set-new-pass';
  SetNewPasswordPage({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return AuthScaffoldStructureWidget(
        bottom: Obx(() {
          return CustomButton(
            isLoading: AuthController.to.isLoadingResetPass.value,
            onTap: () {
              if (formKey.currentState!.validate()) {
                AuthController.to.resetPasswordRequest();
              }
              logger.d(Boxes.getUserData().get(verifyTokenKey).toString());
            },
            title: AppStaticStrings.confirm,
          );
        }),
        appBarTitle: AppStaticStrings.setNewPassword,
        children: [
          Center(child: SvgPicture.asset(signupImg)),
          space12H,
          CustomText(
            text: AppStaticStrings.setNewPassword,
            fontSize: getButtonFontSizeLarge(),
          ),
          CustomText(
            text: AppStaticStrings.createNewPasswordMessage,
            fontSize: getFontSizeSmall(),
            style: poppinsRegular,
          ),
          space12H,
          Form(
            key: formKey,
            child: Column(
              spacing: 6.h,
              children: [
                CustomTextField(
                  title: AppStaticStrings.password,
                  hintText: AppStaticStrings.enterPassword,
                  isPassword: true,
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
                  isRequired: true,
                  textEditingController: AuthController.to.passNewController,
                ),
                CustomTextField(
                  title: AppStaticStrings.confirmPassword,
                  hintText: AppStaticStrings.enterPassword,
                  textEditingController:
                      AuthController.to.confirmPassNewController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStaticStrings.passRequired;
                    } else if (value !=
                        AuthController.to.passNewController.text) {
                      return AppStaticStrings.passNotMatch;
                    }
                    return null;
                  },
                  isRequired: true,
                ),
              ],
            ),
          )
        ]);
  }
}
