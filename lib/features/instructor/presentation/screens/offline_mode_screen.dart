import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/utils/smart_back.dart';

class OfflineModeScreen extends StatelessWidget {
  const OfflineModeScreen({super.key});

  static const Color _bgColor = Color(0xFF0F1117);
  static const Color _cardColor = Color(0xFF1A1D27);
  static const Color _orange = Color(0xFFFF5C00);
  static const Color _barBg = Color(0xFF2E333F);
  static const Color _bannerRed = Color(0xFF992E1A);
  static const Color _retryBg = Color(0xFF0F2E4F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(
        children: [
          // ── Red offline banner ──
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 8,
            ),
            color: _bannerRed,
            child: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud_off, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Offline — Gecachede gegevens',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Dark header ──
          Container(
            width: double.infinity,
            color: _cardColor,
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => smartBack(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Rooster (Offline)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // balance back arrow
              ],
            ),
          ),

          // ── Scrollable content ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Sync info text ──
                  Text(
                    'Gecachet rooster · Sync: 2 uur geleden',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Cached lesson cards ──
                  _buildLessonCard(
                    time: '09:00 – 09:30',
                    location: 'Zwembad De Bilt',
                    students: 'Emma J.',
                    type: '1-op-1',
                  ),
                  const SizedBox(height: 12),
                  _buildLessonCard(
                    time: '09:30 – 10:00',
                    location: 'Zwembad De Bilt',
                    students: 'Sami K., Noor K.',
                    type: '1-op-2',
                  ),
                  const SizedBox(height: 12),
                  _buildLessonCard(
                    time: '13:00 – 13:30',
                    location: 'Zwembad De Bilt',
                    students: 'Lisa B., Tim v.D.',
                    type: '1-op-2',
                  ),

                  const SizedBox(height: 24),

                  // ── Sync queue card ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.sync, size: 20, color: _orange),
                            const SizedBox(width: 8),
                            const Text(
                              'Synchronisatiewachtrij',
                              style: TextStyle(
                                color: _orange,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '3 voortgangsupdates wachten',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                            height: 8,
                            child: Stack(
                              children: [
                                // background
                                Container(
                                  width: double.infinity,
                                  color: _barBg,
                                ),
                                // fill 30 %
                                FractionallySizedBox(
                                  widthFactor: 0.3,
                                  child: Container(color: _orange),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Retry button ──
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Verbinding opnieuw proberen...'),
                            backgroundColor: Color(0xFF0365C4),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.wifi, size: 18),
                      label: const Text(
                        'Verbinding proberen',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _retryBg,
                        foregroundColor: const Color(0xFF4A9EFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
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

  /// Builds a single cached-lesson card with an orange left accent bar.
  Widget _buildLessonCard({
    required String time,
    required String location,
    required String students,
    required String type,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Orange accent bar
          Container(
            width: 4,
            height: 100,
            decoration: const BoxDecoration(
              color: _orange,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                          color: _orange,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _orange.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Gecached',
                          style: TextStyle(
                            color: _orange,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    location,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$students  ·  $type',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
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
