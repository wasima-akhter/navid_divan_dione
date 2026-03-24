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
import '../../presentations/home/controllers/product_list_controller.dart';
import '../../presentations/product/controllers/address_order_controller.dart';

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
    // ✅ fenix: true — recreates when needed, but doesn't create a new instance every time
    Get.lazyPut<ProductController>(() => ProductController(), fenix: true);
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
    Get.put(CartController());

    // ✅ Persistent — survives tab switches, never recreated with wrong args
    Get.put(AddressOrderController(), permanent: true);
  }
}

// bindings.dart — add this
class AddressOrderBinding extends Bindings {
  @override
  void dependencies() {
    // AddressOrderController is already permanent, nothing extra needed
    // but we need this binding to NOT register ProductController
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController(), permanent: true);
  }
}

class ProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductListController(), permanent: true);
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
