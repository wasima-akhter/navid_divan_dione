import 'package:get/get.dart';
import 'package:navid_e_commerce/core/bindings/bindings.dart';
import 'package:navid_e_commerce/presentations/auth/views/forget_pass_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/login_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/otp_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/set_new_password_page.dart';
import 'package:navid_e_commerce/presentations/auth/views/signup_page.dart';
import 'package:navid_e_commerce/presentations/home/views/category_list_page.dart';
import 'package:navid_e_commerce/presentations/home/views/product_list_page.dart';
import 'package:navid_e_commerce/presentations/navigation/views/navigation_page.dart';
import 'package:navid_e_commerce/presentations/product/views/deliver_address_page.dart';
import 'package:navid_e_commerce/presentations/product/views/edit_address_page.dart';
import 'package:navid_e_commerce/presentations/product/views/payment_page.dart';
import 'package:navid_e_commerce/presentations/product/views/pickup_address_page.dart';
import 'package:navid_e_commerce/presentations/product/views/product_details_page.dart';
import 'package:navid_e_commerce/presentations/profile/views/profile_page.dart';
import 'package:navid_e_commerce/presentations/settings/views/change_pass_page.dart';
import 'package:navid_e_commerce/presentations/settings/views/feedback_page.dart';
import 'package:navid_e_commerce/presentations/settings/views/privacy_terms_page.dart';
import 'package:navid_e_commerce/presentations/settings/views/settings_page.dart';
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
            name: ProfilePage.routeName,
            page: () => ProfilePage(),
            binding: ProfileBinding()),
        GetPage(
            name: SettingPage.routeName,
            page: () => SettingPage(),
            binding: SettingsBinding()),
        GetPage(
            name: FeedbackPage.routeName,
            page: () => FeedbackPage(),
            binding: SettingsBinding()),
        GetPage(
            name: ChangePassPage.routeName,
            page: () => ChangePassPage(),
            binding: SettingsBinding()),
        GetPage(
            name: PrivacyTermsPage.routeName,
            page: () => PrivacyTermsPage(),
            binding: SettingsBinding()),
        GetPage(
            name: CategoryListPage.routeName,
            page: () => CategoryListPage(),
            binding: HomeBinding()),
        GetPage(
            name: ProductListPage.routeName,
            page: () => ProductListPage(),
            binding: ProductListBinding()),
        GetPage(
            name: ProductDetailsPage.routeName,
            page: () => ProductDetailsPage(),
            binding: ProductBinding()),

        ////
        GetPage(
          name: EditAddressPage.routeName,
          page: () => EditAddressPage(),
        ),
        GetPage(
          name: PaymentScreen.routeName,
          page: () => PaymentScreen(),
        ),
        GetPage(
          name: PickupAddressPage.routeName,
          page: () => PickupAddressPage(),
        ),
        GetPage(
          name: DeliverAddressPage.routeName,
          page: () => DeliverAddressPage(),
        ),
      ];
}
