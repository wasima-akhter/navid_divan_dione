// presentations/product/controllers/address_order_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_endpoints.dart';
import 'package:navid_e_commerce/core/api-client/api_service.dart';
import 'package:navid_e_commerce/core/helper/helper_function.dart';
import 'package:navid_e_commerce/presentations/product/model/pick_address_model.dart';
import 'package:navid_e_commerce/presentations/splash/controllers/common_controller.dart';

import '../views/payment_page.dart';

class AddressOrderController extends GetxController {
  static AddressOrderController get to => Get.find();

  // ─── Shipping / Pickup state ───
  RxString selectedPickAddress = ''.obs;
  RxString selectedShippingAddress = ''.obs;
  RxList<PickAddressModel> pickAddressList = <PickAddressModel>[].obs;
  RxList<PickAddressModel> shippingAddressList = <PickAddressModel>[].obs;

  RxBool isLoadingPickUpAddress = false.obs;
  RxBool isLoadingShippingAddress = false.obs;
  RxBool isLoadingAddShippingAddress = false.obs;
  RxMap<String, bool> isLoadingDeleteAddress = <String, bool>{}.obs;

  // ─── Name/Phone controllers for pickup ───
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final nameAddressController = TextEditingController();
  final contactAddressController = TextEditingController();
  final deliveryAddressController = TextEditingController();

  // ─── Order/Payment state ───
  RxString orderId = ''.obs;
  RxBool isLoadingOrder = false.obs;
  RxBool isPaymentLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (CommonController.to.isLoggedIn.value) {
      getPickUpAddressRequest();
      getShippingAddressRequest();
    }
  }

  @override
  void onReady() {
    super.onReady();

    if (CommonController.to.isLoggedIn.value) {
      getPickUpAddressRequest();
      getShippingAddressRequest();
    }
  }

  void refreshData() {
    if (CommonController.to.isLoggedIn.value) {
      getPickUpAddressRequest();
      getShippingAddressRequest();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    nameAddressController.dispose();
    contactAddressController.dispose();
    deliveryAddressController.dispose();
    super.onClose();
  }

  void fetchPickUpAddress() {
    for (var p in pickAddressList) {
      if (p.sId == selectedPickAddress.value) {
        nameController.text = p.name ?? '';
        phoneController.text = p.phone ?? '';
      }
    }
  }

  // ─── Pickup Addresses ───
  Future<void> getPickUpAddressRequest() async {
    try {
      isLoadingPickUpAddress.value = true;
      final response = await ApiService()
          .request(endpoint: pickAddressEndPoint, method: 'GET');
      if (response['success'] == true) {
        pickAddressList.value = (response["data"] as List)
            .map((e) => PickAddressModel.fromJson(e))
            .toList();
        if (pickAddressList.isNotEmpty) {
          selectedPickAddress.value = pickAddressList.first.sId ?? '';
          fetchPickUpAddress();
        }
      } else {
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      debugPrint('getPickUpAddressRequest error: $e');
    } finally {
      isLoadingPickUpAddress.value = false;
    }
  }

  // ─── Shipping Addresses ───
  Future<void> getShippingAddressRequest() async {
    try {
      isLoadingShippingAddress.value = true;
      final response = await ApiService()
          .request(endpoint: shippingAddressGetEndPoint, method: 'GET');
      if (response['success'] == true) {
        shippingAddressList.value = (response["data"] as List)
            .map((e) => PickAddressModel.fromJson(e))
            .toList();
        if (shippingAddressList.isNotEmpty) {
          selectedShippingAddress.value = shippingAddressList.first.sId ?? '';
        }
      } else {
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      debugPrint('getShippingAddressRequest error: $e');
    } finally {
      isLoadingShippingAddress.value = false;
    }
  }

  // ─── Add Shipping Address ───
  Future<void> addShippingAddressRequest({
    required String address,
    required String phone,
    required String name,
  }) async {
    try {
      isLoadingAddShippingAddress.value = true;
      final response = await ApiService().request(
        endpoint: shippingAddressCreateEndPoint,
        method: 'POST',
        body: {"address": address, "phone": phone, "name": name},
      );
      if (response['success'] == true) {
        getShippingAddressRequest();
        showCustomSnackbar(title: 'Success', message: response['message']);
      } else {
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      debugPrint('addShippingAddressRequest error: $e');
    } finally {
      isLoadingAddShippingAddress.value = false;
    }
  }

  // ─── Delete Address ───
  Future<void> deleteAddress({required String id}) async {
    try {
      isLoadingDeleteAddress[id] = true;
      final response = await ApiService().request(
        endpoint: "$deletesShippingAddressEndPoint$id",
        method: 'DELETE',
      );
      isLoadingDeleteAddress[id] = false;
      if (response['success'] == true) {
        await getShippingAddressRequest();
        if (shippingAddressList.isEmpty) selectedShippingAddress.value = '';
        showCustomSnackbar(title: 'Success', message: response['message']);
      } else {
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      isLoadingDeleteAddress[id] = false;
    }
  }

  // ─── Order ───
  Future<void> orderRequest({
    required String userId,
    required double totalAmount,
    required List<Map<String, dynamic>> items,
    String? pickupAddress,
    String? deliveryAddress,
  }) async {
    try {
      debugPrint('pickupAddress:${pickupAddress}  ');
      isLoadingOrder.value = true;
      final response = await ApiService().request(
        endpoint: orderCreateEndPoint,
        method: 'POST',
        body: {
          "user": userId,
          "items": items,
          "totalAmount": totalAmount,
          if (deliveryAddress != null) "delivery_address": deliveryAddress,
          if (pickupAddress != null) "pick_up_address": pickupAddress,
        },
      );

      if (response['success'] == true) {
        final orderData = (response['order'] as List?)?.first;
        if (orderData != null && orderData["_id"] != null) {
          orderId.value = orderData["_id"];
          await paymentRequest(orderId: orderId.value);
        }
        showCustomSnackbar(title: 'Success', message: response['message']);
      } else {
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      debugPrint("Order error: $e");
    } finally {
      isLoadingOrder.value = false;
    }
  }

  // ─── Payment ───
  Future<void> paymentRequest({required String orderId}) async {
    try {
      isPaymentLoading.value = true;
      final response = await ApiService().request(
        endpoint: paymentCreateEndPoint,
        method: 'POST',
        body: {"order_id": orderId},
      );
      if (response['success'] == true) {
        CommonController.to.stripeUrl.value = response["url"];
        Get.toNamed(PaymentScreen.routeName);
        showCustomSnackbar(title: 'Success', message: response['message']);
      } else {
        showCustomSnackbar(
            title: 'Failed',
            message: response['message'],
            type: SnackBarType.failed);
      }
    } catch (e) {
      debugPrint('paymentRequest error: $e');
    } finally {
      isPaymentLoading.value = false;
    }
  }
}
