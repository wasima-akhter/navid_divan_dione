import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_refresh_indicator.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/presentations/orders/controllers/order_controller.dart';
import 'package:navid_e_commerce/presentations/orders/widgets/order_card_item_widget.dart';
import 'package:navid_e_commerce/presentations/product/widgets/product_det_export.dart';

import '../../../core/constants/custom_space.dart';
import '../../home/widgets/pagination_loading_widget.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: OrderController.to.labelTabs.length,
      vsync: this,
    );

    // Tab switch → fetch filtered orders
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) return;
      OrderController.to.selectedIndex.value = _tabController.index;
      OrderController.to.getOrderListRequest();
    });

    // Pagination on scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        OrderController.to.getOrderListRequest(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ✅ Builds reactive content for each tab — no state mutation
  Widget _buildTabContent() {
    return Obx(() {
      if (OrderController.to.isLoadingOrder.value) {
        return Padding(
          padding: padding12V,
          child: DefaultProgressIndicator(color: AppColors.kPrimaryColor),
        );
      }

      if (OrderController.to.orderList.isEmpty) {
        return Padding(
          padding: padding12V,
          child: CustomText(text: "Order List is Empty!!"),
        );
      }

      return Column(
        children: [
          space12H,
          ...List.generate(
            OrderController.to.orderList.length,
            (index) => OderTabItemWidget(
              orderModel: OrderController.to.orderList[index],
            ),
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = OrderController.to;

    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, _) => [
        // ✅ Tab bar built statically — no addAll() in build
        SliverToBoxAdapter(
          child: Container(
            // color: Colors.amber,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelPadding:
                  EdgeInsets.symmetric(horizontal: 14.w), // optional spacing
              padding: EdgeInsets.zero, tabAlignment: TabAlignment.center,
              indicatorColor: AppColors.kPrimaryColor,
              labelColor: AppColors.kPrimaryColor,
              unselectedLabelColor: AppColors.kExtraLightGreyTextColor,
              labelStyle: TextStyle(
                fontSize: 13.sp,
                fontFamily: 'Poppins',
              ),
              tabs: controller.labelTabs
                  .map((label) => Tab(text: label))
                  .toList(),
            ),
          ),
        ),
      ],
      body: TabBarView(
        controller: _tabController,
        children: List.generate(
          controller.labelTabs.length,
          (_) => CustomRefreshIndicatorWidget(
            onRefresh: () => controller.getOrderListRequest(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: _buildTabContent(),
                  ),
                  Obx(() => controller.isOrderLoadingMore.value
                      ? PaginationLoadingWidget()
                      : const SizedBox.shrink()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
