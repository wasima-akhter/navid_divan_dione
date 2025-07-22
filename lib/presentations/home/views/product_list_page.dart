import 'package:flutter/material.dart';
import 'package:navid_e_commerce/core/components/custom_refresh_indicator.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/presentations/home/views/home_page.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/search_text_field_widget.dart';

import '../controllers/home_controller.dart';

class ProductListPage extends StatefulWidget {
  static const String routeName = '/product-list';
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    scrollController.addListener(
      () {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          HomeController.to.getProductListRequest(loadMore: true);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        HomeController.to.getProductListRequest();
        HomeController.to.productList.refresh();
        HomeController.to.searchController.value.clear();
      },
      child: CustomRefreshIndicatorWidget(
        onRefresh: () {
          return  HomeController.to.getProductListRequest();
        },
        child: DefaultScaffoldStructureWidget(
            appBarTitle: 'Products',
            scrollController: scrollController,
            children: [
              SearchTextFieldWidget(
                  searchController: HomeController.to.searchController.value),
              space12H,
              DynamicProductList()
            ]),
      ),
    );
  }
}
