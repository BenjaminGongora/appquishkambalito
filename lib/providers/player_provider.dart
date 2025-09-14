import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:myapp/models/channel.dart';
import 'package:flutter/material.dart';

class PlayerProvider with ChangeNotifier {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  Channel? _currentChannel;
  bool _isPlaying = false;

  VideoPlayerController? get videoController => _videoController;
  ChewieController? get chewieController => _chewieController;
  Channel? get currentChannel => _currentChannel;
  bool get isPlaying => _isPlaying;

  Future<void> changeChannel(Channel channel) async {
    _currentChannel = channel;

    // Dispose previous controllers
    if (_videoController != null) {
      _videoController!.dispose();
    }
    if (_chewieController != null) {
      _chewieController!.dispose();
    }

    // Initialize new video controller
    _videoController = VideoPlayerController.network(channel.streamUrl);

    try {
      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoController!.value.aspectRatio,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFFF7931E),
          handleColor: const Color(0xFFF7931E),
          backgroundColor: const Color(0xFFB3B3B3),
          bufferedColor: const Color(0xFF666666),
        ),
        placeholder: Container(color: const Color(0xFF121212)),
        autoInitialize: true,
        showControls: true,
      );

      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      print('Error changing channel: $e');
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> play() async {
    if (_chewieController != null) {
      await _chewieController!.play();
      _isPlaying = true;
      notifyListeners();
    }
  }

  Future<void> pause() async {
    if (_chewieController != null) {
      await _chewieController!.pause();
      _isPlaying = false;
      notifyListeners();
    }
  }

  void togglePlayPause() {
    if (_isPlaying) {
      pause();
    } else {
      play();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
