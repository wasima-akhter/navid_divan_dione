import 'package:flutter_svg/svg.dart';
import 'package:navid_e_commerce/core/components/custom_refresh_indicator.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/presentations/home/controllers/product_list_controller.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';

import '../../../core/components/custom_button_tap.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/constants/padding_constant.dart';
import '../../../core/constants/text_style_constant.dart';
import '../../../core/export/ui_export.dart';
import '../../profile/widgets/custom_loading_widget.dart';
import '../widgets/category_list_card_item_widget.dart';
import '../widgets/dynamic_product_list.dart';
import '../widgets/pagination_loading_widget.dart';
import '../widgets/search_text_field_widget.dart';

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
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ProductListController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductListController>();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        // HomeController.to.pagingController.refresh();
        // HomeController.to.productList.refresh();
        // HomeController.to.searchController.value.clear();
      },
      child: CustomRefreshIndicatorWidget(
        onRefresh: () async {
          // return HomeController.to.pagingController.refresh();
        },
        child: DefaultScaffoldStructureWidget(appBarTitle: 'Products', children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  // fitlter icon
                  IconButton(
                      onPressed: () {
                        controller.searchController.text = '';
                        controller.searchFocusNode.unfocus();
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.r),
                                        topRight: Radius.circular(8.r))),
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
                                child: Obx(() {
                                  if (controller.isLoadingCategory.value) {
                                    return CustomLoadingWidget(height: 40.h);
                                  } else if (controller.catList.isEmpty) {
                                    return CustomText(text: 'There is no Category available!!');
                                  } else {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        spacing: 12.w,
                                        children: List.generate(
                                            controller.catList.length,
                                            (index) => CategoryListCardItemWidget(
                                                categoryModel: controller.catList[index],
                                                onTapItem: () {
                                                  Get.back();
                                                  controller.applyFilters(
                                                      category: controller.catList[index].sId);
                                                },
                                                arrowDownWidget: ProductFilterWidget(
                                                  controller: controller,
                                                  index: index,
                                                ))),
                                      ),
                                    );
                                  }
                                }));
                          },
                        );
                      },
                      icon: Icon(
                        Icons.filter_list,
                        size: 26.h,
                      )),
                  12.horizontalSpace,
                  Flexible(
                    child: SearchTextFieldWidget(
                      searchController: controller.searchController,
                      focusNode: controller.searchFocusNode,
                      onChanged: (value) {
                        controller.applyFilters(search: value);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
          space12H,
          //
          DynamicProductList(
            controller: controller,
          )
        ]),
      ),
    );
  }
}

class ProductFilterWidget extends StatelessWidget {
  final ProductListController controller;
  final int index;
  const ProductFilterWidget({Key? key, required this.controller, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ButtonTapWidget(
          onTap: () async {
            await controller.getSubCategoryRequest(category: controller.catList[index]);

            if (controller.subCategoryList.isNotEmpty) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) {
                  return Obx(() {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: controller.subCategoryList.length,
                      separatorBuilder: (_, __) => Divider(),
                      itemBuilder: (context, index) {
                        final subCat = controller.subCategoryList[index];
                        return Container(
                          margin: EdgeInsets.only(top: 10.h),
                          child: ListTile(
                            leading: CustomNetworkImage(
                              imageUrl: "${ApiService().baseUrl}${subCat.img}",
                              height: 40.sp,
                              width: 40.sp,
                            ),
                            title: CustomText(
                              text: subCat.name ?? 'Unnamed',
                              style: poppinsMedium,
                            ),
                            onTap: () {
                              // handle subcategory tap
                              Navigator.pop(context);
                              Navigator.pop(context);
                              controller.applyFilters(subCategory: subCat.sId);
                            },
                          ),
                        );
                      },
                    );
                  });
                },
              );
            } else {
              showCustomSnackbar(
                title: 'No Subcategories',
                message: 'No subcategories found for this category.',
                type: SnackBarType.alert,
              );
            }
          },
          child: Padding(
            padding: padding8,
            child: controller.catList[index].isLoadingSub.value
                ? PaginationLoadingWidget(
                    padding: padding2,
                    size: 10.sp,
                  )
                : SvgPicture.asset(arrowDownIcon),
          )),
    );
  }
}
