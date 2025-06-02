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
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: padding12,
            sliver: Obx(() {
              if (NotificationController.to.isLoadingNotificationList.value) {
                return SliverToBoxAdapter(child: PaginationLoadingWidget());
              }

              final list = NotificationController.to.notificationList;

              if (list.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: CustomText(text: "Notification List is Empty!!")),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final item = list[index];
                    return Column(
                      children: [
                        Padding(
                          padding: padding6V,
                          child: Row(
                            children: [
                              ///------------------------dynamic title-------------------------///
                              Expanded(
                                child: CustomText(text: item.title.toString()),
                              ),
                              CustomText(
                                text: NotificationController.to.formatDate(item.updatedAt.toString()),
                                style: poppinsLight,
                                fontSize: getFontSizeSmall(),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                  childCount: list.length,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

