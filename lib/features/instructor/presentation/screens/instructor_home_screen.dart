import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class _ScheduleItem {
  final String time;
  final String location;
  final int students;
  final String type;
  final bool done;
  final bool current;
  const _ScheduleItem(this.time, this.location, this.students, this.type, {this.done = false, this.current = false});
}

const _schedule = <_ScheduleItem>[
  _ScheduleItem('13:00', 'De Bilt', 2, '1-op-2', done: true),
  _ScheduleItem('14:00', 'De Bilt', 1, '1-op-1', done: true),
  _ScheduleItem('15:00', 'De Bilt', 3, '1-op-3', current: true),
  _ScheduleItem('16:00', 'Bad Hulck.', 2, '1-op-2'),
  _ScheduleItem('16:30', 'Bad Hulck.', 1, '1-op-1'),
];

class InstructorHomeScreen extends StatelessWidget {
  const InstructorHomeScreen({super.key});

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Goedemorgen';
    if (h < 18) return 'Goedemiddag';
    return 'Goedenavond';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 58, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1D27), Color(0xFF252836)],
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.goNamed(RouteNames.login),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.logout, color: Color(0xFFFF5C00), size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)]),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: const Color(0xFFFF5C00).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    alignment: Alignment.center,
                    child: const Text('J', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$_greeting,', style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
                        const Text('Jan de Vries',
                            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  _iconBadge(Icons.chat_bubble_outline, '3', const Color(0xFF00C1FF),
                      onTap: () => context.pushNamed(RouteNames.instructorChatList)),
                  const SizedBox(width: 8),
                  _iconBadge(Icons.notifications_outlined, '5', const Color(0xFFFF5C00),
                      onTap: () => context.pushNamed(RouteNames.notifications)),
                ],
              ),
            ),

            // Stats banner
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFF5C00), Color(0xFFF5A623)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: const Color(0xFFFF5C00).withValues(alpha: 0.3), blurRadius: 32, offset: const Offset(0, 12))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vandaag — Maandag 28 april',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _stat('8', 'lessen'),
                        _divider(),
                        _stat('12', 'leerlingen'),
                        _divider(),
                        _stat('2', 'locaties'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Next lesson
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Volgende les',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 12, color: Color(0xFFFF5C00)),
                          SizedBox(width: 6),
                          Text('Over 45 min',
                              style: TextStyle(color: Color(0xFFFF5C00), fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1D27),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFFF5C00).withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('15:00 – 15:30',
                                  style: TextStyle(color: Color(0xFFFF5C00), fontSize: 16, fontWeight: FontWeight.w700)),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 13, color: Color(0xFF8E9BB3)),
                                  SizedBox(width: 6),
                                  Text('De Bilt Zwembad',
                                      style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 13)),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.people_outline, size: 13, color: Color(0xFF8E9BB3)),
                                  SizedBox(width: 6),
                                  Text('3 leerlingen · 1-op-3',
                                      style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 72,
                              height: 32,
                              child: Stack(
                                children: [
                                  _miniAvatar('S', [const Color(0xFF0365C4), const Color(0xFF00C1FF)], 0),
                                  _miniAvatar('K', [const Color(0xFF27AE60), const Color(0xFF2ECC71)], 20),
                                  _miniAvatar('L', [const Color(0xFFF5A623), const Color(0xFFFF5C00)], 40),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Row(
                              children: [
                                Text('Details',
                                    style: TextStyle(color: Color(0xFFFF5C00), fontSize: 12, fontWeight: FontWeight.w600)),
                                SizedBox(width: 4),
                                Icon(Icons.chevron_right, color: Color(0xFFFF5C00), size: 14),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Today's schedule
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Rooster vandaag',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      GestureDetector(
                        onTap: () => context.pushNamed(RouteNames.instructorSchedule),
                        child: const Text('Volledig rooster →',
                            style: TextStyle(color: Color(0xFFFF5C00), fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._schedule.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: item.current ? null : const Color(0xFF1A1D27),
                        gradient: item.current
                            ? LinearGradient(colors: [
                                const Color(0xFFFF5C00).withValues(alpha: 0.12),
                                const Color(0xFFF5A623).withValues(alpha: 0.06),
                              ])
                            : null,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: item.current ? const Color(0xFFFF5C00).withValues(alpha: 0.3) : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          if (item.current)
                            Container(
                              width: 3,
                              height: 24,
                              decoration: const BoxDecoration(color: Color(0xFFFF5C00)),
                            )
                          else
                            const SizedBox(width: 3),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 48,
                            child: Text(
                              item.time,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: item.done
                                    ? const Color(0xFF4A5568)
                                    : item.current
                                        ? const Color(0xFFFF5C00)
                                        : const Color(0xFFE2E8F0),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.location,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: item.done ? const Color(0xFF4A5568) : const Color(0xFFE2E8F0),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(item.type,
                                style: const TextStyle(color: Color(0xFF4A5568), fontSize: 10)),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.people_outline,
                              size: 12, color: item.done ? const Color(0xFF4A5568) : const Color(0xFF8E9BB3)),
                          const SizedBox(width: 4),
                          Text('${item.students}',
                              style: TextStyle(
                                fontSize: 12,
                                color: item.done ? const Color(0xFF4A5568) : const Color(0xFF8E9BB3),
                              )),
                          const SizedBox(width: 8),
                          if (item.done)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF27AE60).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text('✓',
                                  style: TextStyle(color: Color(0xFF27AE60), fontSize: 10, fontWeight: FontWeight.w600)),
                            ),
                          if (item.current)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF5C00).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text('NU',
                                  style: TextStyle(color: Color(0xFFFF5C00), fontSize: 10, fontWeight: FontWeight.w700)),
                            ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),

            // Quick actions
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Snelle acties',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.6,
                    children: [
                      _qa(context, Icons.calendar_month, 'Volledig rooster', [const Color(0xFF0365C4), const Color(0xFF00C1FF)], const Color(0x330365C4), RouteNames.instructorSchedule),
                      _qa(context, Icons.people, 'Mijn leerlingen', [const Color(0xFFFF5C00), const Color(0xFFF5A623)], const Color(0x33FF5C00), RouteNames.instructorStudents),
                      _qa(context, Icons.chat_bubble_outline, 'Berichten', [const Color(0xFF27AE60), const Color(0xFF2ECC71)], const Color(0x3327AE60), RouteNames.instructorChatList),
                      _qa(context, Icons.trending_up, 'Beschikbaarheid', [const Color(0xFF9B59B6), const Color(0xFF8E44AD)], const Color(0x339B59B6), RouteNames.instructorAvailability),
                    ],
                  ),
                ],
              ),
            ),

            // Sync
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF27AE60).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.wifi, size: 14, color: Color(0xFF27AE60)),
                    SizedBox(width: 8),
                    Text('Online — Alle data gesynchroniseerd',
                        style: TextStyle(color: Color(0xFF27AE60), fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBadge(IconData icon, String count, Color color, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: const Color(0xFFE2E8F0), size: 20),
          ),
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              alignment: Alignment.center,
              child: Text(count, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w700)),
          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 40,
        color: Colors.white.withValues(alpha: 0.2),
        margin: const EdgeInsets.symmetric(horizontal: 16),
      );

  Widget _miniAvatar(String l, List<Color> bg, double left) {
    return Positioned(
      left: left,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: bg),
          border: Border.all(color: const Color(0xFF1A1D27), width: 2),
        ),
        alignment: Alignment.center,
        child: Text(l, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _qa(BuildContext context, IconData icon, String label, List<Color> gradient, Color shadow, String route) {
    return GestureDetector(
      onTap: () => context.pushNamed(route),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D27),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradient),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: shadow, blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
