import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/utils/smart_back.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});
  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  String _search = '';

  /// Each location lists its currently-available instructors.
  /// Walter 2026-04-22: when 2+ available, customer picks which one.
  static const _locations = <_LocationInfo>[
    _LocationInfo(name: 'De Bilt', city: 'Utrecht', slots: 12, status: 'available',
        instructors: ['Jan de Vries', 'Maria Jansen']),
    _LocationInfo(name: 'Bad Hulckesteijn', city: 'Nijkerk', slots: 8, status: 'available',
        instructors: ['Jan de Vries']),
    _LocationInfo(name: 'Garderen', city: 'Barneveld', slots: 5, status: 'few',
        instructors: ['Pieter Bakker']),
    _LocationInfo(name: 'Wolfheze', city: 'Renkum', slots: 0, status: 'full',
        instructors: ['Maria Jansen']),
    _LocationInfo(name: 'Dordrecht', city: 'Dordrecht', slots: 3, status: 'available',
        instructors: ['Pieter Bakker', 'Jan de Vries']),
    _LocationInfo(name: 'Soestduinen', city: 'Soest', slots: 6, status: 'available',
        instructors: ['Jan de Vries']),
  ];

  Color _statusColor(String s) => s == 'full' ? const Color(0xFFE74C3C) : s == 'few' ? const Color(0xFFF5A623) : const Color(0xFF18BB68);
  Color _statusBg(String s) => s == 'full' ? const Color(0xFFFCE8E8) : s == 'few' ? const Color(0xFFFEF3DB) : const Color(0xFFE0F9EC);
  String _statusText(String s, int slots) => s == 'full' ? 'Vol deze week' : '$slots beschikbaar';

  void _onLocationTap(_LocationInfo loc) {
    HapticFeedback.selectionClick();
    if (loc.status == 'full') return;
    if (loc.instructors.length >= 2) {
      _showInstructorPicker(loc);
    } else {
      context.pushNamed(RouteNames.extraLessonCalendar);
    }
  }

  void _showInstructorPicker(_LocationInfo loc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Kies uw instructeur',
                  style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('Bij ${loc.name} zijn meerdere instructeurs beschikbaar',
                  style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
              const SizedBox(height: 16),
              for (final inst in loc.instructors)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(ctx);
                      context.pushNamed(RouteNames.extraLessonCalendar);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F7FC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)]),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(inst.split(' ').map((s) => s.isEmpty ? '' : s[0]).take(2).join(),
                                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(inst,
                                    style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                                const Text('Beschikbaar deze week',
                                    style: TextStyle(color: Color(0xFF27AE60), fontSize: 11, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 20, color: Color(0xFF8E9BB3)),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _locations.where((l) =>
      l.name.toLowerCase().contains(_search.toLowerCase()) ||
      l.city.toLowerCase().contains(_search.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SafeArea(
        child: Column(children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              GestureDetector(
                onTap: () => smartBack(context),
                child: Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFF4F7FC), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.chevron_left, size: 20, color: Color(0xFF1A1A2E))),
              ),
              const Expanded(child: Center(child: Text('Kies locatie', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))))),
              const SizedBox(width: 40),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: const Align(alignment: Alignment.centerLeft,
              child: Text('Extra 1-op-1 les', style: TextStyle(fontSize: 13, color: Color(0xFF818EA6)))),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Container(
              height: 44,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB))),
              child: Row(children: [
                const SizedBox(width: 16),
                const Icon(Icons.search, size: 16, color: Color(0xFF818EA6)),
                const SizedBox(width: 8),
                Expanded(child: TextField(
                  onChanged: (v) => setState(() => _search = v),
                  decoration: const InputDecoration(hintText: 'Locatie zoeken...', border: InputBorder.none,
                    hintStyle: TextStyle(color: Color(0xFF818EA6), fontSize: 14)),
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
                )),
              ]),
            ),
          ),

          // Locations
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final loc = filtered[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => _onLocationTap(loc),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB))),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        children: [
                          Row(children: [
                            const Text('🏊', style: TextStyle(fontSize: 22)),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(loc.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                              Text(loc.city, style: const TextStyle(fontSize: 12, color: Color(0xFF818EA6))),
                            ])),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: _statusBg(loc.status), borderRadius: BorderRadius.circular(20)),
                              child: Text(_statusText(loc.status, loc.slots),
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _statusColor(loc.status))),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.chevron_right, size: 18, color: Color(0xFF818EA6)),
                          ]),
                          if (loc.instructors.length >= 2 && loc.status != 'full') ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF7FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.people_outline, size: 12, color: Color(0xFF0365C4)),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      '${loc.instructors.length} instructeurs beschikbaar — kies uw favoriet',
                                      style: const TextStyle(color: Color(0xFF0365C4), fontSize: 11, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class _LocationInfo {
  final String name, city, status;
  final int slots;
  final List<String> instructors;
  const _LocationInfo({
    required this.name, required this.city, required this.slots,
    required this.status, required this.instructors,
  });
}
