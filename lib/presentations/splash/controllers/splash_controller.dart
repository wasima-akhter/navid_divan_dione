import 'package:get/get.dart';
import 'package:navid_e_commerce/presentations/auth/views/login_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/signup_page.dart';

class SplashController extends GetxController{
  static SplashController get to => Get.find();
  @override
  void onInit() {
    Future.delayed(Duration(seconds: 3),(){
      Get.offAllNamed(SignupPage.routeName);
    });
    super.onInit();
  }
}