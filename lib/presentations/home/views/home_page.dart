import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:navid_e_commerce/core/components/custom_text_button.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';

import 'package:navid_e_commerce/presentations/home/widgets/category_list_card_item_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/search_text_field_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding12,
      child: Column(
        spacing: 6.w ,
        children: [
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
                title: AppStaticStrings.viewAll,
                fontSize: getFontSizeSemiSmall(),
                textColor: AppColors.kPrimaryTextDarkColor,
              )
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 12.w,
              children: List.generate(
                10,
                (index) => CategoryListCardItemWidget(isDropDown: index==1?true:false,),
              ),
            ),
          )
        ],
      ),
    );
  }
}

