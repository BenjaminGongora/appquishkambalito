import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _currentStreamUrl;

  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  String? get currentStreamUrl => _currentStreamUrl;

  AudioProvider() {
    // Escuchar los cambios de estado del reproductor
    _audioPlayer.playerStateStream.listen((playerState) {
      final wasPlaying = _isPlaying;
      _isPlaying = playerState.playing;
      
      // Solo notificar si el estado cambió
      if (wasPlaying != _isPlaying) {
        notifyListeners();
      }
    });

    // Escuchar errores
    _audioPlayer.playbackEventStream.listen((event) {}, 
      onError: (error) {
        print("Error en audio: $error");
        _isPlaying = false;
        notifyListeners();
      });
  }

  Future<void> play(String streamUrl) async {
    try {
      _currentStreamUrl = streamUrl;
      
      if (_audioPlayer.playing) {
        await _audioPlayer.stop();
      }
      
      await _audioPlayer.setUrl(streamUrl);
      await _audioPlayer.play();
      // _isPlaying se actualizará automáticamente por el listener
      
    } catch (e) {
      print("Error playing audio: $e");
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      // _isPlaying se actualizará automáticamente por el listener
    } catch (e) {
      print("Error pausing audio: $e");
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      // _isPlaying se actualizará automáticamente por el listener
    } catch (e) {
      print("Error stopping audio: $e");
      _isPlaying = false;
      notifyListeners();
    }
  }

  void togglePlayPause() {
    if (_isPlaying) {
      pause();
    } else {
      if (_currentStreamUrl != null) {
        play(_currentStreamUrl!);
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}