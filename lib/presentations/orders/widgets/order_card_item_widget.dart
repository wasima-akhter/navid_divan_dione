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

import '../../../core/constants/custom_space.dart';
import '../controllers/order_controller.dart';

class OrderCardItemWidget extends StatelessWidget {
  final Items itemModel;
  final OrderModel orderModel;

  const OrderCardItemWidget({
    super.key,
    required this.itemModel,
    required this.orderModel,
  });

  @override
  Widget build(BuildContext context) {
    String? statusName;
    Color color = AppColors.kPrimaryColor;

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

    // ✅ price lives in variant.priceAfterDiscount, NOT product.price (which is null)
    final discount = itemModel.variant?.discount ?? 0;
    final double variantPrice = discount == 0
        ? (itemModel.variant?.price ?? 0.0)
        : (itemModel.variant?.priceAfterDiscount ?? 0.0);
    final int qty = (itemModel.quantity as num?)?.toInt() ?? 0;
    final double totalItemPrice = variantPrice;

    print("totalItemPrice: $totalItemPrice");
    print("itemModel.variant?.price: ${itemModel.variant?.price}");

    // ✅ image from variant.img list, not variant.color
    final String imageUrl = itemModel.variant?.img?.isNotEmpty == true
        ? "${ApiService().baseUrl}${itemModel.variant!.img!.first}"
        : "";

    // ✅ address fallback
    final String address =
        orderModel.deliveryAddress?.address ?? orderModel.pickUpAddress?.address ?? "N/A";

    return itemModel.product == null
        ? const SizedBox.shrink()
        : DefaultFadeContainerWidget(
            child: Row(
              spacing: 12.w,
              children: [
                // ✅ correct image
                Expanded(
                  flex: 2,
                  child: CustomNetworkImage(
                    imageUrl: imageUrl,
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
                              text: itemModel.product!.name ?? "N/A",
                              color: AppColors.kPrimaryDarkColor,
                            ),
                          ),
                          Container(
                            padding: padding8,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: CustomText(
                              text: statusName ?? "N/A",
                              color: AppColors.kWhiteColor,
                              style: poppinsRegular,
                            ),
                          ),
                        ],
                      ),
                      // ✅ safe price calculation — no double.parse on null
                      CustomText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: '${AppStaticStrings.price}: \$${totalItemPrice.toStringAsFixed(2)}',
                        fontSize: getFontSizeSmall(),
                        style: poppinsRegular,
                      ),
                      CustomText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: '${AppStaticStrings.quantity}: $qty',
                        fontSize: getFontSizeSmall(),
                        style: poppinsRegular,
                      ),
                      // ✅ size & color from variant
                      if (itemModel.variant?.size != null)
                        CustomText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: 'Size: ${itemModel.variant!.size}',
                          fontSize: getFontSizeSmall(),
                          style: poppinsRegular,
                        ),
                      CustomText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: '${AppStaticStrings.location}: $address',
                        fontSize: getFontSizeSmall(),
                        style: poppinsRegular,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
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
    print("orderModel.sId: ${orderModel.sId}");
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border:
              Border.all(width: 0.6, color: AppColors.kExtraLightGreyTextColor.withOpacity(0.6))),
      padding: EdgeInsets.all(12.h),
      margin: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6.h,
        children: [
          CustomText(
            text: 'Order no: #${orderModel.sId ?? "N/A"}',
            color: AppColors.kPrimaryTextDarkColor,
            style: poppinsSemiBold,
          ),
          // ✅ Wrap the whole payment row in Obx so it reacts to list updates
          Obx(() {
            // find the fresh order from the list (in case it was updated)
            final fresh =
                OrderController.to.orderList.firstWhereOrNull((o) => o.sId == orderModel.sId) ??
                    orderModel;

            return Row(
              children: [
                Expanded(
                  child: CustomText(
                    text: 'Total amount: \$${(fresh.totalAmount ?? 0.0).toStringAsFixed(2)}',
                    color: AppColors.kPrimaryTextDarkColor,
                    style: poppinsSemiBold,
                  ),
                ),
                space12W,
                if (fresh.paymentStatus == "pending")
                  Expanded(
                    child: Obx(() {
                      // ✅ isLoading must be inside Obx, not Builder
                      final isLoading =
                          OrderController.to.isPaymentLoadingMap[fresh.sId ?? ""] == true;
                      return CustomButton(
                        isLoading: isLoading,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        onTap: () {
                          isLoading //
                              ? null
                              : OrderController.to.payForOrder(orderModel: fresh);
                        },
                        title: "Pay",
                      );
                    }),
                  ),
              ],
            );
          }),

// ✅ payment status text also reactive
          Obx(() {
            final fresh =
                OrderController.to.orderList.firstWhereOrNull((o) => o.sId == orderModel.sId) ??
                    orderModel;
            if (fresh.paymentStatus == "pending") return const SizedBox.shrink();
            return CustomText(
              text: 'Payment Status: ${(fresh.paymentStatus ?? "N/A").toUpperCase()}',
              color: AppColors.kPrimaryColor,
              style: poppinsSemiBold,
            );
          }),

          Column(
            spacing: 6.h,
            children: List.generate(
              orderModel.items?.length ?? 0,
              (index) => OrderCardItemWidget(
                orderModel: orderModel,
                itemModel: orderModel.items![index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
