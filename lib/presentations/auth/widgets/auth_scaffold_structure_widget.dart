import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/core/components/custom_appbar.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
class AuthScaffoldStructureWidget extends StatelessWidget {
  final String appBarTitle;
  final List<Widget> children;
  final Widget? bottom;
  const AuthScaffoldStructureWidget({
    super.key, required this.appBarTitle, required this.children, this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAuthAppbar(title: appBarTitle),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: padding12,
              child: Column(
                spacing: 4.h,
          crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
          Padding(
            padding: padding12.copyWith(bottom: 20.w ),
            child: bottom??SizedBox.shrink(),
          )
        ],
      ),

    );
  }
}
