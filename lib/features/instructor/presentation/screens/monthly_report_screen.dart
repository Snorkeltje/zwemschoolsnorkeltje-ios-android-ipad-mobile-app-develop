import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MonthlyReportScreen extends StatelessWidget {
  const MonthlyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF1A1D27), Color(0xFF252836)]),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.chevron_left, color: Color(0xFFE2E8F0), size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Maandrapport', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                      Text('April 2026', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.download_outlined, size: 14, color: Color(0xFFE2E8F0)),
                      SizedBox(width: 4),
                      Text('PDF', style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview stats
                  Row(
                    children: [
                      _ReportStat(label: 'Lessen gegeven', value: '96', icon: Icons.calendar_today, color: const Color(0xFFFF5C00)),
                      const SizedBox(width: 12),
                      _ReportStat(label: 'Unieke leerlingen', value: '38', icon: Icons.people, color: const Color(0xFF0365C4)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _ReportStat(label: 'Lesuren totaal', value: '48u', icon: Icons.access_time, color: const Color(0xFF27AE60)),
                      const SizedBox(width: 12),
                      _ReportStat(label: 'Locaties', value: '5', icon: Icons.location_on, color: const Color(0xFF9B59B6)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Lesson type breakdown
                  const Text('Lestype verdeling', style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  _BreakdownItem(label: '1-op-1', count: 48, total: 96, color: const Color(0xFF0365C4)),
                  const SizedBox(height: 8),
                  _BreakdownItem(label: '1-op-2', count: 32, total: 96, color: const Color(0xFFFF5C00)),
                  const SizedBox(height: 8),
                  _BreakdownItem(label: '1-op-3', count: 16, total: 96, color: const Color(0xFF27AE60)),
                  const SizedBox(height: 24),

                  // Location breakdown
                  const Text('Locatie verdeling', style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  ...[
                    {'name': 'De Bilt', 'lessons': 36},
                    {'name': 'Bad Hulckesteijn', 'lessons': 24},
                    {'name': 'Garderen', 'lessons': 16},
                    {'name': 'Ampt v. Nijkerk', 'lessons': 12},
                    {'name': 'Wolfheze', 'lessons': 8},
                  ].map((loc) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1D27),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF8E9BB3)),
                          const SizedBox(width: 10),
                          Expanded(child: Text(loc['name'] as String, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 13, fontWeight: FontWeight.w600))),
                          Text('${loc['lessons']} lessen', style: const TextStyle(color: Color(0xFFFF5C00), fontSize: 13, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(height: 24),

                  // Student progress
                  const Text('Leerling voortgang', style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  ...[
                    {'emoji': '🎉', 'text': '3 leerlingen naar volgend niveau'},
                    {'emoji': '⭐', 'text': 'Emma Jansen bijna klaar voor Diploma A'},
                    {'emoji': '📈', 'text': 'Gemiddelde voortgang: +12% deze maand'},
                    {'emoji': '🏊', 'text': 'Sami Khilji: eerste 10m vrije slag'},
                  ].map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1D27),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(item['emoji']!, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(item['text']!, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 13))),
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _ReportStat({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D27),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _BreakdownItem extends StatelessWidget {
  final String label;
  final int count, total;
  final Color color;
  const _BreakdownItem({required this.label, required this.count, required this.total, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D27),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 10, height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 13, fontWeight: FontWeight.w600))),
          Text('$count', style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(width: 12),
          SizedBox(
            width: 80, height: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: count / total,
                backgroundColor: const Color(0xFF2D3748),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
