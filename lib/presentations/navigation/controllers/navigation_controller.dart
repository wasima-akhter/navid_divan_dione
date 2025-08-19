import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/utils/hive_boxes.dart';
import 'package:navid_e_commerce/presentations/cart/views/cart_page.dart';
import 'package:navid_e_commerce/presentations/home/controllers/home_controller.dart';
import 'package:navid_e_commerce/presentations/home/views/home_page.dart';
import 'package:navid_e_commerce/presentations/notification/controller/notification_controller.dart';
import 'package:navid_e_commerce/presentations/notification/views/notification_page.dart';
import 'package:navid_e_commerce/presentations/orders/controllers/order_controller.dart';
import 'package:navid_e_commerce/presentations/orders/views/order_page.dart';
import 'package:navid_e_commerce/presentations/splash/controllers/common_controller.dart';

import '../../../core/api-client/api_endpoints.dart';
import '../../../core/api-client/api_service.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/variable.dart';
import '../../auth/views/login_page.dart';
import '../../profile/controllers/profile_controller.dart';

class NavigationController extends GetxController {
  static NavigationController get to => Get.find();
  RxInt currentNavIndex = 0.obs;
  @override
  void onInit() async {
    if (Boxes.getUserData().get(tokenKey) != null &&
        Boxes.getUserData().get(tokenKey).toString().isNotEmpty) {
      Get.put(ProfileController());
      Get.put(OrderController());
       ProfileController.to.getUserProfileRequest();

      Get.put(NotificationController());
    }
    Get.put(HomeController());

    super.onInit();
  }

  List<Widget> getPages() {
    return [
      HomePage(),
      if (CommonController.to.isLoggedIn) CartPage(),
      if (CommonController.to.isLoggedIn) OrderPage(),
      if (CommonController.to.isLoggedIn) NotificationPage()
    ];
  }

  List<String> appbarTitle = [
    AppStaticStrings.addToCard,
    AppStaticStrings.orders,
    AppStaticStrings.notifications,
  ];
  Rx<bool> isLoadingLogout = false.obs;

  ///------------------------------ log out method -------------------------///

  Future<void> logoutRequest() async {
    try {
      isLoadingLogout.value = true;
      final response = await ApiService().request(
        endpoint: logoutEndPoint,
        method: 'POST',
      );
      isLoadingLogout.value = false;
      if (response['success'] == true) {
        logger.d(response);
        showCustomSnackbar(
          title: 'Success',
          message: response['message'],
        );
        CommonController.to.isLoggedIn=false;
        if (Hive.isBoxOpen(userBoxName)) {
          await Hive.box(userBoxName).close();
        }
        await Hive.deleteBoxFromDisk(userBoxName);

        Get.offAllNamed(LoginPage.routeName);
      } else {
        logger.e(response);
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
