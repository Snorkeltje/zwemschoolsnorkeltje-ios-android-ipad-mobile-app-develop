import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/utils/smart_back.dart';

/// Walter: exercises must link to skill components + child's progress level.
/// Also shows "goal for next lesson" linked to the exercises.
class _Exercise {
  final String emoji;
  final String title;
  final String duration;
  final String desc;
  final Color bg;
  final Color circleBg;
  final String skillComponent; // links to skill in progress
  final String level; // required level
  const _Exercise({
    required this.emoji,
    required this.title,
    required this.duration,
    required this.desc,
    required this.bg,
    required this.circleBg,
    required this.skillComponent,
    required this.level,
  });
}

class PracticeAtHomeScreen extends StatelessWidget {
  const PracticeAtHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const childLevel = 'Gevorderd Beginner';
    const childProgress = 72;
    const nextGoal = 'Beiderzijdse armcoördinatie 25m halen';

    final exercises = <_Exercise>[
      _Exercise(
        emoji: '🛁',
        title: 'Ademhaling in bad',
        duration: '5 min',
        desc: 'Doe je gezicht in het water, adem uit met bellen, til dan je hoofd op. Herhaal 10x. Helpt bij beheersen van ademhaling tijdens vrije slag.',
        bg: const Color(0xFFF0F4FC),
        circleBg: const Color(0xFFE1EDF8),
        skillComponent: 'Ademhaling',
        level: 'Beginner',
      ),
      _Exercise(
        emoji: '🪑',
        title: 'Scharrelschop op stoel',
        duration: '3 min',
        desc: 'Zit op de rand, maak een flutter-schopbeweging 30 seconden aan elk been. Versterkt beenkracht voor borstcrawl.',
        bg: const Color(0xFFFEF0E7),
        circleBg: const Color(0xFFFFEBE0),
        skillComponent: 'Vrije slag',
        level: 'Gevorderd Beginner',
      ),
      _Exercise(
        emoji: '🏠',
        title: 'Arm zwaaioefening',
        duration: '3 min',
        desc: 'Oefen de windmolenarmbeweging 20x per kant bij de spiegel. Direct gekoppeld aan je doel: beiderzijdse armcoördinatie.',
        bg: const Color(0xFFE0F9EC),
        circleBg: const Color(0xFFE3F7ED),
        skillComponent: 'Arm coördinatie',
        level: 'Gevorderd Beginner',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF131827)), onPressed: () => smartBack(context)),
        title: const Text('Oefeningen voor Thuis', style: TextStyle(color: Color(0xFF131827), fontSize: 18, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level card — linked to child's current progress level
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.trending_up, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      const Text('Niveau: $childLevel',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text('$childProgress%',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Oefeningen zijn afgestemd op het huidige niveau van Sami',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Goal card — linked to next lesson (Walter's feedback)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3DB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF5A623).withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5A623).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.flag, color: Color(0xFFF5A623), size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('🎯 Doel volgende les',
                            style: TextStyle(color: Color(0xFFF5A623), fontSize: 11, fontWeight: FontWeight.w700)),
                        SizedBox(height: 4),
                        Text(nextGoal,
                            style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 13, fontWeight: FontWeight.w600, height: 1.4)),
                        SizedBox(height: 6),
                        Text('👇 De oefeningen hieronder helpen je dit doel te behalen',
                            style: TextStyle(color: Color(0xFF8E6F1E), fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('Oefeningen deze week', style: TextStyle(color: Color(0xFF131827), fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('Gekoppeld aan je vaardigheden',
                style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
            const SizedBox(height: 16),

            ...exercises.map((ex) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ex.bg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: ex.circleBg),
                        child: Center(child: Text(ex.emoji, style: const TextStyle(fontSize: 28))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ex.title, style: const TextStyle(color: Color(0xFF131827), fontSize: 14, fontWeight: FontWeight.w700)),
                            Text('⏱ ${ex.duration}', style: const TextStyle(color: Color(0xFF818EA6), fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Linked skill tag — per Walter's feedback
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.link, size: 11, color: Color(0xFF44516B)),
                            const SizedBox(width: 4),
                            Text('Vaardigheid: ${ex.skillComponent}',
                                style: const TextStyle(color: Color(0xFF44516B), fontSize: 10, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text('Niveau: ${ex.level}',
                            style: const TextStyle(color: Color(0xFF44516B), fontSize: 10, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(ex.desc, style: const TextStyle(color: Color(0xFF44516B), fontSize: 12, height: 1.5)),
                ],
              ),
            )),

            const SizedBox(height: 8),
            const Text('✓ Toegewezen door Jan de Vries · 20 april', style: TextStyle(color: Color(0xFF818EA6), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
