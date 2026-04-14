import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class _Option {
  final int count;
  final int price;
  final int perLesson;
  final String? savings;
  const _Option(this.count, this.price, this.perLesson, [this.savings]);
}

class PunchCardOrderScreen extends StatefulWidget {
  const PunchCardOrderScreen({super.key});
  @override
  State<PunchCardOrderScreen> createState() => _PunchCardOrderScreenState();
}

class _PunchCardOrderScreenState extends State<PunchCardOrderScreen> {
  String _cardType = '1-op-1';
  int _selected = 0;

  Map<String, List<_Option>> get _options => {
    '1-op-1': const [_Option(10, 380, 38), _Option(5, 190, 38), _Option(3, 114, 38)],
    '1-op-2': const [_Option(10, 270, 27, '29%'), _Option(5, 135, 27, '29%'), _Option(3, 81, 27, '29%')],
  };

  @override
  Widget build(BuildContext context) {
    final opts = _options[_cardType]!;
    final current = opts[_selected];
    final included = [
      '${current.count} zwemlessen ($_cardType)',
      'Geldig 365 dagen na aankoop',
      'Flexibel boeken — elk moment, elke locatie',
      'Voortgangsrapportage inbegrepen',
      'Gratis annuleren tot 24 uur van tevoren',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero header
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 58, 20, 40),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 0.5, 1.0],
                        colors: [Color(0xFF0365C4), Color(0xFF0D7FE8), Color(0xFF00C1FF)],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Container(
                                width: 40,
                                height: 40,
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
                                const Text('Bestel Knipkaart',
                                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                                Text('Kies uw ideale pakket',
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Toggle
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(child: _toggleBtn('1-op-1')),
                              Expanded(child: _toggleBtn('1-op-2', showBadge: true)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Pricing cards
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: List.generate(opts.length, (i) {
                        final opt = opts[i];
                        final isSel = _selected == i;
                        final isBest = i == 0;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => setState(() => _selected = i),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSel ? null : Colors.white,
                                gradient: isSel
                                    ? const LinearGradient(
                                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                                        colors: [Color(0xFF0365C4), Color(0xFF0D7FE8)],
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSel ? const Color(0xFF0365C4).withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.06),
                                    blurRadius: isSel ? 32 : 16,
                                    offset: Offset(0, isSel ? 12 : 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  if (isBest)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          gradient: isSel
                                              ? null
                                              : const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)]),
                                          color: isSel ? Colors.white.withValues(alpha: 0.2) : null,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(14),
                                          ),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.white, size: 10),
                                            SizedBox(width: 4),
                                            Text('BESTE KEUZE',
                                                style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 72,
                                          height: 72,
                                          decoration: BoxDecoration(
                                            gradient: isSel
                                                ? null
                                                : LinearGradient(
                                                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                                                    colors: _cardType == '1-op-1'
                                                        ? [const Color(0xFFE8F0FE), const Color(0xFFF0F6FF)]
                                                        : [const Color(0xFFFEF0E7), const Color(0xFFFFF8F0)],
                                                  ),
                                            color: isSel ? Colors.white.withValues(alpha: 0.15) : null,
                                            borderRadius: BorderRadius.circular(18),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('${opt.count}x',
                                                  style: TextStyle(
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.w700,
                                                    color: isSel
                                                        ? Colors.white
                                                        : _cardType == '1-op-1'
                                                            ? const Color(0xFF0365C4)
                                                            : const Color(0xFFFF5C00),
                                                  )),
                                              Text('lessen',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: isSel ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF8E9BB3),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${opt.count}x $_cardType Zwemlessen',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: isSel ? Colors.white : const Color(0xFF1A1A2E),
                                                  )),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Text('€${opt.price}',
                                                      style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight: FontWeight.w700,
                                                        color: isSel ? Colors.white : const Color(0xFF0365C4),
                                                      )),
                                                  if (opt.savings != null) ...[
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: isSel ? const Color(0x4DFF5C00) : const Color(0xFFFEF0E7),
                                                        borderRadius: BorderRadius.circular(999),
                                                      ),
                                                      child: Text('-${opt.savings}',
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w700,
                                                            color: isSel ? const Color(0xFFFFB380) : const Color(0xFFFF5C00),
                                                          )),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              Text('€${opt.perLesson} per les · 365 dagen geldig',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: isSel ? Colors.white.withValues(alpha: 0.6) : const Color(0xFF8E9BB3),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color: isSel ? Colors.white : const Color(0xFFF0F4FA),
                                            shape: BoxShape.circle,
                                          ),
                                          child: isSel ? const Icon(Icons.check, color: Color(0xFF0365C4), size: 16) : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                // Trust badges
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _TrustBadge(Icons.verified_user, 'Veilig betalen', Color(0xFF27AE60)),
                        _TrustBadge(Icons.access_time, '365 dagen geldig', Color(0xFF0365C4)),
                        _TrustBadge(Icons.credit_card, 'Direct starten', Color(0xFFFF5C00)),
                      ],
                    ),
                  ),
                ),

                // What's included
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Wat zit erin',
                          style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                        ),
                        child: Column(
                          children: List.generate(included.length, (i) => Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: i > 0 ? const Border(top: BorderSide(color: Color(0xFFF0F4FA))) : null,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(color: Color(0xFFE8F8F0), shape: BoxShape.circle),
                                  child: const Icon(Icons.check, color: Color(0xFF27AE60), size: 12),
                                ),
                                const SizedBox(width: 10),
                                Text(included[i], style: const TextStyle(color: Color(0xFF4A5568), fontSize: 13)),
                              ],
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sticky bottom CTA
          Positioned(
            left: 20,
            right: 20,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 24, offset: const Offset(0, -4))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Totaal',
                            style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 10)),
                        Text('€${current.price}',
                            style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 26, fontWeight: FontWeight.w700)),
                        Text('${current.count}x $_cardType',
                            style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 10)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pushNamed(RouteNames.confirmOrder),
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: const Color(0xFFFF5C00).withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 8))],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.credit_card, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text('Bestellen',
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                        ],
                      ),
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

  Widget _toggleBtn(String type, {bool showBadge = false}) {
    final sel = _cardType == type;
    return GestureDetector(
      onTap: () => setState(() { _cardType = type; _selected = 0; }),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: sel ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          boxShadow: sel ? [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4))] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.credit_card, size: 14, color: sel ? const Color(0xFF0365C4) : Colors.white.withValues(alpha: 0.7)),
            const SizedBox(width: 6),
            Text(type,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: sel ? const Color(0xFF0365C4) : Colors.white.withValues(alpha: 0.7),
                )),
            if (showBadge) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5C00),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text('KORTING',
                    style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _TrustBadge(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(height: 4),
        Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF4A5568), fontSize: 9, fontWeight: FontWeight.w600, height: 1.3)),
      ],
    );
  }
}
