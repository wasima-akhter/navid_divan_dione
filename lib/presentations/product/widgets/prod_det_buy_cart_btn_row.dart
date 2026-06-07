import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/components/custom_button.dart';
import '../../../core/constants/app_static_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/helper/helper_function.dart';
import '../../auth/views/login_page.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../splash/controllers/common_controller.dart';
import '../controllers/product_controller.dart';

class ProdDetBuyCartBtnRow extends StatelessWidget {
  final String productId;
  const ProdDetBuyCartBtnRow({Key? key, required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      children: [
        /*
        Expanded(
          child: CustomButton(
            /*
            onTap: () {
// check if logged in.
// not--> login Page// yes, --> go ahead

              final isLoggedIn = CommonController.to.isLoggedIn.value;

              if (!isLoggedIn) {
                Get.toNamed(LoginPage.routeName);
                return;
              }

              buyProductDialog(
                context,
                selectedColor: ProductController.to.selectedColor.value,
                selectedSize: ProductController.to.selectedSize.value,
              );
            },
            */
            onTap: () async {
              final isLoggedIn = CommonController.to.isLoggedIn.value;

              if (!isLoggedIn) {
                Get.toNamed(LoginPage.routeName);
                return;
              }

              final selectedVariant =
                  ProductController.to.getSelectedVariantForCart();

              if (selectedVariant == null) {
                showCustomSnackbar(
                  title: "Warning",
                  message: "No variant available for this product!",
                );
                return;
              }

              final stock = selectedVariant.quantity ?? 0;
              final qty = ProductController.to.cartQuantity.value;

              if (qty > stock) {
                showCustomSnackbar(
                  title: "Stock Limit",
                  message: "Only $stock item(s) available",
                );
                return;
              }

              // Refresh cart data if needed
              await CartController.to.buyNow(
                productId: productId,
                variantId: selectedVariant.id ?? '',
                quantity: qty,
              );

              buyProductDialog(
                context,
                selectedColor: ProductController.to.selectedColor.value,
                selectedSize: ProductController.to.selectedSize.value,
              );
            },
            title: AppStaticStrings.buyNow,
          ),
        ),
*/

        Expanded(
          child: Obx(() {
            final isLoading =
                CartController.to.isBuyNowLoading[productId] ?? false;

            return CustomButton(
              isLoading: isLoading,
              onTap: () async {
                final isLoggedIn = CommonController.to.isLoggedIn.value;

                if (!isLoggedIn) {
                  Get.toNamed(LoginPage.routeName);
                  return;
                }

                final selectedVariant =
                    ProductController.to.getSelectedVariantForCart();

                if (selectedVariant == null) {
                  showCustomSnackbar(
                    title: "Warning",
                    message: "No variant available for this product!",
                  );
                  return;
                }

                final stock = selectedVariant.quantity ?? 0;
                final qty = ProductController.to.cartQuantity.value;

                if (qty > stock) {
                  showCustomSnackbar(
                    title: "Stock Limit",
                    message: "Only $stock item(s) available",
                  );
                  return;
                }

                await CartController.to.buyNow(
                  productId: productId,
                  variantId: selectedVariant.id ?? '',
                  quantity: qty,
                );

                buyProductDialog(
                  context,
                  selectedColor: ProductController.to.selectedColor.value,
                  selectedSize: ProductController.to.selectedSize.value,
                );
              },
              title: AppStaticStrings.buyNow,
            );
          }),
        ),
        /*
        Expanded(
          child: Obx(() {
            final isLoading = CartController.to.isLoadingAddCart[productId] ?? false;

            return CustomButton(
              loadingColor: AppColors.kPrimaryColor,
              onTap: () {
                // Get the variant: selected one or default to first
                final selectedVariant = ProductController.to.getSelectedVariantForCart();

                if (selectedVariant == null) {
                  showCustomSnackbar(
                    title: "Warning",
                    message: "No variant available for this product!",
                  );
                  return;
                }

                CartController.to.addToCart(
                  variant: selectedVariant.id ?? '',
                  productId: productId,
                  quantity: ProductController.to.cartQuantity.value,
                );
              },
              isLoading: isLoading,
              title:
                  // ProductController.to.cartQuantity  if it's changed, then update text to " update cart"
                  AppStaticStrings.addToCard,
              fillColor: Colors.transparent,
              textColor: AppColors.kPrimaryColor,
            );
          }),
        )

    */

        Expanded(
          child: Obx(() {
            final isLoading =
                CartController.to.isLoadingAddCart[productId] ?? false;

            final isLoggedIn = CommonController.to.isLoggedIn.value;
            final label = isLoggedIn
                ? ProductController.to.cartButtonLabel.value
                : "Login to Buy";

            return CustomButton(
              loadingColor: AppColors.kPrimaryColor,
              isLoading: isLoading,
              onTap: () {
                final isLoggedIn = CommonController.to.isLoggedIn.value;

                if (!isLoggedIn) {
                  Get.toNamed(LoginPage.routeName);
                  return;
                }

                final selectedVariant =
                    ProductController.to.getSelectedVariantForCart();

                if (selectedVariant == null) {
                  showCustomSnackbar(
                    title: "Warning",
                    message: "No variant available for this product!",
                  );
                  return;
                }

                // 🔥 STOCK VALIDATION (important)
                final stock = selectedVariant.quantity ?? 0;
                final qty = ProductController.to.cartQuantity.value;

                if (qty > stock) {
                  showCustomSnackbar(
                    title: "Stock Limit",
                    message: "Only $stock item(s) available",
                  );
                  return;
                }

                CartController.to.addToCart(
                  variant: selectedVariant.id ?? '',
                  productId: productId,
                  quantity: qty,
                );
              },
              title: label, //
              fillColor: CommonController.to.isLoggedIn.value
                  ? Colors.transparent
                  : Colors.grey.shade200,
              textColor: CommonController.to.isLoggedIn.value
                  ? AppColors.kPrimaryColor
                  : Colors.grey,
            );
          }),
        )
      ],
    );
  }
}
