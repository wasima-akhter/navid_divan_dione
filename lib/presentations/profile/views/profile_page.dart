import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/components/custom_textfield.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/helper/helper_function.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';
import 'package:navid_e_commerce/presentations/profile/controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = '/profile';
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final argument = Get.arguments;
    return DefaultScaffoldStructureWidget(
        appBarTitle: AppStaticStrings.myProfile,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 6.h,
        children: [
          space12H,
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Obx(
                () => ProfileController.to.uploadProfileImg.value.isNotEmpty &&
                        argument != null &&
                        argument == 'edit'
                    ? ClipOval(
                        child: Image.file(
                          File(ProfileController.to.uploadProfileImg.value),
                          height: 70.w,
                          width: 70.w,
                          fit: BoxFit.cover,
                        ),
                      )
                    : CustomNetworkImage(
                        imageUrl: dummyProfile,
                        boxShape: BoxShape.circle,
                        height: 70.w,
                        width: 70.w),
              ),
              /*argument != null && argument == 'edit'
                  ? */
              Positioned(
                bottom: -10.h,
                right: -10.w,
                child: IconButton(
                    onPressed: () async {
                      if (argument != null && argument == 'edit') {
                        await pickImages(
                            singleImagePath:
                                ProfileController.to.uploadProfileImg);
                      } else {
                        Get.toNamed(ProfilePage.routeName, arguments: 'edit');
                      }
                    },
                    icon: SvgPicture.asset(editIcon)),
              )
            ],
          ),

          ///====================dynamic name=====================///
          UserInfoText(
            text: AppStaticStrings.userName,
            fontSize: getFontSizeDefault(),
          ),

          ///====================dynamic email=====================///
          UserInfoText(
            text: 'mstkhushiakter333@gmail.com',
            style: poppinsRegular,
          ),

          Obx(() {
            return CustomTextField(
              title: AppStaticStrings.name,
              isEnable: argument != null && argument == 'edit' ? true : false,
              textEditingController: ProfileController.to.nameController.value,
            );
          }),
          Obx(() {
            return CustomTextField(
              title: AppStaticStrings.email,
              isEnable:
                  /*argument != null && argument == 'edit' ? true :*/ false,
              textEditingController: ProfileController.to.emailController.value,
            );
          }),
          Obx(() {
            return CustomTextField(
              title: AppStaticStrings.contactNumber,
              keyboardType: TextInputType.number,
              isEnable: argument != null && argument == 'edit' ? true : false,
              textEditingController:
                  ProfileController.to.contactNumberController.value,
            );
          }),
          Obx(() {
            return CustomTextField(
              title: AppStaticStrings.location,
              isEnable: argument != null && argument == 'edit' ? true : false,
              textEditingController:
                  ProfileController.to.locationController.value,
            );
          }),
          Row(
            children: [
              Expanded(
                child: CustomText(
                  text: AppStaticStrings.documentation,
                  style: poppinsSemiBold,
                ),
              ),
            ],
          ),
          Obx(() {
            return CustomTextField(
              title: AppStaticStrings.taxId,
              isEnable: argument != null && argument == 'edit' ? true : false,
              textEditingController:
                  ProfileController.to.locationController.value,
            );
          }),
          Image.asset(pdfImg),
          argument != null && argument == 'edit'
              ? CustomButton(
                  // isLoading: ProfileController.to.isLoadingUpdateProfile.value,
                  onTap: () async {
                    // await ProfileController.to.updateProfileRequest();
                  },
                  title: AppStaticStrings.save,
                )
              : const SizedBox.shrink()
        ]);
  }
}

class UserInfoText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final TextStyle? style;
  const UserInfoText({
    super.key,
    required this.text,
    this.fontSize, this.style,
  });

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      fontSize: fontSize ?? getFontSizeSmall(),
      style:style?? poppinsMedium
    );
  }
}
