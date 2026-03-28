import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';

class _PunchCardOption {
  final String lessonType;
  final int lessons;
  final double price;
  final double pricePerLesson;

  const _PunchCardOption({
    required this.lessonType,
    required this.lessons,
    required this.price,
    required this.pricePerLesson,
  });
}

class PurchasePunchCardScreen extends StatefulWidget {
  const PurchasePunchCardScreen({super.key});

  @override
  State<PurchasePunchCardScreen> createState() =>
      _PurchasePunchCardScreenState();
}

class _PurchasePunchCardScreenState extends State<PurchasePunchCardScreen> {
  String? _selectedOptionKey;

  final List<_PunchCardOption> _oneOnOneOptions = const [
    _PunchCardOption(
      lessonType: '1-op-1',
      lessons: 10,
      price: 305,
      pricePerLesson: 30.50,
    ),
    _PunchCardOption(
      lessonType: '1-op-1',
      lessons: 20,
      price: 590,
      pricePerLesson: 29.50,
    ),
    _PunchCardOption(
      lessonType: '1-op-1',
      lessons: 30,
      price: 870,
      pricePerLesson: 29.00,
    ),
  ];

  final List<_PunchCardOption> _oneOnTwoOptions = const [
    _PunchCardOption(
      lessonType: '1-op-2',
      lessons: 10,
      price: 230,
      pricePerLesson: 23.00,
    ),
    _PunchCardOption(
      lessonType: '1-op-2',
      lessons: 20,
      price: 440,
      pricePerLesson: 22.00,
    ),
    _PunchCardOption(
      lessonType: '1-op-2',
      lessons: 30,
      price: 640,
      pricePerLesson: 21.33,
    ),
  ];

  _PunchCardOption? get _selectedOption {
    if (_selectedOptionKey == null) return null;
    final allOptions = [..._oneOnOneOptions, ..._oneOnTwoOptions];
    final idx = int.tryParse(_selectedOptionKey!);
    if (idx != null && idx < allOptions.length) return allOptions[idx];
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.purchasePunchCard),
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
              'Kies een knipkaart',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.sectionSpacing),

            // 1-on-1 section
            _buildSectionHeader(
              '1-op-1 Zwemlessen',
              'Priveles met uw kind',
              AppColors.lessonExtra1on1,
              Icons.person,
            ),
            const SizedBox(height: AppDimensions.md),
            ...List.generate(_oneOnOneOptions.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                child: _buildOptionCard(
                  _oneOnOneOptions[i],
                  i.toString(),
                  AppColors.lessonExtra1on1,
                ),
              );
            }),

            const SizedBox(height: AppDimensions.sectionSpacing),

            // 1-on-2 section
            _buildSectionHeader(
              '1-op-2 Zwemlessen',
              'Gedeelde les met 2 kinderen',
              AppColors.lessonExtra1on2,
              Icons.people,
            ),
            const SizedBox(height: AppDimensions.md),
            ...List.generate(_oneOnTwoOptions.length, (i) {
              final globalIdx = _oneOnOneOptions.length + i;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                child: _buildOptionCard(
                  _oneOnTwoOptions[i],
                  globalIdx.toString(),
                  AppColors.lessonExtra1on2,
                ),
              );
            }),

            const SizedBox(height: AppDimensions.xl),

            // Purchase button
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: _selectedOption != null
                    ? () {
                        // TODO: Navigate to Stripe payment
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.textWhite,
                  disabledBackgroundColor: AppColors.border,
                  disabledForegroundColor: AppColors.textLight,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  elevation: _selectedOption != null ? 2 : 0,
                ),
                child: Text(
                  _selectedOption != null
                      ? 'Betaal \u20AC${_selectedOption!.price.toStringAsFixed(0)} via Stripe'
                      : 'Selecteer een knipkaart',
                  style: const TextStyle(
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

  Widget _buildSectionHeader(
    String title,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          child: Icon(icon, color: color, size: 22),
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
    );
  }

  Widget _buildOptionCard(
    _PunchCardOption option,
    String key,
    Color accentColor,
  ) {
    final isSelected = _selectedOptionKey == key;
    final isBestValue = option.lessons == 30;

    return GestureDetector(
      onTap: () => setState(() => _selectedOptionKey = key),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: isSelected ? accentColor : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Lesson count
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              alignment: Alignment.center,
              child: Text(
                '${option.lessons}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${option.lessons} lessen',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (isBestValue) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Beste waarde',
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
                  const SizedBox(height: 2),
                  Text(
                    '\u20AC${option.pricePerLesson.toStringAsFixed(2)} per les',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\u20AC${option.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? accentColor : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected ? accentColor : AppColors.textLight,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
