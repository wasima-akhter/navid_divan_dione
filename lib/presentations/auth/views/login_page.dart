import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_check_box.dart';
import 'package:navid_e_commerce/core/components/custom_text_button.dart';
import 'package:navid_e_commerce/core/components/custom_textfield.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/helper/helper_function.dart';
import 'package:navid_e_commerce/presentations/auth/controllers/auth_controller.dart';
import 'package:navid_e_commerce/presentations/auth/views/forget_pass_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/signup_page.dart';
import 'package:navid_e_commerce/presentations/auth/widgets/auth_scaffold_structure_widget.dart';

class LoginPage extends StatelessWidget {
  static const String routeName = '/login';
  LoginPage({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldStructureWidget(
      appBarTitle: AppStaticStrings.signIn,
      children: [
        Center(
            child: SvgPicture.asset(
          signupImg,
        )),
        space12H,
        CustomText(
          text: AppStaticStrings.signInToYourAccount,
          fontSize: getButtonFontSizeLarge(),
        ),
        CustomText(
          text: AppStaticStrings.notesAgeRequirement,
          fontSize: getFontSizeSemiSmall(),
          style: poppinsRegular,
        ),
        space6H,
        Form(
          key: formKey,
          child: Column(
            spacing: 6.h,
            children: [
              CustomTextField(
                textEditingController: AuthController.to.emailLoginController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStaticStrings.emailRequired;
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return AppStaticStrings.enterValidEmail;
                  }
                  return null;
                },
                title: AppStaticStrings.email,
                hintText: AppStaticStrings.enterEmail,
              ),
              CustomTextField(
                textEditingController: AuthController.to.passLoginController,
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
                title: AppStaticStrings.password,
                hintText: AppStaticStrings.enterPassword,
                isPassword: true,
              ),
            ],
          ),
        ),
        Row(
          spacing: 6.w,
          children: [
            Obx(() {
              return CustomCheckbox(
                isChecked: AuthController.to.isAgeChecked.value,
                onChanged: (value) {
                  AuthController.to.isAgeChecked.value = value;
                },
              );
            }),
            Expanded(
              flex: 2,
              child: CustomText(
                text: AppStaticStrings.confirmOver21,
                style: poppinsRegular,
                fontSize: getFontSizeSmall(),
              ),
            ),
            Expanded(
                flex: 3,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomTextButton(
                        onPressed: () {
                          Get.toNamed(ForgetPassPage.routeName);
                        },
                        title: AppStaticStrings.forgetPassword))),
          ],
        ),
        Padding(
          padding: padding12V,
          child: Obx(
           () {
              return CustomButton(
                isLoading: AuthController.to.isLoadingLogin.value,
                onTap: () {
                  if (formKey.currentState!.validate()&&AuthController.to.isAgeChecked.value) {
                    AuthController.to.signInRequest();
                  }else if(!AuthController.to.isAgeChecked.value){
showCustomSnackbar(title: 'Failed', message: 'Age must be more then 21',type: SnackBarType.failed);
                  }
                },
                title: AppStaticStrings.signIn,
              );
            }
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: AppStaticStrings.dontHaveAccount,
              style: poppinsRegular,
              fontSize: getFontSizeSemiSmall(),
            ),
            CustomTextButton(
              title: AppStaticStrings.signUp,
              onPressed: () {
                Get.toNamed(SignupPage.routeName);
              },
            )
          ],
        ),
      ],
    );
  }
}
