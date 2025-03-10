import 'package:flutter/material.dart';
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
import 'package:navid_e_commerce/presentations/auth/views/add_documentation_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/login_page.dart';
import 'package:navid_e_commerce/presentations/auth/widgets/auth_scaffold_structure_widget.dart';

class SignupPage extends StatelessWidget {
  static const String routeName = '/sign-up';
  const SignupPage({super.key});

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
        CustomTextField(
          isRequired: true,
          hintText: AppStaticStrings.enterUserName,
          title: AppStaticStrings.fullName,
        ),
        CustomTextField(
          isRequired: true,
          hintText: AppStaticStrings.enterEmail,
          title: AppStaticStrings.email,
        ),
        CustomTextField(
          isRequired: true,
          isPassword: true,
          hintText: AppStaticStrings.enterPassword,
          title: AppStaticStrings.password,
        ),
        CustomTextField(
          isRequired: true,
          isPassword: true,
          hintText: AppStaticStrings.enterPassword,
          title: AppStaticStrings.confirmPassword,
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
        space6H,
        CustomButton(
          onTap: () {
            Get.toNamed(AddDocumentationPage.routeName);
          },
          title: AppStaticStrings.signUp,
        )
      ],
    );
  }
}
