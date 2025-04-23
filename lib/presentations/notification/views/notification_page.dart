import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:navid_e_commerce/core/components/custom_refresh_indicator.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/home/widgets/pagination_loading_widget.dart';
import 'package:navid_e_commerce/presentations/notification/controller/notification_controller.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicatorWidget(
      onRefresh: () => NotificationController.to.getNotificationRequest(),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: padding12,
          child: Obx(() {
            return NotificationController.to.isLoadingNotificationList.value? PaginationLoadingWidget():NotificationController.to.notificationList.isEmpty?
                Center(child: CustomText(text: "Notification List is Empty!! ")): Column(
              children: List.generate(
                NotificationController.to.notificationList.length,
                    (index) =>
                    Column(
                      children: [
                        Padding(
                          padding: padding6V,
                          child: Row(
                            children: [

                              ///------------------------dynamic title-------------------------///
                              Expanded(child: CustomText(text: NotificationController.to.notificationList[index].title.toString())),
                              CustomText(
                                text: NotificationController.to.formatDate(NotificationController.to.notificationList[index].updatedAt.toString()),
                                style: poppinsLight,
                                fontSize: getFontSizeSmall(),
                              ),
                            ],
                          ),
                        ),
                        Divider()
                      ],
                    ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
