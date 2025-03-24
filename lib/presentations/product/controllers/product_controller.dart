import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/presentations/profile/model/user_profile_model.dart';


class ProductController extends GetxController {
  static ProductController get to => Get.find();

  RxString selectedTime = ''.obs;
  Rx<TextEditingController> dateController =
      TextEditingController(text: kDebugMode ? '2025-01-22' : '').obs;

}
