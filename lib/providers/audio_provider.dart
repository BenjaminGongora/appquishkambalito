import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _currentStreamUrl;

  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  String? get currentStreamUrl => _currentStreamUrl;

  Future<void> play(String streamUrl) async {
    try {
      _currentStreamUrl = streamUrl;
      await _audioPlayer.setUrl(streamUrl);
      await _audioPlayer.play();
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      print("Error playing audio: $e");
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
      await _audioPlayer.stop();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
