import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../home/widgets/default_scaffold_structure_widget.dart';
import '../../splash/controllers/common_controller.dart';

class PaymentScreen extends StatefulWidget {
  static const String routeName = '/payment';

  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final commonController = CommonController.to;

    // Initialize WebViewController if not already done
    if (commonController.webController == null) {
      commonController.initializeWebViewController();
    }

    return DefaultScaffoldStructureWidget(
      appBarTitle: AppStaticStrings.payment,
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: WebViewWidget(controller: commonController.webController!),
            ),
            Obx(
              () => commonController.isLoading.value
                  ? const Center(
                      child: DefaultProgressIndicator(
                        color: AppColors.kPrimaryColor,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    CommonController.to.webController = null;
    CommonController.to.stripeUrl.value = '';
    // TODO: implement dispose
    super.dispose();
  }
}
