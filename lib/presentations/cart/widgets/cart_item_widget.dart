import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/cart/controllers/cart_controller.dart';
import 'package:navid_e_commerce/presentations/cart/model/cart_model.dart';
import 'package:navid_e_commerce/presentations/cart/widgets/blue_container_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/product_card_item_widget.dart';

class CartItemWidget extends StatelessWidget {
  final CartModel cartModel;
  const CartItemWidget({super.key, required this.cartModel});

  @override
  Widget build(BuildContext context) {
    // ✅ Use product ID (matches localQty key), not cart document ID
    final String productId = cartModel.product?.sId ?? "";

    return DefaultFadeContainerWidget(
      child: Row(
        spacing: 8.w,
        children: [
          Expanded(
            flex: 2,
            child: Builder(
              builder: (context) {
                debugPrint(
                  ' cart item image :  "${cartModel.variant?.img?.first ?? ''}"',
                );
                return CustomNetworkImage(
                  imageUrl: "${cartModel.variant?.img?.first ?? ''}",
                  height: 100.w,
                );
              },
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
                        text: (cartModel.product?.name ?? "")
                            .capitalize
                            .toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: poppinsRegular,
                        fontSize: getFontSizeDefault(),
                      ),
                    ),
                    space6W,
                    // ✅ Obx here to reactively read localQty
                    Obx(() {
                      final controller = CartController.to;
                      // ✅ localQty returns int, wrap in RxInt for CartCounterWidget
                      final RxInt qty = (controller.localQty[productId] ??
                              cartModel.quantity ??
                              1)
                          .obs;

                      return CartCounterWidget(
                        count: qty,
                        increLoading: controller.isIncreLoading[productId],
                        decreLoading: controller.isDecreLoading[productId],
                        // ✅ local — no API call
                        onIncrement: () => controller.incrementLocal(productId),
                        onDecrement: () => controller.decrementLocal(productId),
                      );
                    }),
                  ],
                ),
                CustomText(
                  text: 'size: ${cartModel.variant?.size ?? "n/a"}  ',
                  style: poppinsMedium.copyWith(
                    color: AppColors.kPrimaryTextDarkColor,
                    fontSize: getFontSizeSemiSmall(),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        text:
                            'price: \$${(cartModel.variant?.price ?? 0.0).toString()}  ',
                        style: poppinsMedium.copyWith(
                          color: AppColors.kPrimaryTextDarkColor,
                          fontSize: getFontSizeSemiSmall(),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        CartController.to
                            .deleteCartItem(cartId: cartModel.sId ?? "");
                      },
                      icon: Icon(CupertinoIcons.delete,
                          color: Colors.red, size: 16.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartCounterWidget extends StatelessWidget {
  final RxInt count;
  final Function()? onIncrement;
  final Function()? onDecrement;
  final RxBool? increLoading;
  final RxBool? decreLoading;

  const CartCounterWidget({
    super.key,
    required this.count,
    this.onIncrement,
    this.onDecrement,
    this.increLoading,
    this.decreLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4.w,
      children: [
        BlueContainerWithIcon(
          icon: 'assets/icons/minius_icon.svg',
          onTap: onDecrement,
          isLoading: decreLoading?.value,
        ),
        Obx(
          () => BlueContainerWithIcon(
            // ✅ wrapped
            child: Padding(
              padding: paddingH16V6,
              child: CustomText(
                text: count.value.toString(),
                color: AppColors.kPrimaryTextDarkColor,
                fontSize: getFontSizeSmall(),
              ),
            ),
          ),
        ),
        BlueContainerWithIcon(
          icon: 'assets/icons/plus_icon.svg',
          onTap: onIncrement,
          isLoading: increLoading?.value,
        ),
        // Obx(() => BlueContainerWithIcon(
        //       icon: 'assets/icons/minius_icon.svg',
        //       onTap: onDecrement,
        //       isLoading: decreLoading?.value,
        //     )),
        // Obx(() => BlueContainerWithIcon(
        //         // ✅ wrapped
        //         child: Padding(
        //       padding: paddingH16V6,
        //       child: CustomText(
        //         text: count.value.toString(),
        //         color: AppColors.kPrimaryTextDarkColor,
        //         fontSize: getFontSizeSmall(),
        //       ),
        //     ))),
        // Obx(() => BlueContainerWithIcon(
        //       icon: 'assets/icons/plus_icon.svg',
        //       onTap: onIncrement,
        //       isLoading: increLoading?.value,
        //     )),
      ],
    );
  }
}
