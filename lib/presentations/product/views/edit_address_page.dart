import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_textfield.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/presentations/product/controllers/product_controller.dart';

import '../../../core/constants/app_static_strings.dart';
import '../../home/widgets/default_scaffold_structure_widget.dart';

class EditAddressPage extends StatelessWidget {
  static const String routeName = "/edit-address";

  const EditAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldStructureWidget(
      spacing: 6.h,
      appBarTitle: AppStaticStrings.address,
      children: [
        CustomTextField(
          title: AppStaticStrings.name,
          textEditingController: ProductController.to.nameAddressController,
        ),
        CustomTextField(
          title: AppStaticStrings.contactNumberLabel,
          textEditingController: ProductController.to.contactAddressController,
          keyboardType: TextInputType.number,
        ),
        CustomTextField(
          title: AppStaticStrings.deliveryAddress,
          textEditingController: ProductController.to.deliveryAddressController,
        ),
        space12H,
        Obx(() {
          return CustomButton(
            isLoading: ProductController.to.isLoadingAddShippingAddress.value,
            onTap: () {
              ProductController.to.addShippingAddressRequest(
                  address: ProductController.to.deliveryAddressController.text,
                  phone: ProductController.to.contactAddressController.text,
                  name: ProductController.to.nameAddressController.text);
            },
            title: AppStaticStrings.save,
          );
        })
      ],
    );
  }
}
