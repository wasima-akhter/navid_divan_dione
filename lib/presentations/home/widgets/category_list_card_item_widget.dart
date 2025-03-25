import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/helper/helper_function.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/home/model/category_model.dart';
class CategoryListCardItemWidget extends StatelessWidget {
  final bool? isDropDown;
  final CategoryModel categoryModel;
  const CategoryListCardItemWidget({
    super.key, this.isDropDown=false, required this.categoryModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTapDown: (TapDownDetails details) {
      //  if(isDropDown==true) {
      //     showPopupMenu(context, details.globalPosition);
      //   }
      // },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
                color: AppColors.kPrimaryColor, width: 1.5)),
        child: Row(
          children: [
            CustomNetworkImage(
              imageUrl: dummyCatImg,
              height: 47.w,
              width: 52.w,
              borderRadius:
              BorderRadius.horizontal(left: Radius.circular(4.r)),
            ),

            ///=====================dynamic cat name ===================///

            Padding(
              padding: padding8,
              child: CustomText(
                text: 'hookah',
                style: poppinsRegular,
                fontSize: getFontSizeDefault(),
                color: AppColors.kPrimaryTextDarkColor,
              ),
            ),
            isDropDown==true?SvgPicture.asset(arrowDownIcon):SizedBox.shrink(),
            space8W
          ],
        ),
      ),
    );
  }
}
