import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _currentStreamUrl;
  PlayerState? _playerState;

  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  String? get currentStreamUrl => _currentStreamUrl;

  AudioProvider() {
    // Escuchar los cambios de estado del reproductor
    _audioPlayer.playerStateStream.listen((PlayerState state) {
      _playerState = state;

      // Actualizar el estado de reproducción basado en el estado del reproductor
      final wasPlaying = _isPlaying;
      _isPlaying = state.playing;

      // Solo notificar si el estado cambió
      if (wasPlaying != _isPlaying) {
        notifyListeners();
      }
    });

    // Escuchar errores
    _audioPlayer.playbackEventStream.listen(
      (event) {},
      onError: (error) {
        print("Error en reproducción: $error");
        _isPlaying = false;
        notifyListeners();
      },
    );
  }

  Future<void> play(String streamUrl) async {
    try {
      _currentStreamUrl = streamUrl;

      // Si ya está reproduciendo la misma URL, solo reanudar
      if (_audioPlayer.audioSource != null && _currentStreamUrl == streamUrl) {
        await _audioPlayer.play();
      } else {
        // Configurar nueva URL
        await _audioPlayer.setUrl(streamUrl);
        await _audioPlayer.play();
      }

      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      print("Error playing audio: $e");
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  Future<void> stop() async {
    try {
      _audioPlayer.stop();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      if (_currentStreamUrl != null) {
        await play(_currentStreamUrl!);
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
