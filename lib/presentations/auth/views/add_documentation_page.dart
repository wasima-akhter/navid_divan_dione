import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_button_tap.dart';
import 'package:navid_e_commerce/core/components/custom_check_box.dart';
import 'package:navid_e_commerce/core/components/custom_textfield.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/auth/controllers/auth_controller.dart';
import 'package:navid_e_commerce/presentations/auth/widgets/auth_scaffold_structure_widget.dart';

class AddDocumentationPage extends StatelessWidget {
  static const String routeName = '/add-doc';
  const AddDocumentationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffoldStructureWidget(
        appBarTitle: AppStaticStrings.documentations,
    bottom:  CustomButton(onTap: () {

    },
      title: AppStaticStrings.send,),
        children: [
          CustomTextField(
            title: AppStaticStrings.taxId,
            hintText: AppStaticStrings.enterTaxId,
          ),
          space12H,
          CustomText(
            text: AppStaticStrings.documentations,
            style: poppinsRegular.copyWith(
                color: AppColors.kLightTextColor,
                fontSize: getFontSizeSemiSmall()),
          ),
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
                color: AppColors.kTextFieldColor,
                borderRadius: BorderRadius.circular(8.r)),
            child: ButtonTapWidget(
              radius: 8.r ,
              onTap: () {

              },
              child: Padding(
                padding: padding16,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(addDocIcon),
                    CustomText(
                      text: AppStaticStrings.uploadImage,
                      fontSize: getFontSizeSmall(),
                      style: poppinsRegular,
                      color: AppColors.kExtraLightTextColor,
                    )
                  ],
                ),
              ),
            ),
          ),
          space12H,
          Row(
            spacing: 12.w,
            children: [
              Obx(() {
                return CustomCheckbox(
                  isChecked: AuthController.to.isIdShowChecked.value,
                  onChanged: (value) {
                    AuthController.to.isIdShowChecked.value = value;
                  },
                );
              }),
              Expanded(
                child: CustomText(
                  text: AppStaticStrings.showIdOnPickup,
                  fontSize: getFontSizeSmall(),
                  color: AppColors.kLightTextColor,
                ),
              )
            ],
          ),
          space12H,

        ],);
  }
}
