import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/export/ui_export.dart';
import '../../product/model/product_model.dart';
import '../../profile/widgets/custom_loading_widget.dart';
import '../controllers/product_list_controller.dart';
import 'no_product_widget.dart';
import 'product_card_item_widget.dart';

class DynamicProductList extends StatelessWidget {
  final ProductListController controller;
  const DynamicProductList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PagedGridView<int, ProductModel>(
      pagingController: controller.pagingController,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.w,
        mainAxisExtent: 265.w,
        maxCrossAxisExtent: 210.w,
      ),
      builderDelegate: PagedChildBuilderDelegate<ProductModel>(
        itemBuilder: (context, item, index) {
          return ProductCardItemWidget(product: item);
        },
        firstPageProgressIndicatorBuilder: (_) => CustomLoadingWidget(height: 200.h),
        noItemsFoundIndicatorBuilder: (_) => NoProductWidget(
            searchController: controller.searchController.obs,
            searchQuery: controller.searchQuery,
            selectedCategory: controller.selectedCategory,
            selectedSubCategory: controller.selectedSubCategory,
            applyFilters: ({category, search, subCategory}) => controller.applyFilters(
                category: category, search: search, subCategory: subCategory)),
      ),
    );
  }
}
