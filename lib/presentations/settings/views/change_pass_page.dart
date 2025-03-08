import 'package:flutter/material.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';

class ChangePassPage extends StatelessWidget {
  static const String routeName = '/chang-pass';
  const ChangePassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldStructureWidget(
        appBarTitle: AppStaticStrings.settings, children: []);
  }
}
