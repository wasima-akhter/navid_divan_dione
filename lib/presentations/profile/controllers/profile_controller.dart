import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController{


  static ProfileController get to => Get.find();
  RxString uploadProfileImg = ''.obs;
  ///=====================add dynmic name ====================///
  Rx<TextEditingController> nameController =
      TextEditingController(/*text: kDebugMode ? 'Khushi akter' : ''*/).obs;

  ///=====================add dynmic email ====================///
  Rx<TextEditingController> emailController =
      TextEditingController(/*text: kDebugMode ? 'youremail@gmail.com' : ''*/)
          .obs;

  ///=====================add dynmic contactNumber ====================///
  Rx<TextEditingController> contactNumberController =
      TextEditingController(/*text: kDebugMode ? '+999 68526546 65' : ''*/).obs;

  ///=====================add dynmic location ====================///
  Rx<TextEditingController> locationController = TextEditingController(
    /* text: kDebugMode ? '4140 Parker Rd. Allentown, New Mexico 31134' : ''*/)
      .obs;

}