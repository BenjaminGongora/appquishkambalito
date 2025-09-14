import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/audio_provider.dart';
import 'package:myapp/providers/video_provider.dart';
import 'package:myapp/providers/player_provider.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
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
