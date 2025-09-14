import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:myapp/theme/colors.dart';

class VideoThumbnail extends StatefulWidget {
  final String videoUrl;
  final double? width;
  final double? height;
  final bool showPlayIcon;
  final bool isListStyle;

  const VideoThumbnail({
    super.key,
    required this.videoUrl,
    this.width,
    this.height,
    this.showPlayIcon = false,
    this.isListStyle = true,
  });

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.network(widget.videoUrl);

    try {
      await _controller!.initialize();
      _controller!.setVolume(0);
      _controller!.setLooping(true);

      if (mounted) {
        setState(() => _isInitialized = true);
      }

      await _controller!.play();
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) await _controller!.pause();
    } catch (e) {
      if (mounted) setState(() => _isInitialized = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(widget.isListStyle ? 10 : 8),
      ),
      child: Stack(
        children: [
          // Video o placeholder
          _isInitialized && _controller != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(
                    widget.isListStyle ? 10 : 8,
                  ),
                  child: VideoPlayer(_controller!),
                )
              : _buildPlaceholder(),

          // Overlay de gradiente para lista
          if (widget.isListStyle)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                ),
              ),
            ),

          // Icono de play
          if (widget.showPlayIcon)
            Center(
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: widget.isListStyle ? 20 : 24,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(widget.isListStyle ? 10 : 8),
      ),
      child: Center(
        child: Icon(
          Icons.live_tv_rounded,
          color: AppColors.primaryBlue,
          size: widget.isListStyle ? 24 : 30,
        ),
      ),
    );
  }
}
