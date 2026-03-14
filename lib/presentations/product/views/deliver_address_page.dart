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
    return subtotal > 100 ? 0 : 10;
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
          if (ProductController.to.isLoadingShippingAddress.value) {
            return Padding(
              padding: padding12V,
              child: DefaultProgressIndicator(color: AppColors.kPrimaryColor),
            );
          }
          if (ProductController.to.shippingAddressList.isEmpty) {
            return Padding(
              padding: padding12V,
              child: CustomText(text: "Shipping Address not found!!"),
            );
          }
          return Column(
            children: List.generate(
              ProductController.to.shippingAddressList.length,
              (index) => _shippingAddressCard(
                ProductController.to.shippingAddressList[index],
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

        // ───── Subtotal ─────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: AppStaticStrings.subTotal,
              fontSize: getFontSizeSmall(),
              color: AppColors.kExtraLightGreyTextColor,
            ),
            Obx(() => CustomText(
                  text:
                      '\$${isFromCart ? CartController.to.subTotal.value : ((ProductController.to.getSelectedVariantForCart()?.price ?? 0) * ProductController.to.cartQuantity.value).toStringAsFixed(2)}',
                  fontSize: getFontSizeSmall(),
                  color: AppColors.kExtraLightGreyTextColor,
                )),
          ],
        ),

        // ───── Quantity (single product only) ─────
        if (!isFromCart)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: AppStaticStrings.quantity,
                fontSize: getFontSizeSmall(),
                color: AppColors.kExtraLightGreyTextColor,
              ),
              Obx(() => CustomText(
                    text: ProductController.to.cartQuantity.value.toString(),
                    fontSize: getFontSizeSmall(),
                    color: AppColors.kExtraLightGreyTextColor,
                  )),
            ],
          ),

        // ───── Delivery Fee ─────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: AppStaticStrings.deliveryFee,
              fontSize: getFontSizeSmall(),
              color: AppColors.kExtraLightGreyTextColor,
            ),
            Obx(() => CustomText(
                  text: shippingPrice == 0 ? 'Free' : '\$${shippingPrice.toStringAsFixed(2)}',
                  fontSize: getFontSizeSmall(),
                  color: AppColors.kExtraLightGreyTextColor,
                )),
          ],
        ),

        const Divider(),

        // ───── Total ─────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: AppStaticStrings.totalLabel,
              fontSize: getFontSizeDefault(),
              color: AppColors.kSplashBackgroundColor,
            ),
            Obx(() {
              final subtotal = double.tryParse(
                    isFromCart
                        ? CartController.to.subTotal.value
                        : ((ProductController.to.getSelectedVariantForCart()?.price ?? 0) *
                                ProductController.to.cartQuantity.value)
                            .toString(),
                  ) ??
                  0;
              final total = subtotal + shippingPrice;
              return CustomText(
                text: '\$${total.toStringAsFixed(2)}',
                fontSize: getFontSizeDefault(),
                color: AppColors.kSplashBackgroundColor,
              );
            }),
          ],
        ),

        space12H,

        // ───── Payment Button ─────
        Obx(() => CustomButton(
              isLoading: ProductController.to.isLoadingOrder.value ||
                  ProductController.to.isPaymentLoading.value,
              onTap: () {
                if (ProductController.to.selectedShippingAddress.value.isNotEmpty &&
                    CartController.to.cartList.isNotEmpty) {
                  final items = CartController.to.buildOrderItems();

                  final userId = ProductController.to.shippingAddressList
                          .firstWhereOrNull(
                              (e) => e.sId == ProductController.to.selectedShippingAddress.value)
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

                  ProductController.to.orderRequest(
                    userId: userId,
                    totalAmount: subtotal + shippingPrice,
                    deliveryAddress: ProductController.to.selectedShippingAddress.value,
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
              value:
                  ProductController.to.selectedShippingAddress.value == pickAddress.sId.toString(),
              onChanged: (_) {
                ProductController.to.selectedShippingAddress.value = pickAddress.sId.toString();
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
              onPressed: () => ProductController.to.deleteAddress(id: pickAddress.sId.toString()),
              icon: Icon(CupertinoIcons.delete, color: Colors.red),
            ),
          ],
        ));
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
