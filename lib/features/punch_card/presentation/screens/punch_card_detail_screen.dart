import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../data/models/punch_card_model.dart';
import '../../../../shared/utils/smart_back.dart';

class PunchCardDetailScreen extends StatelessWidget {
  final PunchCardModel? punchCard;

  const PunchCardDetailScreen({super.key, this.punchCard});

  PunchCardModel get _card =>
      punchCard ??
      PunchCardModel(
        id: '22976',
        userId: 'usr_001',
        lessonType: '1-op-1',
        totalLessons: 10,
        usedLessons: 2,
        remainingLessons: 8,
        validUntil: DateTime(2027, 3, 24),
        isActive: true,
      );

  @override
  Widget build(BuildContext context) {
    final card = _card;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // White header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => smartBack(context),
                    icon: const Icon(Icons.arrow_back, size: 24),
                    color: AppColors.textPrimary,
                  ),
                  const Expanded(
                    child: Text(
                      'Kaartdetails',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // balance the back button
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Blue card visual
                    _buildCardVisual(card),
                    const SizedBox(height: 28),

                    // Usage history section
                    const Text(
                      'Gebruiksgeschiedenis',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildUsageHistoryList(),
                    const SizedBox(height: 24),

                    // Buy another punch card button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          context.goNamed(RouteNames.purchasePunchCard);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8F4FD),
                          foregroundColor: const Color(0xFF1A6FBF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Nog een knipkaart kopen →',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardVisual(PunchCardModel card) {
    final double progress = card.totalLessons > 0
        ? card.remainingLessons / card.totalLessons
        : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A6FBF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          const Text(
            '💳 1-op-1 Zwemlessen',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Zwemschool Snorkeltje',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFB2D9FF),
            ),
          ),
          const SizedBox(height: 16),

          // Big remaining count
          Text(
            '${card.remainingLessons}',
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const Text(
            'lessen resterend',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFB2D9FF),
            ),
          ),
          const SizedBox(height: 16),

          // Progress bar
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF80A6D9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Bottom info row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kaart #${card.id}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFB2D9FF),
                ),
              ),
              Text(
                'Geldig: ${DateFormat('d MMM yyyy', 'nl').format(card.validUntil)}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFB2D9FF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsageHistoryList() {
    final usageHistory = [
      {
        'date': '15 maart 2027',
        'detail': '1-op-1 les bij Anna de Vries, De Bilt',
      },
      {
        'date': '8 maart 2027',
        'detail': '1-op-1 les bij Jan Bakker, Soestduinen',
      },
      {
        'date': '1 maart 2027',
        'detail': '1-op-1 les bij Anna de Vries, De Bilt',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: List.generate(usageHistory.length, (index) {
          final entry = usageHistory[index];
          return Column(
            children: [
              if (index > 0)
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry['date']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            entry['detail']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '-1',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE74C3C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
