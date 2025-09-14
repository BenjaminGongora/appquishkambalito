import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/audio_provider.dart';
import 'package:myapp/theme/colors.dart';

class RadioScreen extends StatelessWidget {
  const RadioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final isPlaying = audioProvider.isPlaying;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // AppBar con gradiente y logo
          SliverAppBar(
            expandedHeight: 350,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Radio en Vivo',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
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
                                  color: AppColors.accentOrange.withOpacity(
                                    0.5,
                                  ),
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
                                                .withOpacity(
                                                  0.3 - (value * 0.3),
                                                ),
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.accentOrange,
                                          AppColors.accentOrange.withOpacity(
                                            0.8,
                                          ),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  // Punto de control
                                  Positioned(
                                    left:
                                        MediaQuery.of(context).size.width *
                                            0.5 -
                                        8,
                                    top: -4,
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: AppColors.accentOrange,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.accentOrange
                                                .withOpacity(0.5),
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
                            // Botón anterior
                            _buildControlButton(
                              Icons.skip_previous_rounded,
                              AppColors.greyText,
                              () {},
                            ),

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
                                    color: AppColors.accentOrange.withOpacity(
                                      0.4,
                                    ),
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
                                  if (isPlaying) {
                                    audioProvider.pause();
                                  } else {
                                    audioProvider.play(
                                      'https://servidor26.brlogic.com:7652/live',
                                    );
                                  }
                                },
                              ),
                            ),

                            // Botón siguiente
                            _buildControlButton(
                              Icons.skip_next_rounded,
                              AppColors.greyText,
                              () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Volumen y ajustes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildSmallControlButton(
                              Icons.volume_up_rounded,
                              AppColors.greyText,
                              () {},
                            ),
                            _buildSmallControlButton(
                              Icons.favorite_border_rounded,
                              AppColors.greyText,
                              () {},
                            ),
                            _buildSmallControlButton(
                              Icons.share_rounded,
                              AppColors.greyText,
                              () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Información de la estación
                  Container(
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
                            // _buildStatItem('HD', 'Calidad', Icons.quality_rounded),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
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

// CustomPainter para efecto de ondas de radio
class _RadioWavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

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
