import 'package:flutter/material.dart'; // Importación añadida para Colors
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoProvider with ChangeNotifier {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isPlaying = false;
  String? _currentStreamUrl;

  VideoPlayerController? get videoPlayerController => _videoPlayerController;
  ChewieController? get chewieController => _chewieController;
  bool get isPlaying => _isPlaying;
  String? get currentStreamUrl => _currentStreamUrl;

  Future<void> initializePlayer(String streamUrl) async {
    _currentStreamUrl = streamUrl;

    // Dispose of previous controllers if they exist
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose(); // No usar await con dispose()
    }
    if (_chewieController != null) {
      _chewieController!.dispose(); // No usar await con dispose()
    }

    _videoPlayerController = VideoPlayerController.network(streamUrl);
    await _videoPlayerController!.initialize(); // Este sí necesita await

    // Configurar el listener correctamente
    _setupVideoListener();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: false,
      aspectRatio: _videoPlayerController!.value.aspectRatio,
      // Personalización adicional
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.yellow[700]!,
        handleColor: Colors.yellow[700]!,
        backgroundColor: Colors.grey[700]!,
        bufferedColor: Colors.grey[500]!,
      ),
      placeholder: Container(color: Colors.black),
      autoInitialize: true,
    );

    _isPlaying = true;
    notifyListeners();
  }

  // Método separado para configurar el listener
  void _setupVideoListener() {
    _videoPlayerController!.addListener(() {
      if (_videoPlayerController != null) {
        // Actualizar el estado de reproducción basado en el controlador de video
        final wasPlaying = _isPlaying;
        _isPlaying = _videoPlayerController!.value.isPlaying;

        // Solo notificar si el estado cambió
        if (wasPlaying != _isPlaying) {
          notifyListeners();
        }
      }
    });
  }

  Future<void> play() async {
    if (_chewieController != null &&
        _chewieController!.videoPlayerController.value.isInitialized) {
      await _chewieController!.play(); // Este sí necesita await
      _isPlaying = true;
      notifyListeners();
    } else if (_videoPlayerController != null &&
        _videoPlayerController!.value.isInitialized) {
      await _videoPlayerController!.play(); // Este sí necesita await
      _isPlaying = true;
      notifyListeners();
    }
  }

  Future<void> pause() async {
    if (_chewieController != null &&
        _chewieController!.videoPlayerController.value.isInitialized) {
      await _chewieController!.pause(); // Este sí necesita await
      _isPlaying = false;
      notifyListeners();
    } else if (_videoPlayerController != null &&
        _videoPlayerController!.value.isInitialized) {
      await _videoPlayerController!.pause(); // Este sí necesita await
      _isPlaying = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.removeListener(() {});
    _videoPlayerController?.dispose(); // No usar await
    _chewieController?.dispose(); // No usar await
    super.dispose();
  }
}
