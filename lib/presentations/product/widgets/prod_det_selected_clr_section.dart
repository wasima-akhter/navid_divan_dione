import '../model/product_details_model.dart';
import 'product_det_export.dart';

class ProdDetSelectedClrSection extends StatelessWidget {
  final ProductController controller;
  final List<ProductVariantModel>? variants;
  const ProdDetSelectedClrSection({Key? key, required this.controller, required this.variants})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 8.w,
            children: [
              CustomText(text: AppStaticStrings.selectColor),
              ...variants!.map((variant) {
                final isSelected = controller.selectedColor.value == variant.color;

                return GestureDetector(
                    onTap: () {
                      controller.onColorSelected(variant.color ?? '');
                    },
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: isSelected ? Colors.red.shade800 : Colors.grey.shade300),
                      ),
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: hexToColor(variant.color ?? ''),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ));
              }),
            ],
          ),
        );
      },
    );
  }
}
