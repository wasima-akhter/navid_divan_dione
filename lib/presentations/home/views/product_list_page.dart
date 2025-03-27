import 'package:flutter/material.dart';
import 'package:navid_e_commerce/presentations/home/views/home_page.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';

class ProductListPage extends StatelessWidget {
  static const String routeName ='/product-list';
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldStructureWidget(appBarTitle: 'Products',
        children: [
          DynamicProductList()
        ]);
  }
}
