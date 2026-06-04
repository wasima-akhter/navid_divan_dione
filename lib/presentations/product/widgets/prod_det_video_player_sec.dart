import 'package:better_player_plus/better_player_plus.dart';

import '../../../core/export/ui_export.dart';
import '../controllers/product_controller.dart';
/*
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
        child: Container(
            color: Colors.grey.shade50,
            child: BetterPlayer(controller: videoPlayerCtrl)),
      );
    });
  }
}
*/

class ProdDetVideoPlayerSec extends StatefulWidget {
  const ProdDetVideoPlayerSec({super.key});

  @override
  State<ProdDetVideoPlayerSec> createState() => _ProdDetVideoPlayerSecState();
}

class _ProdDetVideoPlayerSecState extends State<ProdDetVideoPlayerSec>
    with AutomaticKeepAliveClientMixin {
  // ← add this

  @override
  bool get wantKeepAlive => true; // ← add this

  @override
  Widget build(BuildContext context) {
    super.build(context); // ← required when using mixin

    final controller = ProductController.to;

    return Obx(() {
      final videoPath = controller.productDetailsModel.value.video;

      // No video available
      if (videoPath == null || videoPath.isEmpty) {
        return _VideoPlaceholder();
      }

      // Video errored out — show retry UI
      // if (controller.videoHasError.value) {
      //   return VideoErrorWidget(
      //     errorMessage: "Video could not be played",
      //     onRetry: controller.retryVideoPlayer,
      //   );
      // }

      // In ProdDetVideoPlayerSec Obx, replace the videoHasError block:
      if (controller.videoHasError.value) {
        return VideoErrorWidget(
          isUnsupported: controller.videoUnsupported.value,
          onRetry: controller.videoUnsupported.value
              ? null // no point retrying unsupported format
              : controller.retryVideoPlayer,
        );
      }

      final playerController = controller.betterPlayerController.value;

      // Still initializing
      if (playerController == null) {
        return Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(color: Colors.white),
        );
      }

      // ✅ Show player
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer(controller: playerController),
      );
    });
  }
}

// ── Placeholder when no video URL ──────────────────────────────────────────
class _VideoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.videocam_off_outlined,
                color: Colors.grey.shade900, size: 48.r),
            SizedBox(height: 8.h),
            Text(
              'No video is available',
              style: TextStyle(color: Colors.grey.shade900, fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error + Retry UI ────────────────────────────────────────────────────────

/*
class VideoErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback onRetry;

  const VideoErrorWidget({
    required this.onRetry,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.grey.shade100,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_circle_outline, color: Colors.grey, size: 48),
            const SizedBox(height: 12),
            // Text(
            //   "Video cannot be played",
            //   style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            // ),
            if (errorMessage != null) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text("Try Again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.blue.shade500,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.white30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

class VideoErrorWidget extends StatelessWidget {
  final bool isUnsupported;
  final VoidCallback? onRetry;

  const VideoErrorWidget({
    required this.isUnsupported,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isUnsupported ? Icons.videocam_off : Icons.play_circle_outline,
              color: Colors.white54,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              isUnsupported
                  ? "Video format not supported\non this device"
                  : "Video cannot be played",
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            if (isUnsupported) ...[
              const SizedBox(height: 6),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  "The video resolution is too high\nfor your device's hardware",
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text("Try Again"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white24,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.white30),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
