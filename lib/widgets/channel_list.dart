import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../providers/video_provider.dart';
import '../models/channel.dart';
import '../screens/video_player_screen.dart'; // Importación añadida

class ChannelList extends StatelessWidget {
  const ChannelList({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final videoProvider = Provider.of<VideoProvider>(context);

    return ListView.builder(
      itemCount: channels.length,
      itemBuilder: (context, index) {
        final channel = channels[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.yellow[700],
            child: Icon(
              channel.type == 'audio' ? Icons.radio : Icons.live_tv,
              color: Colors.black,
            ),
          ),
          title: Text(channel.name, style: TextStyle(color: Colors.white)),
          trailing: IconButton(
            icon: Icon(
              (channel.type == 'audio'
                      ? audioProvider.isPlaying &&
                            audioProvider.currentStreamUrl == channel.streamUrl
                      : videoProvider.isPlaying &&
                            videoProvider.currentStreamUrl == channel.streamUrl)
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.yellow[700],
            ),
            onPressed: () {
              if (channel.type == 'audio') {
                if (audioProvider.isPlaying &&
                    audioProvider.currentStreamUrl == channel.streamUrl) {
                  audioProvider.pause();
                } else {
                  // Detener video si está reproduciéndose
                  if (videoProvider.isPlaying) {
                    videoProvider.pause();
                  }
                  audioProvider.play(channel.streamUrl);
                }
              } else {
                if (videoProvider.isPlaying &&
                    videoProvider.currentStreamUrl == channel.streamUrl) {
                  videoProvider.pause();
                } else {
                  // Detener audio si está reproduciéndose
                  if (audioProvider.isPlaying) {
                    audioProvider.pause();
                  }
                  videoProvider.initializePlayer(channel.streamUrl);
                }
              }
            },
          ),
          onTap: () {
            // Navegar a pantalla de reproducción completa solo para video
            if (channel.type == 'video') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    channel: channel,
                  ), // Ahora está definido
                ),
              );
            }
          },
        );
      },
    );
  }
}
