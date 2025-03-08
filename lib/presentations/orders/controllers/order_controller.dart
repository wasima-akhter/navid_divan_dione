import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';

class OrderController extends GetxController {
  static OrderController get to => Get.find();
  var tabItem = <Widget>[

  ].obs;
  RxList<String> labelTabs = [
    AppStaticStrings.running,
    AppStaticStrings.shipped,
    AppStaticStrings.complete
  ].obs;
}
