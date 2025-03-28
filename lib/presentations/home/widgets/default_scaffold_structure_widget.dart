import 'package:flutter/material.dart';
import 'package:navid_e_commerce/core/components/custom_appbar.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';

class DefaultScaffoldStructureWidget extends StatelessWidget {
  final String appBarTitle;
  final double? spacing;
  final ScrollController? scrollController;
  final CrossAxisAlignment? crossAxisAlignment;
  final List<Widget> children;
  final List<Widget>? action;
  const DefaultScaffoldStructureWidget({
    super.key, required this.appBarTitle, required this.children, this.spacing, this.crossAxisAlignment, this.action, this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDefaultAppbar(title: appBarTitle,action: action,),

      body: SingleChildScrollView(
        controller:scrollController ,
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: padding12,
          child: Column(
            crossAxisAlignment:crossAxisAlignment?? CrossAxisAlignment.start,
            spacing: spacing??0,
            children: children,
          ),
        ),
      ),
    );
  }
}
