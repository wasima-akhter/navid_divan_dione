import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/utils/enum.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/home/widgets/product_card_item_widget.dart';

class OrderCardItemWidget extends StatelessWidget {
  final OrderStatus statusEnum;
  const OrderCardItemWidget({
    super.key,
    required this.statusEnum,
  });

  @override
  Widget build(BuildContext context) {
    String statusName;
    Color color;
    switch (statusEnum) {
      case OrderStatus.pending:
        // TODO: Handle this case.
        statusName = AppStaticStrings.pending;
        color = AppColors.kPendingColor;
        break;
      case OrderStatus.shipping:
        // TODO: Handle this case.
        statusName = AppStaticStrings.shipping;
        color = AppColors.kGreenColor;
        break;
      case OrderStatus.completed:
        // TODO: Handle this case.
        statusName = AppStaticStrings.complete;
        color = Colors.black;
        break;
      case OrderStatus.shipped:
        // TODO: Handle this case.
        statusName = AppStaticStrings.shipped;
        color = AppColors.kPrimaryDarkColor;
        break;
    }
    return DefaultFadeContainerWidget(
        child: Row(
      spacing: 12.w,
      children: [
        Expanded(
          flex: 2,
          child: CustomNetworkImage(
            imageUrl: dummyCatImg,
            height: 90.w,
          ),
        ),
        Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        text: 'Total Item 05',
                        color: AppColors.kPrimaryDarkColor,
                      ),
                    ),
                    Container(
                      padding: padding8,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8.r)
                      ),
                      child: CustomText(
                        text: statusName,
                        color: AppColors.kWhiteColor,
                        style: poppinsRegular,
                      ),
                    )
                  ],
                ),
                CustomText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: '${AppStaticStrings.totalAmount}: \$34553',
                  fontSize: getFontSizeSmall(),
                  style: poppinsRegular,
                ),
                CustomText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: '${AppStaticStrings.deliveryDate}: 05/12/2021',
                  fontSize: getFontSizeSmall(),
                  style: poppinsRegular,
                ),
                CustomText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text:
                      '${AppStaticStrings.location}: 3 / 621 Juvenal Ridge, Port Vestachester',
                  fontSize: getFontSizeSmall(),
                  style: poppinsRegular,
                ),
              ],
            )),
      ],
    ));
  }
}
