import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_text_button.dart';
import 'package:navid_e_commerce/core/components/custom_textfield.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/auth/controllers/auth_controller.dart';
import 'package:navid_e_commerce/presentations/auth/views/login_page.dart';
import 'package:navid_e_commerce/presentations/auth/widgets/auth_scaffold_structure_widget.dart';

class SignupPage extends StatelessWidget {
  static const String routeName = '/sign-up';
  SignupPage({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AuthScaffoldStructureWidget(
      appBarTitle: AppStaticStrings.signUp,
      children: [
        Center(
            child: SvgPicture.asset(
          signupImg,
        )),
        space6H,
        CustomText(
          text: AppStaticStrings.welcomeBack,
          fontSize: getButtonFontSizeLarge(),
        ),
        CustomText(
          text: AppStaticStrings.createAccount,
          fontSize: getFontSizeSemiSmall(),
          style: poppinsRegular,
        ),
        space12H,
        Form(
          key: formKey,
          child: Column(
            spacing: 6.h,
            children: [
              CustomTextField(
                textEditingController: AuthController.to.nameSignUpController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStaticStrings.nameRequired;
                  }
                  return null;
                },
                isRequired: true,
                hintText: AppStaticStrings.enterUserName,
                title: AppStaticStrings.fullName,
              ),
              CustomTextField(
                textEditingController:
                    AuthController.to.emailSignUpController.value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStaticStrings.emailRequired;
                  }
                 else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return AppStaticStrings.enterValidEmail;
                  }
                  return null;
                },
                isRequired: true,
                hintText: AppStaticStrings.enterEmail,
                title: AppStaticStrings.email,
              ),
              CustomTextField(
                textEditingController: AuthController.to.passSignUpController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStaticStrings.passRequired;
                  }
                  else if (value.length < 8) {
                    return AppStaticStrings.passMustbe6;
                  }
                  else if(!value.contains(RegExp(r'[A-Z]'))){
                    return AppStaticStrings.passMustContain;
                  }
                  return null;
                },
                isRequired: true,
                isPassword: true,
                hintText: AppStaticStrings.enterPassword,
                title: AppStaticStrings.password,
              ),
              CustomTextField(
                textEditingController:
                    AuthController.to.confirmPassSignUpController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStaticStrings.passRequired;
                  }
                  else if (value !=
                      AuthController.to.passSignUpController.value.text) {
                    return AppStaticStrings.passNotMatch;
                  }
                  return null;
                },
                isRequired: true,
                isPassword: true,
                hintText: AppStaticStrings.enterPassword,
                title: AppStaticStrings.confirmPassword,
              ),
              GestureDetector(
                onTap: () {
                  AuthController.to.selectDateOfBirth(context);
                },
                child: Obx(() {
                  return CustomTextField(
                    textEditingController:
                        AuthController.to.ageSignUpController.value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStaticStrings.ageRequired;
                      }
                      return null;
                    },
                    isRequired: true,
                    isEnable: false,
                    hintText: AppStaticStrings.enterAge,
                    title: AppStaticStrings.age,
                  );
                }),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: AppStaticStrings.alreadyHaveAccount,
              style: poppinsRegular,
              fontSize: getFontSizeSemiSmall(),
            ),
            CustomTextButton(
              title: AppStaticStrings.signIn,
              onPressed: () {
                Get.toNamed(LoginPage.routeName);
              },
            )
          ],
        ),
        Obx(
         () {
            return CustomButton(isLoading: AuthController.to.isLoadingSignUp.value,
              onTap: () {
                if (formKey.currentState!.validate()) {
                  AuthController.to.signUpRequest();
                }
              },
              title: AppStaticStrings.signUp,
            );
          }
        )
      ],
    );
  }
}
