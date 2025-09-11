import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
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
Get.dialog(AlertDialog(
  content: SizedBox(
    width: ScreenUtil().screenWidth*.8,
    child: Column(
      mainAxisSize: MainAxisSize.min,
    children: [
    CustomText(text: "Are you more then 21?"),
    space6H,
    Row(
      children: [
        Expanded(child: CustomButton(onTap: () {
          Get.offAllNamed(NavigationPage.routeName);
        },
        title: "Yes",)),
        space12W,
        Expanded(child: CustomButton(onTap: () {
    exit(0);
        },
        title: "No",)),
      ],
    )
    ],
    ),
  ),

));
      
    });
    super.onInit();
  }
}