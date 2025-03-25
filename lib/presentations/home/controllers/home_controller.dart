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
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalItems = 0.obs;
  final RxInt itemsPerPage = 10.obs;
  final RxBool isLoadingMore = false.obs;
@override
  void onInit() {
getCategoryListRequest();
    super.onInit();
  }

  ///------------------------------ get category list method -------------------------///

  Future<void> getCategoryListRequest({bool loadMore = false}) async {
    try {
    if(loadMore){
      isLoadingMore.value = true;
      currentPage.value++;
    }else{
      isLoadingCategory.value = true;
      currentPage.value=1;
    }
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService()
          .request(endpoint: catGetAllEndPoint, method: 'GET',queryParams: {
        'page': currentPage.value.toString(),
        'limit': itemsPerPage.value.toString(),
      });

    isLoadingCategory.value = false;
    isLoadingMore.value = false;
      if (response['success'] == true) {
        if (response['pagination'] != null) {
          currentPage.value = response['pagination']['currentPage'] ?? 1;
          totalPages.value = response['pagination']['totalPages'] ?? 1;
          totalItems.value = response['pagination']['totalItems'] ?? 0;
          itemsPerPage.value = response['pagination']['itemsPerPage'] ?? 10;
        }
        final newCategories = (response['data'] as List)
            .map((e) => CategoryModel.fromJson(e))
            .toList();

        if (loadMore) {
          catList.addAll(newCategories); // Append for load more
        } else {
          catList.value = newCategories; // Replace for refresh
        }
        logger.d(response);

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