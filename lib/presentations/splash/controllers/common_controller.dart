import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/utils/hive_boxes.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';

import '../../../core/api-client/api_service.dart';

class CommonController extends GetxController {
  static CommonController get to => Get.find();
  @override
  void onInit() {
    ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

    debugPrint("---------token---------");
    logger.d(Boxes.getUserData().get(tokenKey));
    super.onInit();
  }

  RxInt count = 1.obs;
  void increment(int currentIndex) {
    count++;
  }

  void decrement(int currentIndex) {
    count--;
  }
}
