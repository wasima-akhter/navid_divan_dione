import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_textfield.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';

import '../../../core/constants/app_static_strings.dart';
import '../../home/widgets/default_scaffold_structure_widget.dart';
import '../controllers/address_order_controller.dart';

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
          textEditingController: AddressOrderController.to.nameAddressController,
        ),
        CustomTextField(
          title: AppStaticStrings.contactNumberLabel,
          textEditingController: AddressOrderController.to.contactAddressController,
          keyboardType: TextInputType.number,
        ),
        CustomTextField(
          title: AppStaticStrings.deliveryAddress,
          textEditingController: AddressOrderController.to.deliveryAddressController,
        ),
        space12H,
        Obx(() {
          return CustomButton(
            isLoading: AddressOrderController.to.isLoadingAddShippingAddress.value,
            onTap: () {
              AddressOrderController.to.addShippingAddressRequest(
                  address: AddressOrderController.to.deliveryAddressController.text,
                  phone: AddressOrderController.to.contactAddressController.text,
                  name: AddressOrderController.to.nameAddressController.text);
            },
            title: AppStaticStrings.save,
          );
        })
      ],
    );
  }
}
