import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
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
Future<dynamic> defaultAlertDialog(BuildContext context, {required Widget child , String? title,Color? backgroundColor}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            title!=null?Spacer():SizedBox.shrink(),
            title!=null?CustomText(text: title,style: poppinsMedium.copyWith(
                fontSize: getFontSizeLarge()),
            ):SizedBox.shrink(),
            Spacer(),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  CupertinoIcons.multiply,
                  color: AppColors.kPrimaryDarkColor,
                ))
          ],
        ),
        content: Padding(
          padding: padding12H,
          child: child,
        ),
      );
    },
  );
}
Future<void> pickImages({
  bool allowMultiple = false,
  RxList<String>? uploadImages,
  RxString? singleImagePath,
}) async {
  try {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.image, // Restrict to image files
        allowMultiple: allowMultiple,
        allowCompression: true,
        compressionQuality: 50 // Allow multiple selection
    );

    if (result != null) {
      final selectedPaths = result.paths.whereType<String>().toList();

      if (allowMultiple && uploadImages != null) {
        if (uploadImages.length + selectedPaths.length <= 5) {
          uploadImages.addAll(selectedPaths); // Add selected images to the list
        } else {
          // showCustomSnackbar(
          //   title: "Limit Reached",
          //   message: "You can only add up to 5 images.",
          //   type: SnackBarType.alert,
          // );
        }
      } else if (!allowMultiple && singleImagePath != null) {
        singleImagePath.value = result.files.single.path ?? '';
      } else {
        debugPrint("No files selected or improper usage of the method.");
      }
    } else {
      debugPrint("No files selected.");
    }
  } catch (e) {
    debugPrint("File picker error: $e");
  }
}