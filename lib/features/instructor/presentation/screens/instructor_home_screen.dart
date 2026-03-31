import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class InstructorHomeScreen extends StatelessWidget {
  const InstructorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
              ),
              child: Row(
                children: [
                  // Back/Logout button
                  GestureDetector(
                    onTap: () => context.goNamed(RouteNames.login),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.logout, color: Color(0xFFFF5C00), size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF5C00), Color(0xFFF5A623)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text('A', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Goedemorgen,', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                        Text('Anna de Vries', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
                        Positioned(
                          top: 8, right: 8,
                          child: Container(
                            width: 8, height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF5C00), shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today's stats
                    Row(
                      children: [
                        _StatCard(label: 'Lessen vandaag', value: '6', icon: Icons.calendar_today, color: const Color(0xFFFF5C00)),
                        const SizedBox(width: 12),
                        _StatCard(label: 'Leerlingen', value: '8', icon: Icons.people, color: const Color(0xFF0365C4)),
                        const SizedBox(width: 12),
                        _StatCard(label: 'Locatie', value: 'De Bilt', icon: Icons.location_on, color: const Color(0xFF18BB68)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Today's schedule
                    const Text('Rooster vandaag',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),

                    ...[
                      _LessonItem(time: '09:00', child: 'Emma K.', type: '1-op-1', level: 'Beginner'),
                      _LessonItem(time: '09:30', child: 'Liam V.', type: '1-op-1', level: 'Gevorderd'),
                      _LessonItem(time: '10:00', child: 'Sophie W.', type: '1-op-2', level: 'Beginner'),
                      _LessonItem(time: '14:00', child: 'Noah B.', type: '1-op-1', level: 'Geavanceerd'),
                      _LessonItem(time: '14:30', child: 'Mia J.', type: '1-op-1', level: 'Beginner'),
                      _LessonItem(time: '15:00', child: 'Oliver P.', type: '1-op-2', level: 'Gevorderd'),
                    ],

                    const SizedBox(height: 24),

                    // Quick actions
                    const Text('Snelle acties',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _ActionButton(
                          label: 'Rooster',
                          icon: Icons.calendar_month,
                          color: const Color(0xFF0365C4),
                          onTap: () {},
                        ),
                        const SizedBox(width: 12),
                        _ActionButton(
                          label: 'Leerlingen',
                          icon: Icons.people,
                          color: const Color(0xFFFF5C00),
                          onTap: () {},
                        ),
                        const SizedBox(width: 12),
                        _ActionButton(
                          label: 'Chat',
                          icon: Icons.chat_bubble_outline,
                          color: const Color(0xFF18BB68),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
            Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _LessonItem extends StatelessWidget {
  final String time, child, type, level;
  const _LessonItem({required this.time, required this.child, required this.type, required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            child: Text(time, style: const TextStyle(color: Color(0xFFFF5C00), fontSize: 13, fontWeight: FontWeight.w700)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(child, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                Text('$type · $level', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: const Color(0xFF94A3B8), size: 18),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
