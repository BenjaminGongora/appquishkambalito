import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/audio_provider.dart';
import 'package:myapp/theme/colors.dart';
import 'package:myapp/providers/chat_provider.dart';
import '../models/chat_message.dart';
import 'home_screen.dart'; // Importar HomeScreen para navegación
import 'tv_screen.dart'; // Importar TvScreen para navegación

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  bool _showChat = false;
  int _currentIndex = 1; // Índice 1 para Radio (coincide con HomeScreen)

  // Colores estilo red social
  final Color _primaryColor = Color(0xFF0099FF);
  final Color _secondaryColor = Color(0xFFFFD600);
  final Color _backgroundColor = Color(0xFFF8F9FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF1C1E21);
  final Color _greyText = Color(0xFF65676B);

  void _toggleChat() {
    setState(() {
      _showChat = !_showChat;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navegar a las pantallas correspondientes
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
      // Ya estamos en RadioScreen
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TvScreen()),
        );
        break;
      case 3:
      // Aquí iría la pantalla de Perfil (puedes crearla después)
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final isPlaying = audioProvider.isPlaying;
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 1024;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header moderno estilo red social
          SliverAppBar(
            title: Text(
              '',
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
                            _showChat ? Icons.radio_rounded : Icons.chat_rounded,
                            color: _showChat ? Colors.white : _primaryColor,
                            size: isDesktop ? 20.0 : 18.0,
                          ),
                          SizedBox(width: isDesktop ? 8.0 : 6.0),
                          Text(
                            _showChat ? 'Radio' : 'Chat',
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
            expandedHeight: isDesktop ? 300.0 : 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _primaryColor.withOpacity(0.9),
                      _primaryColor.withOpacity(0.7),
                      _backgroundColor,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Efecto de ondas sutiles
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.1,
                        child: CustomPaint(painter: _RadioWavesPainter()),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo/Icono animado
                          Container(
                            width: isDesktop ? 120.0 : 100.0,
                            height: isDesktop ? 120.0 : 100.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [_primaryColor, _secondaryColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _primaryColor.withOpacity(0.4),
                                  blurRadius: 20.0,
                                  spreadRadius: 3.0,
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Efecto de pulsación cuando está reproduciendo
                                if (isPlaying)
                                  TweenAnimationBuilder(
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration: const Duration(seconds: 2),
                                    builder: (context, value, child) {
                                      return Container(
                                        width: (isDesktop ? 120.0 : 100.0) * value,
                                        height: (isDesktop ? 120.0 : 100.0) * value,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: _primaryColor.withOpacity(0.3 - (value * 0.3)),
                                            width: 2.0,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                Icon(
                                  Icons.radio_rounded,
                                  size: isDesktop ? 50.0 : 40.0,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isDesktop ? 20.0 : 16.0),
                          Text(
                            'Radio Quishkambalito',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? 26.0 : 22.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Transmitiendo en vivo 24/7',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: isDesktop ? 16.0 : 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Contenido principal
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(isDesktop ? 32.0 : 24.0),
              child: Column(
                children: [
                  // Tarjeta de controles principal
                  Card(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(isDesktop ? 30.0 : 24.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            _backgroundColor,
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          // Indicador de estado
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 20.0 : 16.0,
                              vertical: isDesktop ? 10.0 : 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: isPlaying
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: isPlaying
                                    ? Colors.green.withOpacity(0.3)
                                    : Colors.orange.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 10.0,
                                  height: 10.0,
                                  decoration: BoxDecoration(
                                    color: isPlaying ? Colors.green : Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  isPlaying ? 'EN VIVO AHORA' : 'PAUSADO',
                                  style: TextStyle(
                                    color: isPlaying ? Colors.green : Colors.orange,
                                    fontSize: isDesktop ? 14.0 : 12.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isDesktop ? 30.0 : 25.0),

                          // Barra de progreso
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '2:45',
                                    style: TextStyle(
                                      color: _greyText,
                                      fontSize: isDesktop ? 14.0 : 12.0,
                                    ),
                                  ),
                                  Text(
                                    '5:30',
                                    style: TextStyle(
                                      color: _greyText,
                                      fontSize: isDesktop ? 14.0 : 12.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                height: 6.0,
                                decoration: BoxDecoration(
                                  color: _greyText.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 6.0,
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [_primaryColor, _secondaryColor],
                                        ),
                                        borderRadius: BorderRadius.circular(3.0),
                                      ),
                                    ),
                                    Positioned(
                                      left: MediaQuery.of(context).size.width * 0.5 - 8.0,
                                      top: -4.0,
                                      child: Container(
                                        width: 16.0,
                                        height: 16.0,
                                        decoration: BoxDecoration(
                                          color: _primaryColor,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: _primaryColor.withOpacity(0.4),
                                              blurRadius: 8.0,
                                              spreadRadius: 2.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isDesktop ? 35.0 : 30.0),

                          // Controles de reproducción
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Botón play/pause principal
                              Container(
                                width: isDesktop ? 100.0 : 80.0,
                                height: isDesktop ? 100.0 : 80.0,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [_primaryColor, _secondaryColor],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _primaryColor.withOpacity(0.3),
                                      blurRadius: 15.0,
                                      spreadRadius: 3.0,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    size: isDesktop ? 45.0 : 35.0,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (audioProvider.isPlaying) {
                                      audioProvider.pause();
                                    } else {
                                      audioProvider.play('https://servidor26.brlogic.com:7652/live');
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isDesktop ? 25.0 : 20.0),

                          // Información adicional
                          Text(
                            '128 oyentes en vivo • Calidad: 128kbps',
                            style: TextStyle(
                              color: _greyText,
                              fontSize: isDesktop ? 14.0 : 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: isDesktop ? 32.0 : 24.0),

                  // Sección dinámica (Información o Chat)
                  _showChat ? _buildChatContent(isDesktop) : _buildRadioInfo(isDesktop),

                  SizedBox(height: isDesktop ? 40.0 : 32.0),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar idéntico al HomeScreen
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

  // Widget para construir el contenido del chat
  Widget _buildChatContent(bool isDesktop) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: isDesktop ? 450.0 : 400.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: _primaryColor.withOpacity(0.1),
            width: 1.5,
          ),
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
                          'Chat en Vivo - Radio',
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
      ),
    );
  }

  // Widget para construir la información de la radio
  Widget _buildRadioInfo(bool isDesktop) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: EdgeInsets.all(isDesktop ? 28.0 : 24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_rounded, color: _primaryColor, size: isDesktop ? 24.0 : 20.0),
                SizedBox(width: 12.0),
                Text(
                  'Acerca de Radio Quishkambalito',
                  style: TextStyle(
                    color: _textColor,
                    fontSize: isDesktop ? 20.0 : 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Disfruta de la mejor programación musical las 24 horas del día con Radio Quishkambalito. '
                  'Transmitiendo en vivo para todo el mundo con la mejor selección de música y contenido local.',
              style: TextStyle(
                color: _greyText,
                fontSize: isDesktop ? 15.0 : 14.0,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20.0),
            // Estadísticas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('128', 'Oyentes ahora', Icons.people_rounded, isDesktop),
                _buildStatItem('24/7', 'Transmisión', Icons.schedule_rounded, isDesktop),
              ],
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
              'Inicia sesión para participar en el chat en vivo de la radio',
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

  Widget _buildStatItem(String value, String label, IconData icon, bool isDesktop) {
    return Column(
      children: [
        Container(
          width: isDesktop ? 50.0 : 40.0,
          height: isDesktop ? 50.0 : 40.0,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: _primaryColor.withOpacity(0.2)),
          ),
          child: Icon(icon, size: isDesktop ? 24.0 : 20.0, color: _primaryColor),
        ),
        SizedBox(height: 8.0),
        Text(
          value,
          style: TextStyle(
            color: _textColor,
            fontSize: isDesktop ? 16.0 : 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: _greyText,
            fontSize: isDesktop ? 12.0 : 10.0,
          ),
        ),
      ],
    );
  }
}

// CustomPainter para efecto de ondas de radio
class _RadioWavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 1; i <= 5; i++) {
      final radius = (size.width / 2) * (i / 5);
      final paint = Paint()
        ..color = Colors.white.withOpacity(0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}