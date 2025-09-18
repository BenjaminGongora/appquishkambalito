import 'package:flutter/material.dart';
import 'dart:math';
import 'package:myapp/theme/colors.dart';
import 'package:myapp/screens/radio_screen.dart';
import 'package:myapp/screens/tv_screen.dart';
import 'package:myapp/screens/live_chat_screen.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;
    final gridCount = isWeb ? 3 : 1; // Cambiado a 1 columna en móvil para mejor visualización

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: isWeb ? 220 : 200, // Más compacto en móvil
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Radio y TV Quishkambalito',
                style: TextStyle(
                  fontSize: isWeb ? 18 : 16,
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
                          Container(
                            width: isWeb ? 100 : 80, // Más pequeño en móvil
                            height: isWeb ? 100 : 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryBlue.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 2,
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
                                    child: Icon(
                                      Icons.live_tv_rounded,
                                      size: isWeb ? 40 : 30,
                                      color: AppColors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(isWeb ? 30.0 : 16.0), // Menos padding en móvil
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SECCIÓN PRINCIPAL MEJORADA PARA MÓVIL
                  _buildSectionHeader('¿Qué quieres disfrutar hoy?'),
                  const SizedBox(height: 20),

                  // LISTA EN VEZ DE GRID PARA MÓVIL - Mucho mejor en celular
                  isWeb ? _buildWebGrid(context) : _buildMobileList(context),

                  const SizedBox(height: 24),

                  // PRIMER ESPACIO PUBLICITARIO
                  _buildModernAdSpaceWithImage(
                    context,
                    'Patrocinado por Quishkambalito',
                    'Amazonas',
                    'Ven y Disfruta',
                    'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
                    Colors.redAccent,
                  ),

                  const SizedBox(height: 24),

                  // SEGUNDO ESPACIO PUBLICITARIO
                  _buildModernAdSpaceWithImage(
                    context,
                    'Patrocinado por Quishkambalito',
                    'Chachapoyas',
                    'Ven y Disfruta',
                    'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
                    Colors.blueAccent,
                  ),

                  const SizedBox(height: 24),

                  // TERCER ESPACIO PUBLICITARIO
                  _buildModernAdSpaceWithImage(
                    context,
                    'Patrocinado por Quishkambalito',
                    'Iquitos',
                    'Ven y Disfruta',
                    'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
                    Colors.orangeAccent,
                  ),

                  const SizedBox(height: 32),

                  // Sección de canales destacados
                  _buildSectionHeader('Canales populares', showViewAll: true),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: isWeb ? 250 : 200, // Más compacto en móvil
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildPremiumChannelCard(
                          'Canal Principal',
                          '24/7 sin interrupciones',
                          Icons.live_tv_rounded,
                          AppColors.primaryBlue,
                          0.9,
                        ),
                        _buildPremiumChannelCard(
                          'Radio FM',
                          'Música sin comerciales',
                          Icons.radio_rounded,
                          AppColors.accentOrange,
                          0.8,
                        ),
                        _buildPremiumChannelCard(
                          'Eventos',
                          'Conciertos en vivo',
                          Icons.event_rounded,
                          Colors.purpleAccent,
                          0.4,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Sección de estadísticas
                  _buildSectionHeader('Estadísticas en tiempo real'),
                  const SizedBox(height: 16),

                  _buildPremiumStatsSection(),

                  const SizedBox(height: 32),

                  // CUARTO ESPACIO PUBLICITARIO
                  _buildModernAdSpaceWithImage(
                    context,
                    'Patrocinado por McDonald\'s',
                    'Happy Meal',
                    'Disfruta de nuestro menú infantil con juguete incluido',
                    'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
                    Colors.yellowAccent,
                  ),

                  const SizedBox(height: 32),

                  // QUINTO ESPACIO PUBLICITARIO
                  _buildModernAdSpaceWithImage(
                    context,
                    'Patrocinado por Netflix',
                    'Nuevos estrenos',
                    'Miles de películas y series por solo \$9.99/mes',
                    'https://images.unsplash.com/photo-1489599102910-59206b8ca314?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
                    Colors.redAccent,
                  ),

                  const SizedBox(height: 32),

                  // SEXTO ESPACIO PUBLICITARIO
                  _buildModernAdSpaceWithImage(
                    context,
                    'Patrocinado por Amazon',
                    'Prime Day',
                    'Ofertas exclusivas con envío gratis para miembros Prime',
                    'https://images.unsplash.com/photo-1526947425960-945c6e72858f?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
                    Colors.blueAccent,
                  ),

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

  // Widget para construir grid en web
  Widget _buildWebGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 0.85,
      children: [
        _buildEnhancedFeatureCard(
          context,
          'Radio en Vivo',
          Icons.radio_rounded,
          AppColors.accentOrange,
          const RadioScreen(),
          'Escucha nuestra programación en vivo las 24 horas',
        ),
        _buildEnhancedFeatureCard(
          context,
          'TV en Vivo',
          Icons.live_tv_rounded,
          AppColors.primaryBlue,
          const TvScreen(),
          'Disfruta de nuestros canales de televisión',
        ),
        _buildEnhancedFeatureCard(
          context,
          'Chat en Vivo',
          Icons.chat_rounded,
          Colors.purpleAccent,
          const LiveChatScreen(),
          'Únete a la conversación con otros oyentes',
        ),
      ],
    );
  }

  // Widget para construir lista en móvil - MUCHO MEJOR para celular
  Widget _buildMobileList(BuildContext context) {
    return Column(
      children: [
        _buildMobileFeatureCard(
          context,
          'Radio en Vivo',
          Icons.radio_rounded,
          AppColors.accentOrange,
          const RadioScreen(),
          'Escucha programación 24/7',
        ),
        const SizedBox(height: 16),
        _buildMobileFeatureCard(
          context,
          'TV en Vivo',
          Icons.live_tv_rounded,
          AppColors.primaryBlue,
          const TvScreen(),
          'Canales en directo',
        ),
        const SizedBox(height: 16),
        _buildMobileFeatureCard(
          context,
          'Chat en Vivo',
          Icons.chat_rounded,
          Colors.purpleAccent,
          const LiveChatScreen(),
          'Conversa con la comunidad',
        ),
      ],
    );
  }

  // NUEVO: Tarjeta optimizada para móvil
  Widget _buildMobileFeatureCard(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      Widget screen,
      String description,
      ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.15),
                color.withOpacity(0.05),
              ],
            ),
            border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          ),
          child: Row(
            children: [
              // Icono
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 28, color: Colors.white),
              ),

              const SizedBox(width: 16),

              // Texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: AppColors.greyText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Flecha indicadora
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // NUEVO: Publicidad con imagen de demostración
  Widget _buildModernAdSpaceWithImage(
      BuildContext context,
      String sponsorText,
      String brandName,
      String offer,
      String imageUrl,
      Color color,
      ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showAdDetails(context, brandName),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.cardDark,
            border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen de demostración
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Patrocinado',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Contenido del anuncio
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sponsorText,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      brandName,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      offer,
                      style: TextStyle(
                        color: AppColors.greyText,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Botón de acción
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _showAdDetails(context, brandName),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Ver más información'),
                      ),
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

  void _showAdDetails(BuildContext context, String brand) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text(
          'Oferta de $brand',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Este es un espacio publicitario demostrativo. '
              'En una implementación real, aquí se mostrarían los detalles '
              'completos de la promoción especial con imágenes y enlaces.',
          style: TextStyle(color: AppColors.greyText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Me interesa'),
          ),
        ],
      ),
    );
  }

  // Resto de los métodos (mantenidos pero optimizados)
  Widget _buildEnhancedFeatureCard(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      Widget screen,
      String description,
      ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.15),
                color.withOpacity(0.05),
              ],
            ),
            border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 28, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: AppColors.greyText,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.primaryBlue.withOpacity(0.3))),
      ),
      child: Column(
        children: [
          Text(
            'v1.0.0',
            style: TextStyle(color: AppColors.greyText, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            '© 2025 Radio Quishkambalito',
            style: TextStyle(color: AppColors.greyText.withOpacity(0.7), fontSize: 11),
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (showViewAll)
          Text(
            'Ver todos',
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontSize: 14,
            ),
          ),
      ],
    );
  }

  Widget _buildPremiumChannelCard(
      String title,
      String subtitle,
      IconData icon,
      Color color,
      double progress,
      ) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), Colors.transparent],
        ),
        border: Border.all(color: color.withOpacity(0.25), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color.withOpacity(0.3), color.withOpacity(0.1)]),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.4), width: 2),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: AppColors.greyText, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumStatsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [AppColors.primaryBlue.withOpacity(0.1), AppColors.cardDark],
        ),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPremiumStatItem('1.2K', 'Oyentes activos', Icons.people_rounded, AppColors.primaryBlue),
          _buildPremiumStatItem('24/7', 'Transmisión', Icons.online_prediction_rounded, AppColors.accentOrange),
        ],
      ),
    );
  }

  Widget _buildPremiumStatItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color.withOpacity(0.3), color.withOpacity(0.1)]),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.4), width: 2),
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: AppColors.greyText, fontSize: 11)),
      ],
    );
  }
}