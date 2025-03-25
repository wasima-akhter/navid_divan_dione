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
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/helper/helper_function.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/presentations/product/controllers/product_controller.dart';
import 'package:navid_e_commerce/presentations/product/widgets/expand_able_text.dart';

class DeliverAddressPage extends StatelessWidget {
  static const String routeName = '/deliver-add';
  const DeliverAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldStructureWidget(
        spacing: 6.h,
        appBarTitle: AppStaticStrings.address,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomText(
                  text: AppStaticStrings.deliveryAddress,
                  fontSize: getFontSizeDefault(),
                ),
              ),

              Flexible(
                child: CustomButton(onTap: () {

                },fillColor: AppColors.kPrimaryDarkColor,title: AppStaticStrings.editAddress,padding: padding6,),
              )
            ],
          ),
          CustomText(
            text:
                'Name: User Name\nCnontuct No:+9900000000\n13th Street. 47 W 13th St, New York, NY 10011',
            fontSize: getFontSizeSmall(),
            color: AppColors.kExtraLightGreyTextColor,
            style: poppinsRegular,
          ),
          Row(
            children: [
              Expanded(
                  child: ButtonTapWidget(
                      onTap: () async {
                        ProductController.to.dateController.value.text =
                            await selectDate(context);
                      },
                      child: CustomTextField(
                        title: AppStaticStrings.deliveryDateLabel,
                        hintText: AppStaticStrings.defaultDeliveryDate,
                        // textEditingController: controller,
                        isEnable: false,
                        suffixIcon: Icon(
                          Icons.calendar_month,
                          color: AppColors.kExtraLightGreyTextColor,
                        ),
                      ))),
              SizedBox(width: 12.w),
              Expanded(
                  child: ButtonTapWidget(
                      onTap: () async {
                        ProductController.to.selectedTime.value =
                            await selectAndFormatTime(
                                    context: context,
                                    initialTime:
                                        const TimeOfDay(hour: 10, minute: 0)) ??
                                '';
                      },
                      child: CustomTextField(
                        title: AppStaticStrings.deliveryTimeLabel,
                        hintText: AppStaticStrings.defaultDeliveryTime,
                        textEditingController: TextEditingController(
                            text: ProductController.to.selectedTime.value),
                        isEnable: false,
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.kExtraLightGreyTextColor,
                        ),
                      ))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: AppStaticStrings.subTotal,
                fontSize: getFontSizeSmall(),
                color: AppColors.kExtraLightGreyTextColor,

              ),
              CustomText(
                text: '\$715.00',
                fontSize: getFontSizeSmall(),
                color: AppColors.kExtraLightGreyTextColor,

              ),
            ],
          ),Row(
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
}
