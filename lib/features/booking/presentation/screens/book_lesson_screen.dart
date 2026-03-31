import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class BookLessonScreen extends StatelessWidget {
  const BookLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lessonTypes = [
      _LessonType(
        icon: Icons.access_time,
        title: 'Vast Tijdstip',
        subtitle: 'Boek op uw vaste wekelijkse tijdstip',
        gradient: const [Color(0xFF0365C4), Color(0xFF0D7FE8)],
        shadowColor: const Color(0x330365C4),
        bgLight: const Color(0xFFE8F4FD),
        badge: null,
        route: '/fixed-slot-calendar',
      ),
      _LessonType(
        icon: Icons.person,
        title: 'Extra 1-op-1',
        subtitle: 'Privéles op een extra moment',
        gradient: const [Color(0xFFFF5C00), Color(0xFFF5A623)],
        shadowColor: const Color(0x33FF5C00),
        bgLight: const Color(0xFFFEF0E7),
        badge: '€38/les',
        route: '/extra-lesson-calendar',
      ),
      _LessonType(
        icon: Icons.people,
        title: 'Extra 1-op-2',
        subtitle: 'Gedeelde les op een extra moment',
        gradient: const [Color(0xFF00C1FF), Color(0xFF0D9FE8)],
        shadowColor: const Color(0x3300C1FF),
        bgLight: const Color(0xFFE0F3FF),
        badge: '€19/les',
        route: '/location-selection',
      ),
      _LessonType(
        icon: Icons.wb_sunny,
        title: 'Vakantie Zwemles',
        subtitle: 'Zwemlessen tijdens vakanties',
        gradient: const [Color(0xFF27AE60), Color(0xFF2ECC71)],
        shadowColor: const Color(0x3327AE60),
        bgLight: const Color(0xFFE0F9EC),
        badge: null,
        route: '/holiday-lessons',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header with gradient
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Boek een les',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    Text(
                      'Kies het type les',
                      style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.6)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // 14-day rule banner
                  Transform.translate(
                    offset: const Offset(0, -12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3DC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.info_outline, size: 16, color: Color(0xFFF5A623)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(fontSize: 12, height: 1.5, color: Color(0xFF6B7B94), fontFamily: 'Inter'),
                                children: [
                                  TextSpan(text: '14-dagenregel: ', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFF5A623))),
                                  TextSpan(text: 'Extra lessen kunnen alleen worden geboekt binnen 14 dagen. Vaste tijdstippen altijd beschikbaar.'),
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
                  ...lessonTypes.map((type) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate based on route
                        switch (type.route) {
                          case '/fixed-slot-calendar':
                            context.push('/booking/fixed-slot');
                            break;
                          case '/extra-lesson-calendar':
                            context.push('/booking/extra-lesson');
                            break;
                          case '/location-selection':
                            context.push('/booking/location');
                            break;
                          case '/holiday-lessons':
                            context.push('/booking/holiday');
                            break;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [BoxShadow(color: type.shadowColor, blurRadius: 16, offset: const Offset(0, 4))],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: type.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [BoxShadow(color: type.shadowColor, blurRadius: 16, offset: const Offset(0, 6))],
                              ),
                              child: Icon(type.icon, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(type.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                                      if (type.badge != null) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: type.bgLight,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(type.badge!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: type.gradient[0])),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(type.subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF8E9BB3), height: 1.4)),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, size: 18, color: Color(0xFFC4CDD9)),
                          ],
                        ),
                      ),
                    ),
                  )),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonType {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final Color shadowColor;
  final Color bgLight;
  final String? badge;
  final String route;

  const _LessonType({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.shadowColor,
    required this.bgLight,
    required this.badge,
    required this.route,
  });
}
