import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/utils/smart_back.dart';

class SkillDetailScreen extends StatelessWidget {
  const SkillDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'name': 'Vangfase met hoge elleboog', 'done': true},
      {'name': 'Trekfase met volledige extensie', 'done': true},
      {'name': 'Herstel over water', 'done': true},
      {'name': 'Beiderzijdse armcoördinatie 25m', 'done': false},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF131827)), onPressed: () => smartBack(context)),
        title: const Text('Vrije slag armen', style: TextStyle(color: Color(0xFF131827), fontSize: 18, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF0F4FC), borderRadius: BorderRadius.circular(12)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Niveau: Gevorderd Beginner', style: TextStyle(color: Color(0xFF131827), fontSize: 14, fontWeight: FontWeight.w700)),
                  SizedBox(height: 4),
                  Text('Voortgang: 3 van 4 stappen afgerond', style: TextStyle(color: Color(0xFF818EA6), fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('Stappen', style: TextStyle(color: Color(0xFF131827), fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),

            ...steps.map((step) {
              final done = step['done'] as bool;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: done ? const Color(0xFFE0F9EC) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done ? const Color(0xFF18BB67) : const Color(0xFFDCE4F0),
                      ),
                      child: done ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        step['name'] as String,
                        style: TextStyle(
                          color: done ? const Color(0xFF131827) : const Color(0xFF818EA6),
                          fontSize: 13,
                          fontWeight: done ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),
            const Text('Instructeursnotitie', style: TextStyle(color: Color(0xFF131827), fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('💬  Jan de Vries  ·  22 maart 2026', style: TextStyle(color: Color(0xFF818EA6), fontSize: 12)),
                  SizedBox(height: 8),
                  Text('Goede verbetering vandaag. Focus op hoge elleboog in de vangfase.', style: TextStyle(color: Color(0xFF44516B), fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('Doel voor volgende les', style: TextStyle(color: Color(0xFF131827), fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFFEF3DB), borderRadius: BorderRadius.circular(12)),
              child: const Text('🎯  Beiderzijdse armcoördinatie 25m halen', style: TextStyle(color: Color(0xFFFCAA00), fontSize: 13, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: () => context.push('/practice-home'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFE0F9EC), borderRadius: BorderRadius.circular(14)),
                child: const Text('📚  Oefeningen voor thuis →', style: TextStyle(color: Color(0xFF18BB67), fontSize: 14, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
