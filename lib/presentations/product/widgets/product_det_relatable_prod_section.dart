import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/custom_text.dart';
import '../../../core/constants/fontsize_constant.dart';
import '../../home/widgets/product_card_item_widget.dart';
import '../controllers/product_controller.dart';

class ProductDetRelatedProducts extends StatelessWidget {
  const ProductDetRelatedProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Related Products',
          fontSize: getFontSizeDefault(),
          color: AppColors.kPrimaryTextDarkColor,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              spacing: 12.w,
              children: List.generate(
                ProductController.to.relatedProductList.length,
                (index) => SizedBox(
                    width: 200.w,
                    height: 200.w,
                    child: ProductCardItemWidget(
                      product: ProductController.to.relatedProductList[index],
                    )),
              )),
        )
      ],
    );
  }
}
