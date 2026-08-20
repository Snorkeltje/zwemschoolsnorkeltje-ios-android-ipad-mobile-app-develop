/// Walter 2026-05-07 — "My Waiting List Status" screen.
/// Walter's explicit request: parents self-check their position per slot,
/// reducing the "how long is the waiting list?" support workload.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/utils/smart_back.dart';
import '../../data/models/waitlist_models.dart';
import '../providers/waitlist_providers.dart';

class WaitlistStatusScreen extends ConsumerWidget {
  const WaitlistStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positionsAsync = ref.watch(myWaitlistPositionsProvider);
    final entriesAsync = ref.watch(myWaitlistEntriesProvider);
    final offersAsync = ref.watch(mySlotOffersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: RefreshIndicator(
        color: const Color(0xFF0365C4),
        onRefresh: () async {
          ref.invalidate(myWaitlistPositionsProvider);
          ref.invalidate(myWaitlistEntriesProvider);
          ref.invalidate(mySlotOffersProvider);
          await ref.read(myWaitlistPositionsProvider.future);
        },
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _Header()),
            offersAsync.when(
              data: (offers) {
                if (offers.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _SlotOfferCard(offer: offers[i]),
                    ),
                    childCount: offers.length,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
              error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),
            entriesAsync.when(
              data: (entries) {
                if (entries.isEmpty) return const SliverToBoxAdapter(child: _EmptyState());
                return SliverToBoxAdapter(child: _OverallStatusCard(entries: entries));
              },
              loading: () => const SliverToBoxAdapter(child: _LoadingState()),
              error: (e, _) => SliverToBoxAdapter(child: _ErrorState(message: e.toString())),
            ),
            positionsAsync.when(
              data: (positions) {
                if (positions.isEmpty) return const SliverToBoxAdapter(child: SizedBox(height: 24));
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      if (i == 0) return const _PerSlotSectionHeader();
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: _SlotPositionTile(position: positions[i - 1]),
                      );
                    },
                    childCount: positions.length + 1,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(child: _LoadingState()),
              error: (e, _) => SliverToBoxAdapter(child: _ErrorState(message: e.toString())),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 58, 20, 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0365C4), Color(0xFF034DA9)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => smartBack(context),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Mijn Wachtlijst Status',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Hier zie je je positie op elke wachtlijst en je ranking per gekozen dag/tijd combinatie.',
              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverallStatusCard extends StatelessWidget {
  final List<WaitlistEntry> entries;
  const _OverallStatusCard({required this.entries});

  @override
  Widget build(BuildContext context) {
    final general = entries.firstWhere(
      (e) => e.listType == WaitlistListType.general,
      orElse: () => entries.first,
    );
    final official = entries.where((e) => e.listType == WaitlistListType.official).toList();
    final mini = entries.where((e) => e.listType == WaitlistListType.miniSurvival).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0365C4).withValues(alpha: 0.06),
              blurRadius: 12, offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1E6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.list_alt, size: 18, color: Color(0xFFFF5C00)),
                ),
                const SizedBox(width: 10),
                const Text('Lijst lidmaatschappen',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
              ],
            ),
            const SizedBox(height: 12),
            _ListMembershipRow(
              label: 'Algemene Wachtlijst',
              joined: general.generalRegistrationDate,
              color: const Color(0xFF0365C4),
              icon: Icons.access_time,
            ),
            if (official.isNotEmpty) ...[
              const SizedBox(height: 8),
              _ListMembershipRow(
                label: 'Officiële Wachtlijst',
                joined: official.first.officialRegistrationDate ?? official.first.generalRegistrationDate,
                color: const Color(0xFF27AE60),
                icon: Icons.verified,
              ),
            ],
            if (mini.isNotEmpty) ...[
              const SizedBox(height: 8),
              _ListMembershipRow(
                label: 'Mini Survival',
                joined: mini.first.generalRegistrationDate,
                color: const Color(0xFFFF5C00),
                icon: Icons.pool,
              ),
            ],
            if (official.isEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFBAE6FD)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Color(0xFF0369A1)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Zodra je kind 4 wordt, krijg je een uitnodiging om je te registreren voor de officiële wachtlijst (€30 inschrijfgeld).',
                        style: TextStyle(fontSize: 11, height: 1.4, color: Color(0xFF0369A1)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ListMembershipRow extends StatelessWidget {
  final String label;
  final DateTime joined;
  final Color color;
  final IconData icon;
  const _ListMembershipRow({
    required this.label, required this.joined, required this.color, required this.icon,
  });

  String _fmtDate(DateTime d) {
    const months = ['jan','feb','mrt','apr','mei','jun','jul','aug','sep','okt','nov','dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final waiting = DateTime.now().difference(joined).inDays;
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
              Text('Sinds ${_fmtDate(joined)} · $waiting dagen wachtend',
                style: const TextStyle(fontSize: 11, color: Color(0xFF6B7B94))),
            ],
          ),
        ),
      ],
    );
  }
}

class _PerSlotSectionHeader extends StatelessWidget {
  const _PerSlotSectionHeader();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Icon(Icons.calendar_month, size: 16, color: Color(0xFFFF5C00)),
          SizedBox(width: 6),
          Text('JE POSITIE PER SLOT',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF6B7B94), letterSpacing: 0.6)),
        ],
      ),
    );
  }
}

class _SlotPositionTile extends StatelessWidget {
  final SlotPosition position;
  const _SlotPositionTile({required this.position});

  @override
  Widget build(BuildContext context) {
    final isFirst = position.position == 1;
    final isClose = position.position <= 3;
    final color = isFirst
        ? const Color(0xFF27AE60)
        : isClose
            ? const Color(0xFFFF5C00)
            : const Color(0xFF0365C4);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFirst ? color.withValues(alpha: 0.25) : const Color(0xFFE5EAF2),
          width: isFirst ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isFirst
                    ? [const Color(0xFF27AE60), const Color(0xFF2ECC71)]
                    : [color.withValues(alpha: 0.85), color],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.25),
                  blurRadius: 8, offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('#${position.position}',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                Text('van ${position.totalWaiting}',
                  style: const TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(position.locationName,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7FC),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('${position.dayLabel} · ${position.timeSlot}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF6B7B94))),
                ),
                const SizedBox(height: 4),
                Text(position.estimatedWait,
                  style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotOfferCard extends ConsumerWidget {
  final SlotOffer offer;
  const _SlotOfferCard({required this.offer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remaining = offer.timeRemaining;
    final hours = remaining.inHours;
    final mins = remaining.inMinutes % 60;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF27AE60).withValues(alpha: 0.25),
              blurRadius: 14, offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.celebration, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('PLEK AANGEBODEN!',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
              ],
            ),
            const SizedBox(height: 6),
            Text('${offer.locationName}\n${offer.dayLabel} · ${offer.slotTime}',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, height: 1.4)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text('Reageer binnen ${hours}u ${mins}m',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final err = await ref.read(waitlistRepositoryProvider).respondToSlotOffer(offerId: offer.id, accept: true);
                      final ok = err == null;
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(ok
                                ? '✓ Plek geaccepteerd — volg de betaling-stap'
                                : '❌ $err'),
                            backgroundColor: ok ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                          ),
                        );
                      }
                      ref.invalidate(mySlotOffersProvider);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF065F46),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Accepteer', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final err = await ref.read(waitlistRepositoryProvider).respondToSlotOffer(offerId: offer.id, accept: false);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(err == null ? 'Plek afgewezen' : 'Niet gelukt: $err')),
                        );
                      }
                      ref.invalidate(mySlotOffersProvider);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Afwijzen', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.list_alt, size: 40, color: Color(0xFFC4CDD9)),
            SizedBox(height: 12),
            Text('Je staat nog niet op een wachtlijst',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
            SizedBox(height: 4),
            Text('Schrijf je in via Mijn kinderen → wachtlijst inschrijven',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7B94))),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(child: CircularProgressIndicator(color: Color(0xFF0365C4))),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 36, color: Color(0xFFFF5C00)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7B94))),
          ],
        ),
      ),
    );
  }
}
