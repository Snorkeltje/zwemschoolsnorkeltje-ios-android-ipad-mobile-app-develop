import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class _PurchaseOption {
  final String type;
  final Color color;
  final List<Color> gradient;
  final String prices;
  const _PurchaseOption(this.type, this.color, this.gradient, this.prices);
}

const _purchaseOptions = <_PurchaseOption>[
  _PurchaseOption('1-op-1', Color(0xFF0365C4), [Color(0xFF0365C4), Color(0xFF00C1FF)], '10x €380  ·  5x €190  ·  3x €114'),
  _PurchaseOption('1-op-2', Color(0xFFFF5C00), [Color(0xFFFF5C00), Color(0xFFF5A623)], '10x €270  ·  5x €135  ·  3x €81'),
  _PurchaseOption('1-op-3', Color(0xFF27AE60), [Color(0xFF27AE60), Color(0xFF2ECC71)], '10x €200  ·  5x €100  ·  3x €60'),
  _PurchaseOption('Survival', Color(0xFF8E44AD), [Color(0xFF8E44AD), Color(0xFF9B59B6)], '10x €250  ·  5x €125  ·  3x €75'),
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
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
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
                        const Text('Strippenkaarten',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                        Text('Saldo & bestellingen',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Primary card
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: GestureDetector(
                onTap: () => context.pushNamed(RouteNames.punchCardDetail, pathParameters: {'id': '22976'}),
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
                        top: -5,
                        right: -10,
                        child: Icon(Icons.waves, color: Colors.white.withValues(alpha: 0.08), size: 80),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.credit_card, color: Color(0xFF00C1FF), size: 18),
                                  const SizedBox(width: 8),
                                  Text('1-op-1 Zwemlessen',
                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.4), size: 18),
                            ],
                          ),
                          const SizedBox(height: 16),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700),
                              children: [
                                const TextSpan(text: '8 '),
                                TextSpan(
                                  text: '/ 10 credits',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.7)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              height: 8,
                              color: Colors.white.withValues(alpha: 0.15),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: 0.8,
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
                              Text('Geldig tot: 24 mrt 2027',
                                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11)),
                              Text('Kaart #22976',
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

            // Secondary card
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: GestureDetector(
                onTap: () => context.pushNamed(RouteNames.punchCardDetail, pathParameters: {'id': '22980'}),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF27AE60), Color(0xFF1E8C4E)],
                    ),
                    boxShadow: [BoxShadow(color: const Color(0xFF27AE60).withValues(alpha: 0.25), blurRadius: 24, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.credit_card, color: Color(0xFFA0F0C0), size: 16),
                              const SizedBox(width: 8),
                              Text('1-op-2 Zwemlessen',
                                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.4), size: 16),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
                              children: [
                                const TextSpan(text: '5 '),
                                TextSpan(
                                  text: '/ 5 credits',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white.withValues(alpha: 0.7)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text('Geldig tot: 15 jun 2027',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Purchase section header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Strippenkaart bestellen',
                      style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.w700)),
                  GestureDetector(
                    onTap: () => context.pushNamed(RouteNames.allPunchCardPrices),
                    child: const Text('Alle prijzen →',
                        style: TextStyle(color: Color(0xFF0365C4), fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),

            // Purchase options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: _purchaseOptions.map((opt) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => context.pushNamed(RouteNames.purchasePunchCard),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: opt.gradient),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.credit_card, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(opt.type,
                                    style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text(opt.prices,
                                    style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                              ],
                            ),
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: opt.color.withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.shopping_cart_outlined, color: opt.color, size: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
