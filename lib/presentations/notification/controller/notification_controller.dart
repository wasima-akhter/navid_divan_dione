import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:navid_e_commerce/core/api-client/api_endpoints.dart';
import 'package:navid_e_commerce/presentations/notification/model/notification_model.dart';

import '../../../core/api-client/api_service.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/variable.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;
  RxBool isLoadingNotificationList = false.obs;
  @override
  void onInit() {
    getNotificationRequest();
    super.onInit();
  }

  ///-------------------- get Notification method ---------------------///

  Future<void> getNotificationRequest() async {
    try {
      isLoadingNotificationList.value = true;

      final response = await ApiService().request(endpoint: getNotificationEndPoint, method: 'GET');
      isLoadingNotificationList.value = false;
      if (response['success'] == true) {
        logger.d(response);
        notificationList.value = (response["data"] as List)
            .map(
              (e) => NotificationModel.fromJson(e),
            )
            .toList();
      } else {
        logger.e(response);
        showCustomSnackbar(title: 'Failed', message: response['message'], type: SnackBarType.failed);
      }
    } catch (e) {
      logger.e(e.toString());
      isLoadingNotificationList.value = false;
    }
  }


  String formatDate(String dateString) {
    DateTime utcDate = DateTime.parse(dateString).toLocal(); // Convert to local time
    return DateFormat('MM-dd-yyyy h:mm a').format(utcDate);  // Format it
  }
}
