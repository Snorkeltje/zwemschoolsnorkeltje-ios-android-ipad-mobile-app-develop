import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class _PunchCardOrderOption {
  final String lessonType;
  final int lessons;
  final double price;
  final double pricePerLesson;
  final String description;
  final bool isSpecial;

  const _PunchCardOrderOption({
    required this.lessonType,
    required this.lessons,
    required this.price,
    required this.pricePerLesson,
    required this.description,
    this.isSpecial = false,
  });
}

class PunchCardOrderScreen extends StatefulWidget {
  const PunchCardOrderScreen({super.key});

  @override
  State<PunchCardOrderScreen> createState() => _PunchCardOrderScreenState();
}

class _PunchCardOrderScreenState extends State<PunchCardOrderScreen> {
  int _selectedTabIndex = 0;
  String? _selectedOptionKey;

  final List<_PunchCardOrderOption> _oneOnOneOptions = const [
    _PunchCardOrderOption(
      lessonType: '1-op-1',
      lessons: 10,
      price: 305,
      pricePerLesson: 30.50,
      description: 'Standaard knipkaart',
    ),
    _PunchCardOrderOption(
      lessonType: '1-op-1',
      lessons: 20,
      price: 590,
      pricePerLesson: 29.50,
      description: 'Voordelig pakket',
    ),
    _PunchCardOrderOption(
      lessonType: '1-op-1',
      lessons: 30,
      price: 870,
      pricePerLesson: 29.00,
      description: 'Beste waarde',
    ),
  ];

  final List<_PunchCardOrderOption> _oneOnTwoOptions = const [
    _PunchCardOrderOption(
      lessonType: '1-op-2',
      lessons: 10,
      price: 230,
      pricePerLesson: 23.00,
      description: 'Standaard knipkaart',
    ),
    _PunchCardOrderOption(
      lessonType: '1-op-2',
      lessons: 20,
      price: 440,
      pricePerLesson: 22.00,
      description: 'Voordelig pakket',
    ),
    _PunchCardOrderOption(
      lessonType: '1-op-2',
      lessons: 30,
      price: 640,
      pricePerLesson: 21.33,
      description: 'Beste waarde',
    ),
  ];

  final List<_PunchCardOrderOption> _specialOptions = const [
    _PunchCardOrderOption(
      lessonType: 'Vakantie',
      lessons: 5,
      price: 140,
      pricePerLesson: 28.00,
      description: 'Vakantie zwemles pakket',
      isSpecial: true,
    ),
    _PunchCardOrderOption(
      lessonType: 'Proef',
      lessons: 3,
      price: 99,
      pricePerLesson: 33.00,
      description: 'Proefles pakket - ideaal om te starten',
      isSpecial: true,
    ),
  ];

  List<_PunchCardOrderOption> get _currentOptions {
    switch (_selectedTabIndex) {
      case 0:
        return _oneOnOneOptions;
      case 1:
        return _oneOnTwoOptions;
      case 2:
        return _specialOptions;
      default:
        return _oneOnOneOptions;
    }
  }

  _PunchCardOrderOption? get _selectedOption {
    if (_selectedOptionKey == null) return null;
    final idx = int.tryParse(_selectedOptionKey!);
    if (idx != null && idx < _currentOptions.length) {
      return _currentOptions[idx];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Knipkaart bestellen'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Column(
        children: [
          // Tab selector
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPadding,
              vertical: AppDimensions.sm,
            ),
            child: Row(
              children: [
                _buildTab('1-op-1', 0),
                const SizedBox(width: AppDimensions.sm),
                _buildTab('1-op-2', 1),
                const SizedBox(width: AppDimensions.sm),
                _buildTab('Speciaal', 2),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          // Options list
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header
                  _buildSectionInfo(),
                  const SizedBox(height: AppDimensions.md),

                  // Option cards
                  ...List.generate(_currentOptions.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.md),
                      child: _buildOptionCard(_currentOptions[i], i),
                    );
                  }),

                  const SizedBox(height: AppDimensions.md),

                  // Info box
                  _buildInfoBox(),
                ],
              ),
            ),
          ),

          // Bottom action bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
            _selectedOptionKey = null;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryBlue
                : AppColors.primaryBlue.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.primaryBlue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionInfo() {
    String title;
    String subtitle;
    IconData icon;
    Color color;

    switch (_selectedTabIndex) {
      case 0:
        title = '1-op-1 Zwemlessen';
        subtitle = 'Priveles met uw kind en de instructeur';
        icon = Icons.person;
        color = AppColors.lessonExtra1on1;
        break;
      case 1:
        title = '1-op-2 Zwemlessen';
        subtitle = 'Gedeelde les met 2 kinderen';
        icon = Icons.people;
        color = AppColors.lessonExtra1on2;
        break;
      default:
        title = 'Speciale knipkaarten';
        subtitle = 'Vakantie en proefles pakketten';
        icon = Icons.star;
        color = AppColors.lessonHoliday;
    }

    return Row(
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
        Expanded(
          child: Column(
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
        ),
      ],
    );
  }

  Widget _buildOptionCard(_PunchCardOrderOption option, int index) {
    final isSelected = _selectedOptionKey == index.toString();
    final isBestValue = option.lessons >= 30 || option.description.contains('Beste');
    Color accentColor;

    switch (_selectedTabIndex) {
      case 0:
        accentColor = AppColors.lessonExtra1on1;
        break;
      case 1:
        accentColor = AppColors.lessonExtra1on2;
        break;
      default:
        accentColor = AppColors.lessonHoliday;
    }

    return GestureDetector(
      onTap: () => setState(() => _selectedOptionKey = index.toString()),
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
              : [
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
                            horizontal: 8,
                            vertical: 2,
                          ),
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
                  if (option.isSpecial) ...[
                    const SizedBox(height: 2),
                    Text(
                      option.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ],
              ),
            ),
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

  Widget _buildInfoBox() {
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.info, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Hoe werkt een knipkaart?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Na aankoop kunt u direct lessen boeken. '
                  'Bij elke boeking wordt 1 les van uw knipkaart afgeschreven. '
                  'Knipkaarten zijn 12 maanden geldig.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedOption != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_selectedOption!.lessons}x ${_selectedOption!.lessonType} lessen',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '\u20AC${_selectedOption!.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: _selectedOption != null
                    ? () {
                        // TODO: Navigate to ConfirmOrderScreen
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
                      ? 'Ga naar bestellen'
                      : 'Selecteer een knipkaart',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
