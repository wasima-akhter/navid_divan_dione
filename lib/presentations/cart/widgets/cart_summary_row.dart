import '../../../core/constants/text_style_constant.dart';
import '../../../core/export/ui_export.dart';

class CartSummaryRow extends StatelessWidget {
  final String value;
  final String title;
  const CartSummaryRow({Key? key, required this.value, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          style: poppinsMedium,
          fontSize: getFontSizeDefault(),
        ),
        CustomText(
          text: value,
          style: poppinsMedium,
          fontSize: getFontSizeDefault(),
        ),
      ],
    );
  }
}
