import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:navid_e_commerce/core/api-client/api_service.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/components/custom_refresh_indicator.dart';
import 'package:navid_e_commerce/core/components/custom_text_button.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/home/controllers/home_controller.dart';
import 'package:navid_e_commerce/presentations/home/views/category_list_page.dart';
import 'package:navid_e_commerce/presentations/home/widgets/category_list_card_item_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/product_card_item_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/search_text_field_widget.dart';
import 'package:navid_e_commerce/presentations/product/model/product_model.dart';
import 'package:navid_e_commerce/presentations/profile/widgets/custom_loading_widget.dart';

import '../widgets/pagination_loading_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final hCtrl = Get.find<HomeController>();
    return CustomRefreshIndicatorWidget(
      onRefresh: () {
        return hCtrl.refreshCall();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          /// ============ Search Field =============
          SliverPadding(
            padding: padding12H.copyWith(top: 12),
            sliver: SliverToBoxAdapter(
              child: SearchTextFieldWidget(
                searchController: hCtrl.searchController.value,
              ),
            ),
          ),
          SliverPadding(
            padding: padding12H.copyWith(top: 12),
            sliver: SliverToBoxAdapter(
              child: Obx(() {
                return hCtrl.isLoadingBanner.value
                    ? PaginationLoadingWidget()
                    : hCtrl.bannerList.isEmpty
                        ? SizedBox.shrink()
                        : SizedBox(
                            height: 150.h,
                            child: CarouselSlider.builder(
                              itemCount:
                                  hCtrl.bannerList.length > 10 ? 10 : hCtrl.bannerList.length,
                              itemBuilder: (context, index, realIndex) {
                                final bannerItem = hCtrl.bannerList[index];

                                return Padding(
                                  padding: padding6H,
                                  child: CustomNetworkImage(
                                    borderRadius: BorderRadius.circular(10.r),
                                    imageUrl: '${ApiService().baseUrl}${bannerItem.img ?? ''}',
                                    height: 150.h,
                                    width: double.maxFinite,
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                height: 150.h,
                                viewportFraction: 1, // full width
                                autoPlay: true, // enable auto play
                                autoPlayInterval: const Duration(seconds: 3), // time gap
                                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: false,
                                enableInfiniteScroll: true,
                              ),
                            ),
                          );
              }),
            ),
          ),

          /// ============ Category Title & Button =============
          SliverPadding(
            padding: padding12H,
            sliver: Obx(() {
              return hCtrl.isLoadingCategory.value || hCtrl.catList.isEmpty
                  ? SliverToBoxAdapter(child: SizedBox.shrink())
                  : SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              text: AppStaticStrings.category,
                              style: poppinsMedium,
                              fontSize: getFontSizeDefault(),
                              color: AppColors.kPrimaryTextDarkColor,
                            ),
                          ),
                          CustomTextButton(
                            onPressed: () {
                              Get.toNamed(CategoryListPage.routeName);
                            },
                            title: AppStaticStrings.viewAll,
                            fontSize: getFontSizeSemiSmall(),
                            textColor: AppColors.kPrimaryTextDarkColor,
                          )
                        ],
                      ),
                    );
            }),
          ),

          /// ============ Category Horizontal List =============
          SliverPadding(
            padding: padding12H4V,
            sliver: Obx(() {
              if (hCtrl.isLoadingCategory.value) {
                return SliverToBoxAdapter(
                  child: CustomLoadingWidget(height: 40.h),
                );
              } else if (hCtrl.catList.isEmpty) {
                return SliverToBoxAdapter(
                    child: CustomText(text: 'There is no Category available!!'));
              } else {
                return SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12.w,
                      children: List.generate(
                        hCtrl.catList.length,
                        (index) => CategoryListCardItemWidget(
                          categoryModel: hCtrl.catList[index],
                        ),
                      ),
                    ),
                  ),
                );
              }
            }),
          ),

          /// ============ Spacing =============
          SliverToBoxAdapter(child: SizedBox(height: 6.h)),

          /// ============ Product Grid ============
          SliverPadding(
            padding: padding12H4V,
            sliver: PagedSliverGrid<int, ProductModel>(
              pagingController: hCtrl.pagingController,
              builderDelegate: PagedChildBuilderDelegate<ProductModel>(
                itemBuilder: (context, product, index) {
                  return ProductCardItemWidget(product: product);
                },
                firstPageProgressIndicatorBuilder: (context) => CustomLoadingWidget(height: 200.h),
                newPageProgressIndicatorBuilder: (context) => PaginationLoadingWidget(),
                noItemsFoundIndicatorBuilder: (context) =>
                    CustomText(text: 'There is no product available!!'),
                firstPageErrorIndicatorBuilder: (context) =>
                    CustomText(text: 'Something went wrong!'),
                newPageErrorIndicatorBuilder: (context) =>
                    CustomText(text: 'Failed to load more products!'),
              ),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 210.w,
                mainAxisExtent: 230.w,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.w,
              ),
            ),
          ),

          /// ============ Pagination Loader =============
          SliverPadding(
            padding: padding12H4V,
            sliver: Obx(() {
              return hCtrl.isProductLoadingMore.value
                  ? SliverToBoxAdapter(child: PaginationLoadingWidget())
                  : SliverToBoxAdapter(child: SizedBox.shrink());
            }),
          ),
        ],
      ),
    );
  }
}

class DynamicProductList extends StatelessWidget {
  const DynamicProductList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hCtrl = Get.find<HomeController>();
    return Obx(() {
      return hCtrl.isLoadingProduct.value
          ? CustomLoadingWidget(
              height: 200.h,
            )
          : hCtrl.productList.isEmpty
              ? CustomText(text: 'There is no product available!!')
              : GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  primary: false,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: hCtrl.productList.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.w,
                    mainAxisExtent: 265.w,
                    // childAspectRatio: .5,
                    maxCrossAxisExtent: 210.w,
                  ),
                  itemBuilder: (context, index) => ProductCardItemWidget(
                    product: hCtrl.productList[index],
                  ),
                );
    });
  }
}
