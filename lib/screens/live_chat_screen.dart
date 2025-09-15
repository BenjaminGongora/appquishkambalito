import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/providers/chat_provider.dart';
import 'package:myapp/theme/colors.dart';
import 'package:myapp/models/chat_message.dart';

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        }

        if (authSnapshot.hasData && authSnapshot.data != null) {
          return _buildChatScreen(context);
        } else {
          return _buildLoginScreen(context);
        }
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            ),
            const SizedBox(height: 20),
            Text('Cargando...', style: TextStyle(color: AppColors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginScreen(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_rounded, size: 80, color: AppColors.primaryBlue),
              const SizedBox(height: 20),
              Text(
                'Chat en Vivo',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Únete a la conversación en vivo',
                style: TextStyle(color: AppColors.greyText, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => chatProvider.signInWithGoogle(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Iniciar sesión con Google'),
              ),
              const SizedBox(height: 20),
              if (chatProvider.error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    chatProvider.error!,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatScreen(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Chat en Vivo'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => chatProvider.signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header de información
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Conectado • ${chatProvider.messages.length} mensajes',
                  style: TextStyle(color: AppColors.greyText, fontSize: 14),
                ),
              ],
            ),
          ),

          // Lista de mensajes
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                if (chatProvider.messages.isEmpty) {
                  return Center(
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
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageItem(
                      chatProvider.messages[index],
                      chatProvider,
                    );
                  },
                );
              },
            ),
          ),

          // Input de mensaje
          _buildMessageInput(chatProvider),
        ],
      ),
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
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
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
                      chatProvider.currentUser?.displayName?[0].toUpperCase() ??
                          'U',
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

  Widget _buildMessageInput(ChatProvider chatProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        border: Border(
          top: BorderSide(color: AppColors.primaryBlue.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (value) => _sendMessage(chatProvider),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.primaryBlue,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: () => _sendMessage(chatProvider),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(ChatProvider chatProvider) {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      chatProvider.sendMessage(text);
      _messageController.clear();
    }
  }
}
