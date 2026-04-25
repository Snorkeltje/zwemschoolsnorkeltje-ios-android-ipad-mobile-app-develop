import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/utils/smart_back.dart';
import '../../../wallet/data/models/wallet_model.dart';

/// Top-up screen — Walter 2026-04-22: unified balance with 3 packages.
/// €200→€202, €400→€405, €1000→€1015. No discount % shown.
class PunchCardOrderScreen extends ConsumerStatefulWidget {
  const PunchCardOrderScreen({super.key});

  @override
  ConsumerState<PunchCardOrderScreen> createState() => _PunchCardOrderScreenState();
}

class _PunchCardOrderScreenState extends ConsumerState<PunchCardOrderScreen> {
  int _selected = 1; // default to €400 package

  @override
  Widget build(BuildContext context) {
    final pkg = kWalletPackages[_selected];
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SafeArea(
        top: false,
        child: Column(
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
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
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
                        child: const Icon(Icons.chevron_left, color: Colors.white, size: 22),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tegoed kopen',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                          Text('Kies uw pakket',
                              style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < kWalletPackages.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _PackageCard(
                          pkg: kWalletPackages[i],
                          selected: _selected == i,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _selected = i);
                          },
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Info block
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF7FF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF0365C4).withValues(alpha: 0.15)),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, color: Color(0xFF0365C4), size: 18),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hoe werkt het?',
                                    style: TextStyle(color: Color(0xFF0365C4), fontSize: 13, fontWeight: FontWeight.w700)),
                                SizedBox(height: 4),
                                Text(
                                  'Uw tegoed gebruikt u voor alle lessoorten. '
                                  'Bij elke les wordt het juiste bedrag automatisch afgetrokken. '
                                  'Annuleringen komen terug op uw saldo.',
                                  style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 12, height: 1.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Pay bar
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.04))),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Totaal te betalen',
                          style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                      Text(pkg.payFormatted,
                          style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 22, fontWeight: FontWeight.w800)),
                      Text('U ontvangt ${pkg.balanceFormatted} tegoed',
                          style: const TextStyle(color: Color(0xFF27AE60), fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      // Skip detail entry — straight to iDEAL per Walter 2026-04-22.
                      context.pushNamed(
                        RouteNames.stripePayment,
                        extra: {
                          'amount': pkg.payAmount.toDouble(),
                          'balanceAmount': pkg.balanceAmount,
                          'description': 'Tegoed opwaarderen (€${pkg.payAmount} → ${pkg.balanceFormatted})',
                          'isTopUp': true,
                        },
                      );
                    },
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0365C4).withValues(alpha: 0.3),
                            blurRadius: 16, offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.lock, color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text('Betalen met iDEAL',
                              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final WalletPackage pkg;
  final bool selected;
  final VoidCallback onTap;
  const _PackageCard({required this.pkg, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
                )
              : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? Colors.transparent : const Color(0xFFE5E7EB),
          ),
          boxShadow: selected
              ? [BoxShadow(color: const Color(0xFF0365C4).withValues(alpha: 0.25), blurRadius: 20, offset: const Offset(0, 8))]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: selected ? Colors.white.withValues(alpha: 0.2) : const Color(0xFF0365C4).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                color: selected ? Colors.white : const Color(0xFF0365C4),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pkg.payFormatted,
                    style: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF1A1A2E),
                      fontSize: 24, fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'U ontvangt ${pkg.balanceFormatted} tegoed',
                    style: TextStyle(
                      color: selected ? Colors.white.withValues(alpha: 0.85) : const Color(0xFF8E9BB3),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? Colors.white : const Color(0xFFE0E5EC),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 14, color: Color(0xFF0365C4))
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
