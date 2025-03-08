import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/presentations/cart/views/cart_page.dart';
import 'package:navid_e_commerce/presentations/home/views/home_page.dart';
import 'package:navid_e_commerce/presentations/notification/views/notification_page.dart';
import 'package:navid_e_commerce/presentations/orders/controllers/order_controller.dart';
import 'package:navid_e_commerce/presentations/orders/views/order_page.dart';

class NavigationController extends GetxController {
  static NavigationController get to => Get.find();
  RxInt currentNavIndex = 0.obs;
  @override
  void onInit() {
    Get.put(OrderController());
    // Get.put(ProfileController());
    super.onInit();
  }

  List<Widget> getPages() {
    return [HomePage(), CartPage(), OrderPage(), NotificationPage()];
  }
  List<String> appbarTitle= [
      AppStaticStrings.addToCard,
      AppStaticStrings.orders,
      AppStaticStrings.notifications,
    ];

}
