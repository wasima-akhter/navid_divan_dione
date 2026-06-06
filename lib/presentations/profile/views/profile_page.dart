import 'dart:io';

import 'package:flutter/cupertino.dart';
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
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';
import 'package:navid_e_commerce/presentations/profile/controllers/profile_controller.dart';

import '../../../core/constants/padding_constant.dart';
import '../widgets/custom_loading_widget.dart';
import '../widgets/user_info_text_widget.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = '/profile';
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController.to.isEditMode.value = false;
    // final argument = Get.arguments;
    return DefaultScaffoldStructureWidget(
        onRefresh: () async {
          ProfileController.to.getUserProfileRequest();
        },
        appBarTitle: AppStaticStrings.myProfile,
        action: [
          Obx(() => !ProfileController.to.isEditMode.value
              ? IconButton(
                  onPressed: () {
                    ProfileController.to.isEditMode.value = true;
                  },
                  icon: Icon(
                    Icons.mode_edit_outlined,
                    color: AppColors.kWhiteColor,
                  ),
                )
              : const SizedBox.shrink())
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          space12H,
          Obx(() {
            return ProfileController.to.isLoadingProfile.value
                ? CustomLoadingWidget()
                : Column(
                    spacing: 6.h,
                    children: [
                      Obx(() {
                        return Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            // PROFILE IMAGE
                            ProfileController
                                        .to.uploadProfileImg.value.isNotEmpty &&
                                    ProfileController.to.isEditMode.value
                                ? ClipOval(
                                    child: Image.file(
                                      File(ProfileController
                                          .to.uploadProfileImg.value),
                                      height: 100.w,
                                      width: 100.w,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : CustomNetworkImage(
                                    imageUrl: ProfileController
                                            .to.userModel.value.img ??
                                        '',
                                    boxShape: BoxShape.circle,
                                    height: 100.w,
                                    imageErrorUrl: placeholderImage,
                                    width: 100.w,
                                  ),

                            // EDIT ICON
                            if (ProfileController.to.isEditMode.value)
                              Positioned(
                                bottom: -10.h,
                                right: -10.w,
                                child: IconButton(
                                  onPressed: () async {
                                    await pickImages(
                                      singleImagePath:
                                          ProfileController.to.uploadProfileImg,
                                    );
                                  },
                                  icon: SvgPicture.asset(editIcon),
                                ),
                              ),
                          ],
                        );
                      }),

/*
                      Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Obx(
                            () => ProfileController
                                        .to.uploadProfileImg.value.isNotEmpty &&
                                    ProfileController.to.isEditMode.value
                                // argument != null &&
                                // argument == 'edit'
                                ? ClipOval(
                                    child: Image.file(
                                      File(ProfileController
                                          .to.uploadProfileImg.value),
                                      height: 100.w,
                                      width: 100.w,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : CustomNetworkImage(
                                    imageUrl:
                                        '${ProfileController.to.userModel.value.img ?? ''}',
                                    boxShape: BoxShape.circle,
                                    height: 100.w,
                                    imageErrorUrl: placeholderImage,
                                    width: 100.w),
                          ),
                          Obx(() {
                            return ProfileController.to.isEditMode.value
                                ? Positioned(
                                    bottom: -10.h,
                                    right: -10.w,
                                    child: IconButton(
                                      onPressed: () async {
                                        await pickImages(
                                          singleImagePath: ProfileController
                                              .to.uploadProfileImg,
                                        );
                                        // if (// argument != null && argument == 'edit'
                                        // ProfileController.to.isEditMode.value) {
                                        //   await pickImages(
                                        //       singleImagePath:
                                        //           ProfileController.to.uploadProfileImg);
                                        // } else {
                                        //   Get.toNamed(ProfilePage.routeName, arguments: 'edit');
                                        // }
                                      },
                                      icon: SvgPicture.asset(editIcon),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          })
                        ],
                      ),
*/
                      ///====================dynamic name=====================///
                      UserInfoText(
                        text:
                            ProfileController.to.userModel.value.name ?? 'n/a',
                        fontSize: getFontSizeDefault(),
                      ),

                      ///====================dynamic email=====================///
                      UserInfoText(
                        text:
                            ProfileController.to.userModel.value.email ?? 'n/a',
                        style: poppinsRegular,
                      ),

                      CustomTextField(
                        title: AppStaticStrings.name,
                        isEnable: // argument != null && argument == 'edit'
                            ProfileController.to.isEditMode.value
                                ? true
                                : false,
                        textEditingController:
                            ProfileController.to.nameController.value,
                      ),
                      CustomTextField(
                        title: AppStaticStrings.email,
                        isEnable: /*// argument != null && argument == 'edit'
ProfileController.to.isEditMode.value ? true :*/
                            false,
                        textEditingController:
                            ProfileController.to.emailController.value,
                      ),
                      CustomTextField(
                        title: AppStaticStrings.contactNumber,
                        keyboardType: TextInputType.number,
                        isEnable: // argument != null && argument == 'edit'
                            ProfileController.to.isEditMode.value
                                ? true
                                : false,
                        textEditingController:
                            ProfileController.to.contactNumberController.value,
                      ),
                      CustomTextField(
                        title: AppStaticStrings.age,
                        isEnable: // argument != null && argument == 'edit'
                            ProfileController.to.isEditMode.value
                                ? true
                                : false,
                        textEditingController:
                            ProfileController.to.birthDayController.value,
                      ),
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
                      CustomTextField(
                        title: AppStaticStrings.taxId,
                        isEnable: // argument != null && argument == 'edit'
                            ProfileController.to.isEditMode.value
                                ? true
                                : false,
                        textEditingController:
                            ProfileController.to.taxIdController.value,
                      ),
                      space8H,
                      ProfileController.to.docPhotosList.isNotEmpty
                          ? Wrap(
                              // spacing: 8.h, runSpacing: 8.w,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                ...List.generate(
                                  ProfileController.to.docPhotosList.length,
                                  (index) => Stack(
                                    children: [
                                      Padding(
                                        padding: padding12,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          child: Image.file(
                                            File(ProfileController
                                                .to.docPhotosList[index]),
                                            height: 70.w,
                                            width: 70.w,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: -5.w,
                                        top: -5.h,
                                        child: IconButton(
                                            onPressed: () {
                                              removeImage(
                                                  uploadImages:
                                                      ProfileController
                                                          .to.docPhotosList,
                                                  imagePath: ProfileController
                                                      .to.docPhotosList[index]);
                                            },
                                            icon: const Icon(
                                              CupertinoIcons
                                                  .multiply_circle_fill,
                                              color: AppColors.kPrimaryColor,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      pickImages(
                                          allowMultiple: true,
                                          uploadImages: ProfileController
                                              .to.docPhotosList);
                                    },
                                    icon: Icon(
                                      Icons.add_circle_outline_sharp,
                                      size: 60.sp,
                                    ))
                              ],
                            )
                          : Stack(
                              children: [
                                ProfileController.to.userModel.value.documents!
                                        .isNotEmpty
                                    ? Wrap(
                                        spacing: 8.w,
                                        runSpacing: 8.w,
                                        children: List.generate(
                                          ProfileController.to.userModel.value
                                              .documents!.length,
                                          (index) => CustomNetworkImage(
                                            imageUrl:
                                                '/${ProfileController.to.userModel.value.documents![index]}',
                                            height: 100.w,
                                            width: 100.w,
                                          ),
                                        ),
                                      )
                                    : Image.asset(
                                        pdfImg,
                                      ),
                                // argument != null && argument == 'edit'
                                ProfileController.to.isEditMode.value
                                    ? Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black45),
                                          child: Center(
                                            child: IconButton(
                                                onPressed: () {
                                                  pickImages(
                                                      allowMultiple: true,
                                                      uploadImages:
                                                          ProfileController.to
                                                              .docPhotosList);
                                                },
                                                icon: Icon(
                                                  Icons.mode_edit_outlined,
                                                  color: AppColors.kWhiteColor,
                                                )),
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink()
                              ],
                            ),
                      // argument != null && argument == 'edit'
                      ProfileController.to.isEditMode.value
                          ? CustomButton(
                              isLoading: ProfileController
                                  .to.isLoadingUpdateProfile.value,
                              onTap: () async {
                                await ProfileController.to
                                    .updateProfileRequest();
                              },
                              title: AppStaticStrings.save,
                            )
                          : const SizedBox.shrink()
                    ],
                  );
          })
        ]);
  }
}
