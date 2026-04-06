import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class BookingSummaryScreen extends StatelessWidget {
  const BookingSummaryScreen({super.key});

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
                          color: Colors.white.withOpacity(0.18),
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
                        const Text('Overzicht',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                        Text('Controleer en bevestig',
                            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Transform.translate(
              offset: const Offset(0, -12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lesson card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: 4,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                  colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('1-op-1 Zwemles',
                                          style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.w700)),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)]),
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: const Text('1-op-1',
                                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _detailRow(Icons.location_on_outlined, 'De Bilt Zwembad', const Color(0xFF0365C4)),
                                  const SizedBox(height: 12),
                                  _detailRow(Icons.calendar_today, 'Maandag 21 april 2026', const Color(0xFFFF5C00)),
                                  const SizedBox(height: 12),
                                  _detailRow(Icons.access_time, '15:00 – 15:30 (30 min)', const Color(0xFF00C1FF)),
                                  const SizedBox(height: 12),
                                  _detailRow(Icons.person_outline, 'Jan de Vries', const Color(0xFF27AE60)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Child selector
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('Kind',
                          style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)]),
                            ),
                            alignment: Alignment.center,
                            child: const Text('S',
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text('Sami Khilji (7 jaar)',
                                style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w600)),
                          ),
                          const Icon(Icons.keyboard_arrow_down, color: Color(0xFF8E9BB3), size: 16),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Payment
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('Betaalmethode',
                          style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                    GestureDetector(
                      onTap: () => context.pushNamed(RouteNames.paymentMethod),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF0365C4), width: 2),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)]),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.credit_card, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Knipkaart #22976',
                                      style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                                  Text('8/10 credits resterend',
                                      style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Color(0xFF0365C4), size: 16),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    // Price summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Prijsoverzicht',
                              style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Les:', style: TextStyle(color: Color(0xFF6B7B94), fontSize: 13)),
                              Text('€0 (knipkaart)',
                                  style: TextStyle(color: Color(0xFF27AE60), fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            height: 1,
                            color: const Color(0xFFF0F4FA),
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Totaal:',
                                  style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 15, fontWeight: FontWeight.w700)),
                              Text('1 credit inhouden',
                                  style: TextStyle(color: Color(0xFF0365C4), fontSize: 15, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    // Confirm button
                    GestureDetector(
                      onTap: () => context.pushNamed(RouteNames.bookingSuccess),
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF0D7FE8)]),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: const Color(0xFF0365C4).withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 8))],
                        ),
                        alignment: Alignment.center,
                        child: const Text('Bevestigen & Boeken ✓',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shield_outlined, size: 13, color: Color(0xFF8E9BB3)),
                        SizedBox(width: 8),
                        Text('Beveiligde transactie · SSL versleuteld',
                            style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
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

  Widget _detailRow(IconData icon, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: color.withOpacity(0.07), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 15),
        ),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Color(0xFF4A5568), fontSize: 13)),
      ],
    );
  }
}
