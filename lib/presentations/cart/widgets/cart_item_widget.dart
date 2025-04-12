import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_service.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/cart/controllers/cart_controller.dart';
import 'package:navid_e_commerce/presentations/cart/model/cart_model.dart';
import 'package:navid_e_commerce/presentations/cart/widgets/blue_container_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/product_card_item_widget.dart';
import 'package:navid_e_commerce/presentations/splash/controllers/common_controller.dart';

class CartItemWidget extends StatelessWidget {
  final CartModel cartModel;
  const CartItemWidget({
    super.key,
    required this.cartModel,
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
              imageUrl: "${ApiService().baseUrl}/${cartModel.variant}",
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
                        text: cartModel.productId?.name ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: poppinsRegular,
                        fontSize: getFontSizeDefault(),
                      )),
                      CartCounterWidget(
                        count: (cartModel.quantity ?? 0).obs,
                        onIncrement: () {
                          CartController.to.addToCart(
                              productId: cartModel.productId?.sId ?? "",
                              quantity: (cartModel.quantity ?? 0) + 1,
                              price: cartModel.price ?? 0,
                              variant: cartModel.variant ?? "");


                          CartController.to.cartList.refresh();
                        },
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                            text: 'price: \$${cartModel.price.toString()}  ',
                            style: poppinsMedium.copyWith(color: AppColors.kPrimaryTextDarkColor, fontSize: getFontSizeSemiSmall())),
                      ),
                      IconButton(
                          onPressed: () {
                            CartController.to.deleteCartItem(cartId: cartModel.productId!.sId ?? "");

                          },
                          icon: Icon(
                            CupertinoIcons.delete,
                            color: Colors.red,
                            size: 16.sp,
                          ))
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

class CartCounterWidget extends StatelessWidget {
  final RxInt count;
  final Function()? onIncrement;
  final Function()? onDecrement;
  const CartCounterWidget({
    super.key,
    required this.count,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          spacing: 4.w,
          children: [
            BlueContainerWithIcon(
              onTap: onDecrement ??
                  () {
                    if (count.value > 1) {
                      count.value--;
                    }
                  },
              icon: 'assets/icons/minius_icon.svg',
            ),
            BlueContainerWithIcon(
              child: Padding(
                  padding: paddingH16V6,
                  child: CustomText(
                    text: count.value.toString(),
                    color: AppColors.kPrimaryTextDarkColor,
                    fontSize: getFontSizeSmall(),
                  )),
            ),
            BlueContainerWithIcon(
              onTap: onIncrement ??
                  () {
                    count.value++;
                  },
              icon: 'assets/icons/plus_icon.svg',
            )
          ],
        ));
  }
}
