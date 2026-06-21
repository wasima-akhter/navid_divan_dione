import 'package:flutter_svg/svg.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/presentations/home/controllers/product_list_controller.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';

import '../../../core/components/custom_button_tap.dart';
import '../../../core/components/custom_refresh_indicator.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/constants/padding_constant.dart';
import '../../../core/constants/text_style_constant.dart';
import '../../../core/export/ui_export.dart';
import '../../profile/widgets/custom_loading_widget.dart';
import '../widgets/category_list_card_item_widget.dart';
import '../widgets/dynamic_product_list.dart';
import '../widgets/pagination_loading_widget.dart';
import '../widgets/search_text_field_widget.dart';
/*
class ProductListPage extends StatefulWidget {
  static const String routeName = '/product-list';
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ScrollController scrollController = ScrollController();
  final controller = ProductListController.to;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetAndReload();
    });
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
      child: DefaultScaffoldStructureWidget(
          appBarTitle: 'Products',
          onRefresh: () async {
            await controller.onRefresh();
          },
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    // fitlter icon
                    FilterIcon(
                      controller: controller,
                    ),
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
                ),
                //
                //  radio button for whole sale and only user

                Obx(
                  () => UserTypeRadioGroup(
                    selectedValue: controller.selectedType.value,
                    onChanged: (value) => controller.onTypeChanged(value),
                  ),
                ),
              ],
            ),
            space12H,
            //
            DynamicProductList(
              controller: controller,
            )
          ]),
    );
  }
}
*/

class ProductListPage extends StatefulWidget {
  static const String routeName = '/product-list';
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ScrollController scrollController = ScrollController();
  final controller = ProductListController.to;

  final RxBool _showScrollToTop = false.obs;
  final RxBool _showScrollToBottom = true.obs;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.resetAndReload();
    // });
  }

  void _onScroll() {
    final offset = scrollController.offset;
    final maxScroll = scrollController.position.maxScrollExtent;

    final shouldShowTop = offset > 400;
    if (shouldShowTop != _showScrollToTop.value) {
      _showScrollToTop.value = shouldShowTop;
    }

    final shouldShowBottom = maxScroll > 0 && (maxScroll - offset) > 300;
    if (shouldShowBottom != _showScrollToBottom.value) {
      _showScrollToBottom.value = shouldShowBottom;
    }
  }

  void _scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  void _scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    Get.delete<ProductListController>(); // 👈 this will now actually work
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ProductListController.to;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {},
      child: DefaultScaffoldStructureWidget(
        appBarTitle: 'Products',
        // --> fully custom body — bypasses the default SingleChildScrollView wrapper
        body: CustomRefreshIndicatorWidget(
          onRefresh: () async {
            await controller.onRefresh();
          },
          child: Stack(
            children: [
              Column(
                children: [
                  // --> Sticky search row — fixed outside the scroll area
                  Material(
                    elevation: 0.6,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Padding(
                      padding: padding12,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              FilterIcon(controller: controller),
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

                              //
                            ],
                          ),
                          // Obx(
                          //   () => UserTypeRadioGroup(
                          //     selectedValue: controller.selectedType.value,
                          //     onChanged: (value) =>
                          //         controller.onTypeChanged(value),
                          //   ),
                          // ),
                          // 12.horizontalSpace,
                          // SortOrderToggle(controller: controller),

                          Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => UserTypeRadioGroup(
                                    selectedValue:
                                        controller.selectedType.value,
                                    onChanged: (value) =>
                                        controller.onTypeChanged(value),
                                  ),
                                ),
                              ),
                              12.horizontalSpace,
                              SortOrderToggle(controller: controller),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --> Scrollable content below the sticky bar
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: padding12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            space12H,
                            DynamicProductList(controller: controller),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // --> Scroll-to-bottom + Scroll-to-top FABs
              Positioned(
                right: 16.w,
                bottom: 24.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() {
                      return AnimatedSlide(
                        duration: const Duration(milliseconds: 250),
                        offset: _showScrollToTop.value
                            ? Offset.zero
                            : const Offset(0, 1),
                        curve: Curves.easeOut,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: _showScrollToTop.value ? 1 : 0,
                          child: IgnorePointer(
                            ignoring: !_showScrollToTop.value,
                            child: FloatingActionButton(
                              heroTag: "scrolltotopAllProds",
                              mini: true,
                              backgroundColor: AppColors.kPrimaryColor,
                              onPressed: _scrollToTop,
                              child: const Icon(
                                Icons.keyboard_arrow_up_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    Obx(() {
                      return AnimatedSlide(
                        duration: const Duration(milliseconds: 250),
                        offset: _showScrollToBottom.value
                            ? Offset.zero
                            : const Offset(0, -1),
                        curve: Curves.easeOut,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: _showScrollToBottom.value ? 1 : 0,
                          child: IgnorePointer(
                            ignoring: !_showScrollToBottom.value,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: FloatingActionButton(
                                heroTag: "scrolltobottomAllProds",
                                mini: true,
                                backgroundColor: AppColors.kPrimaryColor,
                                onPressed: _scrollToBottom,
                                child: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
/*
class UserTypeRadioGroup extends StatelessWidget {
  final bool selectedValue;
  final void Function(bool value) onChanged;

  const UserTypeRadioGroup({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<bool>(
            value: false,
            groupValue: selectedValue,
            activeColor: AppColors.kPrimaryColor,
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(
              "Only User",
              style: TextStyle(fontSize: 14.sp),
            ),
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: RadioListTile<bool>(
            value: true,
            groupValue: selectedValue,
            activeColor: AppColors.kPrimaryColor,
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(
              "Whole Sale",
              style: TextStyle(fontSize: 14.sp),
            ),
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
        ),
      ],
    );
  }
}
*/
class UserTypeRadioGroup extends StatelessWidget {
  final bool selectedValue;
  final void Function(bool value) onChanged;

  const UserTypeRadioGroup({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<bool>(
          value: false,
          groupValue: selectedValue,
          onChanged: (v) => v != null ? onChanged(v) : null,
        ),
        Text(
          "Only User",
          style: TextStyle(fontSize: 14.sp),
        ),
        8.horizontalSpace,
        Radio<bool>(
          value: true,
          groupValue: selectedValue,
          onChanged: (v) => v != null ? onChanged(v) : null,
        ),
        Text(
          "Whole Sale",
          style: TextStyle(fontSize: 14.sp),
        ),
      ],
    );
  }
}

class ProductFilterWidget extends StatelessWidget {
  final ProductListController controller;
  final int index;
  const ProductFilterWidget(
      {Key? key, required this.controller, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ButtonTapWidget(
          onTap: () async {
            await controller.getSubCategoryRequest(
                category: controller.catList[index]);

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
                        return SafeArea(
                          child: Container(
                            margin: EdgeInsets.only(top: 10.h),
                            child: ListTile(
                              leading: CustomNetworkImage(
                                imageUrl: "${subCat.img}",
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
                                controller.applyFilters(
                                    subCategory: subCat.sId);
                              },
                            ),
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

class FilterIcon extends StatelessWidget {
  final ProductListController controller;
  const FilterIcon({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final showDot = controller.hasFilter.value;

      return ButtonTapWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.filter_list,
                size: 26.h,
              ),

              /// 🔴 ACTIVE FILTER DOT
              if (showDot)
                Positioned(
                  right: -5,
                  top: -2,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
        onTap: () {
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
                    topRight: Radius.circular(8.r),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
                child: SafeArea(
                  child: Obx(() {
                    if (controller.isLoadingCategory.value) {
                      return CustomLoadingWidget(height: 40.h);
                    } else if (controller.catList.isEmpty) {
                      return CustomText(
                        text: 'There is no Category available!!',
                      );
                    } else {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 12.w,
                          children: [
                            Builder(
                              builder: (context) {
                                final hasFilter = controller
                                        .searchController.text.isNotEmpty ||
                                    controller.selectedCategory != null ||
                                    controller.selectedSubCategory != null;

                                if (!hasFilter) {
                                  return const SizedBox.shrink();
                                }

                                return Align(
                                  alignment: Alignment.centerRight,
                                  child: CustomButton(
                                    onTap: () {
                                      Get.back();
                                      controller.searchController.clear();
                                      controller.clearFilters();
                                    },
                                    title: 'Reset Filters',
                                    fillColor: AppColors.kPrimaryColor,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.w,
                                      vertical: 10.h,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 12.w,
                                children: [
                                  ...List.generate(
                                    controller.catList.length,
                                    (index) => CategoryListCardItemWidget(
                                      isFromProductList: true,
                                      categoryModel: controller.catList[index],
                                      onTapItem: () {
                                        Get.back();

                                        controller.applyFilters(
                                          category:
                                              controller.catList[index].sId,
                                        );
                                      },
                                      arrowDownWidget: ProductFilterWidget(
                                        controller: controller,
                                        index: index,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
                ),
              );
            },
          );
        },
      );
    });
  }
}

//
class SortOrderToggle extends StatelessWidget {
  final ProductListController controller;
  const SortOrderToggle({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDesc = controller.sortOrder.value == 'dsc';

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: controller.toggleSortOrder,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
                color: AppColors.kPrimaryColor.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDesc
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                size: 16.sp,
                color: AppColors.kPrimaryColor,
              ),
              4.horizontalSpace,
              CustomText(
                text: isDesc ? 'Newest' : 'Oldest',
                fontSize: 11.sp,
                color: AppColors.kPrimaryColor,
              ),
            ],
          ),
        ),
      );
    });
  }
}
