import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/cart/widgets/blue_container_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/product_card_item_widget.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultFadeContainerWidget(
      child: Row(
        spacing: 8.w,
        children: [
          Expanded(
            flex: 2,
            child: CustomNetworkImage(
              imageUrl: dummyCatImg,
              height: 100.w,
            ),
          ),
          Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6.h,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: CustomText(
                        text: 'Tobaco',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: poppinsRegular,
                        fontSize: getFontSizeDefault(),
                      )),
                      CartCounterWidget()
                    ],
                  ),
                  CustomText(
                    text: '12 pis',
                    fontSize: getFontSizeSmall(),
                    style: poppinsLight,
                  ),
                  PriceTextWidget(),
                ],
              ))
        ],
      ),
    );
  }
}

class CartCounterWidget extends StatelessWidget {
  const CartCounterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4.w,
      children: [
        BlueContainerWithIcon(),
        BlueContainerWithIcon(
          child: Padding(
            padding: paddingH16V6,
            child: CustomText(
              text: '2',
              style: poppinsRegular,
              fontSize: getFontSizeSmall(),
            ),
          ),
        ),
        BlueContainerWithIcon(
          icon: CupertinoIcons.plus,
        )
      ],
    );
  }
}
