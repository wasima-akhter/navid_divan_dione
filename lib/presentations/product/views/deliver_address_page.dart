import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/helper/helper_function.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/presentations/product/controllers/product_controller.dart';
import 'package:navid_e_commerce/presentations/product/model/pick_address_model.dart';
import 'package:navid_e_commerce/presentations/product/views/edit_address_page.dart';

import '../../cart/controllers/cart_controller.dart';

class DeliverAddressPage extends StatelessWidget {
  static const String routeName = '/deliver-add';

  DeliverAddressPage({super.key});

  final bool isFromCart = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldStructureWidget(spacing: 6.h, appBarTitle: AppStaticStrings.address, children: [
      Row(
        children: [
          Expanded(
            child: CustomText(
              text: AppStaticStrings.deliveryAddress,
              fontSize: getFontSizeDefault(),
            ),
          ),
          Flexible(
            child: CustomButton(
              onTap: () {
                Get.toNamed(EditAddressPage.routeName);
              },
              fillColor: AppColors.kPrimaryDarkColor,
              title: AppStaticStrings.editAddress,
              padding: padding6,
            ),
          )
        ],
      ),
      Obx(() {
        return ProductController.to.isLoadingShippingAddress.value
            ? Padding(
          padding: padding12V,
          child: DefaultProgressIndicator(
            color: AppColors.kPrimaryColor,
          ),
        )
            : ProductController.to.shippingAddressList.isEmpty
            ? Padding(
          padding: padding12V,
          child: CustomText(text: "Shipping Address not found!!"),
        )
            : Column(
          children: List.generate(
            ProductController.to.shippingAddressList.length,
                (index) => shippingAddressCard(ProductController.to.shippingAddressList[index]),
          ),
        );
      }),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: AppStaticStrings.subTotal,
            fontSize: getFontSizeSmall(),
            color: AppColors.kExtraLightGreyTextColor,
          ),
          Obx(() {
            return CustomText(
              text: '\$${(isFromCart ? CartController.to.totalPrice.value : ProductController.to.productModel.value.price!).toString()}',
              fontSize: getFontSizeSmall(),
              color: AppColors.kExtraLightGreyTextColor,
            );
          }),
        ],
      ), isFromCart ? SizedBox.shrink() : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: AppStaticStrings.quantity,
            fontSize: getFontSizeSmall(),
            color: AppColors.kExtraLightGreyTextColor,
          ),
          Obx(() {
            return CustomText(
              text: (ProductController.to.cartQuantity.value).toString(),
              fontSize: getFontSizeSmall(),
              color: AppColors.kExtraLightGreyTextColor,
            );
          }),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: AppStaticStrings.deliveryFee,
            fontSize: getFontSizeSmall(),
            color: AppColors.kExtraLightGreyTextColor,
          ),
          CustomText(
            text: '\$71',
            fontSize: getFontSizeSmall(),
            color: AppColors.kExtraLightGreyTextColor,
          ),
        ],
      ),
      Divider(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: AppStaticStrings.totalLabel,
            fontSize: getFontSizeDefault(),
            color: AppColors.kSplashBackgroundColor,
          ),
          Obx(() {
            return CustomText(
              text:
              "\$${(int.parse(isFromCart ? CartController.to.totalPrice.value.toString() : (ProductController.to.productModel.value.price!.toInt() *
                  ProductController.to.cartQuantity.value).toString()) + 71).toString()}",
              fontSize: getFontSizeDefault(),
              color: AppColors.kSplashBackgroundColor,
            );
          }),
        ],
      ),
      space12H,
      Obx(() {
        return CustomButton(
          isLoading: ProductController.to.isLoadingOrder.value||ProductController.to.isPaymentLoading.value,
          onTap: isFromCart
              ? () {
            if (ProductController.to.selectedShippingAddress.isNotEmpty && CartController.to.cartList.isNotEmpty) {
              ProductController.to.orderRequest(
                  totalAmount: (int.parse(CartController.to.totalPrice.value.toString()) + 71).toString(),
                  deliveryAddress: ProductController.to.selectedShippingAddress.value,
                  item: List.generate(
                    CartController.to.cartList.length,
                        (index) {
                      final cart = CartController.to.cartList[index];
                      return {"product": cart.productId!.sId, "quantity": cart.quantity, "color": cart.variant};
                    },
                  ),
                  productList: List.generate(
                    CartController.to.cartList.length,
                        (index) {
                      final cart = CartController.to.cartList[index];
                      return {
                        "name": cart.productId!.name,
                        "unit_amount": cart.productId!.price,
                        "quantity": cart.quantity,
                          
                      };
                    },
                  ));
            } else {
              showCustomSnackbar(title: "Failed", message: "Provide valid Data", type: SnackBarType.failed);
            }
          }
              : () {
            ProductController.to.orderRequest(
                totalAmount: (ProductController.to.productModel.value.price!.toInt() + 71).toString(),
                item: [
                  {
                    "product": ProductController.to.productModel.value.id,
                    "quantity": ProductController.to.cartQuantity.value,
                    "color": ProductController.to.currentBannerImages[0]
                  }
                ],
                productList: [{
                  "name": ProductController.to.productModel.value.name,
                  "unit_amount": ProductController.to.productModel.value.price,
                  "quantity": ProductController.to.cartQuantity.value,
                    
                }
                ],
                deliveryAddress: ProductController.to.selectedShippingAddress.value);

            // ProductController.to.orderRequest(totalAmount: CartController.to.totalPrice.value, item: [
            //
            // ],address: )
          },
          title: AppStaticStrings.payment,
        );
      })
    ]);
  }

  Row shippingAddressCard(PickAddressModel pickAddress) {
    return Row(
      children: [
        Checkbox(
          value: ProductController.to.selectedShippingAddress.value == pickAddress.sId.toString() ? true : false,
          onChanged: (value) {
            ProductController.to.selectedShippingAddress.value = pickAddress.sId.toString();
          },
        ),
        Expanded(
          child: CustomText(
            text: 'Name: ${pickAddress.name}\nCnontuct No:${pickAddress.phone}\n${pickAddress.address}',
            fontSize: getFontSizeSmall(),
            color: AppColors.kExtraLightGreyTextColor,
            style: poppinsRegular,
          ),
        ),
        IconButton(
            onPressed: () {
              ProductController.to.deleteAddress(id: pickAddress.sId.toString());
            },
            icon: Icon(
              CupertinoIcons.delete,
              color: Colors.red,
            ))
      ],
    );
  }
}
