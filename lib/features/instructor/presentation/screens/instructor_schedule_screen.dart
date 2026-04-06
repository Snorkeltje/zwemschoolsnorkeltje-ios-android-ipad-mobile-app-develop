import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class InstructorScheduleScreen extends StatefulWidget {
  const InstructorScheduleScreen({super.key});

  @override
  State<InstructorScheduleScreen> createState() => _InstructorScheduleScreenState();
}

class _InstructorScheduleScreenState extends State<InstructorScheduleScreen> {
  int _selectedDayIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1D27), Color(0xFF252836)],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.chevron_left, color: Color(0xFFE2E8F0), size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mijn Rooster', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                            Text('April — Mei 2026', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
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
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.chevron_left, color: Color(0xFFE2E8F0), size: 16),
                      ),
                      const Text('Week 18', style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 13, fontWeight: FontWeight.w600)),
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.chevron_right, color: Color(0xFFE2E8F0), size: 16),
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
                    onTap: () => setState(() => _selectedDayIndex = index),
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
                            ? [BoxShadow(color: const Color(0xFFFF5C00).withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))]
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
                              color: isSelected ? Colors.white.withOpacity(0.7) : const Color(0xFF8E9BB3),
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
                                color: isSelected ? Colors.white.withOpacity(0.2) : const Color(0xFFFF5C00).withOpacity(0.12),
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

            // Day summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
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
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _currentSchedule.length,
                      itemBuilder: (context, index) {
                        final item = _currentSchedule[index];
                        final type = item['type'] as String;
                        final accentColor = _typeColors[type] ?? const Color(0xFFFF5C00);
                        final names = (item['names'] as List).join(', ');

                        return GestureDetector(
                          onTap: () => context.push('/instructor/lesson/1'),
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
                                      // Time
                                      SizedBox(
                                        width: 50,
                                        child: Column(
                                          children: [
                                            Text(item['time'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: accentColor)),
                                            Text(item['end'], style: const TextStyle(fontSize: 10, color: Color(0xFF4A5568))),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(item['location'], style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 13, fontWeight: FontWeight.w700)),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: accentColor.withOpacity(0.08),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Text(type, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: accentColor)),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(Icons.people_outline, size: 11, color: Color(0xFF8E9BB3)),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(names, style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11), overflow: TextOverflow.ellipsis),
                                                ),
                                              ],
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
            ),
          ],
        ),
      ),
    );
  }
}
