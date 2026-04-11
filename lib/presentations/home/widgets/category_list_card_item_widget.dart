import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_service.dart';
import 'package:navid_e_commerce/core/components/custom_button_tap.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/helper/helper_function.dart';
import 'package:navid_e_commerce/presentations/home/controllers/home_controller.dart';
import 'package:navid_e_commerce/presentations/home/model/category_model.dart';
import 'package:navid_e_commerce/presentations/home/widgets/pagination_loading_widget.dart';

class CategoryListCardItemWidget extends StatelessWidget {
  final CategoryModel categoryModel;
  final void Function()? onTapItem;
  final Widget? arrowDownWidget;
  final bool? isFromProductList;

  const CategoryListCardItemWidget({
    super.key,
    required this.categoryModel,
    this.onTapItem,
    this.arrowDownWidget,
    this.isFromProductList,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapItem ??
          () {
            HomeController.to.applyFilters(category: categoryModel.sId);
          },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: AppColors.kPrimaryColor, width: 1.5)),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Row(
              children: [
                CustomNetworkImage(
                  imageUrl: '${ApiService().baseUrl}${categoryModel.img}',
                  height: 47.w,
                  width: 52.w,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(4.r),
                  ),
                ),

                8.horizontalSpace,

                /// ✅ FIXED TEXT
                Container(
                  width: isFromProductList == true ? 1.sw * 0.6 : null,
                  // color: Colors.amber,
                  child: CustomText(
                    text: categoryModel.name ?? 'n/a',
                    style: poppinsRegular,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    fontSize: getFontSizeDefault(),
                    color: AppColors.kPrimaryTextDarkColor,
                  ),
                ),
              ],
            ),
            arrowDownWidget ??
                Obx(() {
                  return ButtonTapWidget(
                      onTap: () async {
                        await HomeController.to.getSubCategoryRequest(category: categoryModel);

                        if (HomeController.to.subCategoryList.isNotEmpty) {
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
                                  itemCount: HomeController.to.subCategoryList.length,
                                  separatorBuilder: (_, __) => Divider(),
                                  itemBuilder: (context, index) {
                                    final subCat = HomeController.to.subCategoryList[index];
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
                                          HomeController.to.applyFilters(subCategory: subCat.sId);
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
                        child: categoryModel.isLoadingSub.value
                            ? PaginationLoadingWidget(
                                padding: padding2,
                                size: 10.sp,
                              )
                            : SvgPicture.asset(arrowDownIcon),
                      ));
                }),
          ],
        ),
      ),
    );
  }
}
