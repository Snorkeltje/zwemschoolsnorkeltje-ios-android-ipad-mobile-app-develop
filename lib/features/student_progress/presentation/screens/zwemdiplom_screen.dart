import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/utils/smart_back.dart';

class ZwemdiplomScreen extends StatefulWidget {
  const ZwemdiplomScreen({super.key});

  @override
  State<ZwemdiplomScreen> createState() => _ZwemdiplomScreenState();
}

class _ZwemdiplomScreenState extends State<ZwemdiplomScreen> {
  String _selected = 'A';

  final List<Map<String, dynamic>> _diplomas = [
    {
      'id': 'A', 'name': 'Zwemdiploma A', 'status': 'in_progress', 'progress': 72, 'color': const Color(0xFF0365C4),
      'description': 'Basiszwemvaardigheden: zelfstandig zwemmen, onderwater zwemmen, drijven.',
      'skills': [
        {'name': 'Borst- en rugcrawl (25m)', 'done': true},
        {'name': 'Schoolslag (25m)', 'done': true},
        {'name': 'Rugslag (25m)', 'done': true},
        {'name': 'Onderwater zwemmen (10m)', 'done': true},
        {'name': 'Drijven op buik en rug (30s)', 'done': true},
        {'name': 'Trap watertrappen (1 min)', 'done': false},
        {'name': 'Spring vanaf rand + 25m zwemmen', 'done': false},
      ],
    },
    {
      'id': 'B', 'name': 'Zwemdiploma B', 'status': 'locked', 'progress': 0, 'color': const Color(0xFFFF5C00),
      'description': 'Verdieping: grotere afstanden, gekleed zwemmen, schrikeffecten.',
      'skills': [
        {'name': 'Gekleed zwemmen (50m)', 'done': false},
        {'name': 'Duiken vanaf startblok', 'done': false},
        {'name': 'Onderwater zwemmen (15m)', 'done': false},
        {'name': 'Borstcrawl (50m)', 'done': false},
        {'name': 'Survival zwemmen', 'done': false},
      ],
    },
    {
      'id': 'C', 'name': 'Zwemdiploma C', 'status': 'locked', 'progress': 0, 'color': const Color(0xFF27AE60),
      'description': 'Expert: noodsituaties, reddend zwemmen, alle slagen perfectioneren.',
      'skills': [
        {'name': 'Reddend zwemmen', 'done': false},
        {'name': 'Alle slagen 100m', 'done': false},
        {'name': 'Survival parcours', 'done': false},
        {'name': 'Duiken + objecten ophalen', 'done': false},
      ],
    },
  ];

  Map<String, dynamic> get _diploma => _diplomas.firstWhere((d) => d['id'] == _selected);

  @override
  Widget build(BuildContext context) {
    final diploma = _diploma;
    final skills = diploma['skills'] as List<Map<String, dynamic>>;
    final doneCount = skills.where((s) => s['done'] == true).length;
    final progress = diploma['progress'] as int;
    final color = diploma['color'] as Color;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF0D7FE8), Color(0xFF00C1FF)]),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => smartBack(context),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Zwemdiploma's", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                      Text('Sami Khilji — Voortgang', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                    ],
                  ),
                ),
                Icon(Icons.emoji_events_outlined, color: Colors.white.withValues(alpha: 0.3), size: 24),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Diploma tabs
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Transform.translate(
                      offset: const Offset(0, -12),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))],
                        ),
                        child: Row(
                          children: _diplomas.map((d) {
                            final isSelected = _selected == d['id'];
                            final isLocked = d['status'] == 'locked';
                            final dColor = d['color'] as Color;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () { if (!isLocked) setState(() => _selected = d['id']); },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    gradient: isSelected ? LinearGradient(colors: [dColor, dColor.withValues(alpha: 0.8)]) : null,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Opacity(
                                    opacity: isLocked ? 0.4 : 1,
                                    child: Column(
                                      children: [
                                        Icon(isLocked ? Icons.lock_outline : Icons.emoji_events, size: 16, color: isSelected ? Colors.white : dColor),
                                        const SizedBox(height: 4),
                                        Text('Diploma ${d['id']}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : const Color(0xFF1A1A2E))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),

                  // Progress ring
                  SizedBox(
                    width: 120, height: 120,
                    child: CustomPaint(
                      painter: _ProgressRingPainter(progress: progress / 100, color: color),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('$progress%', style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 28, fontWeight: FontWeight.w800)),
                            const Text('Voltooid', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(diploma['name'], style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w700)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                    child: Text(diploma['description'], style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 12), textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 20),

                  // Skills checklist
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vaardigheden ($doneCount/${skills.length})', style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        ...skills.asMap().entries.map((entry) {
                          final i = entry.key;
                          final skill = entry.value;
                          final done = skill['done'] as bool;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28, height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: done ? color : const Color(0xFFF4F7FC),
                                    border: done ? null : Border.all(color: const Color(0xFFE8ECF4), width: 2),
                                  ),
                                  child: Center(
                                    child: done
                                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                                        : Text('${i + 1}', style: const TextStyle(color: Color(0xFFC4CDD9), fontSize: 11, fontWeight: FontWeight.w700)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    skill['name'],
                                    style: TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w500,
                                      color: done ? const Color(0xFF27AE60) : const Color(0xFF4A5568),
                                      decoration: done ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                ),
                                if (done) const Icon(Icons.star, size: 14, color: Color(0xFFF5A623)),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 16),

                        // Info card
                        GestureDetector(
                          onTap: () => context.push('/child-progress'),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: const Color(0xFFE8F4FD), borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              children: [
                                Container(
                                  width: 40, height: 40,
                                  decoration: BoxDecoration(color: const Color(0xFF0365C4), borderRadius: BorderRadius.circular(12)),
                                  child: const Icon(Icons.star, color: Colors.white, size: 18),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Gedetailleerde voortgang', style: TextStyle(color: Color(0xFF0365C4), fontSize: 13, fontWeight: FontWeight.w700)),
                                      Text('Bekijk alle skills per niveau', style: TextStyle(color: Color(0xFF6B99C7), fontSize: 11)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, size: 16, color: Color(0xFF0365C4)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  _ProgressRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    final bgPaint = Paint()
      ..color = const Color(0xFFE8ECF4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
