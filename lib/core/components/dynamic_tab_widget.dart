import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/tab_content_view.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';

class DynamicTabWidget extends StatelessWidget {
  final RxList<String> tabs;
  final RxList<Widget> tabContent;
  final Function(int)? function;
  const DynamicTabWidget(
      {super.key, required this.tabs, required this.tabContent, this.function});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DefaultTabController(
        length: tabs.length,
        // Dynamically set the number of tabs
        child: Column(
          children: [
            space16H,
            TabBar(
              // padding: EdgeInsets.zero,
              overlayColor: const WidgetStatePropertyAll<Color>(
                  AppColors.kPrimaryLightColor),
              // isScrollable: true,
              dividerHeight: 4.h,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: UnderlineTabIndicator(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                borderSide: BorderSide(
                  color: AppColors.kPrimaryLightColor,
                  width: 10.w,
                ),
              ),

              labelColor: AppColors.kPrimaryTextDarkColor,
              unselectedLabelColor: AppColors.kPrimaryColor,
              labelStyle:
                  poppinsRegular.copyWith(fontSize: getFontSizeDefault()),
              unselectedLabelStyle:
                  poppinsMedium.copyWith(fontSize: getFontSizeDefault()),
              dividerColor: AppColors.kExtraLightTextColor,
              onTap: function ?? (value) {},
              tabs: tabs
                  .map((tabName) => Padding(
                        padding: padding16b24,
                        child: FittedBox(
                          child: Text(
                            tabName,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            TabContentView(
              children: tabContent.toList(),
            )
          ],
        ),
      );
    });
  }
}
