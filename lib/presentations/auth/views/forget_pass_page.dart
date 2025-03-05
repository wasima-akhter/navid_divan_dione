import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_textfield.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/auth/views/otp_page.dart';
import 'package:navid_e_commerce/presentations/auth/widgets/auth_scaffold_structure_widget.dart';

class ForgetPassPage extends StatelessWidget {
  static const String routeName = '/forget-pass';
  const ForgetPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldStructureWidget(
        appBarTitle: AppStaticStrings.forgetPasswordAppbar,
    bottom:   CustomButton(
      onTap: () {
        Get.toNamed(OtpPage.routeName);
      },
      title: AppStaticStrings.sendCode,
    ),
        children: [
          Center(child: SvgPicture.asset(forgetPassImg)),
          space12H,
          CustomText(
            text: AppStaticStrings.forgetPassword,
            fontSize: getButtonFontSizeLarge(),
          ),
          CustomText(
            text: AppStaticStrings.enterYourEmail,
            fontSize: getFontSizeSmall(),
            style: poppinsRegular,
          ),
          space6H,
          CustomTextField(
            title: AppStaticStrings.email,
            hintText: AppStaticStrings.enterEmail,
          ),

        ],);
  }
}
