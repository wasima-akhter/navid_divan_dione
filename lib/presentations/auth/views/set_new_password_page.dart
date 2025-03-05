import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/presentations/auth/views/login_page.dart';
import 'package:navid_e_commerce/presentations/auth/widgets/auth_scaffold_structure_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navid_e_commerce/core/components/custom_textfield.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';

class SetNewPasswordPage extends StatelessWidget {
  static const String routeName = '/set-new-pass';
  const SetNewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldStructureWidget(
        bottom: CustomButton(
          onTap: () {
            Get.toNamed(LoginPage.routeName);
          },
          title: AppStaticStrings.confirm,
        ),
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
          CustomTextField(
            title: AppStaticStrings.password,
            hintText: AppStaticStrings.enterPassword,
            isPassword: true,
          ), CustomTextField(
            title: AppStaticStrings.confirmPassword,
            hintText: AppStaticStrings.enterPassword,
            isPassword: true,
          ),

        ]);
  }
}
