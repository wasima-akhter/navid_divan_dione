import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_appbar.dart';
import 'package:navid_e_commerce/core/components/custom_refresh_indicator.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/presentations/home/controllers/home_controller.dart';
import 'package:navid_e_commerce/presentations/home/widgets/category_card_item_widget.dart';

import '../widgets/pagination_loading_widget.dart';

class CategoryListPage extends StatefulWidget {
  static const String routeName = '/cat-list';
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        HomeController.to.getCategoryListRequest(loadMore: true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicatorWidget(
      onRefresh: () {
        return HomeController.to.getCategoryListRequest();
      },
      child: Scaffold(
        appBar: CustomDefaultAppbar(title: AppStaticStrings.category),
        body: Obx(() {
          final catList = HomeController.to.catList;
          final isLoadingMore = HomeController.to.isLoadingMore.value;

          return CustomScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: padding12,
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.w,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.w,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return CategoryCardItemWidget(
                        categoryModel: catList[index],
                      );
                    },
                    childCount: catList.length,
                  ),
                ),
              ),
              if (isLoadingMore)
                SliverToBoxAdapter(
                  child: PaginationLoadingWidget(),
                ),
              // Add some bottom padding so content is not clipped by navigation bars
              SliverToBoxAdapter(
                child: SizedBox(height: 16.h),
              ),
            ],
          );
        }),
      ),
    );
  }
}
