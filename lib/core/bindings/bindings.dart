import 'package:get/get.dart';
import 'package:navid_e_commerce/presentations/auth/controllers/auth_controller.dart';
import 'package:navid_e_commerce/presentations/cart/controllers/cart_controller.dart';
import 'package:navid_e_commerce/presentations/navigation/controllers/navigation_controller.dart';
import 'package:navid_e_commerce/presentations/product/controllers/product_controller.dart';
import 'package:navid_e_commerce/presentations/profile/controllers/profile_controller.dart';
import 'package:navid_e_commerce/presentations/settings/controllers/settings_controller.dart';
import 'package:navid_e_commerce/presentations/splash/controllers/common_controller.dart';
import 'package:navid_e_commerce/presentations/splash/controllers/splash_controller.dart';

import '../../presentations/home/controllers/home_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}

class CommonBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CommonController(), permanent: true);

  }
}

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductController());
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigationController());
    Get.lazyPut(()=>CartController());
  }
}class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController());
  }
}

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingsController());
  }
}
