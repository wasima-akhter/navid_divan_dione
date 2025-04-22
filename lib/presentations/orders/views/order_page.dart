import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_refresh_indicator.dart';
import 'package:navid_e_commerce/core/components/dynamic_tab_widget.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/presentations/orders/controllers/order_controller.dart';
import 'package:navid_e_commerce/presentations/orders/model/order_model.dart';
import 'package:navid_e_commerce/presentations/orders/widgets/order_card_item_widget.dart';

import '../../home/widgets/pagination_loading_widget.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    scrollController.addListener(
      () {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          OrderController.to.getOrderListRequest(loadMore: true);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OrderController.to.tabItem.addAll([
      Obx(() {
        return OrderController.to.isLoadingOrder.value
            ? Padding(
                padding: padding12V,
                child: DefaultProgressIndicator(
                  color: AppColors.kPrimaryColor,
                ),
              )
            : OrderController.to.orderList.isEmpty
                ? Padding(
                    padding: padding12V,
                    child: CustomText(text: "Order List is Empty!!"),
                  )
                : Column(
                    children: List.generate(
                      OrderController.to.orderList.length,
                      (index) {
                        return OderTabItemWidget(orderModel: OrderController.to.orderList[index]);
                      },
                    ),
                  );
      }),
      Obx(() {
        return OrderController.to.isLoadingOrder.value
            ? Padding(
                padding: padding12V,
                child: DefaultProgressIndicator(
                  color: AppColors.kPrimaryColor,
                ),
              )
            : OrderController.to.orderList.isEmpty
                ? Padding(
                    padding: padding12V,
                    child: CustomText(text: "Order List is Empty!!"),
                  )
                : Column(
                    children: List.generate(
                      OrderController.to.orderList.length,
                      (index) {
                        return OderTabItemWidget(orderModel: OrderController.to.orderList[index]);
                      },
                    ),
                  );
      }),
      Obx(() {
        return OrderController.to.isLoadingOrder.value
            ? Padding(
                padding: padding12V,
                child: DefaultProgressIndicator(
                  color: AppColors.kPrimaryColor,
                ),
              )
            : OrderController.to.orderList.isEmpty
                ? Padding(
                    padding: padding12V,
                    child: CustomText(text: "Order List is Empty!!"),
                  )
                : Column(
                    children: List.generate(
                      OrderController.to.orderList.length,
                      (index) {
                        return OderTabItemWidget(orderModel: OrderController.to.orderList[index]);
                      },
                    ),
                  );
      }),
    ]);
    return CustomRefreshIndicatorWidget(
      onRefresh: () {
        return OrderController.to.getOrderListRequest();
      },
      child: SingleChildScrollView(
        controller: scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: padding12H,
          child: Column(
            children: [
              DynamicTabWidget(
                tabs: OrderController.to.labelTabs,
                tabContent: OrderController.to.tabItem,
                function: (p0) {
                  OrderController.to.selectedIndex.value = p0;
                  OrderController.to.getOrderListRequest();
                },
              ),
              Obx(
                () {
                  return OrderController.to.isOrderLoadingMore.value ? PaginationLoadingWidget() : SizedBox.shrink();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
