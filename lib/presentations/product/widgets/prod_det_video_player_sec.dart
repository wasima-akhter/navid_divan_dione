import 'package:better_player_plus/better_player_plus.dart';

import '../../../core/export/ui_export.dart';
import '../controllers/product_controller.dart';

class ProdDetVideoPlayerSec extends StatelessWidget {
  const ProdDetVideoPlayerSec({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.to;
    // Initialize BetterPlayer safely after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeBetterPlayerOnce();
    });
    return Obx(() {
      final playerController = controller.betterPlayerController.value;
      if (playerController == null) {
        return const Center(child: CircularProgressIndicator());
      }
      final videoPath = ProductController.to.productDetailsModel.value.video;

      // Placeholder if no video
      if (videoPath == null || videoPath.isEmpty) {
        return SizedBox.expand(
          child: Container(
            // height: 150.h,
            // width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              image: const DecorationImage(
                image: AssetImage("assets/icons/video.png"),
                fit: BoxFit.fitHeight,
                alignment: Alignment.center,
              ),
            ),
          ),
        );
      }

      // Initialize player once
      ProductController.to.initializeBetterPlayerOnce();

      final videoPlayerCtrl = ProductController.to.betterPlayerController.value;

      if (videoPlayerCtrl == null) {
        // Still loading setup
        return SizedBox.expand(
          child: Container(
            // height: 150.h,
            // width: double.infinity,
            color: Colors.blue.shade200,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Show actual video
      return SizedBox.expand(
        child:
            Container(color: Colors.grey.shade50, child: BetterPlayer(controller: videoPlayerCtrl)),
      );
    });
  }
}
