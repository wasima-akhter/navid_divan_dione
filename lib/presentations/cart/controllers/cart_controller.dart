import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_endpoints.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/cart/model/cart_model.dart';

import '../../../core/api-client/api_service.dart';
import '../../../core/constants/app_static_strings.dart';
import '../../../core/helper/helper_function.dart';
import '../../../core/utils/hive_boxes.dart';

class CartController extends GetxController {
  static CartController get to => Get.find();
  RxString totalPrice = "0.0".obs;
  RxMap<String, bool> isLoadingAddCart = <String, bool>{}.obs;
  RxMap<String, bool> isLoadingDeleteCart = <String, bool>{}.obs;
  RxList<CartModel> cartList = <CartModel>[].obs;
  RxBool isCartLoading = false.obs;
  @override
  void onInit() {
    getCartListRequest();
    super.onInit();
  }

  ///------------------------------ get cart list-------------------------///

  Future<void> getCartListRequest() async {
    try {
      isCartLoading.value = true;
      ApiService().setAuthToken(Boxes.getUserData().get(tokenKey).toString());

      final response = await ApiService().request(endpoint: getAllCartEndPoint, method: 'GET');
      isCartLoading.value = false;
      if (response['success'] == true) {
        logger.d(response);
        cartList.value = (response['data']['items'] as List).map((e) => CartModel.fromJson(e)).toList();
        totalPrice.value = response['data']["total_price"].toString();
      } else {
        logger.e(response);
        showCustomSnackbar(title: 'Failed', message: response['message'], type: SnackBarType.failed);
      }
    } catch (e) {
      logger.e(e.toString());
      isCartLoading.value = false;
    }
  }

  ///------------------------------- add to cart ----------------------------///

  Future<void> addToCart({
    required String productId,
  required String size,
    required num quantity,
    required num price,
    required String variant,
  }) async {
    try {
      isLoadingAddCart[productId] = true;
      final response = await ApiService().request(endpoint: addToCartEndPoint, method: 'POST', body: {
        "items": [
          {"product_id": productId, "quantity": quantity, "price": price, "variant": variant,"size":size}
        ]
      });
      isLoadingAddCart[productId] = false;
      if (response['success'] == true) {
        logger.d(response);
        getCartListRequest();
        showCustomSnackbar(
          title: 'Success',
          message: response['message'],
        );
      } else {
        logger.e(response);
        showCustomSnackbar(title: 'Failed', message: response['message'], type: SnackBarType.failed);
      }
    } catch (e) {
      isLoadingAddCart[productId] = false;
      logger.e(e.toString());
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
        logger.d(response);
        getCartListRequest();
        showCustomSnackbar(
          title: 'Success',
          message: response['message'],
        );
      } else {
        logger.e(response);
        showCustomSnackbar(title: 'Failed', message: response['message'], type: SnackBarType.failed);
      }
    } catch (e) {
      isLoadingDeleteCart[cartId] = false;
      logger.e(e.toString());
    }
  }
}
