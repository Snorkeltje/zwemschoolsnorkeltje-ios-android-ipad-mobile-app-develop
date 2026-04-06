import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class BookingTypeScreen extends StatelessWidget {
  const BookingTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Column(
        children: [
          // --- Gradient Header ---
          Container(
            padding: EdgeInsets.only(
              top: topPadding + 12,
              left: AppDimensions.screenPadding,
              right: AppDimensions.screenPadding,
              bottom: 28,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                // Back button
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Title & Subtitle
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welk type les?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Kies een les en boek direct',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.60),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- Scrollable content ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPadding,
              ),
              child: Column(
                children: [
                  // 14-day rule info banner (overlapping header with negative margin)
                  Transform.translate(
                    offset: const Offset(0, -14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMd),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Info icon
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3DC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.info_outline,
                              color: Color(0xFFF5A623),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Info text
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                                children: [
                                  TextSpan(
                                    text: '14-dagen regel: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFF5A623),
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'U kunt uw vaste wekelijkse les maximaal 14 dagen vooruit boeken.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Lesson type cards
                  _LessonTypeCard(
                    icon: Icons.access_time,
                    title: 'Vast tijdstip',
                    subtitle: 'Boek op uw vaste wekelijkse tijdstip',
                    gradientColors: const [
                      Color(0xFF0365C4),
                      Color(0xFF0D7FE8),
                    ],
                    shadowColor: const Color(0xFF0365C4),
                    onTap: () => context.push('/booking/fixed-slot'),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  _LessonTypeCard(
                    icon: Icons.person,
                    title: 'Extra 1-op-1',
                    subtitle: 'Privéles op een extra moment',
                    gradientColors: const [
                      Color(0xFFFF5C00),
                      Color(0xFFF5A623),
                    ],
                    shadowColor: const Color(0xFFFF5C00),
                    priceBadge: '€38/les',
                    priceBadgeColor: const Color(0xFFFFF0E0),
                    priceBadgeTextColor: const Color(0xFFFF5C00),
                    onTap: () => context.push('/booking/extra-lesson'),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  _LessonTypeCard(
                    icon: Icons.people,
                    title: 'Extra 1-op-2',
                    subtitle: 'Gedeelde les op een extra moment',
                    gradientColors: const [
                      Color(0xFF00C1FF),
                      Color(0xFF0D9FE8),
                    ],
                    shadowColor: const Color(0xFF00C1FF),
                    priceBadge: '€19/les',
                    priceBadgeColor: const Color(0xFFE0F5FF),
                    priceBadgeTextColor: const Color(0xFF00C1FF),
                    onTap: () => context.push('/booking/extra-lesson'),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  _LessonTypeCard(
                    icon: Icons.wb_sunny,
                    title: 'Vakantie zwemles',
                    subtitle: 'Zwemlessen tijdens vakanties',
                    gradientColors: const [
                      Color(0xFF27AE60),
                      Color(0xFF2ECC71),
                    ],
                    shadowColor: const Color(0xFF27AE60),
                    onTap: () => context.push('/booking/holiday'),
                  ),
                  const SizedBox(height: AppDimensions.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final Color shadowColor;
  final String? priceBadge;
  final Color? priceBadgeColor;
  final Color? priceBadgeTextColor;
  final VoidCallback onTap;

  const _LessonTypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.shadowColor,
    required this.onTap,
    this.priceBadge,
    this.priceBadgeColor,
    this.priceBadgeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Gradient icon container
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.white, size: 26),
            ),
            const SizedBox(width: AppDimensions.md),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (priceBadge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: priceBadgeColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            priceBadge!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: priceBadgeTextColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}
