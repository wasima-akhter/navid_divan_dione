import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';

void showPopupMenu(BuildContext context, Offset offset) async {
  final result = await showMenu(
    context: context,

    position: RelativeRect.fromLTRB(
        offset.dx, offset.dy, offset.dx + 200, offset.dy + 300),
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
      text: colorName,
      style: poppinsMedium,
      fontSize: getFontSizeSemiSmall(),
    ),
  );
}

Future<dynamic> defaultAlertDialog(BuildContext context,
    {required Widget child, String? title, Color? backgroundColor}) {
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
            title != null ? Spacer() : SizedBox.shrink(),
            title != null
                ? CustomText(
                    text: title,
                    style: poppinsMedium.copyWith(fontSize: getFontSizeLarge()),
                  )
                : SizedBox.shrink(),
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

Future<String?> selectAndFormatTime({
  required BuildContext context,
  required TimeOfDay initialTime,
})
async {
  try {
    final ThemeData customTimePickerTheme = Theme.of(context).copyWith(
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor:
                  WidgetStatePropertyAll(AppColors.kPrimaryColor))),
      timePickerTheme: TimePickerThemeData(
        backgroundColor:
            AppColors.kWhiteColor, // Background color of the dialog
        hourMinuteShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        dayPeriodColor: AppColors.kPrimaryExtraLightColor,
        dialHandColor: AppColors.kPrimaryColor,
        hourMinuteTextColor: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? Colors.white // Text color when selected
                : AppColors.kPrimaryTextDarkColor),
        hourMinuteColor: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.kPrimaryColor // Background color when selected
                : AppColors.kPrimaryExtraLightColor),
        dialBackgroundColor:
            AppColors.kPrimaryExtraLightColor, // Dial's background color
        dialTextColor: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? Colors.white // Dial text color when selected
                : AppColors.kPrimaryTextDarkColor),
        entryModeIconColor:
            AppColors.kPrimaryColor, // Color of the entry mode icon
      ),
    );
    // Show time picker dialog
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: customTimePickerTheme,
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      // Format the selected time
      final now = DateTime.now();
      final formattedTime = DateFormat.jm()
          .format(
            DateTime(now.year, now.month, now.day, pickedTime.hour,
                pickedTime.minute),
          )
          .replaceAll('\u202F', ' ');
      return formattedTime; // Return the formatted time
    } else {
      return null; // No time selected
    }
  } catch (e) {
    debugPrint('Error picking time: $e');
    return null;
  }
}

Future<String> selectDate(
    BuildContext context,
    )
async {
  final DateTime? pickedDate = await showDatePicker(
    barrierDismissible: false,
    builder: (context, child) {
      return Theme(

        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.kPrimaryColor, // header background color
            onPrimary: AppColors.kPrimaryColor, // header text color
            onSurface: AppColors.kPrimaryColor, // body text color
          ),
          datePickerTheme: DatePickerThemeData(
            dayOverlayColor: const WidgetStatePropertyAll<Color>(AppColors.kPrimaryTextDarkColor),

            headerHelpStyle: TextStyle(
              color: AppColors.kPrimaryTextDarkColor,
              fontSize: 16.sp,
            ), yearOverlayColor: const WidgetStatePropertyAll<Color>(AppColors.kPrimaryTextDarkColor) ,
            headerForegroundColor: AppColors.kPrimaryTextDarkColor,
            rangePickerHeaderForegroundColor: AppColors.kPrimaryTextDarkColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.kPrimaryTextDarkColor;  // Change this color
              }
              return null; // Default background
            }),
            rangeSelectionBackgroundColor: AppColors.kPrimaryTextDarkColor,
            todayBackgroundColor: const WidgetStatePropertyAll<Color>(AppColors.kPrimaryTextDarkColor),
            yearForegroundColor:
            const WidgetStatePropertyAll<Color>(AppColors.kPrimaryTextDarkColor),
            dayForegroundColor:
            WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.kWhiteColor;   // Change this color
              }
              return AppColors.kPrimaryTextDarkColor; // Default background
            }),
            todayForegroundColor:
            const WidgetStatePropertyAll<Color>(AppColors.kWhiteColor),
            confirmButtonStyle: const ButtonStyle(
              foregroundColor:
              WidgetStatePropertyAll<Color>(AppColors.kPrimaryTextDarkColor),
            ),
            rangePickerHeaderHeadlineStyle:
            const TextStyle(color: AppColors.kPrimaryTextDarkColor),
            rangePickerSurfaceTintColor: AppColors.kPrimaryTextDarkColor,
            cancelButtonStyle: const ButtonStyle(
              foregroundColor:
              WidgetStatePropertyAll<Color>(AppColors.kPrimaryTextDarkColor),
            ),
            backgroundColor: AppColors.kWhiteColor,
            dividerColor: Colors.transparent,
            // todayBackgroundColor: const WidgetStatePropertyAll<Color>(AppColors.kPrimaryTextDarkColor),
            yearStyle: TextStyle(
              color: AppColors.kPrimaryTextDarkColor,
              fontSize: 16.sp,
            ),
            inputDecorationTheme: const InputDecorationTheme(
                fillColor: AppColors.kPrimaryTextDarkColor),
            weekdayStyle: TextStyle(
              color: AppColors.kPrimaryTextDarkColor, // Color for week names
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            // rangeSelectionBackgroundColor: AppColors.kPrimaryTextDarkColor,
            headerHeadlineStyle: TextStyle(
              color:
              AppColors.kPrimaryTextDarkColor, // Color for month/year in header
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          dropdownMenuTheme: DropdownMenuThemeData(
            textStyle: TextStyle(
              color: AppColors.kPrimaryTextDarkColor, // Dropdown text color
              fontSize: 16.sp,
            ),
          ),
        ),
        child: child!,
      );
    },
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    // Format the date
    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
    // Update the observable
    return formattedDate;
  }
  return ''; // Return null if no date is selected
}
