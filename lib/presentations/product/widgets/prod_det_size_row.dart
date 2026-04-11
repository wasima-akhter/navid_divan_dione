import '../../../core/export/ui_export.dart';
import '../controllers/product_controller.dart';
import '../model/product_details_model.dart';

class ProdDetSizeRow extends StatelessWidget {
  final ProductController controller;
  final ProductVariantModel selectedVariant;
  const ProdDetSizeRow({Key? key, required this.controller, required this.selectedVariant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        debugPrint('  : ');
        final variant = controller.selectedVariant.value;

        if (variant == null) return const SizedBox.shrink();
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 12.w,
            children: [
              CustomText(text: AppStaticStrings.size),
              ColorItemWidget(
                textColor: controller.selectedSize.value == selectedVariant.size
                    ? AppColors.kWhiteColor
                    : AppColors.kPrimaryColor,
                containerColor: controller.selectedSize.value == selectedVariant.size
                    ? AppColors.kPrimaryColor
                    : Colors.transparent,
                color: selectedVariant.size ?? '',
              )
            ],
          ),
        );
      },
    );
  }
}
