import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class _Skill {
  final String name;
  final String level;
  final int pct;
  final Color color;
  final List<Color> gradient;
  final String steps;
  const _Skill(this.name, this.level, this.pct, this.color, this.gradient, this.steps);
}

const _skills = <_Skill>[
  _Skill('Vrije slag armen', 'Goed', 75, Color(0xFF0365C4), [Color(0xFF0365C4), Color(0xFF00C1FF)], '3/4 stappen'),
  _Skill('Ademhaling', 'Bezig', 50, Color(0xFFFF5C00), [Color(0xFFFF5C00), Color(0xFFF5A623)], '2/4 stappen'),
  _Skill('Rugslag basis', 'Start', 25, Color(0xFF27AE60), [Color(0xFF27AE60), Color(0xFF2ECC71)], '1/4 stappen'),
  _Skill('Keerbocht', 'Nieuw', 10, Color(0xFF8E44AD), [Color(0xFF8E44AD), Color(0xFF9B59B6)], '0/3 stappen'),
];

class ChildProgressScreen extends StatelessWidget {
  const ChildProgressScreen({super.key});

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
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 58, 20, 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0365C4), Color(0xFF034DA9)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                        const Text("Sami's Voortgang",
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                            border: Border.all(color: Colors.white.withOpacity(0.2), width: 3),
                          ),
                          alignment: Alignment.center,
                          child: const Text('S',
                              style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.emoji_events, color: Color(0xFFF5A623), size: 16),
                                  SizedBox(width: 8),
                                  Text('Gevorderd Beginner',
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text('Totale voortgang',
                                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(999),
                                      child: Container(
                                        height: 8,
                                        color: Colors.white.withOpacity(0.15),
                                        child: FractionallySizedBox(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: 0.65,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(colors: [Color(0xFF00C1FF), Colors.white]),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('65%',
                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Stats
            Transform.translate(
              offset: const Offset(0, -16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _stat(Icons.star, '24', 'Lessen', const Color(0xFFF5A623)),
                      _stat(Icons.trending_up, '4', 'Skills', const Color(0xFF0365C4)),
                      _stat(Icons.emoji_events, '2', 'Badges', const Color(0xFF27AE60)),
                    ],
                  ),
                ),
              ),
            ),

            // Active skills
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Actieve Vaardigheden',
                      style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  ..._skills.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => context.pushNamed(RouteNames.skillDetail),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(width: 8, height: 8, decoration: BoxDecoration(color: s.color, shape: BoxShape.circle)),
                                    const SizedBox(width: 8),
                                    Text(s.name,
                                        style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: s.color.withOpacity(0.07),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text(s.level,
                                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: s.color)),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.chevron_right, color: Color(0xFFC4CDD9), size: 16),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(999),
                                    child: Container(
                                      height: 6,
                                      color: const Color(0xFFF0F4FA),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: s.pct / 100,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: s.gradient),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text('${s.pct}%',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: s.color)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(s.steps,
                                style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                  )),

                  // Practice at home banner
                  GestureDetector(
                    onTap: () => context.pushNamed(RouteNames.practiceAtHome),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFE8F8F0), Color(0xFFD4F5E0)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFB8E8CB), width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF27AE60), Color(0xFF2ECC71)]),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.menu_book, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Oefeningen voor thuis',
                                    style: TextStyle(color: Color(0xFF27AE60), fontSize: 14, fontWeight: FontWeight.w700)),
                                Text('3 nieuwe oefeningen beschikbaar',
                                    style: TextStyle(color: Color(0xFF5BB17A), fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Color(0xFF27AE60), size: 18),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Last lesson info
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 1))],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Laatste les: 22 maart',
                            style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
                        Text('Instructeur: Jan de Vries',
                            style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 20, fontWeight: FontWeight.w700)),
        Text(label, style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 10)),
      ],
    );
  }
}
