import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/utils/smart_back.dart';

/// Credit vouchers pricing page per Walter's feedback.
/// Replaces the old punch card prices with credit-based system.
class _Tier {
  final int amount;
  final double discount;
  final String label;
  final Color color;
  final List<Color> gradient;
  const _Tier(this.amount, this.discount, this.label, this.color, this.gradient);
}

const _tiers = <_Tier>[
  _Tier(100, 0, 'Starter', Color(0xFF0365C4), [Color(0xFF0365C4), Color(0xFF00C1FF)]),
  _Tier(200, 1, 'Voordelig', Color(0xFFFF5C00), [Color(0xFFFF5C00), Color(0xFFF5A623)]),
  _Tier(300, 1.5, 'Populair', Color(0xFF27AE60), [Color(0xFF27AE60), Color(0xFF2ECC71)]),
  _Tier(400, 2, 'Beste keuze', Color(0xFF9B59B6), [Color(0xFF9B59B6), Color(0xFF8E44AD)]),
];

class AllPunchCardPricesScreen extends StatelessWidget {
  const AllPunchCardPricesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFE8ECF4))),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => smartBack(context),
                    child: const Icon(Icons.chevron_left, size: 24, color: Color(0xFF1A1A2E)),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset('assets/images/snorkeltje_logo.svg', height: 40),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tegoed opwaarderen',
                        style: TextStyle(color: Color(0xFF26323F), fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('Kies een voucher en bespaar met bonus tegoed',
                        style: TextStyle(color: Color(0xFF4A6072), fontSize: 13)),
                    const SizedBox(height: 20),

                    // Tiers
                    ..._tiers.map((t) {
                      final bonus = t.amount * t.discount / 100;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => context.pushNamed(RouteNames.purchasePunchCard),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: t.gradient,
                              ),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [BoxShadow(color: t.color.withValues(alpha: 0.25), blurRadius: 24, offset: const Offset(0, 8))],
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -20, right: -20,
                                  child: Icon(Icons.account_balance_wallet, size: 120, color: Colors.white.withValues(alpha: 0.08)),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text(t.label.toUpperCase(),
                                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text('€${t.amount}',
                                            style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800, height: 1.0)),
                                        const SizedBox(width: 12),
                                        if (t.discount > 0)
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 6),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(999),
                                              ),
                                              child: Text('+${t.discount.toStringAsFixed(t.discount.truncateToDouble() == t.discount ? 0 : 1)}% bonus',
                                                  style: TextStyle(color: t.color, fontSize: 11, fontWeight: FontWeight.w800)),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      t.discount > 0
                                          ? 'Totaal tegoed: €${(t.amount + bonus).toStringAsFixed(bonus.truncateToDouble() == bonus ? 0 : 2)} (inclusief bonus €${bonus.toStringAsFixed(bonus.truncateToDouble() == bonus ? 0 : 2)})'
                                          : 'Totaal tegoed: €${t.amount}',
                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12),
                                    ),
                                    const SizedBox(height: 14),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(999),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Kies deze',
                                                  style: TextStyle(color: t.color, fontSize: 12, fontWeight: FontWeight.w800)),
                                              const SizedBox(width: 6),
                                              Icon(Icons.arrow_forward, color: t.color, size: 14),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 20),
                    // Pay per lesson info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FD),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF0365C4).withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0365C4).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.payment_outlined, color: Color(0xFF0365C4), size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Liever per les betalen?',
                                    style: TextStyle(color: Color(0xFF0365C4), fontSize: 14, fontWeight: FontWeight.w700)),
                                SizedBox(height: 4),
                                Text('Geen voucher nodig — betaal direct met iDEAL per les. Binnen 10 minuten afrekenen.',
                                    style: TextStyle(color: Color(0xFF3282AE), fontSize: 12, height: 1.4)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Special services
                    Row(
                      children: [
                        Expanded(child: _specialCard('📝 Inschrijfgeld', '€30 éénmalig')),
                        const SizedBox(width: 10),
                        Expanded(child: _specialCard('🔄 Rooster wijzigen', '€60 per verzoek')),
                      ],
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

  Widget _specialCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(color: Color(0xFF4A6072), fontSize: 11)),
        ],
      ),
    );
  }
}
