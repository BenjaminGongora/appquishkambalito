import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:myapp/providers/audio_provider.dart';
import 'package:myapp/providers/video_provider.dart';
import 'package:myapp/providers/player_provider.dart';
import 'package:myapp/providers/chat_provider.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase con manejo de errores
  await _initializeFirebase();
  
  runApp(const MyApp());
}

Future<void> _initializeFirebase() async {
  try {
    // Para web, usar configuración directa
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyBIvcydvm-O9Ztf4Q3dtnc73akRq1MOsxI",
          authDomain: "appquishkambalito-chat.firebaseapp.com",
          projectId: "appquishkambalito-chat",
          storageBucket: "appquishkambalito-chat.firebasestorage.app",
          messagingSenderId: "659158041292",
          appId: "1:659158041292:web:33c6dfb09cfeb5318f3869",
          measurementId: "G-B4V72QFEZ1",
        ),
      );
    } else {
      // Para móvil, usar las opciones generadas
      await Firebase.initializeApp();
    }
    print('✅ Firebase inicializado correctamente');
  } catch (error) {
    print('❌ Error inicializando Firebase: $error');
    // Relanzar el error para que se muestre claramente
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'Radio y TV Quishkambalito',
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}