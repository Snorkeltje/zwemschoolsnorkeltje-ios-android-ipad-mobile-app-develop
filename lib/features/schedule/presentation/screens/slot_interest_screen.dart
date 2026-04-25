import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/utils/smart_back.dart';
import '../../data/models/fixed_schedule_models.dart';
import '../providers/fixed_schedule_provider.dart';

/// "Mijn slot-interesses" — parent registers interest in specific weekly slots.
/// When a slot opens up, all interested parents get a 24h offer notification.
class SlotInterestScreen extends ConsumerWidget {
  const SlotInterestScreen({super.key});

  static const _parentId = 'p1', _parentName = 'Ahmed Khilji';
  static const _childId = 'c1', _childName = 'Sami Khilji';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mine = ref.watch(slotInterestProvider).where((i) => i.parentId == _parentId).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Column(
        children: [
          _header(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF7FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: Color(0xFF0365C4), size: 18),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Geef hieronder aan in welke vaste lestijden u geïnteresseerd bent. '
                            'Zodra zo\'n plek vrijkomt, krijgt u 24 uur de tijd om de plek te accepteren. '
                            'De hoogste op de wachtlijst krijgt voorrang.',
                            style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 12, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Already-registered
                  if (mine.isNotEmpty) ...[
                    const Text('Mijn interesses',
                        style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    for (final interest in mine)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _MyInterestTile(
                          interest: interest,
                          onCancel: () {
                            HapticFeedback.lightImpact();
                            ref.read(slotInterestProvider.notifier).cancel(interest.id);
                          },
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],

                  const Text('Beschikbare slots',
                      style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const Text('Tik op een slot om interesse aan te geven',
                      style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
                  const SizedBox(height: 12),

                  // Generate the standard weekly grid; only show non-locked weekdays
                  for (final day in WeekDay.values.take(5))
                    _DaySection(day: day, parentId: _parentId, parentName: _parentName,
                        childId: _childId, childName: _childName),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return ClipRRect(
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
                  Text('Vaste plek aanvragen',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  Text('Geef interesse aan voor specifieke tijdslots',
                      style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyInterestTile extends StatelessWidget {
  final SlotInterest interest;
  final VoidCallback onCancel;
  const _MyInterestTile({required this.interest, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFB370).withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB370).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.bookmark, size: 18, color: Color(0xFFE8863A)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${interest.day.full} · ${interest.time}',
                    style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                Text(interest.location,
                    style: const TextStyle(color: Color(0xFF6B7B94), fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Color(0xFF8E9BB3)),
            onPressed: onCancel,
            tooltip: 'Verwijder interesse',
          ),
        ],
      ),
    );
  }
}

class _DaySection extends ConsumerWidget {
  final WeekDay day;
  final String parentId, parentName, childId, childName;
  const _DaySection({
    required this.day,
    required this.parentId, required this.parentName,
    required this.childId, required this.childName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSlots = ref.watch(fixedScheduleProvider).where((s) => s.day == day).toList();
    if (allSlots.isEmpty) return const SizedBox.shrink();
    allSlots.sort((a, b) => a.time.compareTo(b.time));
    final mine = ref.watch(slotInterestProvider)
        .where((i) => i.parentId == parentId).map((i) => i.slotKey).toSet();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(day.full.toUpperCase(),
              style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
          const SizedBox(height: 8),
          for (final slot in allSlots)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _SlotPickTile(
                slot: slot,
                alreadyInterested: mine.contains(
                  ref.read(slotInterestProvider.notifier).keyFor(slot.day, slot.time, slot.location)),
                onTap: () {
                  HapticFeedback.selectionClick();
                  if (mine.contains(
                    ref.read(slotInterestProvider.notifier).keyFor(slot.day, slot.time, slot.location))) {
                    return;
                  }
                  ref.read(slotInterestProvider.notifier).register(
                    parentId: parentId, parentName: parentName,
                    childId: childId, childName: childName,
                    day: slot.day, time: slot.time, location: slot.location,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Interesse geregistreerd voor ${slot.day.full} ${slot.time}'),
                      backgroundColor: const Color(0xFF27AE60),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _SlotPickTile extends StatelessWidget {
  final FixedSlot slot;
  final bool alreadyInterested;
  final VoidCallback onTap;
  const _SlotPickTile({required this.slot, required this.alreadyInterested, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: alreadyInterested
                ? const Color(0xFF27AE60).withValues(alpha: 0.4)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 8, height: 32,
              decoration: BoxDecoration(
                color: slot.locationColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 60,
              child: Text(slot.time,
                  style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(slot.location,
                      style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13, fontWeight: FontWeight.w600)),
                  Text('${slot.lessonType} · ${slot.instructorName}',
                      style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                ],
              ),
            ),
            if (alreadyInterested)
              const Icon(Icons.bookmark, color: Color(0xFF27AE60), size: 20)
            else if (slot.isEmpty)
              const Icon(Icons.add_circle_outline, color: Color(0xFF0365C4), size: 20)
            else
              const Icon(Icons.bookmark_border, color: Color(0xFF8E9BB3), size: 20),
          ],
        ),
      ),
    );
  }
}
