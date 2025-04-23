import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/pagination_loading_widget.dart';
import 'package:navid_e_commerce/presentations/settings/controllers/settings_controller.dart';

class PrivacyTermsPage extends StatelessWidget {
  static const String routeName = '/privacy';

  const PrivacyTermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? argument = Get.arguments;
    return DefaultScaffoldStructureWidget(
        appBarTitle: argument != null && argument == 'terms'
            ? AppStaticStrings.termsOfUse
            : AppStaticStrings.privacyPolicy,
        children: [
          Obx(() {
            return SettingsController.to.isLoadingPolicy.value?PaginationLoadingWidget(): HtmlWidget(
              argument != null && argument == 'terms' ? '''${SettingsController.to.termsModel.value.desc}
''' : '''${SettingsController.to.policyModel.value.desc}
''',
              textStyle: poppinsRegular.copyWith(fontSize: getFontSizeDefault()),
            );
          })
        ]);
  }
}
