import 'package:flutter/material.dart';
import 'package:navid_e_commerce/core/components/custom_appbar.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';

class DefaultScaffoldStructureWidget extends StatelessWidget {
  final String appBarTitle;
  final List<Widget> children;
  const DefaultScaffoldStructureWidget({
    super.key, required this.appBarTitle, required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDefaultAppbar(title: appBarTitle),

      body: Padding(
        padding: padding12,
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
