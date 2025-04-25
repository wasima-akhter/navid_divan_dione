import 'package:get/get.dart';
import 'package:navid_e_commerce/presentations/auth/views/login_page.dart';
import 'package:navid_e_commerce/presentations/navigation/views/navigation_page.dart';

import '../../../core/utils/hive_boxes.dart';
import '../../../core/utils/variable.dart';
import '../../profile/controllers/profile_controller.dart';

class SplashController extends GetxController{
  static SplashController get to => Get.find();
  @override
  void onInit() {
    Future.delayed(Duration(seconds: 3),(){
     if( Boxes.getUserData().get(tokenKey)==null||  Boxes.getUserData().get(tokenKey).toString().isEmpty) {
        Get.offAllNamed(LoginPage.routeName);
      }else{


       Get.offAllNamed(NavigationPage.routeName);

     }
    });
    super.onInit();
  }
}