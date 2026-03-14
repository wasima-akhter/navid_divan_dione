import '../../../core/export/ui_export.dart';
import '../../cart/widgets/cart_item_widget.dart';
import '../../home/widgets/product_card_item_widget.dart';
import '../controllers/product_controller.dart';
import '../model/product_details_model.dart';

class ProdDetPriceCartRow extends StatelessWidget {
  final ProductController controller;
  final ProductVariantModel selectedVariant;
  const ProdDetPriceCartRow({Key? key, required this.controller, required this.selectedVariant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final price = selectedVariant.price ?? 0.0;
    final discount = selectedVariant.discount ?? 0.0;
    final priceAfterDiscount = price - discount;
    final finalPrice = controller.cartQuantity.value * priceAfterDiscount;

    final pId = controller.productId.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PriceTextWidget(
          previousPrice: price.toString(),
          price: finalPrice.toString(),
          fontSize: getFontSizeExtraLarge(),
          previousPriceFontSize: getFontSizeDefault(),
          discount: discount.toString(),
        ),
        CartCounterWidget(
          count: controller.cartQuantity,
          onIncrement: controller.incrementCartQuantity, // instant local
          onDecrement: controller.decrementCartQuantity, // instant local
          // no loading states needed
        ),
      ],
    );
  }
}
