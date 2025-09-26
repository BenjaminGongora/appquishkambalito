import 'package:flutter/material.dart';
import 'package:myapp/theme/colors.dart';
import 'package:myapp/screens/radio_screen.dart';
import 'package:myapp/screens/tv_screen.dart';
import 'package:myapp/screens/live_chat_screen.dart';
import 'package:myapp/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<Publicidad> publicidades = [];
  bool isLoading = true;
  String errorMessage = '';
  int _currentIndex = 0;

  // Colores estilo red social
  final Color _primaryColor = Color(0xFF0099FF);
  final Color _secondaryColor = Color(0xFFFFD600);
  final Color _backgroundColor = Color(0xFFF8F9FA);
  final Color _textColor = Color(0xFF1C1E21);
  final Color _greyText = Color(0xFF65676B);

  @override
  void initState() {
    super.initState();
    _loadPublicidades();
  }

  Future<void> _loadPublicidades() async {
    try {
      final publicidadesData = await ApiService.fetchPublicidades();
      setState(() {
        publicidades = publicidadesData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => RadioScreen()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => TvScreen()));
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeDesktop = screenSize.width > 1440;
    final isDesktop = screenSize.width > 1024;
    final isTablet = screenSize.width > 768;
    final isLargeMobile = screenSize.width > 480;

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: _buildAppBar(isLargeDesktop, isDesktop, isTablet, screenSize),
      body: _buildBody(isLargeDesktop, isDesktop, isTablet, isLargeMobile, screenSize),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar(bool isLargeDesktop, bool isDesktop, bool isTablet, Size screenSize) {
    double getLogoSize() {
      if (isLargeDesktop) return 100.0;
      if (isDesktop) return 90.0;
      if (isTablet) return 80.0;
      if (screenSize.width > 400) return 70.0;
      return 60.0;
    }

    double getTitleSize() {
      if (isLargeDesktop) return 28.0;
      if (isDesktop) return 24.0;
      if (isTablet) return 20.0;
      if (screenSize.width > 400) return 18.0;
      return 16.0;
    }

    double getSubtitleSize() {
      if (isLargeDesktop) return 16.0;
      if (isDesktop) return 14.0;
      if (isTablet) return 13.0;
      return 12.0;
    }

    double getToolbarHeight() {
      if (isLargeDesktop) return 130.0;
      if (isDesktop) return 120.0;
      if (isTablet) return 110.0;
      return 100.0;
    }

    final logoSize = getLogoSize();
    final titleSize = getTitleSize();
    final subtitleSize = getSubtitleSize();
    final toolbarHeight = getToolbarHeight();

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2.0,
      centerTitle: true,
      toolbarHeight: toolbarHeight,
      title: Container(
        constraints: BoxConstraints(
          maxWidth: isLargeDesktop ? 700.0 :
          isDesktop ? 600.0 :
          isTablet ? 500.0 :
          screenSize.width * 0.9,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: logoSize,
              height: logoSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [_primaryColor, _secondaryColor]),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12.0,
                    offset: Offset(0, 4.0),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  'lib/assets/logoRadio.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.live_tv, color: Colors.white, size: logoSize * 0.4);
                  },
                ),
              ),
            ),
            SizedBox(width: isLargeDesktop ? 24.0 : isDesktop ? 20.0 : isTablet ? 16.0 : 12.0),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Radio Quishkambalito',
                    style: TextStyle(
                      color: _textColor,
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    'Transmitiendo 24/7',
                    style: TextStyle(
                      color: _greyText,
                      fontSize: subtitleSize,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_none,
              color: _textColor,
              size: isLargeDesktop ? 32.0 : isDesktop ? 30.0 : isTablet ? 28.0 : 24.0),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.search,
              color: _textColor,
              size: isLargeDesktop ? 32.0 : isDesktop ? 30.0 : isTablet ? 28.0 : 24.0),
          onPressed: () {},
        ),
        SizedBox(width: isLargeDesktop ? 20.0 : isDesktop ? 16.0 : isTablet ? 12.0 : 8.0),
      ],
    );
  }

  Widget _buildBody(bool isLargeDesktop, bool isDesktop, bool isTablet, bool isLargeMobile, Size screenSize) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: _buildQuickAccessSection(isLargeDesktop, isDesktop, isTablet, isLargeMobile, screenSize),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: isLargeDesktop ? 40.0 : isDesktop ? 32.0 : isTablet ? 28.0 : 24.0),
        ),
        SliverToBoxAdapter(
          child: _buildAdsSection(isLargeDesktop, isDesktop, isTablet, isLargeMobile, screenSize),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: isLargeDesktop ? 50.0 : isDesktop ? 40.0 : isTablet ? 32.0 : 28.0),
        ),
      ],
    );
  }

  Widget _buildQuickAccessSection(bool isLargeDesktop, bool isDesktop, bool isTablet, bool isLargeMobile, Size screenSize) {
    final stories = [
      _StoryItem('Radio', Icons.radio_rounded, _primaryColor, () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => RadioScreen()));
      }),
      _StoryItem('TV', Icons.live_tv_rounded, Color(0xFF00C851), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => TvScreen()));
      }),
      _StoryItem('Chat', Icons.chat_rounded, Color(0xFFFF4444), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LiveChatScreen()));
      }),
    ];

    double getItemWidth() {
      if (isLargeDesktop) return 140.0;
      if (isDesktop) return 120.0;
      if (isTablet) return 110.0;
      if (isLargeMobile) return 100.0;
      return screenSize.width / 3.5;
    }

    double getIconSize() {
      if (isLargeDesktop) return 42.0;
      if (isDesktop) return 38.0;
      if (isTablet) return 34.0;
      if (isLargeMobile) return 30.0;
      return 28.0;
    }

    double getSectionHeight() {
      if (isLargeDesktop) return 160.0;
      if (isDesktop) return 140.0;
      if (isTablet) return 130.0;
      if (isLargeMobile) return 120.0;
      return 110.0;
    }

    final itemWidth = getItemWidth();
    final iconSize = getIconSize();
    final sectionHeight = getSectionHeight();

    return Container(
      margin: EdgeInsets.only(
        top: isLargeDesktop ? 32.0 : isDesktop ? 28.0 : isTablet ? 24.0 : 20.0,
        left: isLargeDesktop ? 40.0 : isDesktop ? 32.0 : isTablet ? 24.0 : 16.0,
        right: isLargeDesktop ? 40.0 : isDesktop ? 32.0 : isTablet ? 24.0 : 16.0,
      ),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: isLargeDesktop ? 32.0 : isDesktop ? 28.0 : isTablet ? 24.0 : 20.0,
            horizontal: isLargeDesktop ? 32.0 : isDesktop ? 28.0 : isTablet ? 24.0 : 20.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: isLargeDesktop ? 28.0 : isDesktop ? 24.0 : isTablet ? 20.0 : 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flash_on_rounded,
                        color: _primaryColor,
                        size: isLargeDesktop ? 32.0 : isDesktop ? 28.0 : isTablet ? 24.0 : 20.0),
                    SizedBox(width: isLargeDesktop ? 16.0 : isDesktop ? 14.0 : isTablet ? 12.0 : 10.0),
                    Text(
                      'Acceso Rápido',
                      style: TextStyle(
                        color: _textColor,
                        fontSize: isLargeDesktop ? 26.0 : isDesktop ? 22.0 : isTablet ? 20.0 : 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: sectionHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    return _buildQuickAccessItem(story, itemWidth, iconSize);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessItem(_StoryItem story, double width, double iconSize) {
    return GestureDetector(
      onTap: story.onTap,
      child: Container(
        width: width,
        margin: EdgeInsets.only(right: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: width * 0.7,
              height: width * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [story.color, story.color.withOpacity(0.7)]),
                border: Border.all(color: Colors.white, width: 4.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12.0,
                    offset: Offset(0, 6.0),
                  ),
                ],
              ),
              child: Icon(story.icon, color: Colors.white, size: iconSize),
            ),
            SizedBox(height: 12.0),
            Text(
              story.title,
              style: TextStyle(
                color: _textColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdsSection(bool isLargeDesktop, bool isDesktop, bool isTablet, bool isLargeMobile, Size screenSize) {
    double getPadding() {
      if (isLargeDesktop) return 48.0;
      if (isDesktop) return 40.0;
      if (isTablet) return 32.0;
      if (isLargeMobile) return 24.0;
      return 20.0;
    }

    final padding = getPadding();

    return Container(
      color: _backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            child: Container(
              padding: EdgeInsets.all(isLargeDesktop ? 24.0 : isDesktop ? 20.0 : isTablet ? 18.0 : 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.campaign_rounded,
                          color: _primaryColor,
                          size: isLargeDesktop ? 32.0 : isDesktop ? 28.0 : isTablet ? 24.0 : 20.0),
                      SizedBox(width: isLargeDesktop ? 16.0 : isDesktop ? 14.0 : isTablet ? 12.0 : 10.0),
                      Text(
                        'Publicidades',
                        style: TextStyle(
                          color: _textColor,
                          fontSize: isLargeDesktop ? 24.0 : isDesktop ? 20.0 : isTablet ? 18.0 : 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Ver todas',
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: isLargeDesktop ? 18.0 : isDesktop ? 16.0 : isTablet ? 14.0 : 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isLargeDesktop ? 28.0 : isDesktop ? 24.0 : isTablet ? 20.0 : 16.0),
          if (isLoading)
            _buildLoadingFeed(isLargeDesktop, isDesktop, isTablet)
          else if (errorMessage.isNotEmpty)
            _buildErrorFeed(isLargeDesktop, isDesktop, isTablet)
          else if (publicidades.isEmpty)
              _buildEmptyFeed(isLargeDesktop, isDesktop, isTablet)
            else
              Column(
                children: publicidades.map((publicidad) =>
                    _buildPostCard(publicidad, isLargeDesktop, isDesktop, isTablet, isLargeMobile, screenSize)).toList(),
              ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Publicidad publicidad, bool isLargeDesktop, bool isDesktop, bool isTablet, bool isLargeMobile, Size screenSize) {
    double getImageHeight() {
      if (isLargeDesktop) return 320.0;
      if (isDesktop) return 280.0;
      if (isTablet) return 240.0;
      if (isLargeMobile) return 200.0;
      return 180.0;
    }

    double getTitleSize() {
      if (isLargeDesktop) return 20.0;
      if (isDesktop) return 18.0;
      if (isTablet) return 16.0;
      if (isLargeMobile) return 15.0;
      return 14.0;
    }

    double getTextSize() {
      if (isLargeDesktop) return 16.0;
      if (isDesktop) return 15.0;
      if (isTablet) return 14.0;
      if (isLargeMobile) return 13.0;
      return 12.0;
    }

    final imageHeight = getImageHeight();
    final titleSize = getTitleSize();
    final textSize = getTextSize();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: isLargeDesktop ? 28.0 : isDesktop ? 24.0 : isTablet ? 20.0 : 16.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(isLargeDesktop ? 24.0 : isDesktop ? 20.0 : isTablet ? 18.0 : 16.0),
              child: Row(
                children: [
                  Container(
                    width: isLargeDesktop ? 60.0 : isDesktop ? 50.0 : isTablet ? 45.0 : 40.0,
                    height: isLargeDesktop ? 60.0 : isDesktop ? 50.0 : isTablet ? 45.0 : 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [_primaryColor, _secondaryColor]),
                    ),
                    child: Icon(Icons.campaign_rounded,
                        color: Colors.white,
                        size: isLargeDesktop ? 28.0 : isDesktop ? 24.0 : isTablet ? 20.0 : 18.0),
                  ),
                  SizedBox(width: isLargeDesktop ? 20.0 : isDesktop ? 16.0 : isTablet ? 14.0 : 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Radio Quishkambalito',
                          style: TextStyle(
                            color: _textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: isLargeDesktop ? 18.0 : isDesktop ? 16.0 : isTablet ? 14.0 : 12.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          _formatDate(publicidad.fechaRegistro),
                          style: TextStyle(
                            color: _greyText,
                            fontSize: isLargeDesktop ? 14.0 : isDesktop ? 13.0 : isTablet ? 12.0 : 11.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.more_horiz,
                      color: _greyText,
                      size: isLargeDesktop ? 28.0 : isDesktop ? 24.0 : isTablet ? 20.0 : 18.0),
                ],
              ),
            ),
            Container(
              height: imageHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(ApiService.getImageUrl(publicidad.imagen)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isLargeDesktop ? 24.0 : isDesktop ? 20.0 : isTablet ? 18.0 : 16.0,
                vertical: isLargeDesktop ? 20.0 : isDesktop ? 16.0 : isTablet ? 14.0 : 12.0,
              ),
              child: Row(
                children: [
                  Icon(Icons.favorite_border, color: _greyText, size: isLargeDesktop ? 28.0 : isDesktop ? 24.0 : isTablet ? 20.0 : 18.0),
                  SizedBox(width: isLargeDesktop ? 24.0 : isDesktop ? 20.0 : isTablet ? 16.0 : 14.0),
                  Icon(Icons.chat_bubble_outline, color: _greyText, size: isLargeDesktop ? 28.0 : isDesktop ? 24.0 : isTablet ? 20.0 : 18.0),
                  SizedBox(width: isLargeDesktop ? 24.0 : isDesktop ? 20.0 : isTablet ? 16.0 : 14.0),
                  Icon(Icons.share, color: _greyText, size: isLargeDesktop ? 28.0 : isDesktop ? 24.0 : isTablet ? 20.0 : 18.0),
                  Spacer(),
                  Icon(Icons.bookmark_border, color: _greyText, size: isLargeDesktop ? 28.0 : isDesktop ? 24.0 : isTablet ? 20.0 : 18.0),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: isLargeDesktop ? 24.0 : isDesktop ? 20.0 : isTablet ? 18.0 : 16.0,
                right: isLargeDesktop ? 24.0 : isDesktop ? 20.0 : isTablet ? 18.0 : 16.0,
                bottom: isLargeDesktop ? 24.0 : isDesktop ? 20.0 : isTablet ? 18.0 : 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    publicidad.titulo,
                    style: TextStyle(
                      color: _textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: isLargeDesktop ? 12.0 : isDesktop ? 10.0 : isTablet ? 8.0 : 6.0),
                  Text(
                    publicidad.descripcion,
                    style: TextStyle(
                      color: _textColor,
                      fontSize: textSize,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isLargeDesktop ? 16.0 : isDesktop ? 14.0 : isTablet ? 12.0 : 10.0),
                  Text(
                    '#RadioQuishkambalito #EnVivo',
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: textSize - 1.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingFeed(bool isLargeDesktop, bool isDesktop, bool isTablet) {
    return Column(
      children: List.generate(2, (index) => _buildShimmerPost(isLargeDesktop, isDesktop, isTablet)),
    );
  }

  Widget _buildShimmerPost(bool isLargeDesktop, bool isDesktop, bool isTablet) {
    return Card(
      margin: EdgeInsets.only(bottom: isLargeDesktop ? 28.0 : isDesktop ? 24.0 : isTablet ? 20.0 : 16.0),
      child: Container(
        padding: EdgeInsets.all(isLargeDesktop ? 24.0 : isDesktop ? 20.0 : isTablet ? 18.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: isLargeDesktop ? 30.0 : isDesktop ? 25.0 : isTablet ? 22.0 : 20.0
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: isLargeDesktop ? 16.0 : isDesktop ? 14.0 : isTablet ? 13.0 : 12.0,
                          width: 100.0,
                          color: Colors.grey[300]
                      ),
                      SizedBox(height: 4.0),
                      Container(
                          height: isLargeDesktop ? 14.0 : isDesktop ? 12.0 : isTablet ? 11.0 : 10.0,
                          width: 60.0,
                          color: Colors.grey[300]
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.0),
            Container(
                height: isLargeDesktop ? 200.0 : isDesktop ? 180.0 : isTablet ? 160.0 : 150.0,
                width: double.infinity,
                color: Colors.grey[300]
            ),
            SizedBox(height: 12.0),
            Container(
                height: isLargeDesktop ? 14.0 : isDesktop ? 12.0 : isTablet ? 11.0 : 10.0,
                width: double.infinity,
                color: Colors.grey[300]
            ),
            SizedBox(height: 4.0),
            Container(
                height: isLargeDesktop ? 14.0 : isDesktop ? 12.0 : isTablet ? 11.0 : 10.0,
                width: 200.0,
                color: Colors.grey[300]
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorFeed(bool isLargeDesktop, bool isDesktop, bool isTablet) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(isLargeDesktop ? 32.0 : isDesktop ? 28.0 : isTablet ? 24.0 : 20.0),
        child: Column(
          children: [
            Icon(Icons.error_outline,
                color: Colors.red,
                size: isLargeDesktop ? 60.0 : isDesktop ? 50.0 : isTablet ? 45.0 : 40.0),
            SizedBox(height: 16.0),
            Text(
                'Error al cargar publicidades',
                style: TextStyle(
                  color: _textColor,
                  fontSize: isLargeDesktop ? 20.0 : isDesktop ? 18.0 : isTablet ? 16.0 : 14.0,
                )
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _loadPublicidades,
              style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
              child: Text('Reintentar',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFeed(bool isLargeDesktop, bool isDesktop, bool isTablet) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(isLargeDesktop ? 40.0 : isDesktop ? 35.0 : isTablet ? 30.0 : 25.0),
        child: Column(
          children: [
            Icon(Icons.campaign_rounded,
                color: _greyText,
                size: isLargeDesktop ? 60.0 : isDesktop ? 50.0 : isTablet ? 45.0 : 40.0),
            SizedBox(height: 16.0),
            Text(
                'No hay publicidades disponibles',
                style: TextStyle(
                  color: _greyText,
                  fontSize: isLargeDesktop ? 18.0 : isDesktop ? 16.0 : isTablet ? 14.0 : 12.0,
                )
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      backgroundColor: Colors.white,
      selectedItemColor: _primaryColor,
      unselectedItemColor: _greyText,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 14.0,
      unselectedFontSize: 14.0,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.radio), label: 'Radio'),
        BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'TV'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString.split(' ')[0]);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

class _StoryItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _StoryItem(this.title, this.icon, this.color, this.onTap);
}