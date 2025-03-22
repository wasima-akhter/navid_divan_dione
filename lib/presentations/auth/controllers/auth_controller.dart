import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_endpoints.dart';
import 'package:navid_e_commerce/core/api-client/api_service.dart';
import 'package:navid_e_commerce/core/helper/helper_function.dart';
import 'package:navid_e_commerce/core/utils/hive_boxes.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/auth/views/forget_pass_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/login_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/otp_page.dart';
import 'package:navid_e_commerce/presentations/navigation/views/navigation_page.dart';

import '../../../core/constants/color_constants.dart';

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
      logger.d(formattedDateOfBirth);
    }
  }

  reinitializeSignUpControllers() {
    if (kDebugMode) {
      emailSignUpController.value.text = 'cayoj38393@evluence.com';
      nameSignUpController.text = 'cayoj38393';
      passSignUpController.text = '12345678S';
      confirmPassSignUpController.text = '12345678S';
      ageSignUpController.value.text = formattedDateOfBirth;
      emailLoginController.text = 'cayoj38393@evluence.com';
      passLoginController.text = '12345678S';
      passNewController.text = '123456';
      confirmPassNewController.text = '123456';
    }
  }

  /// Handles user input
  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        focusNodes[index + 1].requestFocus(); // Move to next field
      }
    } else if (index > 0) {
      focusNodes[index - 1]
          .requestFocus(); // Move to previous field on backspace
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
  
  Future<void> signUpRequest() async{
    try{
      isLoadingSignUp.value= true;
      final response = await ApiService().request(endpoint: signupEndPont,
          method: 'POST',
        body: {
          "name": nameSignUpController.text,
          "email": emailSignUpController.value.text,

          "password": passSignUpController.text,
          "confirm_password":confirmPassSignUpController.text,
          "date_of_birth":formattedDateOfBirth

        }
      );
      isLoadingSignUp.value= false;
      if (response['success'] == true) {
        logger.d(response);
        showCustomSnackbar(title: 'Success', message:  response['message'],);
        Get.toNamed(OtpPage.routeName,arguments: verifyEmail);
      }else{
        logger.e(response);
        showCustomSnackbar(title: 'Failed', message:  response['message'],type: SnackBarType.failed);
      }
    }catch(e){
      logger.e(e.toString());
    }
  }

  ///------------------------------ verify email method -------------------------///

  Future<void> verifyEmailRequest() async{
    try{
      isLoadingActiveAcc.value= true;
      final response = await ApiService().request(endpoint: verifyEmailEndPont,
          method: 'POST',
        body: {

          "email": emailSignUpController.value.text,
          "code": otpControllers.map((e) => e.value.text).join()
        }
      );
      isLoadingActiveAcc.value= false;
      if (response['success'] == true) {
        logger.d(response);
        showCustomSnackbar(title: 'Success', message:  response['message'],);
        Get.offAllNamed(LoginPage.routeName);
      }else{
        logger.e(response);
        showCustomSnackbar(title: 'Failed', message:  response['message'],type: SnackBarType.failed);
      }
    }catch(e){
      logger.e(e.toString());
    }
  }

  ///------------------------------ sign in method -------------------------///

  Future<void> signInRequest() async{
    try{
      isLoadingLogin.value= true;
      final response = await ApiService().request(endpoint: signInEndPont,
          method: 'POST',
        body: {
          "email": "siyamoffice0273@gmail.com",
          "password": "1234567S"
        }
      );
      isLoadingLogin.value= false;
      if (response['success'] == true) {
        logger.d(response);
        showCustomSnackbar(title: 'Success', message:  response['message'],);
        Boxes.getUserData().put(tokenKey, response['token']);
        Get.offAllNamed(NavigationPage.routeName);
      }else{
        logger.e(response);
        showCustomSnackbar(title: 'Failed', message:  response['message'],type: SnackBarType.failed);
      }
    }catch(e){
      logger.e(e.toString());
    }
  }

  clearSignUpController() {
    // emailSignUpController.value.value.dispose();
    // nameSignUpController.value.dispose();
    // passSignUpController.value.dispose();
    // confirmPassSignUpController.value.dispose();
    emailSignUpController.value.clear();
    nameSignUpController.clear();
    passSignUpController.clear();
    confirmPassSignUpController.clear();
  }

  @override
  void onClose() {
    // emailLoginController.dispose();
    // passLoginController.dispose();
    // emailForgetController.dispose();
    emailSignUpController.value.dispose();
    nameSignUpController.dispose();
    passSignUpController.dispose();
    confirmPassSignUpController.dispose();
    passNewController.dispose();
    confirmPassNewController.dispose();
    super.onClose();
  }
}
