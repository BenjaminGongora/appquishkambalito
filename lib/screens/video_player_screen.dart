import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chewie/chewie.dart'; // Importación corregida
import '../providers/video_provider.dart';
import '../models/channel.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Channel channel;

  const VideoPlayerScreen({super.key, required this.channel});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  void initState() {
    super.initState();
    // Inicializar el reproductor de video para este canal
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    videoProvider.initializePlayer(widget.channel.streamUrl);
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.channel.name),
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow[700],
      ),
      body: Center(
        child:
            videoProvider.chewieController != null &&
                videoProvider
                    .chewieController!
                    .videoPlayerController
                    .value
                    .isInitialized
            ? Chewie(
                // Ahora Chewie está correctamente importado
                controller: videoProvider.chewieController!,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.yellow[700]!,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Cargando transmisión...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
