import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/auth/controllers/auth_controller.dart';

class OtpTextField extends StatelessWidget {
  const OtpTextField({super.key});

  // final AuthController otpController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Expanded(
          child: Container(
            width: 50.w,
            height: 50.w,
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Obx(() {
              return TextField(
                controller: AuthController.to.otpControllers[index].value,
                focusNode: AuthController.to.focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: poppinsMedium.copyWith(
                  fontSize: getFontSizeLarge(),
                  color: AppColors.kWhiteColor
                ),
                cursorColor: AppColors.kPrimaryColor,
                maxLength: 1, // Restrict to 1 digit
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                    fillColor:
                        AuthController.to.otpControllers[index].value.text.isNotEmpty
                            ? AppColors.kPrimaryColor
                            : Colors.transparent,
                    filled: true,
                    counterText: "", // Hide character counter
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.kPrimaryColor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.kPrimaryColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.kPrimaryColor))),
                onChanged: (value)
                {AuthController.to.onOtpChanged(value, index);
                AuthController.to.otpControllers[index].refresh();
                  },
              );
            }),
          ),
        );
      }),
    );
  }
}
