import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/route_names.dart';

enum PaymentMethodType { creditCard, punchCard, ideal }

class _PaymentMethodOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final PaymentMethodType type;
  final bool isDefault;

  const _PaymentMethodOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.type,
    this.isDefault = false,
  });
}

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedMethodId = 'pm_001';

  final List<_PaymentMethodOption> _savedMethods = const [
    _PaymentMethodOption(
      id: 'pm_001',
      title: 'Visa ****4242',
      subtitle: 'Vervalt 12/2027',
      icon: Icons.credit_card,
      type: PaymentMethodType.creditCard,
      isDefault: true,
    ),
    _PaymentMethodOption(
      id: 'pm_002',
      title: 'Mastercard ****8888',
      subtitle: 'Vervalt 06/2026',
      icon: Icons.credit_card,
      type: PaymentMethodType.creditCard,
    ),
  ];

  final List<_PaymentMethodOption> _otherMethods = const [
    _PaymentMethodOption(
      id: 'pm_punch',
      title: 'Knipkaart',
      subtitle: '8 lessen resterend',
      icon: Icons.confirmation_number_outlined,
      type: PaymentMethodType.punchCard,
    ),
    _PaymentMethodOption(
      id: 'pm_ideal',
      title: 'iDEAL',
      subtitle: 'Betaal via uw bank',
      icon: Icons.account_balance_outlined,
      type: PaymentMethodType.ideal,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Betaalmethode'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimensions.md),

            // Saved payment methods
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPadding,
              ),
              child: Text(
                'Opgeslagen methoden',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            ..._savedMethods.map((method) => _buildMethodTile(method)),

            const SizedBox(height: AppDimensions.lg),

            // Other methods
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPadding,
              ),
              child: Text(
                'Andere methoden',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            ..._otherMethods.map((method) => _buildMethodTile(method)),

            const SizedBox(height: AppDimensions.lg),

            // Add new card button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPadding,
              ),
              child: OutlinedButton.icon(
                onPressed: () {
                  context.pushNamed(RouteNames.stripePayment);
                },
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Nieuwe kaart toevoegen'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryBlue,
                  side: const BorderSide(color: AppColors.primaryBlue),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          AppDimensions.screenPadding,
          AppDimensions.md,
          AppDimensions.screenPadding,
          MediaQuery.of(context).padding.bottom + AppDimensions.md,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: AppDimensions.buttonHeight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, _selectedMethodId);
            },
            child: const Text(
              'Doorgaan met betalen',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodTile(_PaymentMethodOption method) {
    final isSelected = _selectedMethodId == method.id;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethodId = method.id),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding,
          vertical: 4,
        ),
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
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
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(method.icon, color: AppColors.primaryBlue, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        method.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (method.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Standaard',
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
                    method.subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: method.id,
              groupValue: _selectedMethodId,
              activeColor: AppColors.primaryBlue,
              onChanged: (val) {
                if (val != null) setState(() => _selectedMethodId = val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
