import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/presentations/orders/model/order_model.dart';
import 'package:navid_e_commerce/presentations/product/controllers/product_controller.dart';

import '../../../core/api-client/api_endpoints.dart';
import '../../../core/api-client/api_service.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/variable.dart';

class OrderController extends GetxController {
  static OrderController get to => Get.find();
  var tabItem = <Widget>[

  ].obs;
  RxList<String> labelTabs = [
    AppStaticStrings.running,
    AppStaticStrings.shipped,
    AppStaticStrings.delivered
  ].obs;
RxInt selectedIndex =0.obs;
  RxBool isLoadingOrder = false.obs;
  RxList<OrderModel> orderList = <OrderModel>[].obs;
@override
  void onInit() {

getOrderListRequest();    super.onInit();
Get.lazyPut(() => ProductController(),);
  }

  ///====================product pagination variable========================///

  final RxInt currentOrderPage = 1.obs;
  final RxInt itemsOrderPerPage = 5.obs;
  final RxInt totalOrderPages = 5.obs;
  final RxBool isOrderLoadingMore = false.obs;

  ///------------------------------ get order list method -------------------------///

  Future<void> getOrderListRequest({
    bool loadMore = false,
  })
  async {
    try {
      // Don't load more if we've reached the last page
      if (loadMore && currentOrderPage.value >= totalOrderPages.value) {
        return;
      }

      if (loadMore) {

        isOrderLoadingMore.value = true;
        currentOrderPage.value++;
        // Don't increment page here - we'll do it after successful response
      } else {
        isLoadingOrder.value = true;
        currentOrderPage.value = 1;
      }



      final response = await ApiService().request(
        endpoint: getOrderEndPoint,
        method: 'GET',
        queryParams: {
          'page': currentOrderPage.value.toString(),
          'limit': itemsOrderPerPage.value.toString(),
          'delivery_status': labelTabs[selectedIndex.value],

        },
      );

      isLoadingOrder.value = false;
      isOrderLoadingMore.value = false;

      if (response['success'] == true) {
        if (response['pagination'] != null) {
          currentOrderPage.value = response['pagination']['currentPage'] ?? 1;
          totalOrderPages.value = response['pagination']['totalPages'] ?? 1; // Add this line
          itemsOrderPerPage.value = response['pagination']['itemsPerPage'] ?? 10;
        }

        final newOrders = (response['data'] as List).map((e) => OrderModel.fromJson(e)).toList();

        if (loadMore) {
          // Only increment page after successful load

          orderList.addAll(newOrders);
        } else {
          orderList.value = newOrders;
        }
        debugPrint("------------------Order List-------------------");
        logger.d(response);
      } else {
        logger.e(response);
        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingOrder.value = false;
      isOrderLoadingMore.value = false;
    }
  }
}
