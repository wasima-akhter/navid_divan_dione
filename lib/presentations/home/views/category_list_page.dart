import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/presentations/home/controllers/home_controller.dart';
import 'package:navid_e_commerce/presentations/home/widgets/category_card_item_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';

import '../../../core/components/custom_refresh_indicator.dart';
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
    scrollController.addListener(
      () {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          HomeController.to.getCategoryListRequest(loadMore: true);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicatorWidget(
      onRefresh: () {
        return HomeController.to.getCategoryListRequest();
      },
      child: DefaultScaffoldStructureWidget(
        scrollController: scrollController,
        appBarTitle: AppStaticStrings.category,
        children: [
          Obx(() {
            return GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              primary: false,
              itemCount: HomeController.to.catList.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.w,
                  maxCrossAxisExtent: 200.w),
              itemBuilder: (context, index) => CategoryCardItemWidget(
                categoryModel: HomeController.to.catList[index],
              ),
            );
          }),
          Obx(
            () {
              return HomeController.to.isLoadingMore.value
                  ? PaginationLoadingWidget()
                  : SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }
}

