import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/utils/smart_back.dart';

/// Credit Voucher Purchase per Walter's feedback.
/// Tiered discounts: €100 (0%), €200 (1%), €300 (1.5%), €400 (2%)
/// Payment: iDEAL only (Bancontact removed per Walter).
class _VoucherOption {
  final int amount;
  final double discount;
  final String label;
  final List<Color> gradient;
  const _VoucherOption(this.amount, this.discount, this.label, this.gradient);
}

const _options = <_VoucherOption>[
  _VoucherOption(100, 0, 'Starter', [Color(0xFF0365C4), Color(0xFF00C1FF)]),
  _VoucherOption(200, 1, 'Voordelig', [Color(0xFFFF5C00), Color(0xFFF5A623)]),
  _VoucherOption(300, 1.5, 'Populair', [Color(0xFF27AE60), Color(0xFF2ECC71)]),
  _VoucherOption(400, 2, 'Beste keuze', [Color(0xFF9B59B6), Color(0xFF8E44AD)]),
];

class PunchCardOrderScreen extends StatefulWidget {
  const PunchCardOrderScreen({super.key});
  @override
  State<PunchCardOrderScreen> createState() => _PunchCardOrderScreenState();
}

class _PunchCardOrderScreenState extends State<PunchCardOrderScreen> {
  int _selected = 1; // Default to €200 (Voordelig)

  @override
  Widget build(BuildContext context) {
    final current = _options[_selected];
    final bonus = current.amount * current.discount / 100;
    final totalValue = current.amount + bonus;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 58, 20, 32),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.0, 0.5, 1.0],
                            colors: [Color(0xFF0365C4), Color(0xFF0D7FE8), Color(0xFF00C1FF)],
                          ),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => smartBack(context),
                              child: Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
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
                                const Text('Tegoed kopen',
                                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                                Text('Kies uw voucher',
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Pricing options
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    children: List.generate(_options.length, (i) {
                      final opt = _options[i];
                      final isSelected = _selected == i;
                      final isBest = opt.discount >= 2;
                      final optBonus = opt.amount * opt.discount / 100;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => setState(() => _selected = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: opt.gradient)
                                  : null,
                              color: isSelected ? null : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected ? opt.gradient.last.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.04),
                                  blurRadius: isSelected ? 24 : 8,
                                  offset: Offset(0, isSelected ? 8 : 2),
                                ),
                              ],
                              border: Border.all(
                                color: isSelected ? Colors.transparent : Colors.black.withValues(alpha: 0.05),
                                width: 1,
                              ),
                            ),
                            child: Row(
                                  children: [
                                    Container(
                                      width: 56, height: 56,
                                      decoration: BoxDecoration(
                                        color: isSelected ? Colors.white.withValues(alpha: 0.2) : opt.gradient.last.withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Icon(
                                        Icons.account_balance_wallet_outlined,
                                        color: isSelected ? Colors.white : opt.gradient.last,
                                        size: 26,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Wrap(
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            spacing: 8,
                                            runSpacing: 4,
                                            children: [
                                              Text('€${opt.amount}',
                                                  style: TextStyle(
                                                    color: isSelected ? Colors.white : const Color(0xFF1A1A2E),
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w800,
                                                  )),
                                              if (opt.discount > 0)
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: isSelected ? Colors.white.withValues(alpha: 0.25) : const Color(0xFF27AE60).withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(999),
                                                  ),
                                                  child: Text(
                                                    '+€${optBonus.toStringAsFixed(optBonus.truncateToDouble() == optBonus ? 0 : 2)}',
                                                    style: TextStyle(
                                                      color: isSelected ? Colors.white : const Color(0xFF27AE60),
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              if (isBest)
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: isSelected ? Colors.white : const Color(0xFFFF5C00),
                                                    borderRadius: BorderRadius.circular(999),
                                                  ),
                                                  child: Text(
                                                    '⭐ POPULAIR',
                                                    style: TextStyle(
                                                      color: isSelected ? opt.gradient.last : Colors.white,
                                                      fontSize: 9,
                                                      fontWeight: FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            opt.discount > 0
                                                ? '${opt.label} · Totaal €${(opt.amount + optBonus).toStringAsFixed(optBonus.truncateToDouble() == optBonus ? 0 : 2)} tegoed'
                                                : '${opt.label} · Geen bonus',
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white.withValues(alpha: 0.8)
                                                  : const Color(0xFF8E9BB3),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 24, height: 24,
                                      decoration: BoxDecoration(
                                        color: isSelected ? Colors.white : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected ? Colors.white : const Color(0xFFE0E5EC),
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? Icon(Icons.check, size: 14, color: opt.gradient.last)
                                          : null,
                                    ),
                                  ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // Info
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
                    children: [
                      _infoRow(Icons.verified_outlined, 'Tegoed blijft geldig', 'Geen verloop datum'),
                      const SizedBox(height: 10),
                      _infoRow(Icons.refresh, 'Restitutie naar voucher', 'Annuleringen komen terug op je saldo'),
                      const SizedBox(height: 10),
                      _infoRow(Icons.payment_outlined, 'Betaal met iDEAL', 'Veilige betaling binnen 10 minuten'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom CTA
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, -4))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Totaal te betalen',
                              style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                          Text('€${current.amount}',
                              style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 26, fontWeight: FontWeight.w800)),
                          if (current.discount > 0)
                            Text('Krijg €${totalValue.toStringAsFixed(bonus.truncateToDouble() == bonus ? 0 : 2)} tegoed',
                                style: const TextStyle(color: Color(0xFF27AE60), fontSize: 11, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => context.pushNamed(RouteNames.confirmOrder),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)]),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: const Color(0xFF0365C4).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.lock_outline, color: Colors.white, size: 16),
                              SizedBox(width: 8),
                              Text('Afrekenen met iDEAL',
                                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF0365C4).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF0365C4), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13, fontWeight: FontWeight.w700)),
                Text(subtitle, style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
