import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../data/models/punch_card_model.dart';

class PunchCardDetailScreen extends StatelessWidget {
  final PunchCardModel? punchCard;

  const PunchCardDetailScreen({super.key, this.punchCard});

  // Fallback mock data
  PunchCardModel get _card =>
      punchCard ??
      PunchCardModel(
        id: 'pc_001',
        userId: 'usr_001',
        lessonType: '1-op-1',
        totalLessons: 10,
        usedLessons: 3,
        remainingLessons: 7,
        validUntil: DateTime.now().add(const Duration(days: 180)),
        isActive: true,
      );

  @override
  Widget build(BuildContext context) {
    final card = _card;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Knipkaart details'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card visual
            _buildPunchCardVisual(card),
            const SizedBox(height: AppDimensions.sectionSpacing),

            // Usage details
            _buildInfoCard(
              title: 'Gebruik',
              children: [
                _buildInfoRow('Totaal lessen', '${card.totalLessons}'),
                const Divider(height: 24, color: AppColors.divider),
                _buildInfoRow('Gebruikt', '${card.usedLessons}',
                    valueColor: AppColors.primaryOrange),
                const Divider(height: 24, color: AppColors.divider),
                _buildInfoRow('Resterend', '${card.remainingLessons}',
                    valueColor: AppColors.success),
              ],
            ),
            const SizedBox(height: AppDimensions.md),

            // Card info
            _buildInfoCard(
              title: 'Kaartinformatie',
              children: [
                _buildInfoRow('Lestype', card.lessonType),
                const Divider(height: 24, color: AppColors.divider),
                _buildInfoRow(
                  'Geldig tot',
                  DateFormat('d MMMM yyyy', 'nl').format(card.validUntil),
                ),
                const Divider(height: 24, color: AppColors.divider),
                _buildInfoRow(
                  'Status',
                  card.isActive ? 'Actief' : 'Verlopen',
                  valueColor: card.isActive ? AppColors.success : AppColors.error,
                ),
                const Divider(height: 24, color: AppColors.divider),
                _buildInfoRow('Kaartnummer', '#${card.id.toUpperCase()}'),
              ],
            ),
            const SizedBox(height: AppDimensions.sectionSpacing),

            // Recent usage history
            const Text(
              'Recente lessen',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            ..._buildMockUsageHistory(),

            const SizedBox(height: AppDimensions.sectionSpacing),

            // Book lesson button
            if (card.isActive && card.remainingLessons > 0)
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to booking with this punch card
                  },
                  icon: const Icon(Icons.calendar_today, size: 20),
                  label: const Text(
                    'Boek een les',
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

            const SizedBox(height: AppDimensions.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildPunchCardVisual(PunchCardModel card) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPadding + 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryBlue, Color(0xFF0480E8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${card.totalLessons}x ${card.lessonType} Zwemlessen',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${card.remainingLessons}',
            style: const TextStyle(
              fontSize: 48,
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
          const SizedBox(height: 20),

          // Progress dots
          Row(
            children: List.generate(
              card.totalLessons > 20 ? 20 : card.totalLessons,
              (index) {
                final isUsed = index < card.usedLessons;
                final dotSize = card.totalLessons > 15 ? 10.0 : 14.0;
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
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Geldig tot: ${DateFormat('d MMM yyyy', 'nl').format(card.validUntil)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              Text(
                '#${card.id.toUpperCase()}',
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

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: AppDimensions.shadowBlur,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildMockUsageHistory() {
    final usageHistory = [
      {
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'location': 'De Bilt',
        'instructor': 'Anna de Vries',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 10)),
        'location': 'Soestduinen',
        'instructor': 'Jan Bakker',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 17)),
        'location': 'De Bilt',
        'instructor': 'Anna de Vries',
      },
    ];

    return usageHistory.map((entry) {
      final date = entry['date'] as DateTime;
      return Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.sm),
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: AppDimensions.shadowBlur,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppColors.success,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry['location'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${entry['instructor']}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              DateFormat('d MMM', 'nl').format(date),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
