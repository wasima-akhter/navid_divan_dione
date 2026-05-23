import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:navid_e_commerce/core/bindings/bindings.dart';
import 'package:navid_e_commerce/core/routes/app_routes.dart';
import 'package:navid_e_commerce/core/theme/app_theme.dart';
import 'package:navid_e_commerce/presentations/splash/views/splash_page.dart';

import 'core/utils/variable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Hive.initFlutter();
  await Hive.openBox(userBoxName);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
      /*DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) =>*/
      const MyApp() /*)*/);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 888),
      minTextAdapt: true,
      // useInheritedMediaQuery: true,
      builder: (context, child) => GetMaterialApp(
        title: 'Divan Dione',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.dark,
        initialRoute: SplashPage.routeName,
        getPages: AppRoutes.route(),
        initialBinding: CommonBinding(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
