import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:navid_e_commerce/core/components/custom_text_button.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/home/views/category_list_page.dart';

import 'package:navid_e_commerce/presentations/home/widgets/category_list_card_item_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/product_card_item_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/search_text_field_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: padding12,
        child: Column(
          spacing: 6.h,
          children: [
            ///=================search button=====================///
            SearchTextFieldWidget(),
            Row(
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

            ///=================category list=====================///
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 12.w,
                children: List.generate(
                  10,
                  (index) => CategoryListCardItemWidget(
                    isDropDown: index == 1 ? true : false,
                  ),
                ),
              ),
            ),
            space6H,

            ///=================product list=====================///

            LayoutBuilder(
              builder: (context, constraints) {
                // Calculate dynamic aspect ratio based on available width
                double width = constraints.maxWidth;
                double calculatedAspectRatio =
                    width / (200.w * 2.5); // Adjust multiplier as needed

                return GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  primary: false,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.w,
                    mainAxisExtent: 265.w,
                    // childAspectRatio: .5,
                    maxCrossAxisExtent: 210.w,
                  ),
                  itemBuilder: (context, index) => ProductCardItemWidget(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
