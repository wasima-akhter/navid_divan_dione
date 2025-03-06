import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/routes/app_routes.dart';
import 'package:navid_e_commerce/core/theme/app_theme.dart';
import 'package:navid_e_commerce/presentations/navigation/views/navigation_page.dart';
import 'package:navid_e_commerce/presentations/splash/views/splash_page.dart';

void main() {
  runApp(DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) =>const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 888),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      builder: (context, child) => GetMaterialApp(
        title: 'E-commerce',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.dark,
        initialRoute: NavigationPage.routeName,
        getPages: AppRoutes.route(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

