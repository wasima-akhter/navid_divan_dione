import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_endpoints.dart';
import 'package:navid_e_commerce/core/api-client/api_service.dart';
import 'package:navid_e_commerce/core/helper/helper_function.dart';
import 'package:navid_e_commerce/core/utils/hive_boxes.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/auth/views/login_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/otp_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/set_new_password_page.dart';
import 'package:navid_e_commerce/presentations/navigation/views/navigation_page.dart';

import '../../../core/constants/color_constants.dart';
import '../../splash/controllers/common_controller.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  @override
  void onInit() {
    dateOfBirth.value = DateTime.now().subtract(Duration(days: 365 * 22));
    reinitializeSignUpControllers();
    super.onInit();
  }

  RxBool isAgeChecked = false.obs;
  RxBool isIdShowChecked = false.obs;
  final List<Rx<TextEditingController>> otpControllers =
      List.generate(6, (index) => TextEditingController().obs);
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  Rx<bool> isLoadingSignUp = false.obs;
  Rx<bool> isLoadingLogin = false.obs;
  Rx<bool> isLoadingLogout = false.obs;
  Rx<bool> isLoadingActiveAcc = false.obs;
  Rx<bool> isLoadingForgetPass = false.obs;
  Rx<bool> isLoadingResetPass = false.obs;
  Rx<bool> isLoadingForgetPassVerifyOtp = false.obs;

  ///=============================controller for signUp ========================///

  Rx<TextEditingController> emailSignUpController = TextEditingController().obs;
  TextEditingController nameSignUpController = TextEditingController();
  TextEditingController phoneSignUpController = TextEditingController();
  Rx<TextEditingController> ageSignUpController = TextEditingController().obs;
  TextEditingController passSignUpController = TextEditingController();

  TextEditingController confirmPassSignUpController = TextEditingController();
  Rx<TextEditingController> emailForgetController = TextEditingController().obs;

  TextEditingController emailLoginController = TextEditingController();
  TextEditingController passLoginController = TextEditingController();

  TextEditingController passNewController = TextEditingController();

  TextEditingController confirmPassNewController = TextEditingController();

  Rx<String> otpScreen = ''.obs;
  Rx<DateTime?> dateOfBirth = Rx<DateTime?>(null); // Default to 18 years ago

  var focusedFieldIndex = -1.obs;
  String get formattedDateOfBirth {
    return "${dateOfBirth.value!.month.toString().padLeft(2, '0')}-${dateOfBirth.value!.day}-${dateOfBirth.value!.year}";
  }

  void updateDateTextField() {
    if (dateOfBirth.value != null) {
      ageSignUpController.value.text =
          "${dateOfBirth.value!.day}/${dateOfBirth.value!.month}/${dateOfBirth.value!.year}";
    } else {
      ageSignUpController.value.text = '';
    }
  }

  // Show date picker
  Future<void> selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.kPrimaryColor, // header background color
              onPrimary: AppColors.kWhiteColor, // header text color
              onSurface: AppColors.kTextDarkColor, // body text color
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: dateOfBirth.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != dateOfBirth.value) {
      dateOfBirth.value = picked;
      updateDateTextField();
      //   logger.d(formattedDateOfBirth);
    }
  }

  reinitializeSignUpControllers() {
    if (kDebugMode) {
      emailSignUpController.value.text = 'wifikom733@asaption.com';
      nameSignUpController.text = 'wifikom';
      passSignUpController.text = '1234567A';
      confirmPassSignUpController.text = '1234567A';
      ageSignUpController.value.text = formattedDateOfBirth;
      emailLoginController.text = 'abc@yopmail.com';
      emailForgetController.value.text = 'cayoj38393@evluence.com' /*'pihoner651@eligou.com'*/;
      passLoginController.text = '1234567A';
      passNewController.text = '1234567A';
      confirmPassNewController.text = '1234567A';
    }
  }

  /// Handles user input
  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        focusNodes[index + 1].requestFocus(); // Move to next field
      }
    } else if (index > 0) {
      focusNodes[index - 1].requestFocus(); // Move to previous field on backspace
    }
  }

  void clearOtp() {
    for (var controller in otpControllers) {
      controller.value.clear();
    }
    focusNodes[0].requestFocus();
  }

  bool checkOtpProvided() {
    for (var controller in otpControllers) {
      if (controller.value.text.isEmpty) {
        return false; // If any field is empty, return false
      }
    }
    return true; // All fields are filled
  }

  ///------------------------------ sign up method -------------------------///

  Future<void> signUpRequest() async {
    try {
      isLoadingSignUp.value = true;
      final response = await ApiService().request(
          endpoint: signupEndPoint,
          method: 'POST',
          body: {
            "name": nameSignUpController.text,
            "email": emailSignUpController.value.text,
            "password": passSignUpController.text,
            "confirm_password": confirmPassSignUpController.text,
            "date_of_birth": formattedDateOfBirth
          },
          useAuth: false);
      isLoadingSignUp.value = false;
      if (response['success'] == true) {
        //   logger.d(response);
        showCustomSnackbar(
          title: 'Success',
          message: response['message'],
        );
        Get.toNamed(OtpPage.routeName, arguments: verifyEmail);
      } else {
        //   logger.e(response);
        showCustomSnackbar(
            title: 'Failed', message: response['message'], type: SnackBarType.failed);
      }
    } catch (e) {
      isLoadingSignUp.value = false;

      //   logger.e(e.toString());
    }
  }

  ///------------------------------ verify email method -------------------------///

  Future<void> verifyEmailRequest({required String email, required bool isAccVerify}) async {
    try {
      isLoadingActiveAcc.value = true;
      final response = await ApiService().request(
          endpoint: verifyEmailEndPoint,
          useAuth: false,
          method: 'POST',
          body: {"email": email, "code": otpControllers.map((e) => e.value.text).join()});
      isLoadingActiveAcc.value = false;
      if (response['success'] == true) {
        //   logger.d(response);
        showCustomSnackbar(
          title: 'Success',
          message: response['message'],
        );

        if (isAccVerify) {
          Get.offAllNamed(LoginPage.routeName);
        } else {
          Boxes.getUserData().put(verifyTokenKey, response['data']['resetToken']);

          Get.toNamed(SetNewPasswordPage.routeName);
        }
      } else {
        //   logger.e(response);
        showCustomSnackbar(
            title: 'Failed', message: response['message'], type: SnackBarType.failed);
      }
    } catch (e) {
      isLoadingActiveAcc.value = false;

      //   logger.e(e.toString());
    }
  }

  ///------------------------------ sign in method -------------------------///

  Future<void> signInRequest() async {
    try {
      isLoadingLogin.value = true;
      final response = await ApiService()
          .request(endpoint: signInEndPoint, method: 'POST', useAuth: false, body: {
        "email": AuthController.to.emailLoginController.text,
        "password": AuthController.to.passLoginController.text
      });
      isLoadingLogin.value = false;
      if (response['success'] == true) {
        //   logger.d(response);
        showCustomSnackbar(
          title: 'Success',
          message: response['message'],
        );

        // await Hive.openBox(userBoxName);
        // Boxes.getUserData().put(tokenKey, response['token']);
        // ✅ Use CommonController.updateLogin — sets token, updates isLoggedIn, sets ApiService auth
        CommonController.to.updateLogin(response['token']);

        //
        clearSignInController();
        // ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());
        Get.offAllNamed(NavigationPage.routeName);
      } else {
        //   logger.e(response);
        showCustomSnackbar(
            title: 'Failed', message: response['message'], type: SnackBarType.failed);
      }
    } catch (e) {
      isLoadingLogin.value = false;

      //   logger.e(e.toString());
    }
  }

  ///------------------------------ forget password method -------------------------///

  Future<void> forgetPasswordRequest({required String email}) async {
    try {
      isLoadingForgetPass.value = true;
      final response =
          await ApiService().request(endpoint: forgetPassEndPoint, method: 'POST', body: {
        "email": email,
      });
      isLoadingForgetPass.value = false;
      if (response['success'] == true) {
        //   logger.d(response);
        showCustomSnackbar(
          title: 'Success',
          message: response['message'],
        );

        Get.toNamed(OtpPage.routeName);
      } else {
        //   logger.e(response);
        showCustomSnackbar(
            title: 'Failed', message: response['message'], type: SnackBarType.failed);
      }
    } catch (e) {
      isLoadingForgetPass.value = false;

      //   logger.e(e.toString());
    }
  }

  ///------------------------------ reset password method -------------------------///

  Future<void> resetPasswordRequest() async {
    try {
      isLoadingResetPass.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(verifyTokenKey).toString());

      final response = await ApiService().request(
        endpoint: resetPasswordEndPoint,
        method: 'POST',
        body: {
          "confirm_password": confirmPassNewController.text,
          "password": passNewController.text
        },
      );
      isLoadingResetPass.value = false;
      if (response['success'] == true) {
        //   logger.d(response);
        showCustomSnackbar(
          title: 'Success',
          message: response['message'],
        );
        ApiService().clearAuthToken();
        Get.offAllNamed(LoginPage.routeName);
      } else {
        //   logger.e(response);
        showCustomSnackbar(
            title: 'Failed', message: response['message'], type: SnackBarType.failed);
      }
    } catch (e) {
      isLoadingResetPass.value = false;
      //   logger.e(e.toString());
    }
  }

  clearSignUpController() {
    emailSignUpController.value.clear();
    nameSignUpController.clear();
    passSignUpController.clear();
    confirmPassSignUpController.clear();
  }

  clearSignInController() {
    emailLoginController.clear();
    passLoginController.clear();
  }

  // @override
  // void onClose() {
  //   emailSignUpController.value.dispose();
  //   nameSignUpController.dispose();
  //   passSignUpController.dispose();
  //   confirmPassSignUpController.dispose();
  //   passNewController.dispose();
  //   confirmPassNewController.dispose();
  //   super.onClose();
  // }
}
