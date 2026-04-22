import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/utils/smart_back.dart';

/// Credit Voucher screen — per Walter's feedback.
/// Replaces traditional punch cards with credit-based system.
/// Customers buy €100/€200/€300/€400 vouchers with tiered discounts.
/// Credits are used to book lessons. Refunds go back to the voucher.
class _VoucherTier {
  final int amount;
  final double discount;
  final String label;
  const _VoucherTier(this.amount, this.discount, this.label);
}

const _tiers = <_VoucherTier>[
  _VoucherTier(100, 0, 'Starter'),
  _VoucherTier(200, 1, 'Voordelig'),
  _VoucherTier(300, 1.5, 'Populair'),
  _VoucherTier(400, 2, 'Beste keuze'),
];

class MyPunchCardsScreen extends StatelessWidget {
  const MyPunchCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 58, 20, 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => smartBack(context),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.chevron_left, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Mijn Tegoed',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                        Text('Saldo & vouchers',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Active credit balance card
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: GestureDetector(
                onTap: () => context.pushNamed(RouteNames.punchCardDetail, pathParameters: {'id': 'V2026001'}),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0365C4), Color(0xFF034DA9)],
                    ),
                    boxShadow: [BoxShadow(color: const Color(0xFF0365C4).withValues(alpha: 0.3), blurRadius: 32, offset: const Offset(0, 12))],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -10, right: -15,
                        child: Icon(Icons.account_balance_wallet, color: Colors.white.withValues(alpha: 0.08), size: 90),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF00C1FF), size: 18),
                                  const SizedBox(width: 8),
                                  Text('Actueel tegoed',
                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.4), size: 18),
                            ],
                          ),
                          const SizedBox(height: 16),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w700),
                              children: [
                                const TextSpan(text: '€164'),
                                TextSpan(
                                  text: ',50',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.7)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Beschikbaar voor boekingen',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                          ),
                          const SizedBox(height: 12),
                          // Progress bar showing how much used
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              height: 6,
                              color: Colors.white.withValues(alpha: 0.15),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: 0.82,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(colors: [Color(0xFF00C1FF), Colors.white]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Voucher #V2026001',
                                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11)),
                              Text('82% van €200',
                                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Recent usage quick view
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Gebruik deze maand',
                      style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 15, fontWeight: FontWeight.w700)),
                  GestureDetector(
                    onTap: () => context.pushNamed(RouteNames.paymentHistory),
                    child: const Text('Geschiedenis →',
                        style: TextStyle(color: Color(0xFF0365C4), fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Column(
                  children: [
                    _usageRow(Icons.water, '1-op-1 Zwemles', '4 lessen', '-€152,00', const Color(0xFF0365C4)),
                    const Divider(height: 20, color: Color(0xFFF0F4FA)),
                    _usageRow(Icons.people_outline, '1-op-2 Zwemles', '2 lessen', '-€54,00', const Color(0xFFFF5C00)),
                  ],
                ),
              ),
            ),

            // Purchase new voucher section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tegoed opwaarderen',
                      style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.w700)),
                  GestureDetector(
                    onTap: () => context.pushNamed(RouteNames.allPunchCardPrices),
                    child: const Text('Alle opties →',
                        style: TextStyle(color: Color(0xFF0365C4), fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),

            // Voucher tiers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: _tiers.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => context.pushNamed(RouteNames.purchasePunchCard),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: t.discount > 0
                            ? Border.all(color: const Color(0xFF27AE60).withValues(alpha: 0.3), width: 1.5)
                            : null,
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52, height: 52,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: t.amount >= 400
                                    ? const [Color(0xFF9B59B6), Color(0xFF8E44AD)]
                                    : t.amount >= 300
                                        ? const [Color(0xFF27AE60), Color(0xFF2ECC71)]
                                        : t.amount >= 200
                                            ? const [Color(0xFFFF5C00), Color(0xFFF5A623)]
                                            : const [Color(0xFF0365C4), Color(0xFF00C1FF)],
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('€${t.amount}',
                                        style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w800)),
                                    const SizedBox(width: 8),
                                    if (t.discount > 0)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF27AE60).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: Text('+${t.discount.toStringAsFixed(t.discount.truncateToDouble() == t.discount ? 0 : 1)}% bonus',
                                            style: const TextStyle(color: Color(0xFF27AE60), fontSize: 10, fontWeight: FontWeight.w700)),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  t.discount > 0
                                      ? '${t.label} · Krijg €${(t.amount * (1 + t.discount / 100)).toStringAsFixed(t.discount.truncateToDouble() == t.discount ? 0 : 2)} tegoed'
                                      : '${t.label} · Krijg €${t.amount} tegoed',
                                  style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0365C4).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.arrow_forward, color: Color(0xFF0365C4), size: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ),

            // Info card about pay-per-lesson option
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4FD),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF0365C4).withValues(alpha: 0.15)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF0365C4), size: 18),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Liever per les betalen? Kies iDEAL bij het boeken — geen voucher nodig.',
                        style: TextStyle(color: Color(0xFF0365C4), fontSize: 12, fontWeight: FontWeight.w500, height: 1.4),
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

  Widget _usageRow(IconData icon, String title, String count, String amount, Color color) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13, fontWeight: FontWeight.w600)),
              Text(count, style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
            ],
          ),
        ),
        Text(amount,
            style: const TextStyle(color: Color(0xFFE74C3C), fontSize: 13, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
