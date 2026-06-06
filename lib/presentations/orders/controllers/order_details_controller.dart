import '../../../core/api-client/api_endpoints.dart';
import '../../../core/export/ui_export.dart';
import '../model/order_details_model.dart';

class OrderDetailsController extends GetxController {
  static OrderDetailsController get to => Get.find();

  /// ─── Loading state ───
  RxBool isLoading = false.obs;

  /// ─── Order details ───
  Rx<OrderDetailsModel?> orderDetails = Rx<OrderDetailsModel?>(null);

  /// ─── Fetch order details ───
  Future<void> getOrderDetailsRequest({required String orderId}) async {
    if (orderId.isEmpty) return;

    try {
      isLoading.value = true;

      final response = await ApiService().request(
        endpoint: "$getOrderDetailsEndPoint/$orderId",
        method: 'GET',
      );

      if (response['success'] == true) {
        debugPrint("RAW ORDER DETAILS JSON:");
        debugPrint(response['data'].toString());

        orderDetails.value = OrderDetailsModel.fromJson(response['data']);
      } else {
        showCustomSnackbar(
          title: 'Failed',
          message: response['message'] ?? 'Something went wrong',
          type: SnackBarType.failed,
        );
      }
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: e.toString(),
        type: SnackBarType.failed,
      );

      debugPrint(' e.toString(): ${e.toString()} ');
    } finally {
      isLoading.value = false;
    }
  }

  /// ─── Clear state (optional but useful) ───
  void clear() {
    orderDetails.value = null;
  }
}
