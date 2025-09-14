import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/audio_provider.dart';
import 'package:myapp/theme/colors.dart';

class RadioScreen extends StatelessWidget {
  const RadioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Radio en Vivo'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.accentOrange.withOpacity(0.7),
                      AppColors.darkBackground,
                    ],
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.radio_rounded,
                      size: 100,
                      color: AppColors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Radio Quishkambalito',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Controles de reproducción
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Barra de progreso
                        SizedBox(
                          height: 4,
                          child: LinearProgressIndicator(
                            value: 0.5,
                            backgroundColor: AppColors.greyText.withOpacity(
                              0.3,
                            ),
                            color: AppColors.accentOrange,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Controles
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.skip_previous_rounded,
                                size: 30,
                              ),
                              onPressed: () {},
                              color: AppColors.greyText,
                            ),

                            IconButton(
                              icon: Icon(
                                audioProvider.isPlaying
                                    ? Icons.pause_circle_filled_rounded
                                    : Icons.play_circle_filled_rounded,
                                size: 60,
                              ),
                              onPressed: () {
                                if (audioProvider.isPlaying) {
                                  audioProvider.pause();
                                } else {
                                  audioProvider.play(
                                    'https://servidor26.brlogic.com:7652/live',
                                  );
                                }
                              },
                              color: AppColors.accentOrange,
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.skip_next_rounded,
                                size: 30,
                              ),
                              onPressed: () {},
                              color: AppColors.greyText,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Información de estado
                        Text(
                          audioProvider.isPlaying ? 'Reproduciendo' : 'Pausado',
                          style: TextStyle(
                            color: audioProvider.isPlaying
                                ? AppColors.accentOrange
                                : AppColors.greyText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Sección de información
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Acerca de esta estación',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Disfruta de la mejor programación musical las 24 horas del día. '
                        'Transmitiendo en vivo para todo el mundo.',
                        style: TextStyle(
                          color: AppColors.greyText,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
