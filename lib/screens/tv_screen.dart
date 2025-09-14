import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chewie/chewie.dart';
import 'package:myapp/theme/colors.dart';
import 'package:myapp/models/channel.dart';
import 'package:myapp/providers/player_provider.dart';
import 'package:myapp/widgets/video_thumbnail.dart';

class TvScreen extends StatefulWidget {
  const TvScreen({super.key});

  @override
  State<TvScreen> createState() => _TvScreenState();
}

class _TvScreenState extends State<TvScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final playerProvider = Provider.of<PlayerProvider>(
        context,
        listen: false,
      );
      if (playerProvider.currentChannel == null && tvChannels.isNotEmpty) {
        playerProvider.changeChannel(tvChannels.first);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // AppBar con gradiente
          SliverAppBar(
            expandedHeight: 70,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'TV Quishkambalito',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryBlue.withOpacity(0.9),
                      AppColors.darkBackground.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Reproductor principal
          SliverToBoxAdapter(child: _buildVideoPlayer(playerProvider)),

          // Separador
          SliverToBoxAdapter(
            child: Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: AppColors.primaryBlue.withOpacity(0.3),
            ),
          ),

          // Header de canales
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Text(
                    'CANALES DISPONIBLES',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${tvChannels.length}',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Lista de canales estilo bacán
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final channel = tvChannels[index];
              final isCurrent = playerProvider.currentChannel?.id == channel.id;
              return _buildChannelListItem(
                context,
                channel,
                isCurrent,
                playerProvider,
              );
            }, childCount: tvChannels.length),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(PlayerProvider playerProvider) {
    return Container(
      height: 220,
      color: Colors.black,
      child: Stack(
        children: [
          // Video principal
          if (playerProvider.chewieController != null &&
              playerProvider
                  .chewieController!
                  .videoPlayerController
                  .value
                  .isInitialized)
            Chewie(controller: playerProvider.chewieController!)
          else
            _buildLoadingPlayer(),

          // Overlay de gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.8), Colors.transparent],
              ),
            ),
          ),

          // Información del canal actual
          if (playerProvider.currentChannel != null)
            Positioned(
              left: 16,
              bottom: 16,
              child: _buildCurrentChannelInfo(playerProvider.currentChannel!),
            ),

          // Botones de control
          Positioned(
            right: 16,
            bottom: 16,
            child: _buildControlButtons(playerProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingPlayer() {
    return Container(
      color: AppColors.darkBackground,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            ),
            const SizedBox(height: 16),
            Text(
              'Cargando transmisión...',
              style: TextStyle(color: AppColors.greyText, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentChannelInfo(Channel channel) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Indicador de live
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'EN VIVO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            channel.name,
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons(PlayerProvider playerProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Botón de play/pause
          IconButton(
            icon: Icon(
              playerProvider.isPlaying
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              color: AppColors.white,
              size: 24,
            ),
            onPressed: playerProvider.togglePlayPause,
          ),
        ],
      ),
    );
  }

  Widget _buildChannelListItem(
    BuildContext context,
    Channel channel,
    bool isCurrent,
    PlayerProvider playerProvider,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppColors.primaryBlue.withOpacity(0.15)
            : AppColors.cardDark,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isCurrent ? AppColors.primaryBlue : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => playerProvider.changeChannel(channel),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Miniatura del canal
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryBlue.withOpacity(0.1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: VideoThumbnail(
                      videoUrl: channel.streamUrl,
                      showPlayIcon: false,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Información del canal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        channel.name,
                        style: TextStyle(
                          color: isCurrent
                              ? AppColors.primaryBlue
                              : AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Transmisión en vivo • Canal TV',
                        style: TextStyle(
                          color: isCurrent
                              ? AppColors.primaryBlue.withOpacity(0.8)
                              : AppColors.greyText,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Barra de progreso estilo Spotify
                      Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.greyText.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Stack(
                          children: [
                            // Progreso reproducido
                            Container(
                              height: 3,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                color: isCurrent
                                    ? AppColors.primaryBlue
                                    : AppColors.accentOrange,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Indicador y botón
                Column(
                  children: [
                    if (isCurrent)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'EN VIVO',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      Icon(
                        Icons.play_circle_fill_rounded,
                        color: AppColors.primaryBlue,
                        size: 30,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
