import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/core/components/dynamic_tab_widget.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/utils/enum.dart';
import 'package:navid_e_commerce/presentations/orders/controllers/order_controller.dart';
import 'package:navid_e_commerce/presentations/orders/widgets/order_card_item_widget.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    OrderController.to.tabItem.addAll([
      OderTabItemWidget(
        orderList: Column(
          spacing: 6.h ,
          children: List.generate(
            2,
            (index) => OrderCardItemWidget(
              statusEnum:
                  index == 1 ? OrderStatus.pending : OrderStatus.shipping,
            ),
          ),
        ),
      ),
      OderTabItemWidget(
        orderList: Column(
          spacing: 6.h ,
          children: List.generate(
            10,
            (index) => OrderCardItemWidget(
              statusEnum: OrderStatus.shipped,
            ),
          ),
        ),
      ),
      OderTabItemWidget(
        orderList: Column(
          spacing: 6.h ,
          children: List.generate(
            6,
            (index) => OrderCardItemWidget(
              statusEnum: OrderStatus.completed,
            ),
          ),
        ),
      ),
    ]);
    return SingleChildScrollView(
      child: Padding(
        padding: padding12H,
        child: Column(
          children: [
            DynamicTabWidget(
                tabs: OrderController.to.labelTabs,
                tabContent: OrderController.to.tabItem)
          ],
        ),
      ),
    );
  }
}

class OderTabItemWidget extends StatelessWidget {
  final Widget orderList;
  const OderTabItemWidget({
    super.key,
    required this.orderList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6.h,
        children: [
          space12H,
          CustomText(
            text: 'Order no: #685665',
            color: AppColors.kPrimaryTextDarkColor,
            style: poppinsSemiBold,
          ),
          orderList
        ]);
  }
}
