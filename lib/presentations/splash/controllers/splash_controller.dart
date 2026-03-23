import 'package:get/get.dart';
import 'package:navid_e_commerce/presentations/navigation/views/navigation_page.dart';

class SplashController extends GetxController {
  static SplashController get to => Get.find();
  @override
  void onInit() {
    Future.delayed(Duration(seconds: 3), () {
      Get.offAllNamed(NavigationPage.routeName);
    });
    super.onInit();
  }
}
