import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/utils/smart_back.dart';

class _Instructor {
  final String id;
  final String name;
  final String initial;
  final double rating;
  final List<Color> gradient;
  const _Instructor(this.id, this.name, this.initial, this.rating, this.gradient);
}

class _TimeSlot {
  final String time;
  final String end;
  final bool available;
  final int spots;
  final List<_Instructor> instructors;
  const _TimeSlot(this.time, this.end, this.available, this.spots, this.instructors);
}

// Walter: show actual instructor name, allow choose when 2 available
const _jan = _Instructor('i1', 'Jan de Vries', 'J', 4.9, [Color(0xFFFF5C00), Color(0xFFF5A623)]);
const _maria = _Instructor('i2', 'Maria Jansen', 'M', 4.8, [Color(0xFF0365C4), Color(0xFF00C1FF)]);
const _pieter = _Instructor('i3', 'Pieter Bakker', 'P', 4.7, [Color(0xFF27AE60), Color(0xFF2ECC71)]);

const _slots = <_TimeSlot>[
  _TimeSlot('09:00', '09:30', true, 3, [_jan, _maria]), // 2 instructors — customer can choose
  _TimeSlot('09:30', '10:00', true, 2, [_jan]),
  _TimeSlot('10:00', '10:30', true, 1, [_maria]),
  _TimeSlot('10:30', '11:00', false, 0, []),
  _TimeSlot('14:00', '14:30', true, 3, [_pieter, _jan]), // 2 instructors
  _TimeSlot('14:30', '15:00', true, 2, [_pieter]),
  _TimeSlot('15:00', '15:30', false, 0, []),
  _TimeSlot('16:00', '16:30', true, 1, [_maria]),
];

const _weekDays = ['Ma', 'Di', 'Wo', 'Do', 'Vr', 'Za', 'Zo'];
const _weeks = <List<int?>>[
  [null, null, null, null, null, null, 1],
  [2, 3, 4, 5, 6, 7, 8],
  [9, 10, 11, 12, 13, 14, 15],
  [16, 17, 18, 19, 20, 21, 22],
  [23, 24, 25, 26, 27, 28, 29],
  [30, 31, null, null, null, null, null],
];
const _weekNums = [10, 11, 12, 13, 14, 15];
// Walter: 1-on-1 is binary — either full or available. No "almost full".
const _available = {4, 5, 6, 11, 12, 13, 18, 19, 20, 25, 26, 28, 29};
const _full = {27};

// Walter: 1-on-1 should also show all locations — customer picks one
const _allLocations = <String>[
  'De Bilt',
  'Bad Hulckesteijn',
  'Ampt van Nijkerk',
  'Garderen',
  'Wolfheze',
  'Dordrecht',
  'Soestduinen',
];

class ExtraLessonCalendarScreen extends StatefulWidget {
  const ExtraLessonCalendarScreen({super.key});
  @override
  State<ExtraLessonCalendarScreen> createState() => _ExtraLessonCalendarScreenState();
}

class _ExtraLessonCalendarScreenState extends State<ExtraLessonCalendarScreen> {
  int? _selectedDate;
  _Instructor? _selectedInstructor;
  String? _selectedSlot;
  String _selectedLocation = 'Ampt van Nijkerk';

  String _dayStatus(int day) {
    if (day < 25) return 'past';
    if (_full.contains(day)) return 'full';
    if (_available.contains(day)) return 'available';
    return 'none';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Transform.translate(
              offset: const Offset(0, -12),
              child: _buildInfoBanner(),
            ),
            const SizedBox(height: 16),
            _buildCalendar(),
            if (_selectedDate != null) _buildTimeSlots(),
            if (_selectedDate != null && _selectedSlot != null) _buildDetailsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 58, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.6, 1.0],
                colors: [Color(0xFF0365C4), Color(0xFF0D7FE8), Color(0xFF00C1FF)],
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => smartBack(context),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Extra 1-op-1 Les',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: _showLocationPicker,
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 12, color: Colors.white.withValues(alpha: 0.7)),
                            const SizedBox(width: 4),
                            Text(_selectedLocation,
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(width: 3),
                            Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.white.withValues(alpha: 0.7)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text('1-op-1',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: IgnorePointer(
              child: CustomPaint(
                size: const Size(double.infinity, 30),
                painter: _ExtraLessonWavePainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 24, offset: const Offset(0, 8))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.info_outline, color: Color(0xFF0365C4), size: 15),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text.rich(
                TextSpan(
                  style: TextStyle(color: Color(0xFF4A5568), fontSize: 12, height: 1.5),
                  children: [
                    TextSpan(
                      text: '14-dagenregel: ',
                      style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF0365C4)),
                    ),
                    TextSpan(text: 'Extra lessen zijn beschikbaar binnen 14 dagen. Boek op een dag en tijd naar keuze.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            // Month header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF0D7FE8)]),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 18),
                  ),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.white.withValues(alpha: 0.7)),
                      const SizedBox(width: 8),
                      const Text('maart 2026',
                          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.chevron_right, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),
            // Day headers (8 columns: Wk + 7)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
              child: Row(
                children: [
                  const SizedBox(width: 28, child: Center(
                    child: Text('Wk', style: TextStyle(color: Color(0xFFC4CDD9), fontSize: 9, fontWeight: FontWeight.w600)),
                  )),
                  ..._weekDays.map((d) => Expanded(
                    child: Center(
                      child: Text(d,
                          style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  )),
                ],
              ),
            ),
            // Grid
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: Column(
                children: List.generate(_weeks.length, (wi) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        SizedBox(width: 28, child: Center(
                          child: Text('${_weekNums[wi]}',
                              style: const TextStyle(color: Color(0xFFC4CDD9), fontSize: 9, fontWeight: FontWeight.w500)),
                        )),
                        ...List.generate(7, (di) {
                          final day = _weeks[wi][di];
                          if (day == null) return const Expanded(child: SizedBox(height: 40));
                          return Expanded(child: _buildDayCell(day));
                        }),
                      ],
                    ),
                  );
                }),
              ),
            ),
            // Legend
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFF0F4FA))),
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 6,
                children: [
                  _legend(const Color(0xFFE8F8F0), const Color(0xFF27AE60), 'Beschikbaar'),
                  _legend(const Color(0xFFFEE4E4), const Color(0xFFE74C3C), 'Vol'),
                  _legend(const Color(0xFFF4F7FC), const Color(0xFFC4CDD9), 'Verleden'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell(int day) {
    final status = _dayStatus(day);
    final isSelected = _selectedDate == day;
    // Walter: 1-on-1 is binary — either clickable or full
    final isClickable = status == 'available';

    Color bg;
    Color textColor;

    if (isSelected) {
      bg = const Color(0xFF0365C4);
      textColor = Colors.white;
    } else {
      switch (status) {
        case 'available':
          bg = const Color(0xFFE8F8F0);
          textColor = const Color(0xFF27AE60);
          break;
        case 'full':
          bg = const Color(0xFFFEE4E4);
          textColor = const Color(0xFFE74C3C);
          break;
        case 'past':
          bg = Colors.transparent;
          textColor = const Color(0xFFC4CDD9);
          break;
        default:
          bg = Colors.transparent;
          textColor = const Color(0xFF1A1A2E);
      }
    }

    return GestureDetector(
      onTap: isClickable ? () => setState(() {
        _selectedDate = day;
        _selectedSlot = null;
      }) : null,
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)])
              : null,
          color: isSelected ? null : bg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [BoxShadow(color: const Color(0xFF0365C4).withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4))]
              : null,
        ),
        alignment: Alignment.center,
        child: Text('$day',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: textColor,
            )),
      ),
    );
  }

  Widget _legend(Color bg, Color border, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14, height: 14,
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: border, width: 1.5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildTimeSlots() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Beschikbare tijden — $_selectedDate maart',
              style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          const Text('Selecteer een tijdslot',
              style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.95,
            children: _slots.map((s) => _buildSlotCell(s)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotCell(_TimeSlot s) {
    final isSelected = _selectedSlot == s.time;
    final isFew = s.spots == 1 && s.available;
    return GestureDetector(
      onTap: s.available
          ? () {
              setState(() {
                _selectedSlot = s.time;
                // Auto-select only when one instructor; else show picker
                if (s.instructors.length == 1) {
                  _selectedInstructor = s.instructors.first;
                } else {
                  _selectedInstructor = null;
                  // Delay showing picker so the tap animates first
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showInstructorPicker(s);
                  });
                }
              });
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)])
              : null,
          color: isSelected ? null : (s.available ? Colors.white : const Color(0xFFF4F7FC)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: (isFew && !isSelected) ? const Color(0xFFF39C12) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: const Color(0xFF0365C4).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 6))]
              : (s.available ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))] : null),
        ),
        child: Opacity(
          opacity: s.available ? 1.0 : 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time, size: 14,
                  color: isSelected ? Colors.white : (s.available ? const Color(0xFF0365C4) : const Color(0xFFC4CDD9))),
              const SizedBox(height: 4),
              Text(s.time,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : (s.available ? const Color(0xFF1A1A2E) : const Color(0xFFC4CDD9)),
                  )),
              if (s.available) ...[
                const SizedBox(height: 2),
                Text('${s.spots} ${s.spots == 1 ? "plek" : "plekken"}',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.7)
                          : (isFew ? const Color(0xFFF39C12) : const Color(0xFF8E9BB3)),
                    )),
              ],
              if (isSelected) ...[
                const SizedBox(height: 2),
                Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const Icon(Icons.check, color: Colors.white, size: 10),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    final slot = _slots.firstWhere((s) => s.time == _selectedSlot);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 24, offset: const Offset(0, 8))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lesdetails',
                style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _detailRow(Icons.access_time, const Color(0xFF0365C4), 'Tijd', '${slot.time} – ${slot.end}'),
            const SizedBox(height: 12),
            _detailRow(Icons.location_on_outlined, const Color(0xFFFF5C00), 'Locatie', _selectedLocation),
            const SizedBox(height: 12),
            _buildInstructorRow(slot),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF0F4FA), height: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Prijs per les', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 10)),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 24, fontWeight: FontWeight.w700),
                        children: [
                          TextSpan(text: '€38'),
                          TextSpan(text: ',00', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 14, fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => context.pushNamed(RouteNames.bookingSummary),
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)]),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: const Color(0xFFFF5C00).withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 8))],
                    ),
                    alignment: Alignment.center,
                    child: const Text('Boek nu →',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructorRow(_TimeSlot slot) {
    final hasMultiple = slot.instructors.length > 1;
    final ins = _selectedInstructor ?? (slot.instructors.isNotEmpty ? slot.instructors.first : null);

    if (ins == null) {
      return _detailRow(Icons.person_outline, const Color(0xFF27AE60), 'Instructeur', 'Selecteer');
    }

    return GestureDetector(
      onTap: hasMultiple ? () => _showInstructorPicker(slot) : null,
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: ins.gradient),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(ins.initial, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Instructeur', style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 10, fontWeight: FontWeight.w500)),
                Row(
                  children: [
                    Text(ins.name, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 6),
                    const Icon(Icons.star, color: Color(0xFFFFD700), size: 12),
                    const SizedBox(width: 2),
                    Text('${ins.rating}', style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          if (hasMultiple)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF0365C4).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Wissel', style: TextStyle(color: Color(0xFF0365C4), fontSize: 10, fontWeight: FontWeight.w700)),
                  SizedBox(width: 4),
                  Icon(Icons.swap_horiz, size: 12, color: Color(0xFF0365C4)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E5EC),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Kies een locatie',
                style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('Alle locaties beschikbaar voor 1-op-1',
                style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
            const SizedBox(height: 16),
            ..._allLocations.map((loc) {
              final isSelected = _selectedLocation == loc;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedLocation = loc;
                    _selectedDate = null;
                    _selectedSlot = null;
                    _selectedInstructor = null;
                  });
                  Navigator.pop(ctx);
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFEF0E7) : const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFFF5C00) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5C00).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.pool, color: Color(0xFFFF5C00), size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(loc,
                            style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: Color(0xFFFF5C00), size: 20),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showInstructorPicker(_TimeSlot slot) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E5EC),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Kies uw instructeur',
                style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('${slot.instructors.length} instructeurs beschikbaar om ${slot.time}',
                style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
            const SizedBox(height: 16),
            ...slot.instructors.map((i) {
              final isSelected = _selectedInstructor?.id == i.id;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedInstructor = i);
                  Navigator.pop(ctx);
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFE8F4FD) : const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF0365C4) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: i.gradient),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Text(i.initial, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(i.name, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 15, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Color(0xFFFFD700), size: 13),
                                const SizedBox(width: 3),
                                Text('${i.rating}',
                                    style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 12, fontWeight: FontWeight.w700)),
                                const SizedBox(width: 6),
                                const Text('Zweminstructeur',
                                    style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: Color(0xFF0365C4), size: 24),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, Color color, String label, String value) {
    return Row(
      children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 10, fontWeight: FontWeight.w500)),
            Text(value, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}

class _ExtraLessonWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.12);
    final path = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.75, size.height, size.width, size.height * 0.5)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
