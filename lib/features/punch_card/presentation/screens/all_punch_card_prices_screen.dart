import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/utils/smart_back.dart';
import '../../../wallet/data/models/wallet_model.dart';

/// All prices overview — Walter 2026-04-22:
/// - 3 top-up packages (€200/€400/€1000) with small bonus
/// - 3 lesson types (1-op-1 €39, 1-op-2 €28, 1-op-3 €22)
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
                    const Text('Prijsoverzicht',
                        style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 24, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    const Text(
                      'Koop tegoed en gebruik het voor elke lessoorten. '
                      'Geen onderscheid tussen 1-op-1 en 1-op-2 lessen.',
                      style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 24),

                    // Top-up packages
                    const _SectionTitle('Tegoed opwaarderen'),
                    const SizedBox(height: 12),
                    for (final pkg in kWalletPackages)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _PackageTile(pkg: pkg),
                      ),

                    const SizedBox(height: 24),

                    // Lesson prices
                    const _SectionTitle('Lesprijzen per les'),
                    const SizedBox(height: 12),
                    _LessonTile(
                      label: '1-op-1 zwemles',
                      subtitle: 'Individueel · Maximaal aandacht',
                      price: LessonPricing.oneOnOne,
                      color: const Color(0xFF0365C4),
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 8),
                    _LessonTile(
                      label: '1-op-2 zwemles',
                      subtitle: 'Met één andere leerling',
                      price: LessonPricing.oneOnTwo,
                      color: const Color(0xFFFF5C00),
                      icon: Icons.people_alt_outlined,
                    ),
                    const SizedBox(height: 8),
                    _LessonTile(
                      label: '1-op-3 zwemles',
                      subtitle: 'Kleine groep · Voordelig',
                      price: LessonPricing.oneOnThree,
                      color: const Color(0xFF27AE60),
                      icon: Icons.groups_2_outlined,
                    ),

                    const SizedBox(height: 24),

                    // Info
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F7FC),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, size: 18, color: Color(0xFF0365C4)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Alle prijzen zijn inclusief 9% BTW. '
                              'Annuleringen komen als tegoed terug op uw saldo. '
                              'Geen verloopdatum.',
                              style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 12, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        context.pushNamed(RouteNames.purchasePunchCard);
                      },
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text('Tegoed kopen →',
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
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

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 17, fontWeight: FontWeight.w700));
}

class _PackageTile extends StatelessWidget {
  final WalletPackage pkg;
  const _PackageTile({required this.pkg});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF0365C4).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.account_balance_wallet_outlined,
                color: Color(0xFF0365C4), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pkg.payFormatted,
                    style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text('U ontvangt ${pkg.balanceFormatted} tegoed',
                    style: const TextStyle(color: Color(0xFF27AE60), fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 20, color: Color(0xFF8E9BB3)),
        ],
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  final String label, subtitle;
  final double price;
  final Color color;
  final IconData icon;
  const _LessonTile({
    required this.label, required this.subtitle,
    required this.price, required this.color, required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                Text(subtitle,
                    style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('€${price.toStringAsFixed(0)}',
                  style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
              const Text('per les',
                  style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
