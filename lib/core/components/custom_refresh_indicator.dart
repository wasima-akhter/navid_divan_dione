import 'package:flutter/material.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';

class CustomRefreshIndicatorWidget extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  const CustomRefreshIndicatorWidget({
    super.key,
    required this.child, required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppColors.kWhiteColor,
      color: AppColors.kPrimaryDarkColor,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
