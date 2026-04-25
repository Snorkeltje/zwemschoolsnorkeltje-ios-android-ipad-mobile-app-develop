import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/utils/smart_back.dart';
import '../../data/models/fixed_schedule_models.dart';
import '../providers/fixed_schedule_provider.dart';

/// Parent-side: pending 24h slot offers awaiting Yes/No response.
class SlotOffersScreen extends ConsumerStatefulWidget {
  const SlotOffersScreen({super.key});

  @override
  ConsumerState<SlotOffersScreen> createState() => _SlotOffersScreenState();
}

class _SlotOffersScreenState extends ConsumerState<SlotOffersScreen> {
  static const _parentId = 'p1';
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // Re-render every second to keep countdown live.
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offers = ref.watch(slotOfferProvider).where((o) => o.parentId == _parentId).toList();
    final pending = offers.where((o) => o.status == SlotOfferStatus.pending && !o.isExpired).toList();
    final history = offers.where((o) => o.status != SlotOfferStatus.pending || o.isExpired).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24),
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 58, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
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
                    child: Text('Plek aanbiedingen',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                  if (pending.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text('${pending.length} nieuw',
                          style: const TextStyle(color: Color(0xFF0365C4), fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pending.isEmpty && history.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.inbox_outlined, size: 48, color: Colors.black.withValues(alpha: 0.15)),
                            const SizedBox(height: 12),
                            const Text('Geen aanbiedingen op dit moment',
                                style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 13)),
                          ],
                        ),
                      ),
                    ),

                  if (pending.isNotEmpty) ...[
                    const Text('Te beantwoorden binnen 24 uur',
                        style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    for (final offer in pending)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _PendingOfferCard(offer: offer),
                      ),
                    const SizedBox(height: 20),
                  ],

                  if (history.isNotEmpty) ...[
                    const Text('Geschiedenis',
                        style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    for (final offer in history)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _HistoryOfferCard(offer: offer),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingOfferCard extends ConsumerWidget {
  final SlotOffer offer;
  const _PendingOfferCard({required this.offer});

  String _countdown(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return '${h.toString().padLeft(2,'0')}u ${m.toString().padLeft(2,'0')}m ${s.toString().padLeft(2,'0')}s';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final left = offer.timeLeft;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFF5C00).withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: const Color(0xFFFF5C00).withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5C00).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.celebration, color: Color(0xFFFF5C00), size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Er is een plek vrijgekomen!',
                  style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row('Dag', offer.day.full),
                _row('Tijd', offer.time),
                _row('Locatie', offer.location),
                _row('Voor', offer.childName),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 14, color: Color(0xFFE74C3C)),
              const SizedBox(width: 6),
              Text('Nog $_countdown'.replaceAll('Nog \$_countdown', 'Nog ${_countdown(left)}'),
                  style: const TextStyle(color: Color(0xFFE74C3C), fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ref.read(slotOfferProvider.notifier).respond(offer.id, false);
                  },
                  child: const Text('Nee, bedankt',
                      style: TextStyle(color: Color(0xFF6B7B94), fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF27AE60),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    ref.read(slotOfferProvider.notifier).respond(offer.id, true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reactie verstuurd. U hoort spoedig of u de plek krijgt.'),
                        backgroundColor: Color(0xFF27AE60),
                      ),
                    );
                  },
                  child: const Text('Ja, ik wil deze plek',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 70, child: Text(label,
              style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 12))),
          Text(value,
              style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _HistoryOfferCard extends StatelessWidget {
  final SlotOffer offer;
  const _HistoryOfferCard({required this.offer});

  Color get _statusColor => switch (offer.status) {
    SlotOfferStatus.accepted => const Color(0xFF27AE60),
    SlotOfferStatus.declined => const Color(0xFF8E9BB3),
    SlotOfferStatus.expired => const Color(0xFF8E9BB3),
    SlotOfferStatus.lost => const Color(0xFFE74C3C),
    _ => const Color(0xFF8E9BB3),
  };

  String get _statusLabel => switch (offer.status) {
    SlotOfferStatus.accepted => 'Geaccepteerd',
    SlotOfferStatus.declined => 'Afgewezen',
    SlotOfferStatus.expired => 'Verlopen',
    SlotOfferStatus.lost => 'Aan ander gegeven',
    _ => 'In afwachting',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 8, height: 32,
            decoration: BoxDecoration(color: _statusColor, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${offer.day.full} · ${offer.time} — ${offer.location}',
                    style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13, fontWeight: FontWeight.w600)),
                Text(_statusLabel,
                    style: TextStyle(color: _statusColor, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
