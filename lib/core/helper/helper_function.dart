import 'package:flutter/material.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
void showPopupMenu(BuildContext context, Offset offset) async {
  final result = await showMenu(
    context: context,

    position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx + 200, offset.dy + 300),
    items: items, // Pass the list here
    elevation: 8.0,
    color: AppColors.kPrimaryLightColor, // Popup background color
  );

  // if (result != null) {
  //   setState(() {
  //     selectedItem = result;
  //   });
  // }
}

List<PopupMenuEntry<dynamic>> items = [

  PopupMenuItem(
    value: "Red",
    child: Text("Red"),
  ),
  PopupMenuItem(
    value: "Yellow",
    child: Text("Yellow"),
  ),
  PopupMenuItem(
    value: "Green",
    child: Text("Green"),
  ),
  PopupMenuItem(
    value: "Blue",
    child: Text("Blue"),
  ),
];


PopupMenuItem<String> _buildPopupMenuItem(String colorName) {
  return PopupMenuItem(
    value: colorName,
    child: CustomText(
     text:  colorName,
      style:poppinsMedium,
      fontSize: getFontSizeSemiSmall(),
    ),
  );
}