import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../providers/video_provider.dart';

class NowPlayingBar extends StatelessWidget {
  const NowPlayingBar({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final videoProvider = Provider.of<VideoProvider>(context);

    // Determinar qué está reproduciéndose actualmente
    final bool isAudioPlaying = audioProvider.isPlaying;
    final bool isVideoPlaying = videoProvider.isPlaying;

    if (!isAudioPlaying && !isVideoPlaying) {
      return SizedBox.shrink(); // No mostrar nada si no hay reproducción
    }

    final String currentTitle = isAudioPlaying
        ? "Radio Quishkambalito"
        : "TV Quishkambalito";

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(top: BorderSide(color: Colors.yellow[700]!)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            isAudioPlaying ? Icons.radio : Icons.live_tv,
            color: Colors.yellow[700],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  isAudioPlaying ? "En vivo" : "Transmisión en vivo",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isAudioPlaying
                  ? (audioProvider.isPlaying ? Icons.pause : Icons.play_arrow)
                  : (videoProvider.isPlaying ? Icons.pause : Icons.play_arrow),
              color: Colors.yellow[700],
            ),
            onPressed: () {
              if (isAudioPlaying) {
                if (audioProvider.isPlaying) {
                  audioProvider.pause();
                } else {
                  audioProvider.play(audioProvider.currentStreamUrl!);
                }
              } else {
                if (videoProvider.isPlaying) {
                  videoProvider.pause();
                } else {
                  videoProvider.play();
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
