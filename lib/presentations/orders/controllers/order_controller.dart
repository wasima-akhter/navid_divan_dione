import 'package:get/get.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/presentations/orders/model/order_model.dart';
import 'package:navid_e_commerce/presentations/product/controllers/product_controller.dart';

import '../../../core/api-client/api_endpoints.dart';
import '../../../core/api-client/api_service.dart';
import '../../../core/helper/helper_function.dart';

class OrderController extends GetxController {
  static OrderController get to => Get.find();

  RxList<String> labelTabs =
      [AppStaticStrings.pending, AppStaticStrings.shipped, AppStaticStrings.delivered].obs;
  RxInt selectedIndex = 0.obs;
  RxBool isLoadingOrder = false.obs;
  RxList<OrderModel> orderList = <OrderModel>[].obs;

  // ✅ pagination
  final RxInt currentOrderPage = 1.obs;
  final RxInt itemsOrderPerPage = 5.obs;
  final RxInt totalOrderPages = 5.obs;
  final RxBool isOrderLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    getOrderListRequest();
    Get.lazyPut(() => ProductController());
  }

  Future<void> getOrderListRequest({bool loadMore = false}) async {
    try {
      if (loadMore && currentOrderPage.value >= totalOrderPages.value) return;

      if (loadMore) {
        isOrderLoadingMore.value = true;
        currentOrderPage.value++;
      } else {
        isLoadingOrder.value = true;
        currentOrderPage.value = 1;
      }

      final response = await ApiService().request(
        endpoint: getOrderEndPoint,
        method: 'GET',
        queryParams: {
          'page': currentOrderPage.value.toString(),
          'delivery_status': labelTabs[selectedIndex.value].toLowerCase(),
        },
      );

      isLoadingOrder.value = false;
      isOrderLoadingMore.value = false;

      if (response['success'] == true) {
        print("response: $response");
        if (response['pagination'] != null) {
          currentOrderPage.value = response['pagination']['currentPage'] ?? 1;
          totalOrderPages.value = response['pagination']['totalPages'] ?? 1;
          itemsOrderPerPage.value = response['pagination']['itemsPerPage'] ?? 10;
        }

        final newOrders = (response['data'] as List).map((e) => OrderModel.fromJson(e)).toList();

        if (loadMore) {
          orderList.addAll(newOrders);
        } else {
          orderList.value = newOrders;
        }

        print("payment status: ${newOrders.map(
          (e) => e.paymentStatus,
        )} ");
        print("deliveryStatus : ${newOrders.map(
          (e) => e.deliveryStatus,
        )} ");
      } else {
        showCustomSnackbar(
          title: 'Failed',
          message: response['message'],
          type: SnackBarType.failed,
        );
      }
    } catch (e) {
      isLoadingOrder.value = false;
      isOrderLoadingMore.value = false;
    }
  }

// ✅ tracks payment loading per orderId
  RxMap<String, bool> isPaymentLoadingMap = <String, bool>{}.obs;

  Future<void> payForOrder({required OrderModel orderModel}) async {
    final orderId = orderModel.sId ?? "";
    if (orderId.isEmpty) return;

    isPaymentLoadingMap[orderId] = true;
    isPaymentLoadingMap.refresh();

    await ProductController.to.paymentRequest(
      products: List.generate(
        orderModel.items?.length ?? 0,
        (index) {
          final item = orderModel.items![index];
          return {
            "name": item.product?.name ?? "",
            "unit_amount": item.variant?.priceAfterDiscount ?? 0,
            "quantity": item.quantity ?? 1,
          };
        },
      ),
      orderId: orderId,
    );

    isPaymentLoadingMap[orderId] = false;
    isPaymentLoadingMap.refresh();

    // ✅ refresh order list so UI reflects updated payment status
    await getOrderListRequest();
  }
}
