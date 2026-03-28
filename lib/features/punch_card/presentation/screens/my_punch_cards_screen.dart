import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../data/models/punch_card_model.dart';

class MyPunchCardsScreen extends StatelessWidget {
  const MyPunchCardsScreen({super.key});

  // Mock data
  List<PunchCardModel> get _activeCards => [
        PunchCardModel(
          id: 'pc_001',
          userId: 'usr_001',
          lessonType: '1-op-1',
          totalLessons: 10,
          usedLessons: 3,
          remainingLessons: 7,
          validUntil: DateTime.now().add(const Duration(days: 180)),
          isActive: true,
        ),
        PunchCardModel(
          id: 'pc_002',
          userId: 'usr_001',
          lessonType: '1-op-2',
          totalLessons: 20,
          usedLessons: 14,
          remainingLessons: 6,
          validUntil: DateTime.now().add(const Duration(days: 90)),
          isActive: true,
        ),
      ];

  List<PunchCardModel> get _expiredCards => [
        PunchCardModel(
          id: 'pc_003',
          userId: 'usr_001',
          lessonType: '1-op-1',
          totalLessons: 10,
          usedLessons: 10,
          remainingLessons: 0,
          validUntil: DateTime.now().subtract(const Duration(days: 30)),
          isActive: false,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.myPunchCards),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active cards
            const Text(
              AppStrings.activePunchCards,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            if (_activeCards.isEmpty)
              _buildEmptyState()
            else
              ..._activeCards.map((card) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.md),
                    child: _PunchCardWidget(punchCard: card),
                  )),

            const SizedBox(height: AppDimensions.md),

            // Purchase button
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to purchase punch card
                },
                icon: const Icon(Icons.add),
                label: const Text(
                  AppStrings.purchasePunchCard,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.textWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  elevation: 2,
                ),
              ),
            ),

            // Expired cards
            if (_expiredCards.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.xl),
              const Text(
                'Verlopen kaarten',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.md),
              ..._expiredCards.map((card) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.md),
                    child: _PunchCardWidget(punchCard: card, isExpired: true),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            size: 48,
            color: AppColors.textLight,
          ),
          SizedBox(height: AppDimensions.md),
          Text(
            'Geen actieve knipkaarten',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppDimensions.xs),
          Text(
            'Koop een knipkaart om lessen te boeken.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _PunchCardWidget extends StatelessWidget {
  final PunchCardModel punchCard;
  final bool isExpired;

  const _PunchCardWidget({
    required this.punchCard,
    this.isExpired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPadding + 4),
      decoration: BoxDecoration(
        gradient: isExpired
            ? const LinearGradient(
                colors: [Color(0xFF9CA3AF), Color(0xFF6B7280)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [AppColors.primaryBlue, Color(0xFF0480E8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: isExpired
                ? AppColors.shadow
                : AppColors.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${punchCard.totalLessons}x ${punchCard.lessonType} Zwemlessen',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (isExpired)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Verlopen',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Remaining count
          Text(
            '${punchCard.remainingLessons}',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const Text(
            'lessen resterend',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),

          // Progress dots
          Row(
            children: List.generate(
              punchCard.totalLessons > 20 ? 20 : punchCard.totalLessons,
              (index) {
                final isUsed = index < punchCard.usedLessons;
                final dotSize = punchCard.totalLessons > 15 ? 10.0 : 14.0;
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    height: dotSize,
                    decoration: BoxDecoration(
                      color: isUsed
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(dotSize / 2),
                    ),
                  ),
                );
              },
            ),
          ),
          if (punchCard.totalLessons > 20)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${punchCard.usedLessons} / ${punchCard.totalLessons} gebruikt',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white70,
                ),
              ),
            ),
          const SizedBox(height: 16),

          // Valid until
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppStrings.validUntil}: ${DateFormat('d MMM yyyy', 'nl').format(punchCard.validUntil)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              Text(
                '#${punchCard.id.toUpperCase()}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white54,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
