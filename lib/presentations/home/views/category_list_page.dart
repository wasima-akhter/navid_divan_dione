import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/home/widgets/category_card_item_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';

class CategoryListPage extends StatelessWidget {
  static const String routeName = '/cat-list';
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldStructureWidget(
      appBarTitle: AppStaticStrings.category,
      children: [
        Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
          shrinkWrap: true,
          primary: false,
          itemCount: 10,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.w,
              maxCrossAxisExtent: 200.w),
          itemBuilder: (context, index) => CategoryCardItemWidget(),
        ))
      ],
    );
  }
}

