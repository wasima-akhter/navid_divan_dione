import 'package:get/get.dart';

class CommonController extends GetxController{
  static CommonController get to => Get.find();
  RxInt count=1.obs;
  void increment(int currentIndex){
    count++;

  } void decrement(int currentIndex){
    count--;

  }
}