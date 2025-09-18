import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/audio_provider.dart';
import 'package:myapp/theme/colors.dart';
import 'package:myapp/providers/chat_provider.dart';
import '../models/chat_message.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  bool _showChat = false;

  void _toggleChat() {
    setState(() {
      _showChat = !_showChat;
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final isPlaying = audioProvider.isPlaying;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header con gradiente y logo - ÚNICO AppBar
          SliverAppBar(
            title: Text(
              'Radio en Vivo',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.accentOrange,
            foregroundColor: AppColors.white,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: _showChat
                      ? AppColors.primaryBlue
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
                            _showChat ? Icons.info_outline : Icons.chat_rounded,
                            color: AppColors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _showChat ? 'Info' : 'Chat',
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
            expandedHeight: 350,
            floating: false,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.accentOrange.withOpacity(0.9),
                      AppColors.darkBackground.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Efecto de ondas de radio
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
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.accentOrange,
                                  AppColors.accentOrange.withOpacity(0.7),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accentOrange.withOpacity(0.5),
                                  blurRadius: 30,
                                  spreadRadius: 3,
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
                                        width: 140 * value,
                                        height: 140 * value,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.accentOrange
                                                .withOpacity(0.3 - (value * 0.3)),
                                            width: 2,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                const Icon(
                                  Icons.radio_rounded,
                                  size: 60,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Radio Quishkambalito',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Transmitiendo en vivo',
                            style: TextStyle(
                              color: AppColors.greyText,
                              fontSize: 14,
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Tarjeta de controles premium
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.cardDark,
                          AppColors.cardDark.withOpacity(0.9),
                        ],
                      ),
                      border: Border.all(
                        color: AppColors.accentOrange.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Indicador de estado
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isPlaying
                                ? Colors.green.withOpacity(0.2)
                                : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isPlaying
                                  ? Colors.green.withOpacity(0.4)
                                  : Colors.orange.withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isPlaying
                                      ? Colors.green
                                      : Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isPlaying ? 'EN VIVO' : 'PAUSADO',
                                style: TextStyle(
                                  color: isPlaying
                                      ? Colors.green
                                      : Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Barra de progreso elegante
                        Column(
                          children: [
                            // Tiempo transcurrido
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '2:45',
                                  style: TextStyle(
                                    color: AppColors.greyText,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '5:30',
                                  style: TextStyle(
                                    color: AppColors.greyText,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Barra de progreso
                            Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: AppColors.greyText.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Stack(
                                children: [
                                  // Progreso reproducido
                                  Container(
                                    height: 6,
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.accentOrange,
                                          AppColors.accentOrange.withOpacity(0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  // Punto de control
                                  Positioned(
                                    left: MediaQuery.of(context).size.width * 0.5 - 8,
                                    top: -4,
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: AppColors.accentOrange,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.accentOrange.withOpacity(0.5),
                                            blurRadius: 8,
                                            spreadRadius: 2,
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
                        const SizedBox(height: 30),

                        // Controles de reproducción
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Botón play/pause principal
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.accentOrange,
                                    AppColors.accentOrange.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accentOrange.withOpacity(0.4),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  size: 40,
                                  color: AppColors.white,
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
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Sección dinámica (Información o Chat)
                  _showChat ? _buildChatContent() : _buildRadioInfo(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para construir el contenido del chat
  Widget _buildChatContent() {
    return Container(
      height: 400, // Altura fija para el chat
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Header del chat
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
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
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
                        'Chat en Vivo - Radio',
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
            // Contenido del chat
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

  // Widget para construir la información de la radio
  Widget _buildRadioInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.cardDark.withOpacity(0.6),
        border: Border.all(
          color: AppColors.accentOrange.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📻 Acerca de Radio Quishkambalito',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Disfruta de la mejor programación musical las 24 horas del día con Radio Quishkambalito. '
                'Transmitiendo en vivo para todo el mundo con la mejor selección de música y contenido local.',
            style: TextStyle(
              color: AppColors.greyText,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          // Estadísticas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                '128',
                'Oyentes ahora',
                Icons.people_rounded,
              ),
              _buildStatItem(
                '24/7',
                'Transmisión',
                Icons.schedule_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Versión personalizada del LiveChatScreen
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
              'Inicia sesión para participar en el chat en vivo de la radio',
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

  Widget _buildControlButton(
      IconData icon,
      Color color,
      VoidCallback onPressed,
      ) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: IconButton(
        icon: Icon(icon, size: 24, color: color),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildSmallControlButton(
      IconData icon,
      Color color,
      VoidCallback onPressed,
      ) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: color),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.accentOrange),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: TextStyle(color: AppColors.greyText, fontSize: 10)),
      ],
    );
  }
}

// CustomPainter para efecto de ondas de radio - CORREGIDO
class _RadioWavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0; // strokeWidth debe estar en la misma declaración

    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 1; i <= 5; i++) {
      final radius = (size.width / 2) * (i / 5);
      canvas.drawCircle(
        center,
        radius,
        paint..color = Colors.white.withOpacity(0.1),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}