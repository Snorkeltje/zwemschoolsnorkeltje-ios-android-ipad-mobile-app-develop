import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/utils/smart_back.dart';

class SpecialPunchCardsScreen extends StatelessWidget {
  const SpecialPunchCardsScreen({super.key});

  static const Color _headerBlue = Color(0xFF5492B5);
  static const Color _breadcrumbBg = Color(0xFFF8FAFC);
  static const Color _cardBlueSidebar = Color(0xFF5492B5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => smartBack(context),
                    child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF334155)),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.pool, color: _headerBlue, size: 22),
                  const SizedBox(width: 8),
                  const Text(
                    'Zwemschool Snorkeltje',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),

            // Breadcrumb
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: _breadcrumbBg,
              child: const Text(
                '/ Bestel Knipkaart',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Speciale Knipkaarten',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Eenmalige betalingen voor inschrijving, wijzigingen en speciale pakketten.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Card 1: Inschrijfgeld
                    _buildSpecialCard(
                      context: context,
                      emoji: '📝',
                      title: 'Knipkaart voor Inschrijfgeld',
                      description: 'Eenmalige inschrijfkosten voor nieuwe leerlingen.',
                      price: '25',
                      validity: '1 dag geldig',
                      extraPricing: null,
                    ),
                    const SizedBox(height: 16),

                    // Card 2: Wijzigen dag of tijd
                    _buildSpecialCard(
                      context: context,
                      emoji: '🔄',
                      title: 'Knipkaart voor Wijzigen dag of tijd',
                      description: 'Wijzig uw vaste lesdag of lestijd.',
                      price: '60',
                      validity: '1 dag geldig',
                      extraPricing: null,
                    ),
                    const SizedBox(height: 16),

                    // Card 3: Survival pakket
                    _buildSpecialCard(
                      context: context,
                      emoji: '🏊',
                      title: 'Pakket van 10 lessen (Survival)',
                      description: 'Compleet survivalpakket met 10 zwemlessen.',
                      price: '250',
                      validity: '84 dagen geldig',
                      extraPricing: '5x \u20AC125  |  3x \u20AC75',
                    ),

                    const SizedBox(height: AppDimensions.lg),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialCard({
    required BuildContext context,
    required String emoji,
    required String title,
    required String description,
    required String price,
    required String validity,
    required String? extraPricing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Blue sidebar
            Container(
              width: 64,
              decoration: const BoxDecoration(
                color: _cardBlueSidebar,
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),

            // Content side
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          '\u20AC$price',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _cardBlueSidebar,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.access_time, size: 12, color: Color(0xFF64748B)),
                              const SizedBox(width: 4),
                              Text(
                                validity,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (extraPricing != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        extraPricing,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 38,
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/stripe-payment', extra: {
                            'product': title,
                            'amount': price,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _cardBlueSidebar,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Bestellen!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
