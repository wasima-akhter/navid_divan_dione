import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/dynamic_tab_widget.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/utils/enum.dart';
import 'package:navid_e_commerce/presentations/home/controllers/home_controller.dart';
import 'package:navid_e_commerce/presentations/orders/controllers/order_controller.dart';
import 'package:navid_e_commerce/presentations/orders/model/order_model.dart';
import 'package:navid_e_commerce/presentations/orders/widgets/order_card_item_widget.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    OrderController.to.tabItem.addAll([
      Obx(() {
        return Column(
          children: List.generate(
            OrderController.to.orderList.length,
                (index) {
              return OderTabItemWidget(orderModel: OrderController.to.orderList[index]);
            },
          ),
        );
      }),
      Column(
        children: List.generate(
          OrderController.to.orderList.length,
              (index) {
            return OderTabItemWidget(orderModel: OrderController.to.orderList[index]);
          },
        ),
      ),
      Column(
        children: List.generate(
          OrderController.to.orderList.length,
              (index) {
            return OderTabItemWidget(orderModel: OrderController.to.orderList[index]);
          },
        ),
      ),
    ]);
    return SingleChildScrollView(
      child: Padding(
        padding: padding12H,
        child: Column(
          children: [DynamicTabWidget(tabs: OrderController.to.labelTabs, tabContent: OrderController.to.tabItem)],
        ),
      ),
    );
  }
}

class OderTabItemWidget extends StatelessWidget {
  final OrderModel orderModel;

  const OderTabItemWidget({
    super.key,
    required this.orderModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 6.h, children: [
      space12H,
      CustomText(
        text: 'Order no: #${orderModel.sId.toString()}',
        color: AppColors.kPrimaryTextDarkColor,
        style: poppinsSemiBold,
      ), CustomText(
        text: 'Total amount: \$${orderModel.totalAmount.toString()}',
        color: AppColors.kPrimaryTextDarkColor,
        style: poppinsSemiBold,
      ),
      Column(
        spacing: 6.h,
        children: List.generate(
          orderModel.items!.length,
              (index) =>
              OrderCardItemWidget(
                orderModel: orderModel,
                statusEnum: index == 1 ? OrderStatus.pending : OrderStatus.shipping,
                itemModel: orderModel.items![index],
              ),
        ),
      )
    ]);
  }
}
