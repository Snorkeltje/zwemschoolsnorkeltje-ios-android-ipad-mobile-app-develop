import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/utils/smart_back.dart';
import '../../data/reservations_repository.dart';
import '../providers/reservations_provider.dart';

class MyReservationsScreen extends ConsumerStatefulWidget {
  const MyReservationsScreen({super.key});
  @override
  ConsumerState<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends ConsumerState<MyReservationsScreen> {
  int _tab = 0; // 0=upcoming, 1=history
  String _filter = 'all';

  List<ReservationItem> _applyFilter(List<ReservationItem> all) {
    var list = all.where((r) => _tab == 0 ? r.isUpcoming : r.isHistory).toList();
    if (_filter == 'all') return list;
    final typeMap = {'fixed': '1-op-1', 'extra': '1-op-2', 'holiday': '1-op-3'};
    final t = typeMap[_filter];
    if (t == null) return list;
    return list.where((r) => r.type == t).toList();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(myReservationsProvider);
    final all = async.value ?? const <ReservationItem>[];
    final items = _applyFilter(all);
    final loading = async.isLoading;
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
                      onTap: () => smartBack(context),
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
                        const Text('Mijn reserveringen',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                        Text('${items.length} lessen',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Tab switcher
            Transform.translate(
              offset: const Offset(0, -12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _tabBtn(0, Icons.calendar_today, 'Aankomend')),
                      Expanded(child: _tabBtn(1, Icons.access_time, 'Historie')),
                    ],
                  ),
                ),
              ),
            ),

            // Filter pills
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterPill('all', 'Alle'),
                    const SizedBox(width: 8),
                    _filterPill('fixed', 'Vast'),
                    const SizedBox(width: 8),
                    _filterPill('extra', 'Extra'),
                    const SizedBox(width: 8),
                    _filterPill('holiday', 'Vakantie'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Cards
            if (loading && items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: const Center(
                    child: Column(children: [
                      Text('🏊', style: TextStyle(fontSize: 32)),
                      SizedBox(height: 8),
                      Text('Nog geen reserveringen',
                          style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                      SizedBox(height: 4),
                      Text('Boek uw eerste les vanaf het home scherm',
                          style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
                    ]),
                  ),
                ),
              )
            else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: items.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => context.pushNamed(RouteNames.reservationDetail, pathParameters: {'id': r.id}),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(width: 4, decoration: BoxDecoration(color: r.accentColor, borderRadius: BorderRadius.circular(2))),
                            const SizedBox(width: 12),
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: r.accentColor.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_dayShort(r.date),
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: r.accentColor)),
                                  Text('${r.date.day}',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: r.accentColor)),
                                  Text(_monthShort(r.date),
                                      style: TextStyle(fontSize: 10, color: r.accentColor)),
                                ],
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
                                      Row(
                                        children: [
                                          const Icon(Icons.access_time, size: 13, color: Color(0xFF8E9BB3)),
                                          const SizedBox(width: 6),
                                          Text('${r.startTime}–${r.endTime}',
                                              style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: r.accentColor.withValues(alpha: 0.07),
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: Text(r.type,
                                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: r.accentColor)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined, size: 13, color: Color(0xFF8E9BB3)),
                                      const SizedBox(width: 6),
                                      Expanded(child: Text(r.location, style: const TextStyle(color: Color(0xFF6B7B94), fontSize: 12), overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.person_outline, size: 13, color: Color(0xFF8E9BB3)),
                                      const SizedBox(width: 6),
                                      Text(r.instructor, style: const TextStyle(color: Color(0xFF6B7B94), fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.chevron_right, color: Color(0xFFC4CDD9), size: 16),
                                if (r.isHistory)
                                  // Completed lesson: show usage indicator (Walter)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF27AE60).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_circle, color: Color(0xFF27AE60), size: 11),
                                        SizedBox(width: 3),
                                        Text('Voltooid',
                                            style: TextStyle(color: Color(0xFF27AE60), fontSize: 10, fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  )
                                else
                                  GestureDetector(
                                    onTap: () => context.pushNamed(RouteNames.cancellationConfirm, pathParameters: {'id': r.id}),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.close, color: Color(0xFFE74C3C), size: 12),
                                        SizedBox(width: 2),
                                        Text('Annuleer',
                                            style: TextStyle(color: Color(0xFFE74C3C), fontSize: 11, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
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

  String _dayShort(DateTime d) =>
      const ['Ma', 'Di', 'Wo', 'Do', 'Vr', 'Za', 'Zo'][d.weekday - 1];
  String _monthShort(DateTime d) => const [
        'jan', 'feb', 'mrt', 'apr', 'mei', 'jun',
        'jul', 'aug', 'sep', 'okt', 'nov', 'dec'
      ][d.month - 1];

  Widget _tabBtn(int i, IconData icon, String label) {
    final sel = _tab == i;
    return GestureDetector(
      onTap: () => setState(() => _tab = i),
      child: Container(
        decoration: BoxDecoration(
          gradient: sel
              ? const LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)])
              : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: sel ? [BoxShadow(color: const Color(0x330365C4), blurRadius: 12, offset: const Offset(0, 4))] : null,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: sel ? Colors.white : const Color(0xFF8E9BB3)),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                  color: sel ? Colors.white : const Color(0xFF8E9BB3),
                )),
          ],
        ),
      ),
    );
  }

  Widget _filterPill(String key, String label) {
    final sel = _filter == key;
    return GestureDetector(
      onTap: () => setState(() => _filter = key),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: sel ? null : Colors.white,
          gradient: sel ? const LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)]) : null,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: sel ? const Color(0x330365C4) : Colors.black.withValues(alpha: 0.04),
              blurRadius: sel ? 12 : 3,
              offset: Offset(0, sel ? 4 : 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
              color: sel ? Colors.white : const Color(0xFF6B7B94),
            )),
      ),
    );
  }
}
