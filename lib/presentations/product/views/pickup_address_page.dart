import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_service.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/components/custom_textfield.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/cart/controllers/cart_controller.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
final arg = Get.arguments;

   bool isFromCart = false;
   String? selectColor;
   String? selectSize;
  @override
  void initState() {
isFromCart=arg["isFromCart"];
selectColor=arg["color"];
selectSize=arg["size"];
logger.d("img: $selectColor , size: $selectSize");
super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldStructureWidget(spacing: 12.h, appBarTitle: AppStaticStrings.pickUpAddress, children: [
      _buildSectionTitle(AppStaticStrings.pickUpFromLabel),
      Obx(() {
        return ProductController.to.isLoadingPickUpAddress.value
            ? DefaultProgressIndicator(
                color: AppColors.kPrimaryColor,
              )
            : ProductController.to.pickAddressList.isEmpty
                ? Padding(
                    padding: padding12V,
                    child: CustomText(text: "No pickup Address found!!"),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      ProductController.to.pickAddressList.length,
                      (index) => _buildInfoText(ProductController.to.pickAddressList[index]),
                    ),
                  );
      }),
      _buildSectionTitle(AppStaticStrings.pickUpInfoLabel),
      Obx(() {
        return CustomTextField(
          title: AppStaticStrings.nameLabel,
          textEditingController: ProductController.to.nameController.value,
        );
      }),
      Obx(() {
        return CustomTextField(
          title: AppStaticStrings.contactNumberLabel,
          textEditingController: ProductController.to.phoneController.value,
        );
      }),
      _buildSectionTitle(AppStaticStrings.productsInfoLabel),
      Obx(() {
        return isFromCart
            ? Column(
                children: List.generate(
                  CartController.to.cartList.length,
                  (index) {
                    final cart = CartController.to.cartList[index];
                    return _buildProductItem(
                        name: cart.productId!.name.toString(), price: cart.price.toString(), description: "",size: cart.size, quantity: cart.quantity.toString());
                  },
                ),
              )
            : _buildProductItem(
                name: ProductController.to.productModel.value.name.toString(),
                price: ProductController.to.productModel.value.price.toString(),
                description: ProductController.to.productModel.value.description.toString(),
                quantity: ProductController.to.cartQuantity.value.toString()
            ,color: selectColor, size: selectSize);
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
                "\$${isFromCart ? CartController.to.totalPrice.value.toString() : (ProductController.to.productModel.value.price!.toInt() * ProductController.to.cartQuantity.value)}",
            fontSize: getFontSizeDefault(),
            color: AppColors.kSplashBackgroundColor,
          ),
        ],
      ),
      space12H,
      Obx(() {
        return CustomButton(
          isLoading: ProductController.to.isLoadingOrder.value || ProductController.to.isPaymentLoading.value,
          onTap: isFromCart
              ? () {
                  if (ProductController.to.selectedPickAddress.isNotEmpty && CartController.to.cartList.isNotEmpty) {
                    ProductController.to.orderRequest(
                        totalAmount: CartController.to.totalPrice.value.toString(),
                        pickupAddress: ProductController.to.selectedPickAddress.value,
                        item: List.generate(
                          CartController.to.cartList.length,
                          (index) {
                            final cart = CartController.to.cartList[index];
                            return {"product": cart.productId!.sId, "quantity": cart.quantity, "color": cart.variant,"size": cart.size};
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
                  if (ProductController.to.selectedPickAddress.isNotEmpty &&
                      ProductController.to.productModel.value.price != null &&
                      ProductController.to.productModel.value.id != null
                      && ProductController.to.currentBannerImages.isNotEmpty
                   ) {
                    ProductController.to.orderRequest(
                        totalAmount: ProductController.to.productModel.value.price.toString(),
                        item: [
                          {
                            "product": ProductController.to.productModel.value.id,
                            "quantity": ProductController.to.cartQuantity.value,
                            "color": ProductController.to.currentBannerImages[0]
                          ,"size": ProductController.to.selectedSize.value
                          }
                        ],
                        productList: [
                          {
                            "name": ProductController.to.productModel.value.name,
                            "unit_amount": ProductController.to.productModel.value.price,
                            "quantity": ProductController.to.cartQuantity.value,

                          }
                        ],
                        pickupAddress: ProductController.to.selectedPickAddress.value);
                  } else {
                    showCustomSnackbar(title: "Failed", message: "Provide valid Data", type: SnackBarType.failed);
                  }
                },
          title: AppStaticStrings.payment,
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
          value: ProductController.to.selectedPickAddress.value == pickAddressModel.sId.toString() ? true : false,
          onChanged: (value) {
            ProductController.to.selectedPickAddress.value = pickAddressModel.sId ?? "";
            ProductController.to.fetchPickUpAddress();
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
    return Row(
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

           if(size!=null)  Padding(
             padding: padding4V,
             child: CustomText(
                  text: "Size: $size",
                  fontSize: getFontSizeDefault(),
                  color: AppColors.kPrimaryTextDarkColor,
                ),
           ),
              if(color!=null) Padding(
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

              if(description.isNotEmpty) Padding(
                padding: padding4V,
                child: ExpandableText(text: description),
              ),
            ],
          ),
        ),
        CustomText(text: "$quantity pis", style: poppinsLight),
      ],
    );
  }
}
