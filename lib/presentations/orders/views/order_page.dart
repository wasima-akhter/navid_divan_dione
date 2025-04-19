import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_refresh_indicator.dart';
import 'package:navid_e_commerce/core/components/dynamic_tab_widget.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
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
    return  CustomRefreshIndicatorWidget(
        onRefresh: () {
      return OrderController.to.getOrderListRequest();
    },
      child: SingleChildScrollView(
         physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: padding12H,
          child: Column(
            children: [DynamicTabWidget(tabs: OrderController.to.labelTabs, tabContent: OrderController.to.tabItem,function: (p0) {

            },)],
          ),
        ),
      ),
    );
  }
}

