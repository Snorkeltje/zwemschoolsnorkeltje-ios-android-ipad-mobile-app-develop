import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/instructor_theme.dart';

class InstructorScheduleScreen extends StatefulWidget {
  const InstructorScheduleScreen({super.key});

  @override
  State<InstructorScheduleScreen> createState() => _InstructorScheduleScreenState();
}

class _InstructorScheduleScreenState extends State<InstructorScheduleScreen> {
  int _selectedDayIndex = 0;
  int _weekNumber = 18;

  final List<Map<String, dynamic>> _days = [
    {'day': 'Ma', 'date': 28},
    {'day': 'Di', 'date': 29},
    {'day': 'Wo', 'date': 30},
    {'day': 'Do', 'date': 1},
    {'day': 'Vr', 'date': 2},
    {'day': 'Za', 'date': 3},
    {'day': 'Zo', 'date': 4},
  ];

  final Map<int, List<Map<String, dynamic>>> _scheduleByDay = {
    28: [
      {'time': '09:00', 'end': '09:30', 'location': 'De Bilt', 'students': 1, 'type': '1-op-1', 'names': ['Emma J.']},
      {'time': '09:30', 'end': '10:00', 'location': 'De Bilt', 'students': 2, 'type': '1-op-2', 'names': ['Sami K.', 'Noor K.']},
      {'time': '13:00', 'end': '13:30', 'location': 'De Bilt', 'students': 2, 'type': '1-op-2', 'names': ['Lisa B.', 'Tim v.D.']},
      {'time': '14:00', 'end': '14:30', 'location': 'De Bilt', 'students': 1, 'type': '1-op-1', 'names': ['Daan B.']},
      {'time': '15:00', 'end': '15:30', 'location': 'De Bilt', 'students': 3, 'type': '1-op-3', 'names': ['Sophie d.W.', 'Finn M.', 'Max V.']},
      {'time': '16:00', 'end': '16:30', 'location': 'Bad Hulck.', 'students': 2, 'type': '1-op-2', 'names': ['Eva K.', 'Luuk S.']},
      {'time': '16:30', 'end': '17:00', 'location': 'Bad Hulck.', 'students': 1, 'type': '1-op-1', 'names': ['Anna P.']},
      {'time': '17:00', 'end': '17:30', 'location': 'Bad Hulck.', 'students': 1, 'type': '1-op-1', 'names': ['Noah B.']},
    ],
    29: [
      {'time': '09:00', 'end': '09:30', 'location': 'Garderen', 'students': 2, 'type': '1-op-2', 'names': ['Mila D.', 'Sem J.']},
      {'time': '10:00', 'end': '10:30', 'location': 'Garderen', 'students': 1, 'type': '1-op-1', 'names': ['Lotte V.']},
      {'time': '14:00', 'end': '14:30', 'location': 'De Bilt', 'students': 2, 'type': '1-op-2', 'names': ['Sami K.', 'Lisa B.']},
    ],
    30: [
      {'time': '09:00', 'end': '09:30', 'location': 'Ampt v. Nijkerk', 'students': 1, 'type': '1-op-1', 'names': ['Tim v.D.']},
      {'time': '14:00', 'end': '14:30', 'location': 'Bad Hulck.', 'students': 2, 'type': '1-op-2', 'names': ['Emma J.', 'Daan B.']},
      {'time': '15:00', 'end': '15:30', 'location': 'Bad Hulck.', 'students': 1, 'type': '1-op-1', 'names': ['Sophie d.W.']},
      {'time': '16:00', 'end': '16:30', 'location': 'Bad Hulck.', 'students': 2, 'type': '1-op-2', 'names': ['Finn M.', 'Noah B.']},
    ],
    1: [
      {'time': '10:00', 'end': '10:30', 'location': 'Ampt v. Nijkerk', 'students': 1, 'type': '1-op-1', 'names': ['Tim v.D.']},
      {'time': '11:00', 'end': '11:30', 'location': 'Ampt v. Nijkerk', 'students': 1, 'type': '1-op-1', 'names': ['Finn M.']},
    ],
    2: [
      {'time': '14:00', 'end': '14:30', 'location': 'De Bilt', 'students': 2, 'type': '1-op-2', 'names': ['Sami K.', 'Noor K.']},
      {'time': '15:00', 'end': '15:30', 'location': 'De Bilt', 'students': 1, 'type': '1-op-1', 'names': ['Lisa B.']},
      {'time': '16:00', 'end': '16:30', 'location': 'De Bilt', 'students': 1, 'type': '1-op-1', 'names': ['Emma J.']},
    ],
    3: [],
    4: [],
  };

  static const Map<String, Color> _typeColors = {
    '1-op-1': Color(0xFF0365C4),
    '1-op-2': Color(0xFFFF5C00),
    '1-op-3': Color(0xFF27AE60),
  };

  List<Map<String, dynamic>> get _currentSchedule {
    final date = _days[_selectedDayIndex]['date'] as int;
    return _scheduleByDay[date] ?? [];
  }

  int get _totalStudents {
    return _currentSchedule.fold(0, (sum, item) => sum + (item['students'] as int));
  }

  List<String> _uniqueLocations() {
    final locs = <String>{};
    for (final item in _currentSchedule) {
      locs.add(item['location'] as String);
    }
    return locs.toList();
  }

  /// Build combined schedule including EMPTY slots per Walter's feedback.
  /// Shows all 30-min slots between 09:00 and 18:00.
  /// Empty slots allow instructor to offer earlier times to waitlist.
  List<Map<String, dynamic>> _scheduleWithEmptySlots() {
    final booked = _currentSchedule;
    if (booked.isEmpty) return [];

    final bookedTimes = <String>{};
    for (final item in booked) {
      bookedTimes.add(item['time'] as String);
    }

    final all = <Map<String, dynamic>>[];
    // Generate 30-min slots from 09:00 to 18:00
    for (int h = 9; h < 18; h++) {
      for (final m in [0, 30]) {
        final time = '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
        final endH = m == 30 ? h + 1 : h;
        final endM = m == 30 ? 0 : 30;
        final end = '${endH.toString().padLeft(2, '0')}:${endM.toString().padLeft(2, '0')}';

        if (bookedTimes.contains(time)) {
          final bookedItem = booked.firstWhere((i) => i['time'] == time);
          all.add(bookedItem);
        } else {
          all.add({
            'time': time,
            'end': end,
            'location': '',
            'students': 0,
            'type': 'EMPTY',
            'names': <String>[],
            'isEmpty': true,
          });
        }
      }
    }
    return all;
  }

  Future<void> _onRefresh() async {
    HapticFeedback.selectionClick();
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hPad = ITheme.hPad(context);
    return Scaffold(
      backgroundColor: ITheme.bg,
      body: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.fromLTRB(hPad, 60, hPad, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [ITheme.headerGradStart, ITheme.headerGradEnd],
                ),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mijn Rooster', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                            Text('April — Mei 2026', style: TextStyle(color: ITheme.textMid, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Week navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _weekNumber = (_weekNumber > 1) ? _weekNumber - 1 : 52);
                        },
                        child: Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.chevron_left, color: ITheme.textHi, size: 16),
                        ),
                      ),
                      Text('Week $_weekNumber',
                          style: const TextStyle(color: ITheme.textHi, fontSize: 13, fontWeight: FontWeight.w600)),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _weekNumber = (_weekNumber < 52) ? _weekNumber + 1 : 1);
                        },
                        child: Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.chevron_right, color: ITheme.textHi, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Day selector
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemCount: _days.length,
                itemBuilder: (context, index) {
                  final day = _days[index];
                  final isSelected = _selectedDayIndex == index;
                  final date = day['date'] as int;
                  final lessonsCount = (_scheduleByDay[date] ?? []).length;
                  final isToday = index == 0;

                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedDayIndex = index);
                    },
                    child: Container(
                      width: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)])
                            : null,
                        color: isSelected ? null : const Color(0xFF1A1D27),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isSelected
                            ? [BoxShadow(color: const Color(0xFFFF5C00).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            day['day'],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF8E9BB3),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$date',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : (isToday ? const Color(0xFFFF5C00) : const Color(0xFFE2E8F0)),
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (lessonsCount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFFF5C00).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$lessonsCount',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.white : const Color(0xFFFF5C00),
                                ),
                              ),
                            )
                          else
                            Text('—', style: TextStyle(fontSize: 9, color: const Color(0xFF4A5568))),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Day summary with primary location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_currentSchedule.length} lessen',
                        style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.people_outline, size: 12, color: Color(0xFF8E9BB3)),
                          const SizedBox(width: 4),
                          Text('$_totalStudents', style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  if (_currentSchedule.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    // Location pill — shown once since 1 location/day typically
                    Wrap(
                      spacing: 6,
                      children: _uniqueLocations().map((loc) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5C00).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFFF5C00).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on, size: 11, color: Color(0xFFFF5C00)),
                            const SizedBox(width: 4),
                            Text(loc,
                                style: const TextStyle(color: Color(0xFFFF5C00), fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),

            // Timeline
            Expanded(
              child: _currentSchedule.isEmpty
                  ? Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1D27),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('🏖️', style: TextStyle(fontSize: 40)),
                            SizedBox(height: 12),
                            Text('Geen lessen vandaag', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 14, fontWeight: FontWeight.w600)),
                            SizedBox(height: 4),
                            Text('Geniet van uw vrije dag!', style: TextStyle(color: Color(0xFF4A5568), fontSize: 12)),
                          ],
                        ),
                      ),
                    )
                  : Builder(builder: (_) {
                      final combined = _scheduleWithEmptySlots();
                      return RefreshIndicator(
                        color: ITheme.primary,
                        backgroundColor: ITheme.bgElev,
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: combined.length,
                      itemBuilder: (context, index) {
                        final item = combined[index];
                        final isEmpty = item['isEmpty'] == true;
                        final type = item['type'] as String;
                        final accentColor = _typeColors[type] ?? const Color(0xFFFF5C00);
                        final names = (item['names'] as List).join(', ');

                        // EMPTY slot — per Walter: show box so instructor sees availability
                        if (isEmpty) {
                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              _showEmptySlotActions(item['time'] as String);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 54,
                                    child: Column(
                                      children: [
                                        Text(item['time'],
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4A5568))),
                                        const SizedBox(height: 2),
                                        const Text('30 min', style: TextStyle(fontSize: 9, color: Color(0xFF4A5568), fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                  Container(width: 1, height: 44, color: Colors.white.withValues(alpha: 0.04), margin: const EdgeInsets.symmetric(horizontal: 12)),
                                  const Expanded(
                                    child: Text('LEEG — Beschikbaar',
                                        style: TextStyle(color: Color(0xFF4A5568), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF27AE60).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: const Text('+ OFFER',
                                        style: TextStyle(color: Color(0xFF27AE60), fontSize: 9, fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            // Lesson-detail screen not implemented yet — show options menu instead.
                            _showMoveLessonAction(item['time'] as String);
                          },
                          onLongPress: () {
                            HapticFeedback.mediumImpact();
                            _showMoveLessonAction(item['time'] as String);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1D27),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Stack(
                              children: [
                                // Left accent bar
                                Positioned(
                                  left: 0, top: 12, bottom: 12,
                                  child: Container(
                                    width: 3,
                                    decoration: BoxDecoration(
                                      color: accentColor,
                                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      // Time (30 min — Walter: all lessons are 30min)
                                      SizedBox(
                                        width: 54,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(item['time'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: accentColor)),
                                            const SizedBox(height: 2),
                                            Text('30 min', style: const TextStyle(fontSize: 9, color: Color(0xFF4A5568), fontWeight: FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                      Container(width: 1, height: 44, color: Colors.white.withValues(alpha: 0.06), margin: const EdgeInsets.symmetric(horizontal: 12)),
                                      // Info — children names PRIMARY per Walter
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    names,
                                                    style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 14, fontWeight: FontWeight.w700),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: accentColor.withValues(alpha: 0.12),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Text(type, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: accentColor)),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            // Location only shown if differs from main location of the day
                                            if (_uniqueLocations().length > 1)
                                              Row(
                                                children: [
                                                  const Icon(Icons.location_on_outlined, size: 11, color: Color(0xFF4A5568)),
                                                  const SizedBox(width: 4),
                                                  Text(item['location'],
                                                      style: const TextStyle(color: Color(0xFF4A5568), fontSize: 11)),
                                                ],
                                              )
                                            else
                                              Text(
                                                '${item['students']} ${(item['students'] as int) == 1 ? "leerling" : "leerlingen"}',
                                                style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right, size: 16, color: Color(0xFF4A5568)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    );
                    }),
            ),
          ],
        ),
    );
  }

  /// Empty slot action sheet per Walter: "offer to another customer"
  void _showEmptySlotActions(String time) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1D27),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text('Leeg slot — $time',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('Biedt dit tijdslot aan een leerling aan',
                style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
            const SizedBox(height: 20),
            _actionTile(ctx, Icons.send, 'Aanbieden aan wachtlijst', const Color(0xFF27AE60), () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Slot aangeboden aan wachtlijst klanten'), backgroundColor: Color(0xFF27AE60)),
              );
            }),
            _actionTile(ctx, Icons.person_add_alt, 'Aanbieden aan specifieke leerling', const Color(0xFF0365C4), () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kies leerling uit lijst')),
              );
            }),
            _actionTile(ctx, Icons.block, 'Blokkeer dit slot', const Color(0xFFE74C3C), () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Slot geblokkeerd')),
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// Move lesson action per Walter's drag-drop feedback
  void _showMoveLessonAction(String currentTime) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1D27),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final emptySlots = _scheduleWithEmptySlots().where((s) => s['isEmpty'] == true).toList();
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text('Verplaats les van $currentTime naar...',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              if (emptySlots.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Geen lege tijdslots beschikbaar', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 13)),
                )
              else
                SizedBox(
                  height: 200,
                  child: ListView(
                    children: emptySlots.map((slot) => _actionTile(
                      ctx,
                      Icons.schedule,
                      '${slot['time']} → ${slot['end']}',
                      const Color(0xFF0365C4),
                      () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Les verplaatst naar ${slot['time']}. Ouder op de hoogte gebracht.'),
                            backgroundColor: const Color(0xFF27AE60),
                          ),
                        );
                      },
                    )).toList(),
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _actionTile(BuildContext ctx, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
