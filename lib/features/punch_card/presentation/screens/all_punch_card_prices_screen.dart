import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class AllPunchCardPricesScreen extends StatelessWidget {
  const AllPunchCardPricesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Alle knipkaart prijzen'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overzicht van alle knipkaart opties',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.sectionSpacing),

            // 1-op-1 section
            _buildCategorySection(
              title: '1-op-1 Zwemlessen',
              subtitle: 'Priveles met uw kind',
              icon: Icons.person,
              color: AppColors.lessonExtra1on1,
              prices: const [
                _PriceEntry(lessons: 10, price: 305, perLesson: 30.50),
                _PriceEntry(lessons: 20, price: 590, perLesson: 29.50),
                _PriceEntry(lessons: 30, price: 870, perLesson: 29.00),
              ],
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            // 1-op-2 section
            _buildCategorySection(
              title: '1-op-2 Zwemlessen',
              subtitle: 'Gedeelde les met 2 kinderen',
              icon: Icons.people,
              color: AppColors.lessonExtra1on2,
              prices: const [
                _PriceEntry(lessons: 10, price: 230, perLesson: 23.00),
                _PriceEntry(lessons: 20, price: 440, perLesson: 22.00),
                _PriceEntry(lessons: 30, price: 640, perLesson: 21.33),
              ],
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            // Vakantie section
            _buildCategorySection(
              title: 'Vakantie zwemlessen',
              subtitle: 'Tijdens schoolvakanties',
              icon: Icons.beach_access,
              color: AppColors.lessonHoliday,
              prices: const [
                _PriceEntry(lessons: 5, price: 140, perLesson: 28.00),
                _PriceEntry(lessons: 10, price: 265, perLesson: 26.50),
              ],
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            // Proefles section
            _buildCategorySection(
              title: 'Proefles pakket',
              subtitle: 'Ideaal om te starten',
              icon: Icons.star_outline,
              color: AppColors.primaryBlue,
              prices: const [
                _PriceEntry(lessons: 3, price: 99, perLesson: 33.00),
              ],
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            // Comparison info
            _buildComparisonCard(),

            const SizedBox(height: AppDimensions.sectionSpacing),

            // CTA
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to PunchCardOrderScreen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.textWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Knipkaart bestellen',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required List<_PriceEntry> prices,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.md),

        // Price table
        Container(
          width: double.infinity,
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
            children: [
              // Table header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.cardPadding,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusMd),
                    topRight: Radius.circular(AppDimensions.radiusMd),
                  ),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Lessen',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Per les',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Totaal',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              // Table rows
              ...prices.asMap().entries.map((entry) {
                final idx = entry.key;
                final price = entry.value;
                final isLast = idx == prices.length - 1;
                final isBest = price.lessons >= 30;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.cardPadding,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : const Border(
                            bottom: BorderSide(color: AppColors.divider),
                          ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Text(
                              '${price.lessons}x',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isBest ? color : AppColors.textPrimary,
                              ),
                            ),
                            if (isBest) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Best',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.success,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '\u20AC${price.perLesson.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '\u20AC${price.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isBest ? color : AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline, color: AppColors.info, size: 20),
              SizedBox(width: 8),
              Text(
                'Bespaar met meer lessen',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildSavingRow(
            'Bij 20 lessen (1-op-1)',
            'bespaar \u20AC20',
            AppColors.success,
          ),
          const SizedBox(height: 6),
          _buildSavingRow(
            'Bij 30 lessen (1-op-1)',
            'bespaar \u20AC45',
            AppColors.success,
          ),
          const SizedBox(height: 6),
          _buildSavingRow(
            'Bij 30 lessen (1-op-2)',
            'bespaar \u20AC50',
            AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildSavingRow(String label, String saving, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            saving,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _PriceEntry {
  final int lessons;
  final double price;
  final double perLesson;

  const _PriceEntry({
    required this.lessons,
    required this.price,
    required this.perLesson,
  });
}
