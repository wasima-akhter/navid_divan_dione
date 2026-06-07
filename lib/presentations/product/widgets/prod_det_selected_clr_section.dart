import '../model/product_details_model.dart';
import 'product_det_export.dart';

class ProdDetSelectedClrSection extends StatelessWidget {
  final ProductController controller;
  final List<ProductVariantModel>? variants;

  const ProdDetSelectedClrSection({
    Key? key,
    required this.controller,
    required this.variants,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final safeVariants = variants ?? [];

    if (safeVariants.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: CustomText(
          text: 'No colors available',
          color: Colors.grey,
        ),
      );
    }

    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 8.w,
          children: [
            CustomText(text: AppStaticStrings.selectColor),
            ...safeVariants.map((variant) {
              final colorCode = (variant.color.trim().isNotEmpty ?? false)
                  ? variant.color.trim()
                  : null;

              final isSelected =
                  controller.selectedColor.value == (colorCode ?? '');

              return GestureDetector(
                onTap: colorCode == null
                    ? null
                    : () {
                        controller.onColorSelected(
                          colorCode,
                          safeVariants,
                        );
                      },
                child: Opacity(
                  opacity: colorCode == null ? 0.3 : 1.0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Colors.red.shade800
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: colorCode != null
                            ? hexToColor(colorCode)
                            : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}
