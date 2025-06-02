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
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        OrderController.to.getOrderListRequest(loadMore: true);
      }
    });
    super.initState();
  }

  //
  // List<Widget> _buildTabContent() {
  //   return List.generate(3, (tabIndex) {
  //     return Obx(() {
  //       final isLoading = OrderController.to.isLoadingOrder.value;
  //       final orders = OrderController.to.orderList;
  //
  //       if (isLoading) {
  //         return const Padding(
  //           padding: EdgeInsets.symmetric(vertical: 12),
  //           child: DefaultProgressIndicator(color: AppColors.kPrimaryColor),
  //         );
  //       }
  //
  //       if (orders.isEmpty) {
  //         return const Padding(
  //           padding: EdgeInsets.symmetric(vertical: 12),
  //           child: CustomText(text: "Order List is Empty!!"),
  //         );
  //       }
  //
  //       return SliverList(
  //         delegate: SliverChildBuilderDelegate(
  //               (context, index) {
  //             return OderTabItemWidget(orderModel: orders[index]);
  //           },
  //           childCount: orders.length,
  //         ),
  //       );
  //     });
  //   });
  // }

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

      onRefresh: () => OrderController.to.getOrderListRequest(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        slivers: [
          /// Header/tab section
          SliverToBoxAdapter(
            child: Padding(
              padding: padding12H,
              child: DynamicTabWidget(
                tabs: OrderController.to.labelTabs,
                tabContent: OrderController.to.tabItem,
                function: (index) {
                  OrderController.to.selectedIndex.value = index;
                  OrderController.to.getOrderListRequest();
                },
              ),
            ),
          ),

          // /// Tab content
          // Obx(() {
          //   final index = OrderController.to.selectedIndex.value;
          //   return OrderController.to.tabItem[index];
          // }),

          /// Loading indicator for pagination
          Obx(() {
            return OrderController.to.isOrderLoadingMore.value
                ? SliverToBoxAdapter(child: PaginationLoadingWidget())
                : const SliverToBoxAdapter(child: SizedBox.shrink());
          }),
        ],
      ),
    );
  }
}

