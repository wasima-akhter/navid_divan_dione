import '../../../core/components/custom_button.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/constants/padding_constant.dart';
import '../../../core/constants/text_style_constant.dart';
import '../../../core/export/ui_export.dart';

class NoProductWidget extends StatelessWidget {
  final String searchQuery;
  final String? selectedCategory;
  final String? selectedSubCategory;
  final Rx<TextEditingController> searchController;
  final void Function({
    String? category,
    String? subCategory,
    String? search,
  }) applyFilters;
  const NoProductWidget(
      {required this.searchQuery,
      this.selectedCategory,
      this.selectedSubCategory,
      required this.searchController,
      required this.applyFilters});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding12V,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12.h,
          children: [
            Image.asset(
              emptyListImg, // ✅ replace with your actual asset path
              height: 1.sw * 0.22,
              width: 1.sw * 0.22,
            ),
            CustomText(
              text: 'No products found',
              style: poppinsMedium,
              fontSize: getFontSizeDefault(),
              color: AppColors.kPrimaryTextDarkColor,
            ),
            CustomText(
              text: 'Try adjusting your search or filters',
              style: poppinsRegular,
              fontSize: getFontSizeSmall(),
              color: AppColors.kExtraLightGreyTextColor,
            ),

            2.verticalSpace,
            // ✅ Reset button — only show if filters/search are active
            Builder(builder: (context) {
              final hasFilter =
                  searchQuery.isNotEmpty || selectedCategory != null || selectedSubCategory != null;

              if (!hasFilter) return const SizedBox.shrink();

              return CustomButton(
                onTap: () {
                  searchController.value.clear();
                  applyFilters(
                    search: '',
                    category: null,
                    subCategory: null,
                  );
                },
                title: 'Reset Filters',
                fillColor: AppColors.kPrimaryColor,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                marginHorizontal: 1.sw * 0.2,
              );
            }),
          ],
        ),
      ),
    );
  }
}
