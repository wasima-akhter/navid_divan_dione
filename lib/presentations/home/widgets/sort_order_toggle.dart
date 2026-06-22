import '../../../core/export/ui_export.dart';

class SortOrderToggle extends StatelessWidget {
  final RxString sortOrder;
  final VoidCallback onToggle;

  const SortOrderToggle({
    super.key,
    required this.sortOrder,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDesc = sortOrder.value == 'dsc';

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onToggle,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
                color: AppColors.kPrimaryColor.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDesc
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                size: 16.sp,
                color: AppColors.kPrimaryColor,
              ),
              4.horizontalSpace,
              CustomText(
                text: isDesc ? 'Newest' : 'Oldest',
                fontSize: 11.sp,
                color: AppColors.kPrimaryColor,
              ),
            ],
          ),
        ),
      );
    });
  }
}
