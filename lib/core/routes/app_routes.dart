import 'package:get/get.dart';
import 'package:navid_e_commerce/core/bindings/bindings.dart';
import 'package:navid_e_commerce/presentations/auth/views/login_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/signup_page.dart';
import 'package:navid_e_commerce/presentations/splash/views/splash_page.dart';

class AppRoutes{

  static route()=>[
    GetPage(name: SplashPage.routeName, page: () => SplashPage(),binding: SplashBinding()),
    GetPage(name: LoginPage.routeName, page: () => LoginPage(),binding: AuthBinding()),
    GetPage(name: SignupPage.routeName, page: () => SignupPage(),binding: AuthBinding()),
  ];
}