import 'package:navid_e_commerce/core/components/custom_appbar.dart';
import 'package:navid_e_commerce/core/components/custom_refresh_indicator.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/export/ui_export.dart';

class DefaultScaffoldStructureWidget extends StatelessWidget {
  final String appBarTitle;
  final double? spacing;
  final ScrollController? scrollController;
  final CrossAxisAlignment? crossAxisAlignment;
  final List<Widget>? children;
  final Widget? body;
  final List<Widget>? action;
  final Future<void> Function()? onRefresh;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  const DefaultScaffoldStructureWidget({
    super.key,
    required this.appBarTitle,
    this.children,
    this.spacing,
    this.crossAxisAlignment,
    this.action,
    this.scrollController,
    this.body,
    this.onRefresh,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // top: false,
      child: Scaffold(
        appBar: CustomDefaultAppbar(
          title: appBarTitle,
          action: action,
        ),
        resizeToAvoidBottomInset: true,
        floatingActionButton: IntrinsicHeight(child: floatingActionButton)
            .marginSymmetric(horizontal: 20.w, vertical: 10.h),
        floatingActionButtonLocation:
            floatingActionButtonLocation ?? FloatingActionButtonLocation.centerDocked,
        body: CustomRefreshIndicatorWidget(
          onRefresh: () async {
            if (onRefresh != null) {
              await onRefresh!();
            }
          },
          child: body ??
              SingleChildScrollView(
                controller: scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: padding12,
                  child: Column(
                    crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
                    spacing: spacing ?? 0,
                    children: children ?? [],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
