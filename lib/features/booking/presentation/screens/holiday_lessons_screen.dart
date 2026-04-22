import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/utils/smart_back.dart';

class _Loc {
  final String name;
  final String type;
  final String desc;
  const _Loc(this.name, this.type, this.desc);
}

class _Holiday {
  final String name;
  final String period;
  final bool active;
  const _Holiday(this.name, this.period, this.active);
}

// Dutch school vacations 2026 per Walter's feedback
const _holidays = <_Holiday>[
  _Holiday('Voorjaarsvakantie', '28 apr - 9 mei 2026', true),
  _Holiday('Meivakantie', '1 - 8 mei 2026', true),
  _Holiday('Zomervakantie', '13 jul - 24 aug 2026', false),
  _Holiday('Herfstvakantie', '19 - 27 okt 2026', false),
  _Holiday('Kerstvakantie', '21 dec - 3 jan 2027', false),
];

const _locations = <_Loc>[
  _Loc('De Bilt', '1-op-1 Extra Vakantie', 'Inhaal of extra tijdens vakantie'),
  _Loc('Bad Hulckesteijn', '1-op-1 Extra Vakantie', 'Inhaal of extra tijdens vakantie'),
  _Loc('Garderen', '1-op-1 Extra Vakantie', 'Inhaal of extra tijdens zomervakantie'),
  _Loc('Garderen', '1-op-2 Extra Vakantie', 'Gedeelde les tijdens zomervakantie'),
];

class HolidayLessonsScreen extends StatefulWidget {
  const HolidayLessonsScreen({super.key});

  @override
  State<HolidayLessonsScreen> createState() => _HolidayLessonsScreenState();
}

class _HolidayLessonsScreenState extends State<HolidayLessonsScreen> {
  _Holiday _selectedHoliday = _holidays.firstWhere((h) => h.active);

  void _showHolidayPicker() {
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
            const SizedBox(height: 20),
            const Text('Kies een vakantie',
                style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ..._holidays.map((h) => GestureDetector(
              onTap: h.active
                  ? () {
                      setState(() => _selectedHoliday = h);
                      Navigator.pop(ctx);
                    }
                  : null,
              child: Opacity(
                opacity: h.active ? 1.0 : 0.4,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: _selectedHoliday.name == h.name ? const Color(0xFFFEF3DB) : const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedHoliday.name == h.name
                          ? const Color(0xFFF5A623)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text('🌤️', style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(h.name,
                                style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text(h.period,
                                style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                          ],
                        ),
                      ),
                      if (!h.active)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E5EC),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text('Binnenkort',
                              style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 9, fontWeight: FontWeight.w700)),
                        )
                      else if (_selectedHoliday.name == h.name)
                        const Icon(Icons.check_circle, color: Color(0xFFF5A623), size: 20),
                    ],
                  ),
                ),
              ),
            )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => smartBack(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F7FC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.chevron_left, size: 20, color: Color(0xFF1A1A2E)),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text('Vakantielessen',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  children: [
                    // Holiday dropdown selector
                    GestureDetector(
                      onTap: _showHolidayPicker,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3DB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF5A623).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Text('🌤️', style: TextStyle(fontSize: 22)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Gekozen vakantie',
                                      style: TextStyle(color: Color(0xFF9B6A0D), fontSize: 10, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text(_selectedHoliday.name,
                                      style: const TextStyle(color: Color(0xFFF5A623), fontSize: 14, fontWeight: FontWeight.w800)),
                                  Text(_selectedHoliday.period,
                                      style: const TextStyle(color: Color(0xFF4A4A6A), fontSize: 11)),
                                ],
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down, color: Color(0xFFF5A623), size: 22),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Annuleren tot 4 dagen van tevoren',
                      style: TextStyle(color: const Color(0xFF8E9BB3), fontSize: 11),
                    ),
                    const SizedBox(height: 16),
                    // Location cards
                    ..._locations.map((loc) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: 4,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5A623),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('🏊  ${loc.name}',
                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                                            const SizedBox(height: 2),
                                            Text(loc.type,
                                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFFF5A623))),
                                            const SizedBox(height: 2),
                                            Text(loc.desc,
                                                style: const TextStyle(fontSize: 11, color: Color(0xFF8E8EA0))),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => context.pushNamed(RouteNames.fixedSlotCalendar),
                                        child: const Text('Boek →',
                                            style: TextStyle(color: Color(0xFF1A6FBF), fontSize: 13, fontWeight: FontWeight.w700)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
