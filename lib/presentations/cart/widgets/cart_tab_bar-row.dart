import '../../../core/constants/text_style_constant.dart';
import '../../../core/export/ui_export.dart';
import '../controllers/cart_controller.dart';

class CartTabBarRow extends StatelessWidget {
  final CartController controller;
  const CartTabBarRow({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Items tab
          Expanded(
            child: Obx(() {
              final isSelected = controller.selectedTab.value == 0;
              return GestureDetector(
                onTap: () => controller.selectTab(0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.kPrimaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: CustomText(
                      text: "Items",
                      color: isSelected ? Colors.white : AppColors.kPrimaryColor,
                      fontSize: getFontSizeSmall(),
                      style: poppinsSemiBold,
                    ),
                  ),
                ),
              );
            }),
          ),

          // Summary tab
          Expanded(
            child: Obx(() {
              final isSelected = controller.selectedTab.value == 1;
              return GestureDetector(
                onTap: () => controller.selectTab(1),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.kPrimaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: CustomText(
                      text: "Summary & Checkout",
                      color: isSelected ? Colors.white : AppColors.kPrimaryColor,
                      fontSize: getFontSizeSmall(),
                      style: poppinsSemiBold,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
