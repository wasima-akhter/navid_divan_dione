import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:navid_e_commerce/core/components/custom_appbar.dart';
import 'package:navid_e_commerce/core/components/custom_drawer_widget.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/presentations/navigation/controllers/navigation_controller.dart';
import 'package:navid_e_commerce/presentations/navigation/widgets/home_app_bar_widget.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});
  static const String routeName = '/nav';
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: NavigationController.to.currentNavIndex.value == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && NavigationController.to.currentNavIndex.value != 0) {
          NavigationController.to.currentNavIndex.value = 0;
        }
      },
      child: Scaffold(
        drawer: NavigationController.to.currentNavIndex.value == 0
            ? CustomDrawerWidget()
            : null,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Obx(() {
            return NavigationController.to.currentNavIndex.value == 0
                ? Builder(builder: (context) {
                    return CustomHomeAppbar(
                      onActionTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  })
                : CustomDefaultAppbar(
                    leading: IconButton(
                        onPressed: () {
                          NavigationController.to.currentNavIndex.value = 0;
                        },
                        icon: Icon(Icons.arrow_back_rounded)),
                    title: NavigationController.to.appbarTitle[
                        NavigationController.to.currentNavIndex.value - 1],
                  );
          }),
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(() {
                return IndexedStack(
                  index: NavigationController.to.currentNavIndex.value,
                  children: NavigationController.to.getPages(),
                );
              }),
            ),
          ],
        ),
        bottomNavigationBar: Obx(() {
          return BottomNavigationBar(
            currentIndex: NavigationController.to.currentNavIndex.value,
            onTap: (value) {
              NavigationController.to.currentNavIndex.value = value;
              debugPrint(
                  NavigationController.to.currentNavIndex.value.toString());
            },
            showUnselectedLabels: true,
            backgroundColor: AppColors.kPrimaryExtraLightColor,
            items: [
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    NavigationController.to.currentNavIndex.value == 0
                        ? homeFillIcon
                        : homeOutlineIcon,
                    height: 24.w,
                    width: 24.w,
                  ),
                  label: AppStaticStrings.home),
              BottomNavigationBarItem(
                  backgroundColor: AppColors.kPrimaryExtraLightColor,
                  icon: SvgPicture.asset(
                    NavigationController.to.currentNavIndex.value == 1
                        ? cartFillIcon
                        : cartIcon,
                    height: 24.w,
                    width: 24.w,
                  ),
                  label: AppStaticStrings.cart),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    NavigationController.to.currentNavIndex.value == 2
                        ? orderFillIcon
                        : orderOutlineIcon,
                    height: 24.w,
                    width: 24.w,
                  ),
                  label: AppStaticStrings.orders),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    NavigationController.to.currentNavIndex.value == 3
                        ? notificationFillIcon
                        : notificationOutlineIcon,
                    height: 24.w,
                    width: 24.w,
                  ),
                  label: AppStaticStrings.notifications),
            ],
          );
        }),
      ),
    );
  }
}
