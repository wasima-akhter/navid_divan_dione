import '../../../core/constants/text_style_constant.dart';
import '../../../core/export/ui_export.dart';
import '../model/cart_model.dart';
import 'cart_item_widget.dart';

class CartItemList extends StatelessWidget {
  final RxList<CartModel> cartList;
  const CartItemList({Key? key, required this.cartList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(
          cartList.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: CartItemWidget(
              cartModel: cartList[index],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        CustomText(
          text: "To Checkout, Go to Summary & Checkout",
          style: regularText(16, color: Colors.grey.shade800),
        ),
      ],
    );
  }
}
