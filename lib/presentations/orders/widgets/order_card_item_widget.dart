import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_service.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/home/widgets/product_card_item_widget.dart';
import 'package:navid_e_commerce/presentations/orders/model/order_model.dart';
import 'package:navid_e_commerce/presentations/product/controllers/product_controller.dart';

import '../../../core/constants/custom_space.dart';
import '../controllers/order_controller.dart';

class OrderCardItemWidget extends StatelessWidget {
  final Items itemModel;
  final OrderModel orderModel;

  // final OrderStatus statusEnum;
  const OrderCardItemWidget({
    super.key,
    /*required this.statusEnum,*/ required this.itemModel,
    required this.orderModel,
  });

  @override
  Widget build(BuildContext context) {
    String? statusName;
    Color color=AppColors.kPrimaryColor;
    switch (orderModel.deliveryStatus) {
      case 'pending':
        statusName = AppStaticStrings.pending;
        color = AppColors.kPendingColor;
        break;
      case 'shipping':
        statusName = AppStaticStrings.shipping;
        color = AppColors.kGreenColor;
        break;
      case 'delivered':
        statusName = AppStaticStrings.delivered;
        color = Colors.black;
        break;
      case 'shipped':
        statusName = AppStaticStrings.shipped;
        color = AppColors.kPrimaryDarkColor;
        break;
    }

    return itemModel.product==null?SizedBox.shrink(): DefaultFadeContainerWidget(
        child: Row(
          spacing: 12.w,
          children: [
            Expanded(
              flex: 2,
              child: CustomNetworkImage(
                imageUrl: "${ApiService().baseUrl}/${itemModel.color}",
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
                            text: itemModel.product!.name ?? "n/a",
                            color: AppColors.kPrimaryDarkColor,
                          ),
                        ),
                        Container(
                          padding: padding8,
                          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8.r)),
                          child: CustomText(
                            text:statusName ?? "n/a",
                            color: AppColors.kWhiteColor,
                            style: poppinsRegular,
                          ),
                        )
                      ],
                    ),
                    CustomText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: '${AppStaticStrings.price}: \$${double.parse(itemModel.product!.price.toString()) *
                          int.parse(itemModel.quantity.toString())}',
                      fontSize: getFontSizeSmall(),
                      style: poppinsRegular,
                    ),
                    CustomText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: '${AppStaticStrings.quantity}: ${itemModel.quantity}',
                      fontSize: getFontSizeSmall(),
                      style: poppinsRegular,
                    ),
                    CustomText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text:
                      '${AppStaticStrings.location}: ${orderModel.deliveryAddress != null ? orderModel.deliveryAddress?.address : orderModel
                          .pickUpAddress?.address}',
                      fontSize: getFontSizeSmall(),
                      style: poppinsRegular,
                    ),
                  ],
                )),
          ],
        ));
  }
}

class OderTabItemWidget extends StatelessWidget {
  final OrderModel orderModel;

  const OderTabItemWidget({
    super.key,
    required this.orderModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 6.h, children: [
      space12H,
      CustomText(
        text: 'Order no: #${orderModel.sId.toString()}',
        color: AppColors.kPrimaryTextDarkColor,
        style: poppinsSemiBold,
      ),
      Row(
        children: [
          Expanded(
            child: CustomText(
              text: 'Total amount: \$${orderModel.totalAmount.toString()}',
              color: AppColors.kPrimaryTextDarkColor,
              style: poppinsSemiBold,
            ),
          ),space12W,
          orderModel.paymentStatus == "pending"
              ? Expanded(
            child: Obx(() {
              return CustomButton(
                isLoading: ProductController.to.isPaymentLoading.value,
                padding: EdgeInsets.symmetric(vertical: 6),
                onTap: () {
                  ProductController.to.paymentRequest(products: List.generate(
                    orderModel.items!.length,
                        (index) {
                      final cart = orderModel.items![index];
                      return {
                        "name": cart.product!.name,
                        "unit_amount": cart.product!.price,
                        "quantity": cart.quantity,

                      };
                    },
                  ), orderId: orderModel.sId.toString());

                },
                title: "Pay",
              );
            }),
          ) : SizedBox.shrink()

        ],
      ),
      orderModel.paymentStatus == "pending"
          ? SizedBox.shrink()
          : CustomText(
        text: 'Payment Status: ${orderModel.paymentStatus}',
        color: AppColors.kPrimaryTextDarkColor,
        style: poppinsSemiBold,
      ),
      Column(
        spacing: 6.h,
        children: List.generate(
          orderModel.items!.length,
              (index) =>
              OrderCardItemWidget(
                orderModel: orderModel,
                itemModel: orderModel.items![index],
              ),
        ),
      )
    ]);
  }
}
