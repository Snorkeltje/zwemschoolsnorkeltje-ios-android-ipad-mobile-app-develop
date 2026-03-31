import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});
  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  String _search = '';

  static const _locations = [
    (name: 'De Bilt', city: 'Utrecht', slots: 12, status: 'available'),
    (name: 'Bad Hulckesteijn', city: 'Nijkerk', slots: 8, status: 'available'),
    (name: 'Garderen', city: 'Barneveld', slots: 5, status: 'few'),
    (name: 'Wolfheze', city: 'Renkum', slots: 0, status: 'full'),
    (name: 'Dordrecht', city: 'Dordrecht', slots: 3, status: 'available'),
    (name: 'Soestduinen', city: 'Soest', slots: 6, status: 'available'),
  ];

  Color _statusColor(String s) => s == 'full' ? const Color(0xFFE74C3C) : s == 'few' ? const Color(0xFFF5A623) : const Color(0xFF18BB68);
  Color _statusBg(String s) => s == 'full' ? const Color(0xFFFCE8E8) : s == 'few' ? const Color(0xFFFEF3DB) : const Color(0xFFE0F9EC);
  String _statusText(String s, int slots) => s == 'full' ? 'Vol deze week' : '$slots beschikbaar';

  @override
  Widget build(BuildContext context) {
    final filtered = _locations.where((l) =>
      l.name.toLowerCase().contains(_search.toLowerCase()) ||
      l.city.toLowerCase().contains(_search.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SafeArea(
        child: Column(children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFF4F7FC), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.chevron_left, size: 20, color: Color(0xFF1A1A2E))),
              ),
              const Expanded(child: Center(child: Text('Kies locatie', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))))),
              const SizedBox(width: 40),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Align(alignment: Alignment.centerLeft,
              child: const Text('Extra 1-op-1 les', style: TextStyle(fontSize: 13, color: Color(0xFF818EA6)))),
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
                const Text('🔍', style: TextStyle(fontSize: 14)),
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
                    onTap: loc.status != 'full' ? () => context.pushNamed(RouteNames.extraLessonCalendar) : null,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB))),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(children: [
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
                        const Text('→', style: TextStyle(fontSize: 18, color: Color(0xFF818EA6))),
                      ]),
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
