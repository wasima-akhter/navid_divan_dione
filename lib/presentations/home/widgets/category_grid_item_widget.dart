import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_service.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/helper/helper_function.dart';
import 'package:navid_e_commerce/presentations/home/controllers/home_controller.dart';
import 'package:navid_e_commerce/presentations/home/model/category_model.dart';

class CategoryGridItemWidget extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoryGridItemWidget({
    super.key,
    required this.categoryModel,
  });

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
            return ListView.separated(
              shrinkWrap: true,
              itemCount: HomeController.to.subCategoryList.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (context, index) {
                final subCat = HomeController.to.subCategoryList[index];
                return SafeArea(
                  child: Container(
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
                        Navigator.pop(context);
                        HomeController.to.applyFilters(subCategory: subCat.sId);
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
  }

  @override
  Widget build(BuildContext context) {
    final bool hasSubCategories = categoryModel.isService == true ||
        (categoryModel.subTotal != null && categoryModel.subTotal! > 0);

    return GestureDetector(
      onTap: () async {
        if (hasSubCategories) {
          await _showSubCategoryModal(context);
        } else {
          HomeController.to.applyFilters(category: categoryModel.sId);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 56.w,
                width: 56.w,
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryExtraLightColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.kPrimaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.all(8.w),
                child: Center(
                  child: CustomNetworkImage(
                    imageUrl: '${ApiService().baseUrl}${categoryModel.img}',
                    fit: BoxFit.contain,
                    height: 40.w,
                    width: 40.w,
                  ),
                ),
              ),
              if (hasSubCategories)
                Positioned(
                  top: -2.h,
                  right: -2.w,
                  child: Obx(() {
                    return GestureDetector(
                      onTap: () async {
                        await _showSubCategoryModal(context);
                      },
                      child: Container(
                        height: 20.w,
                        width: 20.w,
                        decoration: BoxDecoration(
                          color: AppColors.kPrimaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: categoryModel.isLoadingSub.value
                              ? SizedBox(
                                  height: 10.w,
                                  width: 10.w,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1.5,
                                  ),
                                )
                              : Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white,
                                  size: 14.w,
                                ),
                        ),
                      ),
                    );
                  }),
                ),
            ],
          ),
          8.verticalSpace,
          CustomText(
            text: categoryModel.name ?? 'n/a',
            style: poppinsRegular,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            fontSize: getFontSizeSmall(),
            color: AppColors.kPrimaryTextDarkColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
