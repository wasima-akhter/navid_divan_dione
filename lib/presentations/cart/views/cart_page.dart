import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_refresh_indicator.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/presentations/cart/controllers/cart_controller.dart';
import 'package:navid_e_commerce/presentations/cart/widgets/cart_item_list.dart';
import 'package:navid_e_commerce/presentations/cart/widgets/cart_summary_row.dart';
import 'package:navid_e_commerce/presentations/cart/widgets/cart_tab_bar-row.dart';

import '../../../core/constants/text_style_constant.dart';
import '../../../core/export/ui_export.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CartController.to;

    return CustomRefreshIndicatorWidget(
      onRefresh: () async {
        await controller.getCartListRequest();
      },
      child: Padding(
        padding: padding12,
        child: Obx(() {
          final cartList = controller.cartList;
          if (cartList.isEmpty) {
            return Padding(
              padding: padding12V,
              child: CustomText(text: "Cart List is Empty!!"),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ///------------------- TAB BAR -------------------///
              CartTabBarRow(controller: controller),

              SizedBox(height: 12.h),

              ///------------------- CONTENT -------------------///
              Obx(() {
                if (controller.selectedTab.value == 0) {
                  // ITEMS LIST
                  return Column(
                    children: [
                      CartItemList(cartList: cartList),

                      // ✅ Show update button only when there are pending changes
                      Obx(() {
                        if (controller.changedItems.isEmpty) return const SizedBox.shrink();

                        return Padding(
                          padding: EdgeInsets.only(top: 12.h),
                          child: Obx(() {
                            final isUpdating =
                                controller.isLoadingAddCart.values.any((v) => v == true);
                            return CustomButton(
                              onTap: () async {
                                isUpdating ? null : await controller.updateCart();
                              },
                              title: isUpdating ? "Updating..." : "Update Cart",
                            );
                          }),
                        );
                      }),
                    ],
                  );
                } else {
                  // SUMMARY & CHECKOUT
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: EdgeInsets.all(15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: AppStaticStrings.orderSummary,
                          style: poppinsMedium,
                          fontSize: getFontSizeDefault(),
                        ),

                        SizedBox(height: 12.h),

                        // ✅ Wrap all summary rows in ONE Obx so they all react together
                        Obx(() => Column(
                              children: [
                                CartSummaryRow(
                                  title: AppStaticStrings.subTotal,
                                  value: '\$${controller.subTotal.value}',
                                ),
                                SizedBox(height: 12.h),
                                CartSummaryRow(
                                  title: AppStaticStrings.salesTax +
                                      "\n${AppStaticStrings.includedTax}",
                                  value: '\$${controller.salesTax.value}',
                                ),
                                SizedBox(height: 12.h),
                                CartSummaryRow(
                                  title: AppStaticStrings.shippingCharge,
                                  value: controller.shippingCharge.value == "0.00"
                                      ? "Free"
                                      : '\$${controller.shippingCharge.value}',
                                ),
                                SizedBox(height: 22.h),
                                CartSummaryRow(
                                  title: AppStaticStrings.totalAmount,
                                  value: '\$${controller.totalPrice.value}',
                                ),
                              ],
                            )),

                        SizedBox(height: 12.h),

                        CustomButton(
                          onTap: () {
                            buyProductDialog(context, isFromCart: true);
                          },
                          title: AppStaticStrings.checkout,
                        ),
                      ],
                    ),
                  );
                }
              }),
            ],
          );
        }),
      ),
    );
  }
}
