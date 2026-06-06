import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';

import '../../presentations/product/views/deliver_address_page.dart';
import '../../presentations/product/views/pickup_address_page.dart';

Color hexToColor(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex';
  }
  return Color(int.parse(hex, radix: 16));
}

void showPopupMenu(BuildContext context, Offset offset) async {
  // if (result != null) {
  //   setState(() {
  //     selectedItem = result;
  //   });
  // }
}
Future<dynamic> buyProductDialog(BuildContext context,
    {bool isFromCart = false, String? selectedColor, String? selectedSize}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        spacing: 6.h,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            onTap: () {
              Get.toNamed(PickupAddressPage.routeName, arguments: {
                "isFromCart": isFromCart,
                "color": selectedColor,
                "size": selectedSize
              });
            },
            title: AppStaticStrings.pickUp,
          ),
          CustomText(text: 'or'),
          CustomButton(
            onTap: () {
              Get.toNamed(DeliverAddressPage.routeName, arguments: {
                "isFromCart": isFromCart,
                "color": selectedColor,
                "size": selectedSize
              });
            },
            fillColor: AppColors.kPrimaryDarkColor,
            borderColor: AppColors.kPrimaryDarkColor,
            title: AppStaticStrings.deliveryAddress,
          )
        ],
      ),
    ),
  );
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
            title != null
                ? Expanded(
                    child: Padding(
                      padding: padding12H,
                      child: CustomText(
                        text: title,
                        style: poppinsMedium.copyWith(
                            fontSize: getFontSizeLarge()),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
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

void removeImage(
    {required RxList<String> uploadImages, required String imagePath}) {
  if (uploadImages.contains(imagePath)) {
    uploadImages.remove(imagePath);
  } else {
    debugPrint("Image not found in the list.");
  }
}

Future<void> pickImages(
    {bool allowMultiple = false,
    RxList<String>? uploadImages,
    RxString? singleImagePath,
    FileType fileType = FileType.image}) async {
  try {
    final result = await FilePicker.platform.pickFiles(
        type: fileType, // Restrict to image files
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
}) async {
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

enum SnackBarType { success, failed, alert }

void showCustomSnackbar({
  required String title,
  required String message,
  bool noInternet = false,
  Function()? retryTap,
  SnackBarType type = SnackBarType.success,
  SnackPosition position = SnackPosition.TOP,
}) {
  Color backgroundColor = AppColors.kWhiteColor.withValues(alpha: .5);
  Color textColor = AppColors.kTextDarkColor;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = AppColors.kWhiteColor.withValues(alpha: .5);

      break;
    case SnackBarType.failed:
      backgroundColor = Color(0xff8a0600);
      textColor = AppColors.kWhiteColor;

      break;
    // TODO: Handle this case.
    case SnackBarType.alert:
      backgroundColor = Color(0xffc86900);
      textColor = AppColors.kWhiteColor;
      break;
    // TODO: Handle this case.
  }
  Get.snackbar(title, message,
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(12),
      colorText: textColor,
      dismissDirection: DismissDirection.horizontal,
      snackPosition: position,
      duration: const Duration(seconds: 3),
      mainButton: noInternet == true
          ? TextButton(
              onPressed: retryTap ?? () {},
              child: CustomText(
                text: 'Retry',
                color: AppColors.kWhiteColor,
              ))
          : null);
}

Future<String> selectDate(
  BuildContext context,
) async {
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
            dayOverlayColor: const WidgetStatePropertyAll<Color>(
                AppColors.kPrimaryTextDarkColor),

            headerHelpStyle: TextStyle(
              color: AppColors.kPrimaryTextDarkColor,
              fontSize: 16.sp,
            ),
            yearOverlayColor: const WidgetStatePropertyAll<Color>(
                AppColors.kPrimaryTextDarkColor),
            headerForegroundColor: AppColors.kPrimaryTextDarkColor,
            rangePickerHeaderForegroundColor: AppColors.kPrimaryTextDarkColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            dayBackgroundColor:
                WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.kPrimaryTextDarkColor; // Change this color
              }
              return null; // Default background
            }),
            rangeSelectionBackgroundColor: AppColors.kPrimaryTextDarkColor,
            todayBackgroundColor: const WidgetStatePropertyAll<Color>(
                AppColors.kPrimaryTextDarkColor),
            yearForegroundColor: const WidgetStatePropertyAll<Color>(
                AppColors.kPrimaryTextDarkColor),
            dayForegroundColor:
                WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.kWhiteColor; // Change this color
              }
              return AppColors.kPrimaryTextDarkColor; // Default background
            }),
            todayForegroundColor:
                const WidgetStatePropertyAll<Color>(AppColors.kWhiteColor),
            confirmButtonStyle: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll<Color>(
                  AppColors.kPrimaryTextDarkColor),
            ),
            rangePickerHeaderHeadlineStyle:
                const TextStyle(color: AppColors.kPrimaryTextDarkColor),
            rangePickerSurfaceTintColor: AppColors.kPrimaryTextDarkColor,
            cancelButtonStyle: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll<Color>(
                  AppColors.kPrimaryTextDarkColor),
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
              color: AppColors
                  .kPrimaryTextDarkColor, // Color for month/year in header
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

String capEach(String text) {
  if (text.trim().isEmpty) return text;

  return text.split(' ').map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

//----------------->>>>>>>
class SafeParser {
  static String str(dynamic v, [String fallback = '']) {
    return v is String ? v : v?.toString() ?? fallback;
  }

  static double dbl(dynamic v, [double fallback = 0.0]) {
    if (v is num) return v.toDouble();
    return double.tryParse(v?.toString() ?? '') ?? fallback;
  }

  static int intVal(dynamic v, [int fallback = 0]) {
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? fallback;
  }

  static bool boolVal(dynamic v, [bool fallback = false]) {
    if (v is bool) return v;
    if (v is num) return v == 1;
    return v?.toString().toLowerCase() == 'true' ? true : fallback;
  }

  static List<T> list<T>(
    dynamic v,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (v is! List) return [];

    return v
        .whereType<Map>()
        .map((e) => fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static List<String> stringList(dynamic v) {
    if (v is! List) return [];
    return v
        .map((e) => e?.toString() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static DateTime? date(dynamic v) {
    return DateTime.tryParse(v?.toString() ?? '');
  }

  static Map<String, dynamic>? map(dynamic v) {
    if (v is Map<String, dynamic>) return v;
    if (v is Map) return Map<String, dynamic>.from(v);
    return null;
  }
}
