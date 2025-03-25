import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_endpoints.dart';

import '../../../core/api-client/api_service.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/variable.dart';

class SettingsController extends GetxController {
  static SettingsController get to => Get.find();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  RxBool isLoadingChangePass = false.obs;
  @override
  void onInit() {
    reinitializeSignUpControllers();
    super.onInit();
  }

  reinitializeSignUpControllers() {
    if (kDebugMode) {
      confirmPasswordController.text = '1234567A';
      newPasswordController.text = '1234567A';
      currentPasswordController.text = '1234567A';
    }
  }

  clearControllers() {
    confirmPasswordController.clear();
    newPasswordController.clear();
    currentPasswordController.clear();
  }

  ///------------------------------ change pass method -------------------------///

  Future<void> changePassRequest() async {
    try {
      isLoadingChangePass.value = true;
      final response = await ApiService()
          .request(endpoint: changePassEndPoint, method: 'POST', body: {
        "confirm_password": confirmPasswordController.text,
        "password": newPasswordController.text,
        "old_password": currentPasswordController.text
      });
      isLoadingChangePass.value = false;
      if (response['success'] == true) {

        showCustomSnackbar(
          title: 'Success',
          message: response['message'],
        );
        clearControllers();
        logger.d(response);
        // Get.back();
      } else {
        logger.e(response);
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      isLoadingChangePass.value = false;

      logger.e(e.toString());
    }
  }
}
