import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button_tap.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/home/controllers/home_controller.dart';
import 'package:navid_e_commerce/presentations/home/controllers/product_list_controller.dart';
import 'package:navid_e_commerce/presentations/home/model/category_model.dart';
import 'package:navid_e_commerce/presentations/home/views/product_list_page.dart';

class CategoryCardItemWidget extends StatelessWidget {
  final CategoryModel categoryModel;
  const CategoryCardItemWidget({
    super.key,
    required this.categoryModel,
  });

  void _applyFilterAndGo({String? categoryId, String? subCategoryId}) {
    ProductListController controller;
    if (Get.isRegistered<ProductListController>()) {
      controller = Get.find<ProductListController>();
    } else {
      controller = Get.put(ProductListController(), permanent: true);
    }
    controller.applyFilters(
      category: categoryId,
      subCategory: subCategoryId,
    );
    Get.toNamed(ProductListPage.routeName);
  }

  Future<void> _showSubCategoryModal(BuildContext context) async {
    await HomeController.to.getSubCategoryRequest(category: categoryModel);

    if (HomeController.to.subCategoryList.isNotEmpty) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        builder: (context) {
          return Obx(() {
            return ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: CustomText(
                    text: 'View All ${categoryModel.name ?? ''}',
                    style: poppinsMedium,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _applyFilterAndGo(categoryId: categoryModel.sId);
                  },
                ),
                const Divider(),
                ...List.generate(
                  HomeController.to.subCategoryList.length,
                  (index) {
                    final subCat = HomeController.to.subCategoryList[index];
                    return ListTile(
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
                        Navigator.pop(context);
                        _applyFilterAndGo(
                          categoryId: categoryModel.sId,
                          subCategoryId: subCat.sId,
                        );
                      },
                    );
                  },
                ),
              ],
            );
          });
        },
      );
    } else {
      _applyFilterAndGo(categoryId: categoryModel.sId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasSubCategories = categoryModel.isService == true ||
        (categoryModel.subTotal != null && categoryModel.subTotal! > 0);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.kPrimaryExtraLightColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ButtonTapWidget(
        radius: 8.r,
        onTap: () async {
          if (hasSubCategories) {
            await _showSubCategoryModal(context);
          } else {
            _applyFilterAndGo(categoryId: categoryModel.sId);
          }
        },
        child: Padding(
          padding: padding8,
          child: Column(
            spacing: 8.h,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    CustomNetworkImage(
                      width: double.infinity,
                      imageUrl: '${categoryModel.img}',
                    ),
                    Obx(() {
                      if (categoryModel.isLoadingSub.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
              CustomText(text: categoryModel.name ?? 'n/a'),
            ],
          ),
        ),
      ),
    );
  }
}
