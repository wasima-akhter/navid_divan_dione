import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_textfield.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/cart/controllers/cart_controller.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';
import 'package:navid_e_commerce/presentations/product/controllers/address_order_controller.dart';
import 'package:navid_e_commerce/presentations/product/controllers/product_controller.dart';
import 'package:navid_e_commerce/presentations/product/model/pick_address_model.dart';
import 'package:navid_e_commerce/presentations/product/widgets/expand_able_text.dart';

import '../../../core/helper/helper_function.dart';

class PickupAddressPage extends StatefulWidget {
  static const String routeName = '/pick-up';

  const PickupAddressPage({super.key});

  @override
  State<PickupAddressPage> createState() => _PickupAddressPageState();
}

class _PickupAddressPageState extends State<PickupAddressPage> {
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

    // logger.d("img: $selectColor , size: $selectSize");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldStructureWidget(
        spacing: 12.h,
        appBarTitle: AppStaticStrings.pickUpAddress,
        children: [
          _buildSectionTitle(AppStaticStrings.pickUpFromLabel),
          Obx(() {
            return AddressOrderController.to.isLoadingPickUpAddress.value
                ? DefaultProgressIndicator(
                    color: AppColors.kPrimaryColor,
                  )
                : AddressOrderController.to.pickAddressList.isEmpty
                    ? Padding(
                        padding: padding12V,
                        child: CustomText(text: "No pickup Address found!!"),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          AddressOrderController.to.pickAddressList.length,
                          (index) =>
                              _buildInfoText(AddressOrderController.to.pickAddressList[index]),
                        ),
                      );
          }),
          _buildSectionTitle(AppStaticStrings.pickUpInfoLabel),
          CustomTextField(
            title: AppStaticStrings.nameLabel,
            textEditingController: AddressOrderController.to.nameController,
          ),

          CustomTextField(
            title: AppStaticStrings.contactNumberLabel,
            textEditingController: AddressOrderController.to.phoneController,
          ),
          _buildSectionTitle(AppStaticStrings.productsInfoLabel),

          // info of product
          Obx(() {
            return isFromCart
                ? Column(children: [
                    ...List.generate(
                      CartController.to.cartList.length,
                      (index) {
                        final cart = CartController.to.cartList[index];
                        return _buildProductItem(
                            name: cart.product!.name.toString(),
                            price: (cart.variant?.price ?? 0.0).toString(),
                            description: "",
                            size: cart.variant?.size ?? '',
                            quantity: cart.quantity.toString());
                      },
                    ),
                  ])
                : _buildProductItem(
                    name: ProductController.to.productDetailsModel.value.name.toString(),
                    price:
                        ProductController.to.getSelectedVariantForCart()?.price.toString() ?? "0",
                    description:
                        ProductController.to.productDetailsModel.value.description.toString(),
                    quantity: ProductController.to.cartQuantity.value.toString(),
                    color: selectColor,
                    size: selectSize);
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: AppStaticStrings.totalLabel,
                fontSize: getFontSizeDefault(),
                color: AppColors.kSplashBackgroundColor,
              ),
              CustomText(
                text:
                    "\$${isFromCart ? CartController.to.totalPrice.value.toString() : (ProductController.to.getSelectedVariantForCart()?.price ?? 0) * ProductController.to.cartQuantity.value}",
                fontSize: getFontSizeDefault(),
                color: AppColors.kSplashBackgroundColor,
              ),
            ],
          ),
          space12H,
          Obx(() {
            return CustomButton(
              isLoading: AddressOrderController.to.isLoadingOrder.value ||
                  AddressOrderController.to.isPaymentLoading.value,
              onTap: () {
                if (AddressOrderController.to.selectedPickAddress.isNotEmpty &&
                    CartController.to.cartList.isNotEmpty) {
                  final items = CartController.to.buildOrderItems();

                  final userId = AddressOrderController.to.pickAddressList
                          .firstWhere(
                              (e) => e.sId == AddressOrderController.to.selectedPickAddress.value)
                          .user ??
                      "";

                  AddressOrderController.to.orderRequest(
                    userId: userId,
                    totalAmount: double.parse(CartController.to.totalPrice.value),
                    pickupAddress: AddressOrderController.to.selectedPickAddress.value,
                    items: items,
                  );
                } else {
                  showCustomSnackbar(
                    title: "Failed",
                    message: "Provide valid Data",
                    type: SnackBarType.failed,
                  );
                }
              },
              title: AppStaticStrings.confirmOrderAndPayment,
            );
          })
        ]);
  }

  Widget _buildSectionTitle(String title) {
    return CustomText(
      text: title,
      style: poppinsMedium,
      fontSize: getFontSizeDefault(),
    );
  }

  Widget _buildInfoText(PickAddressModel pickAddressModel) {
    return Row(
      children: [
        Checkbox(
          value:
              AddressOrderController.to.selectedPickAddress.value == pickAddressModel.sId.toString()
                  ? true
                  : false,
          onChanged: (value) {
            AddressOrderController.to.selectedPickAddress.value = pickAddressModel.sId ?? "";
            AddressOrderController.to.fetchPickUpAddress();
          },
        ),
        CustomText(
          text: pickAddressModel.address ?? "",
          color: AppColors.kExtraLightGreyTextColor,
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
      margin: EdgeInsets.only(
        bottom: 22.h,
      ),
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
                if (size != null)
                  Padding(
                    padding: padding4V,
                    child: CustomText(
                      text: "Size: $size",
                      fontSize: getFontSizeDefault(),
                      color: AppColors.kPrimaryTextDarkColor,
                    ),
                  ),
                if (color != null)
                  Padding(
                    padding: padding4V,
                    child: CustomText(
                      text: "Color: $color",
                      fontSize: getFontSizeDefault(),
                      color: AppColors.kPrimaryTextDarkColor,
                    ),
                  ),
                CustomText(
                  text: "Price: \$$price",
                  fontSize: getFontSizeDefault(),
                  color: AppColors.kPrimaryTextDarkColor,
                ),
                if (description.isNotEmpty)
                  Padding(
                    padding: padding4V,
                    child: ExpandableText(text: description),
                  ),
              ],
            ),
          ),
          CustomText(text: "$quantity pis", style: poppinsLight),
        ],
      ),
    );
  }
}
