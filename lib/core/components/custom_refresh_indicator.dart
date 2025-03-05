import 'package:flutter/material.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.kPrimaryLightColor,
      displacement: 40.0, // Adjust the distance the indicator moves
      child: child,
    );
  }
}
