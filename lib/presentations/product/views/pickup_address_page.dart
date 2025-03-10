import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_button_tap.dart';
import 'package:navid_e_commerce/core/components/custom_textfield.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/helper/helper_function.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/presentations/product/controllers/product_controller.dart';
import 'package:navid_e_commerce/presentations/product/widgets/expand_able_text.dart';

class PickupAddressPage extends StatelessWidget {
  static const String routeName = '/pick-up';
  const PickupAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldStructureWidget(
        spacing: 12.h,
        appBarTitle: AppStaticStrings.pickUpAddress,
        children: [
          _buildSectionTitle(AppStaticStrings.pickUpFromLabel),
          _buildInfoText(AppStaticStrings.pickUpDummyAddress),
          _buildSectionTitle(AppStaticStrings.pickUpInfoLabel),
          _buildInputField(
              AppStaticStrings.nameLabel, AppStaticStrings.defaultName,
              isReadOnly: true),
          _buildInputField(AppStaticStrings.contactNumberLabel,
              AppStaticStrings.defaultContact,
              isReadOnly: true),
          Row(
            children: [
              Expanded(child:
                 ButtonTapWidget(
                  onTap: () async {
                    ProductController.to.dateController.value.text =
                        await selectDate(context);
                  },
                  child: _buildInputField(
                      AppStaticStrings.deliveryDateLabel,
                      isDatePicker: true,
                      AppStaticStrings.defaultDeliveryDate),
                )),
              SizedBox(width: 12.w),
              Expanded(child:  ButtonTapWidget(
                  onTap: () async {
                    ProductController.to.selectedTime.value =
                        await selectAndFormatTime(
                                context: context,
                                initialTime:
                                    const TimeOfDay(hour: 10, minute: 0)) ??
                            '';
                  },
                  child: _buildInputField(AppStaticStrings.deliveryTimeLabel,
                      AppStaticStrings.defaultDeliveryTime,
                      controller: TextEditingController(
                          text: ProductController.to.selectedTime.value),
                      isTimePicker: true),
                )),
            ],
          ),
          _buildSectionTitle(AppStaticStrings.productsInfoLabel),
          _buildInfoText(AppStaticStrings.pickUpDummyAddress),
          _buildProductItem(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: AppStaticStrings.totalLabel,
                fontSize: getFontSizeDefault(),
                color: AppColors.kSplashBackgroundColor,
              ),
              CustomText(
                text: AppStaticStrings.defaultTotal,
                fontSize: getFontSizeDefault(),
                color: AppColors.kSplashBackgroundColor,
              ),
            ],
          ),
          space12H,
          CustomButton(
            onTap: () {},
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

  Widget _buildInfoText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: CustomText(
        text: text,
        color: AppColors.kExtraLightGreyTextColor,
      ),
    );
  }

  Widget _buildInputField(String label, String value,
      {bool isReadOnly = false,
      TextEditingController? controller,
      bool isTimePicker = false,
      bool isDatePicker = false}) {
    return CustomTextField(
      title: label,
      hintText: value,
      textEditingController: controller,
      isEnable: isDatePicker || isDatePicker ? false : true,
      suffixIcon: isTimePicker
          ? Icon(
              Icons.arrow_drop_down,
              color: AppColors.kExtraLightGreyTextColor,
            )
          : isDatePicker
              ? Icon(
                  Icons.calendar_month,
                  color: AppColors.kExtraLightGreyTextColor,
                )
              : SizedBox.shrink(),
    );
  }

  Widget _buildProductItem() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "THC Gummy",
                fontSize: getFontSizeDefault(),
                color: AppColors.kPrimaryTextDarkColor,
              ),
              space4H,
              CustomText(
                text: "Price: \$120",
                fontSize: getFontSizeDefault(),
                color: AppColors.kPrimaryTextDarkColor,
              ),
              space4H,
              ExpandableText(text: dummyDesc),
            ],
          ),
        ),
        CustomText(text: "12 pcs", style: poppinsLight),
      ],
    );
  }
}
