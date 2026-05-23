import '../../../core/export/ui_export.dart';
import '../../cart/widgets/cart_item_widget.dart';
import '../../home/widgets/product_card_item_widget.dart';
import '../controllers/product_controller.dart';
import '../model/product_details_model.dart';

// class ProdDetPriceCartRow extends StatelessWidget {
//   final ProductController controller;
//   final ProductVariantModel selectedVariant;
//   const ProdDetPriceCartRow({Key? key, required this.controller, required this.selectedVariant})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final price = selectedVariant.price ?? 0.0;
//     final discount = selectedVariant.discount ?? 0.0;
//     final priceAfterDiscount = selectedVariant.priceAfterDiscount ?? 0.0;
//     final finalPrice = controller.cartQuantity.value * priceAfterDiscount;

//     final pId = controller.productId.value;

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         PriceTextWidget(
//           previousPrice: price.toString(),
//           price: finalPrice.toString(),
//           fontSize: getFontSizeExtraLarge(),
//           previousPriceFontSize: getFontSizeDefault(),
//           discount: discount.toString(),
//         ),
//         CartCounterWidget(
//           count: controller.cartQuantity,
//           onIncrement: controller.incrementCartQuantity, // instant local
//           onDecrement: controller.decrementCartQuantity, // instant local
//           // no loading states needed
//         ),
//       ],
//     );
//   }
// }

class ProdDetPriceCartRow extends StatelessWidget {
  final ProductController controller;
  final ProductVariantModel selectedVariant;

  const ProdDetPriceCartRow({
    Key? key,
    required this.controller,
    required this.selectedVariant,
  }) : super(key: key);

  String _format(double? value) {
    return (value ?? 0.0).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final price = selectedVariant.price ?? 0.0;
    final discount = selectedVariant.discount ?? 0.0;
    final priceAfterDiscount = selectedVariant.priceAfterDiscount ?? 0.0;

    return Obx(() {
      final qty = controller.cartQuantity.value;
      final finalPrice = qty * priceAfterDiscount;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PriceTextWidget(
            previousPrice: _format(price),
            price: _format(finalPrice),
            fontSize: getFontSizeExtraLarge(),
            previousPriceFontSize: getFontSizeDefault(),
            discount: _format(discount),
          ),
          CartCounterWidget(
            count: controller.cartQuantity,
            onIncrement: controller.incrementCartQuantity,
            onDecrement: controller.decrementCartQuantity,
          ),
        ],
      );
    });
  }
}
