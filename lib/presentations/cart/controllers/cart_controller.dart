import 'package:navid_e_commerce/core/api-client/api_endpoints.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/cart/model/cart_model.dart';

import '../../../core/export/ui_export.dart';
import '../../../core/utils/hive_boxes.dart';
import '../../product/controllers/product_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class CartController extends GetxController {
  static CartController get to => Get.find();

  RxList<CartModel> cartList = <CartModel>[].obs;

  /// local editable quantity
  RxMap<String, int> localQty = <String, int>{}.obs;

  /// track modified cart items
  RxSet<String> changedItems = <String>{}.obs;

  /// initialize local quantities
  void initLocalQty() {
    for (var item in cartList) {
      localQty[item.product?.sId ?? ""] = item.quantity ?? 1;
    }
  }

  ////////////////////////////////
  RxString totalPrice = "0.0".obs;
  RxString salesTax = "0.0".obs;
  RxString shippingCharge = "0.0".obs;
  RxString subTotal = "0.0".obs;

  //
  RxMap<String, bool> isLoadingAddCart = <String, bool>{}.obs;
  RxMap<String, bool> isLoadingDeleteCart = <String, bool>{}.obs;

  RxBool isCartLoading = false.obs;

  RxMap<String, RxBool> isIncreLoading = <String, RxBool>{}.obs;
  RxMap<String, RxBool> isDecreLoading = <String, RxBool>{}.obs;

  // Tab selection: 0 = items, 1 = summary
  RxInt selectedTab = 0.obs;

  void selectTab(int index) {
    selectedTab.value = index;
  }

  @override
  void onInit() {
    getCartListRequest();
    super.onInit();
  }

///////////////////////////////////////////////////
  Future<void> updateCart() async {
    if (changedItems.isEmpty) return;

    // snapshot to avoid mutation during iteration
    final itemsToUpdate = Set<String>.from(changedItems);

    for (var productId in itemsToUpdate) {
      final item = cartList.firstWhereOrNull((e) => e.product?.sId == productId);
      if (item == null) continue;

      await addToCart(
        productId: productId,
        variant: item.variant?.sId ?? '',
        quantity: localQty[productId] ?? 1,
      );

      // ✅ Sync ProductController if it's viewing this product
      if (Get.isRegistered<ProductController>() &&
          ProductController.to.productId.value == productId) {
        ProductController.to.cartQuantity.value = localQty[productId] ?? 1;
      }
    }

    changedItems.clear();
  }

/////////////////////////////////////////////////

  /// For Product Controller tosync with this controller

  // Call this when entering product details page to sync quantity
  void syncQuantityFromCart(String productId, String variantId) {
    // ✅ Never touch ProductController from CartController unless it's already alive
    if (!Get.isRegistered<ProductController>()) return;
    final item = cartList.firstWhereOrNull((e) => e.product?.sId == productId);
    ProductController.to.cartQuantity.value = item?.quantity ?? 1;
  }

  Future<void> incrementCartItem({
    required String productId,
    required String variantId,
  }) async {
    final item = cartList.firstWhereOrNull((e) => e.product?.sId == productId);
    if (item == null) return;

    final newQty = (item.quantity ?? 1) + 1;

    isIncreLoading[productId] ??= false.obs;
    isIncreLoading[productId]!.value = true;

    await addToCart(productId: productId, quantity: newQty, variant: variantId);

    isIncreLoading[productId]!.value = false;
  }

  Future<void> decrementCartItem({
    required String productId,
    required String variantId,
  }) async {
    final item = cartList.firstWhereOrNull((e) => e.product?.sId == productId);
    if (item == null) return;

    final currentQty = item.quantity ?? 1;
    if (currentQty <= 1) return;

    isDecreLoading[productId] ??= false.obs;
    isDecreLoading[productId]!.value = true;

    await addToCart(productId: productId, quantity: currentQty - 1, variant: variantId);

    isDecreLoading[productId]!.value = false;
  }

  ///------------------------------ get cart list-------------------------///

  Future<void> getCartListRequest() async {
    try {
      isCartLoading.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(endpoint: getAllCartEndPoint, method: 'GET');
      isCartLoading.value = false;

      debugPrint('response in get cart all : $response ');

      if (response['success'] == true) {
        // Map response to cartList
        cartList.value = (response['data'] as List).map((e) => CartModel.fromJson(e)).toList();

        // Initialize increment/decrement loading states for each item
        for (var item in cartList) {
          final id = item.product?.sId ?? "";
          if (!isIncreLoading.containsKey(id)) {
            isIncreLoading[id] = false.obs;
          }
          if (!isDecreLoading.containsKey(id)) {
            isDecreLoading[id] = false.obs;
          }
        }

        // recalc total price
        calculateTotalPrice();

        debugPrint('parsed data in get cart all : ${cartList.value.length} ');

        initLocalQty();

        ///
      } else {
        showCustomSnackbar(
            title: 'Failed', message: response['message'], type: SnackBarType.failed);
      }
    } catch (e) {
      isCartLoading.value = false;
      debugPrint('Error in getCartListRequest: $e');
    }
  }

  ///------------------------------- add to cart ----------------------------///

// const data = {
//         user: profileData?.data?._id,
//         product_id: item?.product?._id,
//         variant: item?.variant?._id,
//         quantity: newQuantity
//       }
  /// Call this whenever cart changes to recalc total
  /// Call this whenever cart changes to recalc total
  /// Uses localQty for live preview if available
  void calculateTotalPrice() {
    double subtotal = 0.0;

    for (var item in cartList) {
      final id = item.product?.sId ?? "";
      final price = double.tryParse(item.variant?.price.toString() ?? "0") ?? 0;
      // ✅ explicitly read from localQty map so Obx tracks this dependency
      final qty = localQty.containsKey(id) ? localQty[id]! : (item.quantity ?? 0);
      subtotal += price * qty;
    }

    final double tax = subtotal * 0.06625;
    final double shipping = subtotal > 100 ? 0.0 : 10.0;
    final double total = subtotal + tax + shipping;

    subTotal.value = subtotal.toStringAsFixed(2);
    salesTax.value = tax.toStringAsFixed(2);
    shippingCharge.value = shipping.toStringAsFixed(2);
    totalPrice.value = total.toStringAsFixed(2);
  }

  void incrementLocal(String productId) {
    localQty[productId] = (localQty[productId] ?? 1) + 1;
    changedItems.add(productId);
    localQty.refresh(); // ✅ triggers Obx watching localQty
    calculateTotalPrice();
  }

  void decrementLocal(String productId) {
    if ((localQty[productId] ?? 1) <= 1) return;
    localQty[productId] = (localQty[productId] ?? 1) - 1;
    changedItems.add(productId);
    localQty.refresh(); // ✅ triggers Obx watching localQty
    calculateTotalPrice();
  }

  Future<void> addToCart({
    required String productId,
    required num quantity,
    required String variant,
  }) async {
    //
    try {
      isLoadingAddCart[productId] = true;

      // first retrieve the user Id

      await ProfileController.to.getUserProfileRequest();

      final userId = ProfileController.to.userId.value;

      final response = await ApiService().request(
          endpoint: addToCartEndPoint,
          method: 'POST',
          body: {
            "user": userId,
            "product_id": productId,
            "variant": variant,
            "quantity": quantity
          });

      await getCartListRequest(); // fetch full cart
      calculateTotalPrice(); // recalc total

      isLoadingAddCart[productId] = false;
      if (response['success'] == true) {
        //   logger.d(response);
        getCartListRequest();
        showCustomSnackbar(
          title: 'Success',
          message: response['message'],
        );
      } else {
        //   logger.e(response);
        showCustomSnackbar(
            title: 'Failed', message: response['message'], type: SnackBarType.failed);
      }
    } catch (e) {
      isLoadingAddCart[productId] = false;
      //   logger.e(e.toString());
    }
  }

  ///----------------------- Delete Cart item ----------------------///

  Future<void> deleteCartItem({required String cartId}) async {
    try {
      isLoadingDeleteCart[cartId] = true;
      final response = await ApiService().request(
        endpoint: "$deleteCartEndPoint$cartId",
        method: 'DELETE',
      );
      isLoadingDeleteCart[cartId] = false;
      if (response['success'] == true) {
        //   logger.d(response);
        await getCartListRequest();
        calculateTotalPrice();
        showCustomSnackbar(
          title: 'Success',
          message: response['message'],
        );
      } else {
        //   logger.e(response);
        showCustomSnackbar(
            title: 'Failed', message: response['message'], type: SnackBarType.failed);
      }
    } catch (e) {
      isLoadingDeleteCart[cartId] = false;
      //   logger.e(e.toString());
    }
  }

////////////////////////////////////////////////////////////////////////
  ///
  ///
  ///------------------ Build Order Items --------------------------///

  List<Map<String, dynamic>> buildOrderItems() {
    return cartList.map((cart) {
      final price = double.tryParse(cart.variant?.price.toString() ?? "0") ?? 0;

      return {
        "_id": cart.sId,
        "variant": cart.variant?.toJson(),
        "product": {
          "_id": cart.product?.sId,
          "name": cart.product?.name,
          "video": cart.product?.video,
        },
        "quantity": cart.quantity,
        "total_price": price * (cart.quantity ?? 0),
      };
    }).toList();
  }
}
