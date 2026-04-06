import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top gradient background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFE8F8F0), Colors.white],
                ),
              ),
            ),
          ),
          // Decorative radial
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x1A27AE60), Colors.transparent],
                  stops: [0.0, 0.7],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
              child: Column(
                children: [
                  // Success icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFE8F8F0), Color(0xFFD4F5E0)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: const Color(0xFF27AE60).withOpacity(0.15), blurRadius: 32, offset: const Offset(0, 12))],
                    ),
                    child: const Icon(Icons.check_circle_outline, color: Color(0xFF27AE60), size: 50),
                  ),
                  const SizedBox(height: 20),
                  const Text('Les geboekt! 🎉',
                      style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 26, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const Text('Uw les is succesvol bevestigd.',
                      style: TextStyle(color: Color(0xFF6B7B94), fontSize: 14)),
                  const SizedBox(height: 24),

                  // Details card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(width: 4, decoration: BoxDecoration(color: const Color(0xFF27AE60), borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('1-op-1 Zwemles',
                                    style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 16),
                                _detailRow(Icons.calendar_today, 'Maandag 21 april 2026', const Color(0xFFFF5C00)),
                                const SizedBox(height: 10),
                                _detailRow(Icons.access_time, '15:00 – 15:30', const Color(0xFF00C1FF)),
                                const SizedBox(height: 10),
                                _detailRow(Icons.location_on_outlined, 'De Bilt Zwembad', const Color(0xFF0365C4)),
                                const SizedBox(height: 10),
                                _detailRow(Icons.person_outline, 'Jan de Vries', const Color(0xFF27AE60)),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.only(top: 12),
                                  decoration: const BoxDecoration(
                                    border: Border(top: BorderSide(color: Color(0xFFF0F4FA))),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.credit_card, color: Color(0xFF27AE60), size: 14),
                                      SizedBox(width: 8),
                                      Text('Knipkaart: nog 7 credits resterend',
                                          style: TextStyle(color: Color(0xFF27AE60), fontSize: 12, fontWeight: FontWeight.w600)),
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

                  const SizedBox(height: 20),

                  // QR code placeholder
                  Container(
                    width: 140,
                    height: 140,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD0E4F7), width: 2, style: BorderStyle.solid),
                    ),
                    child: GridView.count(
                      crossAxisCount: 5,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(25, (i) {
                        const filled = [0, 1, 2, 5, 6, 7, 8, 10, 12, 14, 15, 17, 19, 20, 22, 24];
                        return Container(
                          decoration: BoxDecoration(
                            color: filled.contains(i) ? const Color(0xFF0365C4) : Colors.transparent,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Toon bij de ingang',
                      style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),

                  const Spacer(),

                  // Buttons
                  GestureDetector(
                    onTap: () => context.goNamed(RouteNames.myReservations),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF0D7FE8)]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: const Color(0xFF0365C4).withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 8))],
                      ),
                      alignment: Alignment.center,
                      child: const Text('Mijn reserveringen',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => context.goNamed(RouteNames.home),
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F7FC),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: const Text('Terug naar Thuis',
                          style: TextStyle(color: Color(0xFF0365C4), fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: color.withOpacity(0.07), borderRadius: BorderRadius.circular(7)),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Color(0xFF4A5568), fontSize: 13)),
      ],
    );
  }
}
