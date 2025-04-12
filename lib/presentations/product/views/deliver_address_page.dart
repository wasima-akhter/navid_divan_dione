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
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/presentations/product/controllers/product_controller.dart';
import 'package:navid_e_commerce/presentations/product/model/pick_address_model.dart';
import 'package:navid_e_commerce/presentations/product/views/edit_address_page.dart';

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
                child: DefaultProgressIndicator(),
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
      // Row(
      //   children: [
      //     Expanded(
      //         child: ButtonTapWidget(
      //             onTap: () async {
      //               ProductController.to.dateController.value.text = await selectDate(context);
      //             },
      //             child: CustomTextField(
      //               title: AppStaticStrings.deliveryDateLabel,
      //               hintText: AppStaticStrings.defaultDeliveryDate,
      //               // textEditingController: controller,
      //               isEnable: false,
      //               suffixIcon: Icon(
      //                 Icons.calendar_month,
      //                 color: AppColors.kExtraLightGreyTextColor,
      //               ),
      //             ))),
      //     SizedBox(width: 12.w),
      //     Expanded(
      //         child: ButtonTapWidget(
      //             onTap: () async {
      //               ProductController.to.selectedTime.value =
      //                   await selectAndFormatTime(context: context, initialTime: const TimeOfDay(hour: 10, minute: 0)) ?? '';
      //             },
      //             child: CustomTextField(
      //               title: AppStaticStrings.deliveryTimeLabel,
      //               hintText: AppStaticStrings.defaultDeliveryTime,
      //               textEditingController: TextEditingController(text: ProductController.to.selectedTime.value),
      //               isEnable: false,
      //               suffixIcon: Icon(
      //                 Icons.arrow_drop_down,
      //                 color: AppColors.kExtraLightGreyTextColor,
      //               ),
      //             ))),
      //   ],
      // ),
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
              text: '\$${(ProductController.to.productModel.value.price!).toString()}',
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
              text: "\$${(ProductController.to.productModel.value.price!.toInt() + 71).toString()}",
              fontSize: getFontSizeDefault(),
              color: AppColors.kSplashBackgroundColor,
            );
          }),
        ],
      ),
      space12H,
      CustomButton(
        onTap: isFromCart
            ? () {

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
                    deliveryAddress: ProductController.to.selectedShippingAddress.value);

                // ProductController.to.orderRequest(totalAmount: CartController.to.totalPrice.value, item: [
                //
                // ],address: )
              },
        title: AppStaticStrings.payment,
      )
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
        CustomText(
          text: 'Name: ${pickAddress.name}\nCnontuct No:${pickAddress.phone}\n${pickAddress.address}',
          fontSize: getFontSizeSmall(),
          color: AppColors.kExtraLightGreyTextColor,
          style: poppinsRegular,
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
