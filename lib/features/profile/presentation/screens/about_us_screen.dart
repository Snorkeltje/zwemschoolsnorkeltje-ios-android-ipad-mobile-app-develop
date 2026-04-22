import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/utils/smart_back.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HERO GRADIENT HEADER
            _buildHeroHeader(context),

            // 2. USP BANNER (overlapping)
            Transform.translate(
              offset: const Offset(0, -24),
              child: _buildUspBanner(),
            ),

            // 3. WIE IS WALTER
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding),
              child: _buildWieIsWalter(),
            ),
            const SizedBox(height: 20),

            // 4. MISSION & VISION
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding),
              child: _buildMissionVision(),
            ),
            const SizedBox(height: 20),

            // 5. WAAROM SNORKELTJE
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding),
              child: _buildWaaromSnorkeltje(),
            ),
            const SizedBox(height: 20),

            // 6. STATS GRID
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding),
              child: _buildStatsGrid(),
            ),
            const SizedBox(height: 20),

            // 7. COMPANY INFO
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding),
              child: _buildCompanyInfo(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 1. HERO GRADIENT HEADER
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildHeroHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-1, -1),
          end: Alignment(1, 1),
          colors: [
            Color(0xFF0365C4),
            Color(0xFF0D7FE8),
            Color(0xFF00C1FF),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          // Wave decoration
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              child: CustomPaint(
                size: const Size(double.infinity, 60),
                painter: _WavePainter(),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.only(
              top: topPadding + 8,
              bottom: 48,
              left: AppDimensions.screenPadding,
              right: AppDimensions.screenPadding,
            ),
            child: Column(
              children: [
                // Back button row
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => smartBack(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Pool icon logo
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.pool, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 14),
                // Title
                const Text(
                  'Over Snorkeltje',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                // Subtitle
                Text(
                  'Zwemschool voor de regio Utrecht',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                // Rating badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(
                        5,
                        (_) => const Icon(Icons.star,
                            color: Color(0xFFFFC107), size: 16),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '9.6/10',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '240+ reviews',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. USP BANNER
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildUspBanner() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildUspItem(Icons.visibility_outlined, 'Aandacht',
                const Color(0xFF0365C4)),
            Container(width: 1, height: 36, color: AppColors.divider),
            _buildUspItem(
                Icons.bolt_outlined, 'Snelheid', const Color(0xFFFF5C00)),
            Container(width: 1, height: 36, color: AppColors.divider),
            _buildUspItem(Icons.check_circle_outline, 'Duidelijkheid',
                const Color(0xFF27AE60)),
          ],
        ),
      ),
    );
  }

  Widget _buildUspItem(IconData icon, String label, Color color) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. WIE IS WALTER
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildWieIsWalter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wie is Walter',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
                  ),
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0365C4).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'W',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Walter van der Berg',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Oprichter & Hoofdinstructeur',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Met meer dan 15 jaar ervaring in het zwemonderwijs startte Walter Zwemschool Snorkeltje met een duidelijke missie: elk kind leren zwemmen in een veilige, persoonlijke en leuke omgeving. Zijn passie voor water en kinderen is de drijvende kracht achter alles wat wij doen.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 4. MISSION & VISION
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildMissionVision() {
    return Row(
      children: [
        Expanded(
          child: _buildMissionCard(
            icon: Icons.gps_fixed,
            iconColor: const Color(0xFF0365C4),
            title: 'Missie',
            text:
                'Elk kind in de regio Utrecht waterveilig maken met persoonlijke aandacht.',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMissionCard(
            icon: Icons.favorite,
            iconColor: const Color(0xFFE74C3C),
            title: 'Visie',
            text:
                'De beste zwemschool van Utrecht worden door kwaliteit en liefde voor het vak.',
          ),
        ),
      ],
    );
  }

  Widget _buildMissionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 5. WAAROM SNORKELTJE
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildWaaromSnorkeltje() {
    final items = [
      _WhyItem(Icons.person_outline, 'Persoonlijk',
          'Kleine groepen, maximale aandacht', const Color(0xFF0365C4)),
      _WhyItem(Icons.verified_outlined, 'Gecertificeerd',
          'Alle instructeurs zijn gediplomeerd', const Color(0xFF27AE60)),
      _WhyItem(Icons.speed_outlined, 'Snel resultaat',
          'Gemiddeld 30% sneller diploma', const Color(0xFFFF5C00)),
      _WhyItem(Icons.location_on_outlined, 'Meerdere locaties',
          '7+ locaties in de regio Utrecht', const Color(0xFF8E44AD)),
      _WhyItem(Icons.emoji_emotions_outlined, 'Leuk & veilig',
          'Plezier staat centraal bij elke les', const Color(0xFFF5A623)),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Waarom Snorkeltje',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, color: item.color, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 6. STATS GRID
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildStatsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'Snorkeltje in cijfers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildStatCard('2.500+', 'Diploma\'s',
                  Icons.emoji_events, const Color(0xFF0365C4)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard('7+', 'Locaties', Icons.location_on,
                  const Color(0xFF27AE60)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                  '9.6', 'Beoordeling', Icons.star, const Color(0xFFF5A623)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard('15+', 'Jaar ervaring',
                  Icons.workspace_premium, const Color(0xFFFF5C00)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 7. COMPANY INFO
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildCompanyInfo() {
    final items = [
      {'label': 'KVK', 'value': '82341567'},
      {'label': 'BTW', 'value': 'NL123456789B01'},
      {'label': 'Opgericht', 'value': '2009'},
      {'label': 'Eigenaar', 'value': 'Walter van der Berg'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF0365C4).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.business_outlined,
                    color: Color(0xFF0365C4), size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Bedrijfsgegevens',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['label']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      item['value']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DATA CLASSES
// ═══════════════════════════════════════════════════════════════════════════
class _WhyItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _WhyItem(this.icon, this.title, this.subtitle, this.color);
}

// ═══════════════════════════════════════════════════════════════════════════
// WAVE PAINTER
// ═══════════════════════════════════════════════════════════════════════════
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.2,
        size.width * 0.5,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.8,
        size.width,
        size.height * 0.4,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
