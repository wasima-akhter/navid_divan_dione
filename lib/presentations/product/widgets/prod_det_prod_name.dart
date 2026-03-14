import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/custom_text.dart';
import '../../../core/constants/fontsize_constant.dart';
import '../../../core/constants/text_style_constant.dart';
import 'expand_able_text.dart';

class ProdDetProdNameDesQuantity extends StatelessWidget {
  final String productName;
  final String productDes;
  final String productQuantity;
  const ProdDetProdNameDesQuantity(
      {Key? key,
      required this.productName,
      required this.productDes,
      required this.productQuantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomText(
                text: productName,
                fontSize: getFontSizeDefault(),
                color: AppColors.kPrimaryTextDarkColor,
              ),
            ),
            CustomText(
              text: productQuantity.isEmpty ? '' : '$productQuantity pcs',
              style: poppinsRegular,
            ),
          ],
        ),
        10.verticalSpace,
        ExpandableText(
          text: productDes,
          maxLines: 3,
        )
      ],
    );
  }
}
