import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class _LessonType {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final Color shadow;
  final Color bgLight;
  final Color badgeColor;
  final String routeName;
  final String? badge;
  const _LessonType({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.shadow,
    required this.bgLight,
    required this.badgeColor,
    required this.routeName,
    this.badge,
  });
}

class BookLessonScreen extends StatelessWidget {
  const BookLessonScreen({super.key});

  static final _types = <_LessonType>[
    _LessonType(
      icon: Icons.access_time,
      title: 'Vast tijdstip',
      subtitle: 'Wekelijkse les op vast moment',
      gradient: const [Color(0xFF0365C4), Color(0xFF0D7FE8)],
      shadow: const Color(0x330365C4),
      bgLight: const Color(0xFFE8F4FD),
      badgeColor: const Color(0xFF0365C4),
      routeName: RouteNames.fixedSlotCalendar,
    ),
    _LessonType(
      icon: Icons.person_add_alt_1,
      title: 'Extra 1-op-1',
      subtitle: 'Individuele extra les',
      gradient: const [Color(0xFFFF5C00), Color(0xFFF5A623)],
      shadow: const Color(0x33FF5C00),
      bgLight: const Color(0xFFFEF0E7),
      badgeColor: const Color(0xFFFF5C00),
      routeName: RouteNames.extraLessonCalendar,
      badge: '€38',
    ),
    _LessonType(
      icon: Icons.people,
      title: 'Extra 1-op-2',
      subtitle: 'Kies eerst een locatie',
      gradient: const [Color(0xFF00C1FF), Color(0xFF0D9FE8)],
      shadow: const Color(0x3300C1FF),
      bgLight: const Color(0xFFE0F3FF),
      badgeColor: const Color(0xFF00C1FF),
      routeName: RouteNames.locationSelection,
      badge: '€19',
    ),
    _LessonType(
      icon: Icons.wb_sunny,
      title: 'Vakantie-zwemles',
      subtitle: 'Tijdens schoolvakanties',
      gradient: const [Color(0xFF27AE60), Color(0xFF2ECC71)],
      shadow: const Color(0x3327AE60),
      bgLight: const Color(0xFFE0F9EC),
      badgeColor: const Color(0xFF27AE60),
      routeName: RouteNames.holidayLessons,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 58, 20, 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
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
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.chevron_left, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Les boeken',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                        Text('Kies uw lestype',
                            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 14-day rule banner
            Transform.translate(
              offset: const Offset(0, -12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
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
                        alignment: Alignment.center,
                        child: const Icon(Icons.info_outline, color: Color(0xFFF5A623), size: 16),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(color: Color(0xFF6B7B94), fontSize: 12, height: 1.5),
                            children: [
                              TextSpan(
                                text: '14-dagen regel: ',
                                style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFF5A623)),
                              ),
                              TextSpan(
                                text: 'Reserveringen kunnen tot 14 dagen vooruit worden gemaakt.',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Lesson types
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: _types
                    .map((t) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => context.pushNamed(t.routeName),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [BoxShadow(color: t.shadow, blurRadius: 16, offset: const Offset(0, 4))],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: t.gradient,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [BoxShadow(color: t.shadow, blurRadius: 16, offset: const Offset(0, 6))],
                                    ),
                                    child: Icon(t.icon, color: Colors.white, size: 24),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(t.title,
                                                style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 15, fontWeight: FontWeight.w700)),
                                            if (t.badge != null) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(color: t.bgLight, borderRadius: BorderRadius.circular(999)),
                                                child: Text('${t.badge}/les',
                                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: t.badgeColor)),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(t.subtitle,
                                            style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 12, height: 1.4)),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right, color: Color(0xFFC4CDD9), size: 18),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
