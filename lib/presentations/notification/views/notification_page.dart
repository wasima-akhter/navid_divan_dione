import 'package:flutter/material.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: padding12,
        child: Column(
          children: List.generate(
            7,
            (index) => Column(
              children: [
                Padding(
                  padding: padding6V,
                  child: Row(
                    children: [
                      ///------------------------dynamic title-------------------------///
                      Expanded(child: CustomText(text: 'New Collaboration Request Received')),
                      CustomText(
                        text: '05-12-2024',
                        style: poppinsLight,
                        fontSize: getFontSizeSmall(),
                      ),
                    ],
                  ),
                ),
                Divider()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
