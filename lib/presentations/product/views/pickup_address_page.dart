import 'package:flutter/material.dart';
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
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/presentations/product/controllers/product_controller.dart';
import 'package:navid_e_commerce/presentations/product/model/pick_address_model.dart';
import 'package:navid_e_commerce/presentations/product/model/product_model.dart';
import 'package:navid_e_commerce/presentations/product/widgets/expand_able_text.dart';

class PickupAddressPage extends StatelessWidget {
  static const String routeName = '/pick-up';

   PickupAddressPage({super.key});
  final bool isFromCart = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldStructureWidget(spacing: 12.h, appBarTitle: AppStaticStrings.pickUpAddress, children: [
      _buildSectionTitle(AppStaticStrings.pickUpFromLabel),
      Obx(() {
        return ProductController.to.isLoadingPickUpAddress.value
            ? DefaultProgressIndicator()
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
      // Row(
      //   children: [
      //     Expanded(child:
      //        ButtonTapWidget(
      //         onTap: () async {
      //           ProductController.to.dateController.value.text =
      //               await selectDate(context);
      //         },
      //         child: _buildInputField(
      //             AppStaticStrings.deliveryDateLabel,
      //             isDatePicker: true,
      //             AppStaticStrings.defaultDeliveryDate),
      //       )),
      //     SizedBox(width: 12.w),
      //     Expanded(child:  ButtonTapWidget(
      //         onTap: () async {
      //           ProductController.to.selectedTime.value =
      //               await selectAndFormatTime(
      //                       context: context,
      //                       initialTime:
      //                           const TimeOfDay(hour: 10, minute: 0)) ??
      //                   '';
      //         },
      //         child: _buildInputField(AppStaticStrings.deliveryTimeLabel,
      //             AppStaticStrings.defaultDeliveryTime,
      //             controller: TextEditingController(
      //                 text: ProductController.to.selectedTime.value),
      //             isTimePicker: true),
      //       )),
      //   ],
      // ),
      _buildSectionTitle(AppStaticStrings.productsInfoLabel),

      Obx(() {
        return _buildProductItem(ProductController.to.productModel.value);
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
            text: "\$${ProductController.to.productModel.value.price}",
            fontSize: getFontSizeDefault(),
            color: AppColors.kSplashBackgroundColor,
          ),
        ],
      ),
      space12H,
      CustomButton(
        onTap: isFromCart
            ? () {

        }
            : () {
                ProductController.to.orderRequest(
                    totalAmount: ProductController.to.productModel.value.price.toString(),
                    item: [
                      {
                        "product": ProductController.to.productModel.value.id,
                        "quantity": ProductController.to.cartQuantity.value,
                        "color": ProductController.to.currentBannerImages[0]
                      }
                    ],
                    pickupAddress: ProductController.to.selectedPickAddress.value);
              },
        title: AppStaticStrings.payment,
      )
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

  Widget _buildProductItem(ProductModel product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: product.name.toString(),
                fontSize: getFontSizeDefault(),
                color: AppColors.kPrimaryTextDarkColor,
              ),
              space4H,
              CustomText(
                text: "Price: \$${product.price}",
                fontSize: getFontSizeDefault(),
                color: AppColors.kPrimaryTextDarkColor,
              ),
              space4H,
              ExpandableText(text: product.description.toString()),
            ],
          ),
        ),
        CustomText(text: "${product.quantity} pis", style: poppinsLight),
      ],
    );
  }
}
