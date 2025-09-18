import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chewie/chewie.dart';
import 'package:myapp/theme/colors.dart';
import 'package:myapp/models/channel.dart';
import 'package:myapp/providers/player_provider.dart';
import 'package:myapp/widgets/video_thumbnail.dart';
import 'package:myapp/providers/chat_provider.dart';
import 'package:myapp/screens/live_chat_screen.dart';

import '../models/chat_message.dart';

class TvScreen extends StatefulWidget {
  const TvScreen({super.key});

  @override
  State<TvScreen> createState() => _TvScreenState();
}

class _TvScreenState extends State<TvScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showChat = false;

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

  void _toggleChat() {
    setState(() {
      _showChat = !_showChat;
    });
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text(
          'TV Quishkambalito',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        actions: [
          // Botón de alternancia en el AppBar
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: _showChat
                  ? AppColors.accentOrange
                  : AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _toggleChat,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        _showChat ? Icons.tv_rounded : Icons.chat_rounded,
                        color: AppColors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _showChat ? 'Canales' : 'Chat',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Video player fijo en la parte superior
          _buildVideoPlayer(playerProvider),

          // Separador
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: AppColors.primaryBlue.withOpacity(0.3),
          ),

          // Header de sección
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _showChat ? '' : 'CANALES DISPONIBLES',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                if (!_showChat)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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

          // Contenido dinámico (lista de canales o chat)
          Expanded(
            child: _showChat
                ? _buildChatContent()
                : _buildChannelsList(playerProvider),
          ),
        ],
      ),
    );
  }

  // Widget para construir el contenido del chat
  Widget _buildChatContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            // Header del chat mejorado
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryBlue,
                    AppColors.primaryBlue.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chat_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chat en Vivo',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Consumer<ChatProvider>(
                        builder: (context, chatProvider, child) {
                          return Text(
                            '${chatProvider.messages.length} mensajes • ${chatProvider.isAuthenticated ? 'Conectado' : 'Desconectado'}',
                            style: TextStyle(
                              color: AppColors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.5),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Contenido del chat - Versión personalizada sin header
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.darkBackground,
                ),
                child: _buildCustomChatScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Versión personalizada del LiveChatScreen sin header
  Widget _buildCustomChatScreen() {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        if (chatProvider.isLoading) {
          return _buildChatLoading();
        }

        if (!chatProvider.isAuthenticated) {
          return _buildChatLogin(context, chatProvider);
        }

        return _buildChatMessages(chatProvider);
      },
    );
  }

  Widget _buildChatLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
          ),
          const SizedBox(height: 16),
          Text('Cargando chat...', style: TextStyle(color: AppColors.greyText)),
        ],
      ),
    );
  }

  Widget _buildChatLogin(BuildContext context, ChatProvider chatProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_rounded, size: 60, color: AppColors.primaryBlue),
            const SizedBox(height: 20),
            Text(
              'Únete a la conversación',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Inicia sesión para participar en el chat en vivo',
              style: TextStyle(color: AppColors.greyText, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => chatProvider.signInWithGoogle(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Iniciar sesión con Google'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessages(ChatProvider chatProvider) {
    final messageController = TextEditingController();
    final scrollController = ScrollController();

    return Column(
      children: [
        // Lista de mensajes
        Expanded(
          child: chatProvider.messages.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.forum_rounded,
                  size: 60,
                  color: AppColors.primaryBlue.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay mensajes aún',
                  style: TextStyle(
                    color: AppColors.greyText,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Sé el primero en enviar un mensaje',
                  style: TextStyle(
                    color: AppColors.greyText.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
              : ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: chatProvider.messages.length,
            itemBuilder: (context, index) {
              return _buildMessageItem(chatProvider.messages[index], chatProvider);
            },
          ),
        ),

        // Input de mensaje con botón de logout integrado
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            border: Border(
              top: BorderSide(color: AppColors.primaryBlue.withOpacity(0.3)),
            ),
          ),
          child: Row(
            children: [
              // Botón de logout
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: Icon(Icons.exit_to_app, color: Colors.red, size: 20),
                  onPressed: () => chatProvider.signOut(),
                  tooltip: 'Cerrar sesión',
                ),
              ),
              const SizedBox(width: 8),

              // Campo de texto
              Expanded(
                child: TextField(
                  controller: messageController,
                  style: TextStyle(color: AppColors.white),
                  decoration: InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    hintStyle: TextStyle(color: AppColors.greyText),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.darkBackground,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      chatProvider.sendMessage(value.trim());
                      messageController.clear();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),

              // Botón de enviar
              CircleAvatar(
                backgroundColor: AppColors.primaryBlue,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  onPressed: () {
                    final text = messageController.text.trim();
                    if (text.isNotEmpty) {
                      chatProvider.sendMessage(text);
                      messageController.clear();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageItem(ChatMessage message, ChatProvider chatProvider) {
    final isCurrentUser = message.userId == chatProvider.currentUser?.uid;
    final currentTime = DateTime.now();
    final messageTime = message.timestamp;
    final difference = currentTime.difference(messageTime);

    String timeText;
    if (difference.inMinutes < 1) {
      timeText = 'Ahora';
    } else if (difference.inMinutes < 60) {
      timeText = 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      timeText = 'Hace ${difference.inHours} h';
    } else {
      timeText = '${messageTime.day}/${messageTime.month}';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser)
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryBlue.withOpacity(0.2),
              backgroundImage: message.userAvatar.isNotEmpty
                  ? NetworkImage(message.userAvatar)
                  : null,
              child: message.userAvatar.isEmpty
                  ? Text(
                message.userName[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.white,
                ),
              )
                  : null,
            ),
          if (!isCurrentUser) const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isCurrentUser)
                  Text(
                    message.userName,
                    style: TextStyle(color: AppColors.greyText, fontSize: 12),
                  ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? AppColors.primaryBlue
                        : AppColors.cardDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isCurrentUser
                          ? AppColors.white
                          : AppColors.greyText,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeText,
                  style: TextStyle(
                    color: AppColors.greyText.withOpacity(0.6),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          if (isCurrentUser) const SizedBox(width: 8),
          if (isCurrentUser)
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.accentOrange.withOpacity(0.2),
              backgroundImage: chatProvider.currentUser?.photoURL != null
                  ? NetworkImage(chatProvider.currentUser!.photoURL!)
                  : null,
              child: chatProvider.currentUser?.photoURL == null
                  ? Text(
                chatProvider.currentUser?.displayName?[0].toUpperCase() ?? 'U',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.white,
                ),
              )
                  : null,
            ),
        ],
      ),
    );
  }

  // Widget para construir la lista de canales
  Widget _buildChannelsList(PlayerProvider playerProvider) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: tvChannels.length,
      itemBuilder: (context, index) {
        final channel = tvChannels[index];
        final isCurrent = playerProvider.currentChannel?.id == channel.id;
        return _buildChannelListItem(
          context,
          channel,
          isCurrent,
          playerProvider,
        );
      },
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
      margin: const EdgeInsets.only(bottom: 12),
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