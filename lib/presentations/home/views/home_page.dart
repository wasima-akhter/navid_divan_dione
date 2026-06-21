import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
import 'package:navid_e_commerce/presentations/home/views/product_list_page.dart';
import 'package:navid_e_commerce/presentations/home/widgets/product_card_item_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/search_text_field_widget.dart';
import 'package:navid_e_commerce/presentations/product/model/product_model.dart';
import 'package:navid_e_commerce/presentations/profile/widgets/custom_loading_widget.dart';

import '../widgets/category_grid_item_widget.dart';
import '../widgets/no_product_widget.dart';
import '../widgets/pagination_loading_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final RxBool _showScrollToTop = false.obs;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    //  --> show button after scrolling past ~2 screen heights worth of content
    final shouldShow = _scrollController.offset > 400;
    if (shouldShow != _showScrollToTop.value) {
      _showScrollToTop.value = shouldShow;
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hCtrl = Get.find<HomeController>();
    return Scaffold(
      body: CustomRefreshIndicatorWidget(
        onRefresh: () {
          return hCtrl.refreshCall();
        },
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                /// ============ Sticky Search Field =============
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickySearchBarDelegate(
                    height: (1.sh * 0.13).clamp(
                        64.h, 100.h), // --> never below 64, never above 100
                    child: Container(
                      color: Colors.white,
                      padding: padding12H.copyWith(top: 12, bottom: 12),
                      child: SearchTextFieldWidget(
                        searchController: hCtrl.searchController.value,
                        focusNode: hCtrl.searchFocusNode.value,
                      ),
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
                                    itemCount: hCtrl.bannerList.length > 10
                                        ? 10
                                        : hCtrl.bannerList.length,
                                    itemBuilder: (context, index, realIndex) {
                                      final bannerItem =
                                          hCtrl.bannerList[index];

                                      return Padding(
                                        padding: padding6H,
                                        child: CustomNetworkImage(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          imageUrl: '${bannerItem.img ?? ''}',
                                          height: 150.h,
                                          width: double.maxFinite,
                                        ),
                                      );
                                    },
                                    options: CarouselOptions(
                                      height: 150.h,
                                      viewportFraction: 1,
                                      autoPlay: true,
                                      autoPlayInterval:
                                          const Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 800),
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
                    return hCtrl.isLoadingCategory.value ||
                            hCtrl.catList.isEmpty
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
                              Obx(() {
                                final hasFilter =
                                    hCtrl.selectedCategory.value != null ||
                                        hCtrl.selectedSubCategory.value !=
                                            null ||
                                        hCtrl.searchQuery.value.isNotEmpty;

                                if (!hasFilter) return const SizedBox.shrink();

                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    hCtrl.applyFilters(
                                      category: null,
                                      subCategory: null,
                                      search: '',
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: AppColors.kPrimaryColor
                                            .withValues(alpha: 0.2)),
                                    child: Row(
                                      children: [
                                        CustomText(
                                          text: "Clear filters",
                                          fontSize: 12,
                                        ),
                                        const Icon(
                                          Icons.close_rounded,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              CustomTextButton(
                                onPressed: () {
                                  Get.toNamed(CategoryListPage.routeName);
                                },
                                title: AppStaticStrings.viewAll,
                                fontSize: getFontSizeSemiSmall(),
                                textColor: AppColors.kPrimaryTextDarkColor,
                              ),
                            ],
                          ));
                  }),
                ),

                /// ============ Category Grid List (2 rows, 4 columns) =============
                SliverPadding(
                  padding: padding12H4V,
                  sliver: Obx(() {
                    if (hCtrl.isLoadingCategory.value) {
                      return SliverToBoxAdapter(
                        child: CustomLoadingWidget(height: 40.h),
                      );
                    } else if (hCtrl.catList.isEmpty) {
                      return SliverToBoxAdapter(
                          child: CustomText(
                              text: 'There is no Category available!!'));
                    } else {
                      final displayList = hCtrl.catList.take(8).toList();
                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 8.h,
                          crossAxisSpacing: 8.w,
                          childAspectRatio: 0.75,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Container(
                              child: CategoryGridItemWidget(
                                categoryModel: displayList[index],
                              ),
                            );
                          },
                          childCount: displayList.length,
                        ),
                      );
                    }
                  }),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 6.h)),

                /// ============ product List Title & Button =============
                SliverPadding(
                    padding: padding12H,
                    sliver: Obx(() => hCtrl.isProductLoadingMore.value
                        ? SliverToBoxAdapter(child: PaginationLoadingWidget())
                        : SliverToBoxAdapter(
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: AppStaticStrings.recentProducts,
                                    style: poppinsMedium,
                                    fontSize: getFontSizeDefault(),
                                    color: AppColors.kPrimaryTextDarkColor,
                                  ),
                                ),
                                CustomTextButton(
                                  onPressed: () {
                                    Get.toNamed(ProductListPage.routeName);
                                  },
                                  title: AppStaticStrings.viewAll,
                                  fontSize: getFontSizeSemiSmall(),
                                  textColor: AppColors.kPrimaryTextDarkColor,
                                )
                              ],
                            ),
                          ))),

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
                      firstPageProgressIndicatorBuilder: (context) =>
                          CustomLoadingWidget(height: 200.h),
                      newPageProgressIndicatorBuilder: (context) =>
                          PaginationLoadingWidget(),
                      noItemsFoundIndicatorBuilder: (_) => NoProductWidget(
                          searchController: hCtrl.searchController,
                          searchQuery: hCtrl.searchQuery.value,
                          selectedCategory: hCtrl.selectedCategory.value,
                          selectedSubCategory: hCtrl.selectedSubCategory.value,
                          applyFilters: ({category, search, subCategory}) =>
                              hCtrl.applyFilters(
                                  category: category,
                                  search: search,
                                  subCategory: subCategory)),
                      firstPageErrorIndicatorBuilder: (context) => CustomText(
                          text: hCtrl.pagingController.error?.toString() ??
                              'Something went wrong!'),
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

            // 👇 Scroll-to-top FAB
            Positioned(
              right: 16.w,
              bottom: 24.h,
              child: Obx(() {
                return AnimatedSlide(
                  duration: const Duration(milliseconds: 250),
                  offset:
                      _showScrollToTop.value ? Offset.zero : const Offset(0, 2),
                  curve: Curves.easeOut,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: _showScrollToTop.value ? 1 : 0,
                    child: IgnorePointer(
                      ignoring: !_showScrollToTop.value,
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: AppColors.kPrimaryColor,
                        onPressed: _scrollToTop,
                        child: const Icon(Icons.keyboard_arrow_up_rounded,
                            color: Colors.white),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pinned header delegate for the sticky search bar
class _StickySearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _StickySearchBarDelegate({
    required this.child,
    required this.height,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: overlapsContent ? 2 : 0,
      child: SizedBox(
        height: height,
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickySearchBarDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.height != height;
  }
}
//
