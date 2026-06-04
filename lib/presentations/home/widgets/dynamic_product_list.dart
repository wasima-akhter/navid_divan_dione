import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:navid_e_commerce/presentations/profile/views/profile_page.dart';

import '../../../core/export/ui_export.dart';
import '../../auth/views/login_page.dart';
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
        /*
        firstPageErrorIndicatorBuilder: (_) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 1.sh * 0.1),
              Text(
                controller.pagingController.error?.toString().capitalize ??
                    'Something went wrong',
                style: TextStyle(
                    fontSize: 14.sp, color: AppColors.kLightTextColor),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    final isUpdatedTaxId = controller.taxIDUpdated.value;

                    if (!isUpdatedTaxId) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              controller.pagingController.refresh(),
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(AppColors.kPrimaryColor),
                          ),
                          child: Text('Try Again',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.kWhiteColor)),
                        ),
                        SizedBox(width: 8.w),
                      ],
                    );
                  }),
                  ElevatedButton(
                    onPressed: () => Get.toNamed(ProfilePage.routeName),
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(AppColors.kPrimaryColor),
                    ),
                    child: Text('Update Tax ID',
                        style: TextStyle(
                            fontSize: 14.sp, color: AppColors.kWhiteColor)),
                  ),
                ],
              ),
            ],
          ),
        ),

       */

        firstPageErrorIndicatorBuilder: (_) {
          final error = controller.pagingController.error?.toString() ?? '';
          final isLoginRequired = error.toLowerCase().contains('login');

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 1.sh * 0.1),
                Icon(
                  isLoginRequired ? Icons.lock_outline : Icons.error_outline,
                  size: 48.sp,
                  color: AppColors.kLightTextColor,
                ),
                SizedBox(height: 12.h),
                Text(
                  error.capitalize ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.kLightTextColor,
                  ),
                ),
                SizedBox(height: 12.h),
                if (isLoginRequired)
                  ElevatedButton.icon(
                    onPressed: () => Get.toNamed(LoginPage.routeName),
                    icon: const Icon(Icons.login, color: Colors.white),
                    label: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 14.sp, color: AppColors.kWhiteColor),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(AppColors.kPrimaryColor),
                    ),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() {
                        if (!controller.taxIDUpdated.value) {
                          return const SizedBox.shrink();
                        }
                        return Row(
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  controller.pagingController.refresh(),
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    AppColors.kPrimaryColor),
                              ),
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.kWhiteColor),
                              ),
                            ),
                            SizedBox(width: 8.w),
                          ],
                        );
                      }),
                      ElevatedButton(
                        onPressed: () => Get.toNamed(ProfilePage.routeName),
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(AppColors.kPrimaryColor),
                        ),
                        child: Text(
                          'Update Tax ID',
                          style: TextStyle(
                              fontSize: 14.sp, color: AppColors.kWhiteColor),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
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
