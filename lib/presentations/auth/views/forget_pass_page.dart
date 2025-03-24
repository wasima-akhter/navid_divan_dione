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
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/auth/controllers/auth_controller.dart';
import 'package:navid_e_commerce/presentations/auth/views/otp_page.dart';
import 'package:navid_e_commerce/presentations/auth/widgets/auth_scaffold_structure_widget.dart';

class ForgetPassPage extends StatelessWidget {
  static const String routeName = '/forget-pass';
  ForgetPassPage({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    final String? arg = Get.arguments;
    return AuthScaffoldStructureWidget(
        appBarTitle:arg!=null&& arg==verifyEmail?AppStaticStrings.verifyEmail: AppStaticStrings.forgetPasswordAppbar,
    bottom:   Obx(
     () {
        return CustomButton(
          isLoading: AuthController.to.isLoadingForgetPass.value,
          onTap: () {
            if(formKey.currentState!.validate()){
              AuthController.to.forgetPasswordRequest(email: AuthController.to.emailForgetController.value.text);
              }
            },
          title: AppStaticStrings.sendCode,
        );
      }
    ),
        children: [
          Center(child: SvgPicture.asset(forgetPassImg)),
          space12H,
          CustomText(
            text:arg!=null&& arg==verifyEmail?AppStaticStrings.verifyEmail: AppStaticStrings.forgetPassword,
            fontSize: getButtonFontSizeLarge(),
          ),
          CustomText(
            text: AppStaticStrings.enterYourEmail,
            fontSize: getFontSizeSmall(),
            style: poppinsRegular,
          ),
          space6H,
          Form(
            key: formKey,
            child: Obx(
                     () {
                return CustomTextField(
                  textEditingController: arg!=null&& arg==verifyEmail?AuthController.to.emailSignUpController.value:AuthController.to.emailForgetController.value,
                  title: AppStaticStrings.email,
                  hintText: AppStaticStrings.enterEmail,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStaticStrings.emailRequired;
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return AppStaticStrings.enterValidEmail;
                    }
                    return null;
                  },
                );
              }
            ),
          ),

        ],);
  }
}
