import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/utils/hive_boxes.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/navigation/views/navigation_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/api-client/api_service.dart';

class CommonController extends GetxController {
  static CommonController get to => Get.find();

  RxBool isLoggedIn = false.obs;

  WebViewController? webController;
  RxBool isLoading = true.obs;
  RxString stripeUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final token = Boxes.getUserData().get(tokenKey);

    debugPrint("---------token---------");
    debugPrint(token.toString());

    if (token != null && token.toString().isNotEmpty) {
      isLoggedIn.value = true;

      /// set api token once
      ApiService().setAuthToken(token.toString());
    } else {
      isLoggedIn.value = false;
    }
  }

  /// call after login
  void updateLogin(String token) {
    Boxes.getUserData().put(tokenKey, token);

    ApiService().setAuthToken(token);

    isLoggedIn.value = true;
  }

  /// call after logout
  void logout() {
    Boxes.getUserData().delete(tokenKey);

    ApiService().setAuthToken("");

    isLoggedIn.value = false;
  }

  ///

  // bool isLoggedIn = Boxes.getUserData().get(tokenKey) != null &&
  //     Boxes.getUserData().get(tokenKey).toString().isNotEmpty;

  RxInt count = 1.obs;
  void increment(int currentIndex) {
    count++;
  }

  void decrement(int currentIndex) {
    count--;
  }

  void initializeWebViewController() {
    if (webController != null) {
      return; // Avoid re-initialization
    }
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent('Mozilla/5.0 (Mobile; rv:52.0) Gecko/52.0 Firefox/52.0')
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint("WebView progress: $progress");
            isLoading.value = progress < 100;
          },
          onPageStarted: (String url) {
            debugPrint("Page started loading: $url");
            isLoading.value = true;
          },
          onPageFinished: (String url) {
            debugPrint("Page finished loading: $url");
            isLoading.value = false;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint("HTTP Error: ${error}");
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("Web Resource Error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            /* if (request.url.startsWith("https://www.google.com/webhp?hl=en&sa=X&ved=0ahUKEwj4-qy6koSLAxVLRmwGHT7zHXIQPAgI")) {
              return NavigationDecision.prevent;
            }*/
            if (request.url.contains('${ApiService().baseUrl}/payment/success')) {
              Get.offAllNamed(NavigationPage.routeName);
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(stripeUrl.value));
  }
}
