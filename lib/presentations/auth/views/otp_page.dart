import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_text_button.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/presentations/auth/views/set_new_password_page.dart';
import 'package:navid_e_commerce/presentations/auth/widgets/auth_scaffold_structure_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/auth/widgets/otp_text_field.dart';

class OtpPage extends StatelessWidget {
  static const String routeName = '/otp';
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldStructureWidget(
        appBarTitle: AppStaticStrings.otp,
        bottom: CustomButton(
          onTap: () {
            Get.toNamed(SetNewPasswordPage.routeName);
          },
          title: AppStaticStrings.sendCode,
        ),
        children: [
          Center(child: SvgPicture.asset(signupImg)),
          space12H,
          CustomText(
            text: AppStaticStrings.checkYourEmail,
            fontSize: getButtonFontSizeLarge(),
          ),
          CustomText(
            text: AppStaticStrings.otpDescription,
            fontSize: getFontSizeSmall(),
            style: poppinsRegular,
          ),
          space12H,
          OtpTextField(),
          Align(
            alignment: Alignment.centerRight,
            child: CustomTextButton(
              title: AppStaticStrings.resendOtp,
              fontSize: getFontSizeSmall(),
            ),
          )
        ]);
  }
}
