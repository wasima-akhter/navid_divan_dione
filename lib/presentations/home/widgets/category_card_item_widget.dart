import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_service.dart';
import 'package:navid_e_commerce/core/components/custom_button_tap.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/presentations/home/controllers/home_controller.dart';
import 'package:navid_e_commerce/presentations/home/model/category_model.dart';
import 'package:navid_e_commerce/presentations/home/views/product_list_page.dart';

class CategoryCardItemWidget extends StatelessWidget {
  final CategoryModel categoryModel;
  const CategoryCardItemWidget({
    super.key,
    required this.categoryModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kPrimaryExtraLightColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ButtonTapWidget(
        radius: 8.r,
        onTap: () {
          HomeController.to.applyFilters(category: categoryModel.sId);
          Get.toNamed(ProductListPage.routeName);
        },
        child: Padding(
          padding: padding8,
          child: Column(
            spacing: 8.h,
            children: [
              Expanded(
                  child: CustomNetworkImage(
                      width: double.infinity,
                      imageUrl: '${ApiService().baseUrl}${categoryModel.img}')),
              CustomText(text: categoryModel.name ?? 'n/a'),
            ],
          ),
        ),
      ),
    );
  }
}
