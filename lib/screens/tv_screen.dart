import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:myapp/theme/colors.dart';
import 'package:myapp/models/channel.dart';
import 'package:myapp/providers/player_provider.dart';
import 'package:myapp/widgets/video_thumbnail.dart';
import 'package:myapp/providers/chat_provider.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/screens/radio_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/chat_message.dart';

class TvScreen extends StatefulWidget {
  const TvScreen({super.key});

  @override
  State<TvScreen> createState() => _TvScreenState();
}

class _TvScreenState extends State<TvScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showChat = false;
  int _currentIndex = 2; // Índice 2 para TV
  bool _isWeb = kIsWeb;

  // Colores estilo red social
  final Color _primaryColor = Color(0xFF0099FF);
  final Color _secondaryColor = Color(0xFFFFD600);
  final Color _backgroundColor = Color(0xFFF8F9FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF1C1E21);
  final Color _greyText = Color(0xFF65676B);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final playerProvider = Provider.of<PlayerProvider>(
        context,
        listen: false,
      );
      // Solo inicializar si no es web o si hay canales compatibles
      if (!_isWeb || _hasCompatibleChannels()) {
        _initializeFirstChannel(playerProvider);
      }
    });
  }

  bool _hasCompatibleChannels() {
    // En web, solo usar canales con formatos compatibles (MP4, WebM)
    return tvChannels.any((channel) => _isWebCompatible(channel.streamUrl));
  }

  bool _isWebCompatible(String url) {
    // En web, solo formatos directos como MP4, WebM
    if (_isWeb) {
      return url.toLowerCase().endsWith('.mp4') ||
          url.toLowerCase().endsWith('.webm') ||
          url.toLowerCase().endsWith('.ogg');
    }
    return true; // En móvil, todos los formatos son compatibles
  }

  List<Channel> get _compatibleChannels {
    if (_isWeb) {
      return tvChannels.where((channel) => _isWebCompatible(channel.streamUrl)).toList();
    }
    return tvChannels;
  }

  void _initializeFirstChannel(PlayerProvider playerProvider) async {
    final compatibleChannels = _compatibleChannels;
    if (compatibleChannels.isNotEmpty) {
      final firstChannel = compatibleChannels.first;

      // Solo cambiar canal si es diferente al actual
      if (playerProvider.currentChannel?.id != firstChannel.id) {
        try {
          await playerProvider.changeChannel(firstChannel);

          // Reproducir automáticamente después de un breve delay
          await Future.delayed(Duration(milliseconds: 1000));
          if (!playerProvider.isPlaying && playerProvider.chewieController != null) {
            playerProvider.play();
          }
        } catch (e) {
          print('Error inicializando canal: $e');
          _showErrorSnackbar('Error al cargar el canal: ${firstChannel.name}');
        }
      }
    } else if (_isWeb) {
      _showErrorSnackbar('No hay canales compatibles disponibles para web');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
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

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RadioScreen()),
        );
        break;
      case 2:
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 1024;

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          'TV en Vivo',
          style: TextStyle(
            color: _textColor,
            fontSize: isDesktop ? 20.0 : 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: _textColor,
        elevation: 1.0,
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: isDesktop ? 20.0 : 16.0),
            decoration: BoxDecoration(
              color: _showChat ? _primaryColor : _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _toggleChat,
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 20.0 : 16.0,
                    vertical: isDesktop ? 10.0 : 8.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _showChat ? Icons.live_tv_rounded : Icons.chat_rounded,
                        color: _showChat ? Colors.white : _primaryColor,
                        size: isDesktop ? 20.0 : 18.0,
                      ),
                      SizedBox(width: isDesktop ? 8.0 : 6.0),
                      Text(
                        _showChat ? 'TV' : 'Chat',
                        style: TextStyle(
                          color: _showChat ? Colors.white : _primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: isDesktop ? 16.0 : 14.0,
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
          _buildVideoPlayer(playerProvider, isDesktop),

          // Separador
          Container(
            height: 1.0,
            margin: EdgeInsets.symmetric(horizontal: isDesktop ? 24.0 : 16.0),
            color: _primaryColor.withOpacity(0.2),
          ),

          // Header de sección
          Container(
            padding: EdgeInsets.fromLTRB(
                isDesktop ? 24.0 : 16.0,
                isDesktop ? 20.0 : 16.0,
                isDesktop ? 24.0 : 16.0,
                isDesktop ? 12.0 : 8.0
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _showChat ? '' : 'CANALES DISPONIBLES',
                  style: TextStyle(
                    color: _primaryColor,
                    fontSize: isDesktop ? 20.0 : 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                if (!_showChat)
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 12.0 : 8.0,
                        vertical: isDesktop ? 4.0 : 2.0
                    ),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      '${_compatibleChannels.length}',
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: isDesktop ? 14.0 : 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Advertencia para web
          if (_isWeb && _compatibleChannels.isEmpty)
            _buildWebWarning(),

          // Contenido dinámico (lista de canales o chat)
          Expanded(
            child: _showChat
                ? _buildChatContent(isDesktop)
                : _buildChannelsList(playerProvider, isDesktop),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: _primaryColor,
        unselectedItemColor: _greyText,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.radio),
            label: 'Radio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: 'TV',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildWebWarning() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange, size: 24.0),
          SizedBox(width: 12.0),
          Expanded(
            child: Text(
              'En la versión web, solo están disponibles canales con formato MP4/WebM. Para ver todos los canales, usa la app móvil.',
              style: TextStyle(
                color: Colors.orange[800],
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(PlayerProvider playerProvider, bool isDesktop) {
    return Container(
      height: isDesktop ? 280.0 : 220.0,
      color: Colors.black,
      child: Stack(
        children: [
          // Video principal con mejor manejo de estado
          _buildVideoContent(playerProvider),

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
              left: isDesktop ? 20.0 : 16.0,
              bottom: isDesktop ? 20.0 : 16.0,
              child: _buildCurrentChannelInfo(playerProvider.currentChannel!, isDesktop),
            ),

          // Botones de control
          if (playerProvider.chewieController != null)
            Positioned(
              right: isDesktop ? 20.0 : 16.0,
              bottom: isDesktop ? 20.0 : 16.0,
              child: _buildControlButtons(playerProvider, isDesktop),
            ),

          // Indicador de compatibilidad web
          if (_isWeb && playerProvider.currentChannel != null &&
              !_isWebCompatible(playerProvider.currentChannel!.streamUrl))
            _buildCompatibilityWarning(),
        ],
      ),
    );
  }

  Widget _buildCompatibilityWarning() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 50.0),
                SizedBox(height: 10.0),
                Text(
                  'Formato no compatible',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Este canal no es compatible con la versión web.\nUsa la app móvil para ver este contenido.',
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoContent(PlayerProvider playerProvider) {
    if (playerProvider.chewieController != null &&
        playerProvider.chewieController!.videoPlayerController.value.isInitialized) {

      // Verificar compatibilidad web
      if (_isWeb && playerProvider.currentChannel != null) {
        if (!_isWebCompatible(playerProvider.currentChannel!.streamUrl)) {
          return _buildCompatibilityWarning();
        }
      }

      return Chewie(controller: playerProvider.chewieController!);
    } else {
      return _buildLoadingPlayer();
    }
  }

  Widget _buildLoadingPlayer() {
    return Container(
      color: _backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
            ),
            SizedBox(height: 16.0),
            Text(
              _isWeb ? 'Cargando video compatible...' : 'Cargando transmisión...',
              style: TextStyle(color: _greyText, fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }

  // ... (el resto de los métodos se mantienen igual, solo actualizo _buildChannelsList)

  Widget _buildChannelsList(PlayerProvider playerProvider, bool isDesktop) {
    final compatibleChannels = _compatibleChannels;

    if (compatibleChannels.isEmpty) {
      return _buildNoChannelsAvailable();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 24.0 : 16.0,
          vertical: isDesktop ? 12.0 : 8.0
      ),
      itemCount: compatibleChannels.length,
      itemBuilder: (context, index) {
        final channel = compatibleChannels[index];
        final isCurrent = playerProvider.currentChannel?.id == channel.id;
        final isCompatible = _isWebCompatible(channel.streamUrl);

        return _buildChannelListItem(
          context,
          channel,
          isCurrent,
          isCompatible,
          playerProvider,
          isDesktop,
        );
      },
    );
  }

  Widget _buildNoChannelsAvailable() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.live_tv_rounded, size: 80.0, color: _greyText.withOpacity(0.5)),
          SizedBox(height: 20.0),
          Text(
            _isWeb ? 'No hay canales compatibles' : 'No hay canales disponibles',
            style: TextStyle(
              color: _greyText,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            _isWeb
                ? 'Los canales requieren formato MP4/WebM para la versión web'
                : 'No se encontraron canales de TV',
            style: TextStyle(color: _greyText, fontSize: 14.0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChannelListItem(
      BuildContext context,
      Channel channel,
      bool isCurrent,
      bool isCompatible,
      PlayerProvider playerProvider,
      bool isDesktop,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: isDesktop ? 16.0 : 12.0),
      decoration: BoxDecoration(
        color: isCurrent ? _primaryColor.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: isCurrent ? _primaryColor : Colors.transparent,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.0,
            offset: Offset(0, 3.0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isCompatible ? () async {
            try {
              await playerProvider.changeChannel(channel);
              // Reproducir automáticamente al cambiar de canal
              await Future.delayed(Duration(milliseconds: 500));
              if (!playerProvider.isPlaying && playerProvider.chewieController != null) {
                playerProvider.play();
              }
            } catch (e) {
              print('Error cambiando canal: $e');
              _showErrorSnackbar('Error al cargar el canal: ${channel.name}');
            }
          } : null,
          borderRadius: BorderRadius.circular(20.0),
          child: Opacity(
            opacity: isCompatible ? 1.0 : 0.6,
            child: Padding(
              padding: EdgeInsets.all(isDesktop ? 20.0 : 16.0),
              child: Row(
                children: [
                  // Miniatura del canal
                  Container(
                    width: isDesktop ? 70.0 : 60.0,
                    height: isDesktop ? 70.0 : 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: _primaryColor.withOpacity(0.1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: isCompatible
                          ? VideoThumbnail(
                        videoUrl: channel.streamUrl,
                        showPlayIcon: false,
                      )
                          : Icon(Icons.error_outline, color: _greyText, size: 30.0),
                    ),
                  ),
                  SizedBox(width: isDesktop ? 20.0 : 16.0),

                  // Información del canal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          channel.name,
                          style: TextStyle(
                            color: isCurrent ? _primaryColor : _textColor,
                            fontSize: isDesktop ? 18.0 : 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6.0),
                        Text(
                          isCompatible ? 'Transmisión en vivo • Canal TV' : 'No compatible con web',
                          style: TextStyle(
                            color: isCurrent ? _primaryColor.withOpacity(0.8) : _greyText,
                            fontSize: isDesktop ? 13.0 : 12.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        // Barra de progreso
                        Container(
                          height: 3.0,
                          decoration: BoxDecoration(
                            color: _greyText.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: 3.0,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  color: isCurrent ? _primaryColor : _secondaryColor,
                                  borderRadius: BorderRadius.circular(2.0),
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
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 12.0 : 8.0,
                            vertical: isDesktop ? 6.0 : 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: _primaryColor,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            'EN VIVO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? 12.0 : 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else if (isCompatible)
                        Icon(
                          Icons.play_circle_fill_rounded,
                          color: _primaryColor,
                          size: isDesktop ? 32.0 : 30.0,
                        )
                      else
                        Icon(
                          Icons.block,
                          color: Colors.red,
                          size: isDesktop ? 32.0 : 30.0,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  // Widget para construir el contenido del chat
  Widget _buildChatContent(bool isDesktop) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: isDesktop ? 24.0 : 16.0,
          vertical: isDesktop ? 12.0 : 8.0
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: Offset(0, 5.0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Column(
          children: [
            // Header del chat
            Container(
              padding: EdgeInsets.all(isDesktop ? 20.0 : 16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.chat_rounded, color: Colors.white, size: isDesktop ? 24.0 : 20.0),
                  ),
                  SizedBox(width: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chat en Vivo - TV',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isDesktop ? 18.0 : 16.0,
                        ),
                      ),
                      SizedBox(height: 2.0),
                      Consumer<ChatProvider>(
                        builder: (context, chatProvider, child) {
                          return Text(
                            '${chatProvider.messages.length} mensajes • ${chatProvider.isAuthenticated ? 'Conectado' : 'Desconectado'}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: isDesktop ? 13.0 : 11.0,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    width: 12.0,
                    height: 12.0,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.5),
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Contenido del chat
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _backgroundColor,
                ),
                child: _buildCustomChatScreen(isDesktop),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Versión personalizada del LiveChatScreen
  Widget _buildCustomChatScreen(bool isDesktop) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        if (chatProvider.isLoading) {
          return _buildChatLoading(isDesktop);
        }

        if (!chatProvider.isAuthenticated) {
          return _buildChatLogin(context, chatProvider, isDesktop);
        }

        return _buildChatMessages(chatProvider, isDesktop);
      },
    );
  }

  Widget _buildChatLoading(bool isDesktop) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
          ),
          SizedBox(height: 16.0),
          Text(
            'Cargando chat...',
            style: TextStyle(
              color: _greyText,
              fontSize: isDesktop ? 16.0 : 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatLogin(BuildContext context, ChatProvider chatProvider, bool isDesktop) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 30.0 : 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_rounded, size: isDesktop ? 70.0 : 60.0, color: _primaryColor),
            SizedBox(height: 20.0),
            Text(
              'Únete a la conversación',
              style: TextStyle(
                color: _textColor,
                fontSize: isDesktop ? 20.0 : 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Inicia sesión para participar en el chat en vivo de la TV',
              style: TextStyle(
                color: _greyText,
                fontSize: isDesktop ? 15.0 : 14.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () => chatProvider.signInWithGoogle(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 35.0 : 30.0,
                  vertical: isDesktop ? 16.0 : 15.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: Text(
                'Iniciar sesión con Google',
                style: TextStyle(fontSize: isDesktop ? 16.0 : 14.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessages(ChatProvider chatProvider, bool isDesktop) {
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
                  size: isDesktop ? 70.0 : 60.0,
                  color: _primaryColor.withOpacity(0.4),
                ),
                SizedBox(height: 16.0),
                Text(
                  'No hay mensajes aún',
                  style: TextStyle(
                    color: _greyText,
                    fontSize: isDesktop ? 17.0 : 16.0,
                  ),
                ),
                Text(
                  'Sé el primero en enviar un mensaje',
                  style: TextStyle(
                    color: _greyText.withOpacity(0.7),
                    fontSize: isDesktop ? 14.0 : 13.0,
                  ),
                ),
              ],
            ),
          )
              : ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.all(isDesktop ? 20.0 : 16.0),
            itemCount: chatProvider.messages.length,
            itemBuilder: (context, index) {
              return _buildMessageItem(chatProvider.messages[index], chatProvider, isDesktop);
            },
          ),
        ),

        // Input de mensaje
        Container(
          padding: EdgeInsets.all(isDesktop ? 16.0 : 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: _primaryColor.withOpacity(0.2)),
            ),
          ),
          child: Row(
            children: [
              // Botón de logout
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: IconButton(
                  icon: Icon(Icons.exit_to_app, color: Colors.red, size: isDesktop ? 22.0 : 20.0),
                  onPressed: () => chatProvider.signOut(),
                  tooltip: 'Cerrar sesión',
                ),
              ),
              SizedBox(width: 8.0),

              // Campo de texto
              Expanded(
                child: TextField(
                  controller: messageController,
                  style: TextStyle(color: _textColor),
                  decoration: InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    hintStyle: TextStyle(color: _greyText),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: _backgroundColor,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 20.0 : 16.0,
                      vertical: isDesktop ? 16.0 : 12.0,
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      chatProvider.sendMessage(value.trim());
                      messageController.clear();
                    }
                  },
                ),
              ),
              SizedBox(width: 8.0),

              // Botón de enviar
              CircleAvatar(
                backgroundColor: _primaryColor,
                radius: isDesktop ? 24.0 : 20.0,
                child: IconButton(
                  icon: Icon(Icons.send, color: Colors.white, size: isDesktop ? 22.0 : 18.0),
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

  Widget _buildMessageItem(ChatMessage message, ChatProvider chatProvider, bool isDesktop) {
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
      margin: EdgeInsets.only(bottom: isDesktop ? 16.0 : 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser)
            CircleAvatar(
              radius: isDesktop ? 18.0 : 16.0,
              backgroundColor: _primaryColor.withOpacity(0.1),
              backgroundImage: message.userAvatar.isNotEmpty
                  ? NetworkImage(message.userAvatar)
                  : null,
              child: message.userAvatar.isEmpty
                  ? Text(
                message.userName[0].toUpperCase(),
                style: TextStyle(
                  fontSize: isDesktop ? 14.0 : 12.0,
                  color: _primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : null,
            ),
          if (!isCurrentUser) SizedBox(width: isDesktop ? 12.0 : 8.0),

          Expanded(
            child: Column(
              crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isCurrentUser)
                  Text(
                    message.userName,
                    style: TextStyle(
                      color: _greyText,
                      fontSize: isDesktop ? 13.0 : 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (!isCurrentUser) SizedBox(height: 4.0),
                Container(
                  padding: EdgeInsets.all(isDesktop ? 14.0 : 12.0),
                  decoration: BoxDecoration(
                    color: isCurrentUser ? _primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    border: isCurrentUser ? null : Border.all(color: _greyText.withOpacity(0.2)),
                    boxShadow: isCurrentUser
                        ? [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.2),
                        blurRadius: 8.0,
                        offset: Offset(0, 2.0),
                      ),
                    ]
                        : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4.0,
                        offset: Offset(0, 1.0),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : _textColor,
                      fontSize: isDesktop ? 15.0 : 14.0,
                    ),
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  timeText,
                  style: TextStyle(
                    color: _greyText.withOpacity(0.6),
                    fontSize: isDesktop ? 11.0 : 10.0,
                  ),
                ),
              ],
            ),
          ),

          if (isCurrentUser) SizedBox(width: isDesktop ? 12.0 : 8.0),
          if (isCurrentUser)
            CircleAvatar(
              radius: isDesktop ? 18.0 : 16.0,
              backgroundColor: _secondaryColor.withOpacity(0.1),
              backgroundImage: chatProvider.currentUser?.photoURL != null
                  ? NetworkImage(chatProvider.currentUser!.photoURL!)
                  : null,
              child: chatProvider.currentUser?.photoURL == null
                  ? Text(
                chatProvider.currentUser?.displayName?[0].toUpperCase() ?? 'U',
                style: TextStyle(
                  fontSize: isDesktop ? 14.0 : 12.0,
                  color: _secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : null,
            ),
        ],
      ),
    );
  }

  // Widget para construir la lista de canales


  Widget _buildCurrentChannelInfo(Channel channel, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 14.0 : 12.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          // Indicador de live
          Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.0),
          Text(
            'EN VIVO',
            style: TextStyle(
              color: Colors.white,
              fontSize: isDesktop ? 13.0 : 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 12.0),
          Text(
            channel.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isDesktop ? 15.0 : 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons(PlayerProvider playerProvider, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          // Botón de play/pause
          IconButton(
            icon: Icon(
              playerProvider.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
              size: isDesktop ? 26.0 : 24.0,
            ),
            onPressed: playerProvider.togglePlayPause,
          ),
        ],
      ),
    );
  }


}