import 'package:flutter/material.dart';
import 'dart:math';
import 'package:myapp/theme/colors.dart';
import 'package:myapp/screens/radio_screen.dart';
import 'package:myapp/screens/tv_screen.dart';

// Clase CustomPainter fuera del método build
class _DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final random = Random(42);
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 1;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // AppBar con logo integrado
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Radio y TV Quishkambalito',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
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
                      AppColors.primaryBlue.withOpacity(0.95),
                      AppColors.darkBackground.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Efecto de partículas sutiles
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.05,
                        child: CustomPaint(painter: _DotsPainter()),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo de la radio
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryBlue.withOpacity(0.4),
                                  blurRadius: 25,
                                  spreadRadius: 3,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'lib/assets/logoRadio.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.primaryBlue,
                                          AppColors.accentOrange,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.live_tv_rounded,
                                      size: 50,
                                      color: AppColors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Text(
                          //   '',
                          //   style: TextStyle(
                          //     color: AppColors.white,
                          //     fontSize: 18,
                          //     fontWeight: FontWeight.w300,
                          //     letterSpacing: 1.1,
                          //   ),
                          // ),
                          const SizedBox(height: 4),
                          // Text(
                          //   'Disfruta de la mejor programación',
                          //   style: TextStyle(
                          //     color: AppColors.greyText,
                          //     fontSize: 12,
                          //   ),
                          // ),
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección de acceso rápido
                  // _buildSectionHeader('Acceso rápido'),
                  const SizedBox(height: 20),

                  // Grid de opciones principales - DISEÑO MEJORADO
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.9,
                    children: [
                      _buildPremiumFeatureCard(
                        context,
                        'Radio en Vivo',
                        Icons.radio_rounded,
                        AppColors.accentOrange,
                        const RadioScreen(),
                        'Escucha en directo',
                        'lib/assets/radio_bg.png',
                      ),
                      _buildPremiumFeatureCard(
                        context,
                        'TV en Vivo',
                        Icons.live_tv_rounded,
                        AppColors.primaryBlue,
                        const TvScreen(),
                        'Canales en directo',
                        'lib/assets/tv_bg.png',
                      ),
                      // _buildPremiumFeatureCard(
                      //   context,
                      //   'Programación',
                      //   Icons.schedule_rounded,
                      //   Colors.greenAccent,
                      //   Container(),
                      //   'Horarios',
                      //   'lib/assets/schedule_bg.png',
                      // ),
                      // _buildPremiumFeatureCard(
                      //   context,
                      //   'Favoritos',
                      //   Icons.favorite_rounded,
                      //   Colors.pinkAccent,
                      //   Container(),
                      //   'Tus guardados',
                      //   'lib/assets/favorites_bg.png',
                      // ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Sección de canales destacados - DISEÑO MEJORADO
                  _buildSectionHeader('Canales destacados', showViewAll: true),
                  const SizedBox(height: 16),

                  // Lista horizontal de canales mejorada
                  SizedBox(
                    height: 220,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildPremiumChannelCard(
                          'Canal Principal',
                          'Transmisión 24/7',
                          Icons.live_tv_rounded,
                          AppColors.primaryBlue,
                          0.9,
                          'lib/assets/channel1.png',
                        ),
                        _buildPremiumChannelCard(
                          'Radio FM',
                          'Música sin parar',
                          Icons.radio_rounded,
                          AppColors.accentOrange,
                          0.8,
                          'lib/assets/radio_wave.png',
                        ),
                        _buildPremiumChannelCard(
                          'Eventos Especiales',
                          'En vivo próximamente',
                          Icons.event_rounded,
                          Colors.purpleAccent,
                          0.4,
                          'lib/assets/events.png',
                        ),
                        _buildPremiumChannelCard(
                          'Noticias',
                          'Información al momento',
                          Icons.newspaper_rounded,
                          Colors.blueAccent,
                          0.7,
                          'lib/assets/news.png',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Sección de estadísticas - DISEÑO MEJORADO
                  _buildSectionHeader('En directo ahora'),
                  const SizedBox(height: 16),

                  _buildPremiumStatsSection(),

                  const SizedBox(height: 40),
                  _buildAppFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método del footer
  Widget _buildAppFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.primaryBlue.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            'v1.0.0', // Puedes usar AppConfig.version si configuras el archivo
            style: TextStyle(
              color: AppColors.greyText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '© 2025 Radio Quishkambalito',
            style: TextStyle(
              color: AppColors.greyText.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Todos los derechos reservados',
            style: TextStyle(
              color: AppColors.greyText.withOpacity(0.6),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showViewAll = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        if (showViewAll)
          Text(
            'Ver todos',
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildPremiumFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget screen,
    String subtitle,
    String imagePath,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (screen is! Container) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => screen,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.3),
                          end: Offset.zero,
                        ).animate(animation),
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.25),
                color.withOpacity(0.1),
                Colors.transparent,
              ],
            ),
            border: Border.all(color: color.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Efecto de fondo sutil
              Positioned.fill(
                child: Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container();
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icono principal
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(0.3),
                            color.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: color.withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                      child: Icon(icon, size: 28, color: color),
                    ),

                    // Contenido textual
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: AppColors.greyText,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    // Indicador de acción
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: color,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumChannelCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    double progress,
    String imagePath,
  ) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.15), Colors.transparent],
        ),
        border: Border.all(color: color.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono con fondo
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.4), width: 2),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 15),

            // Información del canal
            Text(
              title,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: AppColors.greyText,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 15),

            // Barra de progreso y estado
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.greyText.withOpacity(0.2),
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                  minHeight: 4,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: progress > 0.5 ? Colors.green : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${(progress * 100).toInt()}% en vivo',
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumStatsSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlue.withOpacity(0.1), AppColors.cardDark],
        ),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildPremiumStatItem(
              '1.2K',
              'Oyentes activos',
              Icons.people_rounded,
              AppColors.primaryBlue,
            ),
            _buildPremiumStatItem(
              '24/7',
              'Transmisión',
              Icons.online_prediction_rounded,
              AppColors.accentOrange,
            ),
            _buildPremiumStatItem(
              '15+',
              'Canales HD',
              Icons.live_tv_rounded,
              Colors.greenAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumStatItem(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        // Icono con gradiente
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
            ),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.4), width: 2),
          ),
          child: Icon(icon, size: 26, color: color),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.greyText,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
