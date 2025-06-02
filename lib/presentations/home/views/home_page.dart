import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_refresh_indicator.dart';

import 'package:navid_e_commerce/core/components/custom_text_button.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/home/controllers/home_controller.dart';
import 'package:navid_e_commerce/presentations/home/views/category_list_page.dart';

import 'package:navid_e_commerce/presentations/home/widgets/category_list_card_item_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/product_card_item_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/search_text_field_widget.dart';
import 'package:navid_e_commerce/presentations/profile/widgets/custom_loading_widget.dart';

import '../widgets/pagination_loading_widget.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        HomeController.to.getProductListRequest(loadMore: true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicatorWidget(
      onRefresh: () {
        return HomeController.to.refreshCall();
      },
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          /// ============ Search Field =============
          SliverPadding(
            padding: padding12H.copyWith(top: 12),
            sliver: SliverToBoxAdapter(
              child: SearchTextFieldWidget(
                searchController: HomeController.to.searchController.value,
              ),
            ),
          ),

          /// ============ Category Title & Button =============
          SliverPadding(
            padding: padding12H,
            sliver: Obx(() {
              return HomeController.to.isLoadingCategory.value ||
                  HomeController.to.catList.isEmpty
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
              if (HomeController.to.isLoadingCategory.value) {
                return SliverToBoxAdapter(
                  child: CustomLoadingWidget(height: 40.h),
                );
              } else if (HomeController.to.catList.isEmpty) {
                return SliverToBoxAdapter(
                    child: CustomText(text: 'There is no Category available!!'));
              } else {
                return SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12.w,
                      children: List.generate(
                        HomeController.to.catList.length,
                            (index) => CategoryListCardItemWidget(
                          categoryModel: HomeController.to.catList[index],
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
            sliver: Obx(() {
              if (HomeController.to.isLoadingProduct.value) {
                return SliverToBoxAdapter(
                    child: CustomLoadingWidget(height: 200.h));
              } else if (HomeController.to.productList.isEmpty) {
                return SliverToBoxAdapter(
                    child: CustomText(text: 'There is no product available!!'));
              } else {
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return ProductCardItemWidget(
                        product: HomeController.to.productList[index],
                      );
                    },
                    childCount: HomeController.to.productList.length,
                  ),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 210.w,
                    mainAxisExtent: 265.w,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.w,
                  ),
                );
              }
            }),
          ),

          /// ============ Pagination Loader =============
          SliverPadding(
            padding: padding12H4V,
            sliver: Obx(() {
              return HomeController.to.isProductLoadingMore.value
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
    return Obx(() {
      return HomeController.to.isLoadingProduct.value
          ? CustomLoadingWidget(
              height: 200.h,
            )
          : HomeController.to.productList.isEmpty
              ? CustomText(text: 'There is no product available!!')
              : GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  primary: false,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: HomeController.to.productList.length,
                  gridDelegate:
                      SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.w,
                    mainAxisExtent: 265.w,
                    // childAspectRatio: .5,
                    maxCrossAxisExtent: 210.w,
                  ),
                  itemBuilder: (context, index) =>
                      ProductCardItemWidget(
                    product: HomeController.to.productList[index],
                  ),
                );
    });
  }
}
