import 'dart:developer';

import 'package:get/get.dart';
import 'package:navid_e_commerce/presentations/home/model/category_model.dart';
import '../../../core/api-client/api_endpoints.dart';

import '../../../core/api-client/api_service.dart';
import '../../../core/constants/app_static_strings.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/hive_boxes.dart';
import '../../../core/utils/variable.dart';

class HomeController extends GetxController{
  static HomeController get to => Get.find();

  RxBool isLoadingCategory = false.obs;
RxList<CategoryModel> catList =<CategoryModel>[].obs;
@override
  void onInit() {
getCategoryListRequest();
    super.onInit();
  }

  ///------------------------------ get category list method -------------------------///

  Future<void> getCategoryListRequest() async {
    try {
      isLoadingCategory.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService()
          .request(endpoint: catGetAllEndPoint, method: 'GET');
      isLoadingCategory.value = false;
      if (response['success'] == true) {
        logger.d(response);
        catList.value =response['data'].map((e)=>CategoryModel.fromJson(e)).toList();

      } else if (response['message'] == AppStaticStrings.noInternet) {
        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
          noInternet: true,
          retryTap: () {
            getCategoryListRequest();
          },
        );
      } else {
        logger.e(response);
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingCategory.value = false;
    }
  }

}