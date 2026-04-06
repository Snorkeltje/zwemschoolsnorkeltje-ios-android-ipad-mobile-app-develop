import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PracticeAtHomeScreen extends StatelessWidget {
  const PracticeAtHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exercises = [
      {'emoji': '🛁', 'title': 'Ademhaling in bad', 'duration': '5 min', 'desc': 'Doe je gezicht in het water, adem uit met bellen, til dan je hoofd op. Herhaal 10x.', 'bg': const Color(0xFFF0F4FC), 'circleBg': const Color(0xFFE1EDF8)},
      {'emoji': '🪑', 'title': 'Scharrelschop op stoel', 'duration': '3 min', 'desc': 'Zit op de rand, maak een flutter-schopbeweging 30 seconden aan elk been.', 'bg': const Color(0xFFFEF0E7), 'circleBg': const Color(0xFFFFEBE0)},
      {'emoji': '🏠', 'title': 'Arm zwaaioefening', 'duration': '3 min', 'desc': 'Oefen de windmolenarmbeweging 20x per kant bij de spiegel.', 'bg': const Color(0xFFE0F9EC), 'circleBg': const Color(0xFFE3F7ED)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF131827)), onPressed: () => context.pop()),
        title: const Text('Oefeningen voor Thuis', style: TextStyle(color: Color(0xFF131827), fontSize: 18, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4FC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(width: 4, height: 30, decoration: BoxDecoration(color: const Color(0xFF0365C4), borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('📋  Op basis van Sami\'s niveau: Gevorderd Beginner', style: TextStyle(color: Color(0xFF0365C4), fontSize: 12, fontWeight: FontWeight.w500))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Oefeningen deze week', style: TextStyle(color: Color(0xFF131827), fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),

            ...exercises.map((ex) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ex['bg'] as Color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: ex['circleBg'] as Color),
                        child: Center(child: Text(ex['emoji'] as String, style: const TextStyle(fontSize: 28))),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ex['title'] as String, style: const TextStyle(color: Color(0xFF131827), fontSize: 14, fontWeight: FontWeight.w700)),
                          Text('⏱ ${ex['duration']}', style: const TextStyle(color: Color(0xFF818EA6), fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(ex['desc'] as String, style: const TextStyle(color: Color(0xFF44516B), fontSize: 12)),
                ],
              ),
            )),

            const SizedBox(height: 8),
            const Text('✓ Toegewezen door Jan de Vries · 22 maart', style: TextStyle(color: Color(0xFF818EA6), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
