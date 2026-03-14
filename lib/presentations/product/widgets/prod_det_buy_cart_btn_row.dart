import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/components/custom_button.dart';
import '../../../core/constants/app_static_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/helper/helper_function.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/product_controller.dart';

class ProdDetBuyCartBtnRow extends StatelessWidget {
  final String productId;
  const ProdDetBuyCartBtnRow({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      children: [
        Expanded(
          child: CustomButton(
            onTap: () {
              buyProductDialog(
                context,
                selectedColor: ProductController.to.selectedColor.value,
                selectedSize: ProductController.to.selectedSize.value,
              );
            },
            title: AppStaticStrings.buyNow,
          ),
        ),
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
              title: AppStaticStrings.addToCard,
              fillColor: Colors.transparent,
              textColor: AppColors.kPrimaryColor,
            );
          }),
        )
      ],
    );
  }
}
