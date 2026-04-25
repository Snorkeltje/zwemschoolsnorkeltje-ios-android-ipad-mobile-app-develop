import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/utils/smart_back.dart';

class ReservationDetailScreen extends StatelessWidget {
  const ReservationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('📅', 'Datum:', 'Maandag 28 april 2026'),
      ('⏰', 'Tijd:', '15:00 – 15:30 (30 min)'),
      ('📍', 'Locatie:', 'De Bilt Zwembad'),
      ('👨‍🏫', 'Instructeur:', 'Jan de Vries'),
      ('💳', 'Betaald via:', 'Tegoed (€39 afgetrokken)'),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => smartBack(context),
                  child: const Icon(Icons.chevron_left, color: Color(0xFF131827), size: 24),
                ),
                const SizedBox(width: 12),
                const Text('Detail',
                    style: TextStyle(color: Color(0xFF131827), fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Details card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('1-op-1 Zwemles',
                                style: TextStyle(color: Color(0xFF131827), fontSize: 16, fontWeight: FontWeight.w700)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F4FC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('Vast tijdstip',
                                  style: TextStyle(color: Color(0xFF0365C4), fontSize: 11, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...items.map((it) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 130,
                                    child: Text('${it.$1} ${it.$2}',
                                        style: const TextStyle(color: Color(0xFF818EA6), fontSize: 12)),
                                  ),
                                  Expanded(
                                    child: Text(it.$3,
                                        style: const TextStyle(color: Color(0xFF131827), fontSize: 12, fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Policy
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3DB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('⚠️  Annuleringsbeleid',
                            style: TextStyle(color: Color(0xFFFCAA00), fontSize: 13, fontWeight: FontWeight.w700)),
                        SizedBox(height: 4),
                        Text('Annuleer tot 24 uur voor de les voor terugbetaling.',
                            style: TextStyle(color: Color(0xFF44516B), fontSize: 12)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Cancel button
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE4E4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text('Reservering annuleren',
                        style: TextStyle(color: Color(0xFFF03838), fontSize: 15, fontWeight: FontWeight.w700)),
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
