import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/export/ui_export.dart';
import '../../product/model/product_model.dart';
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
        firstPageErrorIndicatorBuilder: (_) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 1.sh * 0.1,
              ),
              Text(
                controller.pagingController.error?.toString().capitalize ??
                    'Something went wrong',
                style: TextStyle(
                    fontSize: 14.sp, color: AppColors.kLightTextColor),
              ),
              SizedBox(height: 12.h),
              ElevatedButton(
                onPressed: () => controller.pagingController.refresh(),
                child: Text(
                  'Try Again',
                  style:
                      TextStyle(fontSize: 14.sp, color: AppColors.kWhiteColor),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(AppColors.kPrimaryColor)),
              ),
            ],
          ),
        ),
        newPageErrorIndicatorBuilder: (_) => const Center(
          child: Text('No result found. Please try again.'),
        ),
        noItemsFoundIndicatorBuilder: (_) => NoProductWidget(
            searchController: controller.searchController.obs,
            searchQuery: controller.searchQuery,
            selectedCategory: controller.selectedCategory,
            selectedSubCategory: controller.selectedSubCategory,
            applyFilters: ({category, search, subCategory}) =>
                controller.applyFilters(
                    category: category,
                    search: search,
                    subCategory: subCategory)),
      ),
    );
  }
}
