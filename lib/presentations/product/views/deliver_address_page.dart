import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:navid_e_commerce/presentations/product/controllers/product_controller.dart';
import 'package:navid_e_commerce/presentations/product/model/pick_address_model.dart';
import 'package:navid_e_commerce/presentations/product/views/edit_address_page.dart';

import '../../cart/controllers/cart_controller.dart';
import '../controllers/address_order_controller.dart';

class DeliverAddressPage extends StatefulWidget {
  static const String routeName = '/deliver-add';

  const DeliverAddressPage({super.key});

  @override
  State<DeliverAddressPage> createState() => _DeliverAddressPageState();
}

class _DeliverAddressPageState extends State<DeliverAddressPage> {
  Map<String, dynamic>? arg;

  bool isFromCart = false;
  String? selectColor;
  String? selectSize;

  @override
  void initState() {
    super.initState();

    arg = Get.arguments as Map<String, dynamic>?;
    isFromCart = arg?["isFromCart"] ?? false;
    selectColor = arg?["color"];
    selectSize = arg?["size"];
  }

  // ✅ Compute shipping based on subTotal (float-safe)
  double get shippingPrice {
    final subtotal = double.tryParse(
          isFromCart
              ? CartController.to.subTotal.value
              : ((ProductController.to.getSelectedVariantForCart()?.price ?? 0) *
                      ProductController.to.cartQuantity.value)
                  .toString(),
        ) ??
        0;
    return subtotal > 100 ? 0 : 15;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldStructureWidget(
      spacing: 12.h,
      appBarTitle: AppStaticStrings.address,
      children: [
        // ───── Delivery Address Header ─────
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
                onTap: () => Get.toNamed(EditAddressPage.routeName),
                fillColor: AppColors.kPrimaryDarkColor,
                title: AppStaticStrings.editAddress,
                padding: padding6,
              ),
            ),
          ],
        ),

        // ───── Shipping Address List ─────
        Obx(() {
          if (AddressOrderController.to.isLoadingShippingAddress.value) {
            return Padding(
              padding: padding12V,
              child: DefaultProgressIndicator(color: AppColors.kPrimaryColor),
            );
          }
          if (AddressOrderController.to.shippingAddressList.isEmpty) {
            return Padding(
              padding: padding12V,
              child: CustomText(text: "Shipping Address not found!!"),
            );
          }
          return Column(
            children: List.generate(
              AddressOrderController.to.shippingAddressList.length,
              (index) => _shippingAddressCard(
                AddressOrderController.to.shippingAddressList[index],
              ),
            ),
          );
        }),

        // ───── Products Info ─────
        _buildSectionTitle(AppStaticStrings.productsInfoLabel),
        Obx(() => isFromCart
            ? Column(
                children: List.generate(
                  CartController.to.cartList.length,
                  (index) {
                    final cart = CartController.to.cartList[index];
                    return _buildProductItem(
                      name: cart.product?.name ?? '',
                      price: (cart.variant?.price ?? 0.0).toString(),
                      description: '',
                      size: cart.variant?.size ?? '',
                      quantity: (CartController.to.localQty[cart.product?.sId ?? ''] ??
                              cart.quantity ??
                              1)
                          .toString(),
                    );
                  },
                ),
              )
            : _buildProductItem(
                name: ProductController.to.productDetailsModel.value.name ?? '',
                price: ProductController.to.getSelectedVariantForCart()?.price.toString() ?? '0',
                description: ProductController.to.productDetailsModel.value.description ?? '',
                quantity: ProductController.to.cartQuantity.value.toString(),
                color: selectColor,
                size: selectSize,
              )),

// ───── Summary Section ─────
        Obx(() {
          final subtotal = isFromCart
              ? (double.tryParse(CartController.to.subTotal.value) ?? 0)
              : (ProductController.to.getSelectedVariantForCart()?.price ?? 0).toDouble() *
                  ProductController.to.cartQuantity.value;

          final tax = isFromCart
              ? (double.tryParse(CartController.to.salesTax.value) ?? 0)
              : subtotal * 0.06625;

          final shipping = isFromCart
              ? (double.tryParse(CartController.to.shippingCharge.value) ?? 0)
              : shippingPrice;

          final quantity = isFromCart
              ? (CartController.to.cartList.length)
              : ProductController.to.cartQuantity.value;

          final total = subtotal + tax + shipping;

          return Column(
            spacing: 6.h,
            children: [
              const Divider(),
              _summaryRow(AppStaticStrings.subTotal, '\$${subtotal.toStringAsFixed(2)}'),
              _summaryRow(
                '${AppStaticStrings.salesTax}\n${AppStaticStrings.includedTax}',
                '\$${tax.toStringAsFixed(2)}',
              ),
              _summaryRow(
                AppStaticStrings.shippingCharge,
                shipping == 0 ? 'Free' : '\$${shipping.toStringAsFixed(2)}',
              ),
              _summaryRow(
                AppStaticStrings.quantity,
                quantity.toString(),
              ),
              const Divider(),
              _summaryRow(
                AppStaticStrings.totalLabel,
                '\$${total.toStringAsFixed(2)}',
                isTotal: true,
              ),
            ],
          );
        }),

        space12H,

        // ───── Payment Button ─────
        Obx(() => CustomButton(
              isLoading: AddressOrderController.to.isLoadingOrder.value ||
                  AddressOrderController.to.isPaymentLoading.value,
              onTap: () {
                if (AddressOrderController.to.selectedShippingAddress.value.isNotEmpty &&
                    CartController.to.cartList.isNotEmpty) {
                  final items = CartController.to.buildOrderItems();

                  final userId = AddressOrderController.to.shippingAddressList
                          .firstWhereOrNull((e) =>
                              e.sId == AddressOrderController.to.selectedShippingAddress.value)
                          ?.user ??
                      '';

                  final subtotal = double.tryParse(
                        isFromCart
                            ? CartController.to.subTotal.value
                            : ((ProductController.to.getSelectedVariantForCart()?.price ?? 0) *
                                    ProductController.to.cartQuantity.value)
                                .toString(),
                      ) ??
                      0;

                  AddressOrderController.to.orderRequest(
                    userId: userId,
                    totalAmount: subtotal + shippingPrice,
                    deliveryAddress: AddressOrderController.to.selectedShippingAddress.value,
                    items: items,
                  );
                } else {
                  showCustomSnackbar(
                    title: 'Failed',
                    message: 'Provide valid Data',
                    type: SnackBarType.failed,
                  );
                }
              },
              title: AppStaticStrings.payment,
            )),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return CustomText(
      text: title,
      style: poppinsMedium,
      fontSize: getFontSizeDefault(),
    );
  }

  Widget _shippingAddressCard(PickAddressModel pickAddress) {
    return Obx(() => Row(
          children: [
            Checkbox(
              value: AddressOrderController.to.selectedShippingAddress.value ==
                  pickAddress.sId.toString(),
              onChanged: (_) {
                AddressOrderController.to.selectedShippingAddress.value =
                    pickAddress.sId.toString();
              },
            ),
            Expanded(
              child: CustomText(
                text:
                    'Name: ${pickAddress.name}\nContact No: ${pickAddress.phone}\n${pickAddress.address}',
                fontSize: getFontSizeSmall(),
                color: AppColors.kExtraLightGreyTextColor,
                style: poppinsRegular,
              ),
            ),
            IconButton(
              onPressed: () =>
                  AddressOrderController.to.deleteAddress(id: pickAddress.sId.toString()),
              icon: Icon(CupertinoIcons.delete, color: Colors.red),
            ),
          ],
        ));
  }

  Widget _summaryRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          fontSize: isTotal ? getFontSizeDefault() : getFontSizeSmall(),
          color: isTotal ? AppColors.kSplashBackgroundColor : AppColors.kExtraLightGreyTextColor,
          style: isTotal ? poppinsSemiBold : poppinsRegular,
        ),
        CustomText(
          text: value,
          fontSize: isTotal ? getFontSizeDefault() : getFontSizeSmall(),
          color: isTotal ? AppColors.kSplashBackgroundColor : AppColors.kExtraLightGreyTextColor,
          style: isTotal ? poppinsSemiBold : poppinsRegular,
        ),
      ],
    );
  }

  Widget _buildProductItem({
    required String name,
    required String price,
    required String description,
    required String quantity,
    String? color,
    String? size,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 22.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: name,
                  fontSize: getFontSizeDefault(),
                  color: AppColors.kPrimaryTextDarkColor,
                ),
                if (size != null && size.isNotEmpty)
                  Padding(
                    padding: padding4V,
                    child: CustomText(
                      text: 'Size: $size',
                      fontSize: getFontSizeDefault(),
                      color: AppColors.kPrimaryTextDarkColor,
                    ),
                  ),
                if (color != null && color.isNotEmpty)
                  Padding(
                    padding: padding4V,
                    child: CustomText(
                      text: 'Color: $color',
                      fontSize: getFontSizeDefault(),
                      color: AppColors.kPrimaryTextDarkColor,
                    ),
                  ),
                CustomText(
                  text: 'Price: \$$price',
                  fontSize: getFontSizeDefault(),
                  color: AppColors.kPrimaryTextDarkColor,
                ),
                if (description.isNotEmpty)
                  Padding(
                    padding: padding4V,
                    child: CustomText(
                      text: description,
                      fontSize: getFontSizeSmall(),
                      color: AppColors.kExtraLightGreyTextColor,
                    ),
                  ),
              ],
            ),
          ),
          CustomText(text: '$quantity pcs', style: poppinsLight),
        ],
      ),
    );
  }
}
