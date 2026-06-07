import '../../../core/export/ui_export.dart';
import '../controllers/product_controller.dart';

class ProdDetPreviewRow extends StatelessWidget {
  final ProductController controller;

  const ProdDetPreviewRow({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentPage = controller.currentPreviewPage.value;
      final bannerImages = controller.currentBannerImages;

      final videoPath = controller.productDetailsModel.value.video;

      return Row(
        children: [
          // VIDEO (always first)
          if (videoPath.isNotEmpty)
            _PreviewItem(
              isSelected: currentPage == 0,
              onTap: () => controller.pageController.value.jumpToPage(0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(color: Colors.black12),
                  const Icon(Icons.play_circle_fill, size: 26),
                ],
              ),
            ),
          8.horizontalSpace,

          if (bannerImages.isNotEmpty)

            // IMAGE PREVIEWS
            for (int i = 0; i < bannerImages.length; i++) ...[
              _PreviewItem(
                isSelected: currentPage == i + 1,
                onTap: () => controller.pageController.value.jumpToPage(i + 1),
                child: CustomNetworkImage(
                  imageUrl: "${bannerImages[i]}",
                  fit: BoxFit.cover,
                ),
              ),
              if (i != bannerImages.length - 1) 8.horizontalSpace,
            ]
          else
            Row(
              children: [
                CustomText(
                  text: "No banners available",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
        ],
      );
    });
  }
}

class _PreviewItem extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool isSelected; // new property

  const _PreviewItem({
    required this.child,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60.w,
        height: 60.w,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: child,
      ),
    );
  }
}
