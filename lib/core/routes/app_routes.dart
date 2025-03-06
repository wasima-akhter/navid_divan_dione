import 'package:get/get.dart';
import 'package:navid_e_commerce/core/bindings/bindings.dart';
import 'package:navid_e_commerce/presentations/auth/views/add_documentation_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/add_documentation_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/forget_pass_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/forget_pass_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/login_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/otp_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/otp_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/set_new_password_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/set_new_password_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/signup_page.dart';
import 'package:navid_e_commerce/presentations/home/views/category_list_page.dart';
import 'package:navid_e_commerce/presentations/navigation/views/navigation_page.dart';
import 'package:navid_e_commerce/presentations/splash/views/splash_page.dart';

class AppRoutes {
  static route() => [
        GetPage(
            name: SplashPage.routeName,
            page: () => SplashPage(),
            binding: SplashBinding()),
        GetPage(
            name: LoginPage.routeName,
            page: () => LoginPage(),
            binding: AuthBinding()),
        GetPage(
            name: SignupPage.routeName,
            page: () => SignupPage(),
            binding: AuthBinding()),
        GetPage(
            name: AddDocumentationPage.routeName,
            page: () => AddDocumentationPage(),
            binding: AuthBinding()),
        GetPage(
            name: ForgetPassPage.routeName,
            page: () => ForgetPassPage(),
            binding: AuthBinding()),
        GetPage(
            name: OtpPage.routeName,
            page: () => OtpPage(),
            binding: AuthBinding()),
        GetPage(
            name: SetNewPasswordPage.routeName,
            page: () => SetNewPasswordPage(),
            binding: AuthBinding()),
        GetPage(
            name: NavigationPage.routeName,
            page: () => NavigationPage(),
            binding: NavigationBinding()),
        GetPage(
          name: CategoryListPage.routeName,
          page: () => CategoryListPage(), /*binding: NavigationBinding()*/
        ),
      ];
}
