import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/utils/smart_back.dart';

class _Card {
  final String id;
  final String name;
  final int remaining;
  final int total;
  final String validUntil;
  final bool matchesType;
  const _Card(this.id, this.name, this.remaining, this.total, this.validUntil, this.matchesType);
}

const _cards = <_Card>[
  _Card('22976', '10× 1-op-1 zwemles', 8, 10, '24 mrt 2027', true),
  _Card('22980', '5× 1-op-2 zwemles', 3, 5, '15 jun 2027', false),
];

const _providers = [
  ('iDEAL', 'Direct betalen via je bank', '🏦', true),
  ('Creditcard', 'Visa, Mastercard, Amex', '💳', false),
];

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});
  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _method = 'punch';
  String _selectedCard = '22976';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            padding: const EdgeInsets.fromLTRB(16, 56, 16, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => smartBack(context),
                  child: Container(
                    width: 40, height: 40,
                    decoration: const BoxDecoration(color: Color(0xFFF4F7FC), shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const Icon(Icons.chevron_left, color: Color(0xFF1A1A2E), size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Betaalmethode',
                    style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price summary
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                        colors: [Color(0xFF1A6FBF), Color(0xFF0D4F8C)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text('Te betalen',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                        const SizedBox(height: 4),
                        const Text('€38,00',
                            style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text('1-op-1 extra zwemles — De Bilt',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Method tabs
                  Row(
                    children: [
                      Expanded(child: _tabBtn('punch', Icons.confirmation_number_outlined, 'Knipkaart')),
                      const SizedBox(width: 8),
                      Expanded(child: _tabBtn('card', Icons.credit_card, 'Betaalkaart')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_method == 'punch') ..._buildPunchCardSection(),
                  if (_method == 'card') ..._buildCardSection(),

                  // Security
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shield, color: Color(0xFF27AE60), size: 14),
                        SizedBox(width: 8),
                        Text('Beveiligde betaling — SSL versleuteld',
                            style: TextStyle(color: Color(0xFF8E8EA0), fontSize: 11)),
                      ],
                    ),
                  ),
                  if (_method == 'punch')
                    GestureDetector(
                      onTap: () => context.pushNamed(RouteNames.bookingSuccess),
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A6FBF),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: const Color(0xFF1A6FBF).withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2))],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.confirmation_number_outlined, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text('Betalen met knipkaart',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
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

  Widget _tabBtn(String key, IconData icon, String label) {
    final sel = _method == key;
    return GestureDetector(
      onTap: () => setState(() => _method = key),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: sel ? const Color(0xFF1A6FBF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: sel ? null : Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: sel ? const Color(0xFF1A6FBF).withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.04),
              blurRadius: sel ? 4 : 8,
              offset: Offset(0, sel ? 2 : 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: sel ? Colors.white : const Color(0xFF4A4A6A)),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: sel ? Colors.white : const Color(0xFF4A4A6A),
                )),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPunchCardSection() {
    final remaining = _cards.firstWhere((c) => c.id == _selectedCard).remaining - 1;
    return [
      const Text('Selecteer knipkaart',
          style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      ..._cards.map((c) {
        final isSel = _selectedCard == c.id;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => setState(() => _selectedCard = c.id),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSel ? const Color(0xFFE8F4FD) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSel ? const Color(0xFF1A6FBF) : const Color(0xFFE5E7EB),
                  width: isSel ? 2 : 1,
                ),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(c.name,
                                style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                            if (c.matchesType) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F8F0),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text('MATCH',
                                    style: TextStyle(color: Color(0xFF27AE60), fontSize: 9, fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text('Kaart #${c.id}',
                            style: const TextStyle(color: Color(0xFF4A4A6A), fontSize: 12)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  height: 6,
                                  color: const Color(0xFFE5E7EB),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: c.remaining / c.total,
                                    child: Container(color: const Color(0xFF1A6FBF)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('${c.remaining}/${c.total}',
                                style: const TextStyle(color: Color(0xFF1A6FBF), fontSize: 12, fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Geldig tot ${c.validUntil}',
                            style: const TextStyle(color: Color(0xFF8E8EA0), fontSize: 11)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSel ? const Color(0xFF1A6FBF) : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSel ? const Color(0xFF1A6FBF) : const Color(0xFFBDC3C7),
                        width: 2,
                      ),
                    ),
                    child: isSel ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F4FD),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.confirmation_number_outlined, color: Color(0xFF1A6FBF), size: 14),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Na betaling: $remaining credits resterend op kaart #$_selectedCard',
                  style: const TextStyle(color: Color(0xFF1A6FBF), fontSize: 12)),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildCardSection() {
    return [
      const Text('Betaal met kaart',
          style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      ..._providers.map((p) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
          onTap: () => context.pushNamed(RouteNames.stripePayment),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7FC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(p.$3, style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(p.$1,
                              style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w600)),
                          if (p.$4) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3DC),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text('POPULAIR',
                                  style: TextStyle(color: Color(0xFFF39C12), fontSize: 9, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ],
                      ),
                      Text(p.$2, style: const TextStyle(color: Color(0xFF8E8EA0), fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFFBDC3C7), size: 18),
              ],
            ),
          ),
        ),
      )),
    ];
  }
}
