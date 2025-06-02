import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_endpoints.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/navigation/views/navigation_page.dart';
import 'package:navid_e_commerce/presentations/profile/model/user_profile_model.dart';

import '../../../core/api-client/api_service.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/hive_boxes.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();
  RxBool isLoadingProfile = false.obs;
  RxBool isLoadingUpdateProfile = false.obs;

  RxString uploadProfileImg = ''.obs;

  ///=====================add dynmic name ====================///
  Rx<TextEditingController> nameController =
      TextEditingController(/*text: kDebugMode ? 'Khushi akter' : ''*/).obs;

  ///=====================add dynmic email ====================///
  Rx<TextEditingController> emailController =
      TextEditingController(/*text: kDebugMode ? 'youremail@gmail.com' : ''*/)
          .obs;

  ///=====================add dynmic contactNumber ====================///
  Rx<TextEditingController> contactNumberController =
      TextEditingController(/*text: kDebugMode ? '+999 68526546 65' : ''*/).obs;

  ///=====================add dynmic birth day ====================///
  Rx<TextEditingController> birthDayController = TextEditingController(
          /* text: kDebugMode ? '4140 Parker Rd. Allentown, New Mexico 31134' : ''*/)
      .obs;

  ///=====================add dynmic tax id ====================///
  Rx<TextEditingController> taxIdController = TextEditingController(
          /* text: kDebugMode ? '4140 Parker Rd. Allentown, New Mexico 31134' : ''*/)
      .obs;
  Rx<UserProfileModel> userModel = UserProfileModel().obs;
  reinitializeProfileControllers() {
    nameController.value.text = userModel.value.name ?? '';

    ///=====================add dynmic email ====================///
    emailController.value.text = userModel.value.email ?? '';

    ///=====================add dynmic contactNumber ====================///
    contactNumberController.value.text = userModel.value.phone ?? '';

    ///=====================add dynmic birth day ====================///
    birthDayController.value.text = userModel.value.age.toString();

    ///=====================add dynmic tax id ====================///
    taxIdController.value.text = userModel.value.taxId ?? '';

  }
  RxList<String> docPhotosList = <String>[].obs;

  @override
  void onInit() {
    getUserProfileRequest();
    super.onInit();
  }

  ///------------------------------ get User profile method -------------------------///

  Future<void> getUserProfileRequest() async {
    try {
      isLoadingProfile.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService()
          .request(endpoint: getProfileEndPoint, method: 'GET');
      isLoadingProfile.value = false;
      if (response['success'] == true) {
        logger.d(response);
        userModel.value = UserProfileModel.fromJson(response['data']);
        if(response['data']['tax_id']!=null){
          Boxes.getUserData().put("hasTax", true);
        }else{
          Boxes.getUserData().put("hasTax", false);
        }
        reinitializeProfileControllers();
      } else if (response['message'] == AppStaticStrings.noInternet) {
        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
          noInternet: true,
          retryTap: () {
            getUserProfileRequest();
          },
        );
      } else {
        logger.e(response);
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingProfile.value = false;
    }
  }

  ///------------------------------ update profile method -------------------------///

  Future<void> updateProfileRequest() async {
    try {
      isLoadingUpdateProfile.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
      Map<String, String> fields = {
        'name': nameController.value.text,
        'phone': contactNumberController.value.text,
        "tax_id": taxIdController.value.text,
      };
      Map<String, dynamic> files = {};

      // Only add profile image if a new one was selected
      if (uploadProfileImg.value.isNotEmpty) {
        files['img'] = File(uploadProfileImg.value);
      }

      // Only add documents if there are any in the list
      if (docPhotosList.isNotEmpty) {
        // Convert non-empty paths to File objects
        List<File> docFiles = [];
        for (String path in docPhotosList) {
          if (path.isNotEmpty) {
            docFiles.add(File(path));
          }
        }

        // Only add to files map if we have valid files
        if (docFiles.isNotEmpty) {
          files['documents'] = docFiles;
        }
      }
      final response = await ApiService()
          .multipartRequest(endpoint: updateProfileEndPoint, method: 'PATCH', fields: fields, files: files);
      isLoadingUpdateProfile.value = false;
      if (response['success'] == true) {
        logger.d(response);
        getUserProfileRequest();

        Get.offAllNamed(NavigationPage.routeName);
      } else {
        logger.e(response);
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingUpdateProfile.value = false;
    }
  }
}
