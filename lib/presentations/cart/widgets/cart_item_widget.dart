import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/cart/widgets/blue_container_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/product_card_item_widget.dart';
import 'package:navid_e_commerce/presentations/splash/controllers/common_controller.dart';

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
        BlueContainerWithIcon(
          onTap: () {
            if(CommonController.to.count.value>1){
              CommonController.to.decrement(CommonController.to.count.value);
            }
          },
          icon: 'assets/icons/minius_icon.svg',
        ),
        BlueContainerWithIcon(
          child: Padding(
            padding: paddingH16V6,
            child: Obx(() {
              return CustomText(
                text: CommonController.to.count.value.toString(),
                color: AppColors.kPrimaryTextDarkColor,
                fontSize: getFontSizeSmall(),
              );
            }),
          ),
        ),
        BlueContainerWithIcon(
          onTap: () {
            CommonController.to.increment(CommonController.to.count.value);
          },
          icon: 'assets/icons/plus_icon.svg',
        )
      ],
    );
  }
}
