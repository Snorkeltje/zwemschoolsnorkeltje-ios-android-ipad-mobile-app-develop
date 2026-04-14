import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InstructorStudentsScreen extends StatefulWidget {
  const InstructorStudentsScreen({super.key});

  @override
  State<InstructorStudentsScreen> createState() => _InstructorStudentsScreenState();
}

class _InstructorStudentsScreenState extends State<InstructorStudentsScreen> {
  String _search = '';
  String _filter = 'all';

  final List<Map<String, dynamic>> _students = [
    {'id': 1, 'name': 'Sami Khilji', 'initial': 'S', 'age': 7, 'level': 'Gevorderd Beginner', 'progress': 72, 'gradient': const [Color(0xFF0365C4), Color(0xFF00C1FF)], 'location': 'De Bilt', 'nextLesson': 'Ma 28 apr · 15:00', 'lessonsTotal': 24, 'trendUp': true},
    {'id': 2, 'name': 'Noor Khilji', 'initial': 'N', 'age': 5, 'level': 'Beginner', 'progress': 35, 'gradient': const [Color(0xFFFF5C00), Color(0xFFF5A623)], 'location': 'De Bilt', 'nextLesson': 'Ma 28 apr · 15:30', 'lessonsTotal': 12, 'trendUp': true},
    {'id': 3, 'name': 'Lisa Bos', 'initial': 'L', 'age': 8, 'level': 'Gevorderd', 'progress': 88, 'gradient': const [Color(0xFF27AE60), Color(0xFF2ECC71)], 'location': 'Bad Hulckesteijn', 'nextLesson': 'Wo 30 apr · 14:00', 'lessonsTotal': 42, 'trendUp': true},
    {'id': 4, 'name': 'Tim van Dijk', 'initial': 'T', 'age': 6, 'level': 'Beginner', 'progress': 20, 'gradient': const [Color(0xFF9B59B6), Color(0xFF8E44AD)], 'location': 'Ampt v. Nijkerk', 'nextLesson': 'Do 1 mei · 10:00', 'lessonsTotal': 8, 'trendUp': false},
    {'id': 5, 'name': 'Emma Jansen', 'initial': 'E', 'age': 9, 'level': 'Diploma A', 'progress': 95, 'gradient': const [Color(0xFFE74C3C), Color(0xFFC0392B)], 'location': 'De Bilt', 'nextLesson': 'Vr 2 mei · 16:00', 'lessonsTotal': 56, 'trendUp': true},
    {'id': 6, 'name': 'Daan Bakker', 'initial': 'D', 'age': 7, 'level': 'Beginner', 'progress': 45, 'gradient': const [Color(0xFFF39C12), Color(0xFFE67E22)], 'location': 'Garderen', 'nextLesson': 'Ma 28 apr · 16:00', 'lessonsTotal': 18, 'trendUp': true},
    {'id': 7, 'name': 'Sophie de Wit', 'initial': 'So', 'age': 6, 'level': 'Beginner', 'progress': 30, 'gradient': const [Color(0xFF1ABC9C), Color(0xFF16A085)], 'location': 'Bad Hulckesteijn', 'nextLesson': 'Wo 30 apr · 15:00', 'lessonsTotal': 10, 'trendUp': false},
    {'id': 8, 'name': 'Finn Mulder', 'initial': 'F', 'age': 10, 'level': 'Gevorderd Beginner', 'progress': 60, 'gradient': const [Color(0xFF3498DB), Color(0xFF2980B9)], 'location': 'Ampt v. Nijkerk', 'nextLesson': 'Do 1 mei · 11:00', 'lessonsTotal': 28, 'trendUp': true},
  ];

  final Map<String, String> _filterLabels = {
    'all': 'Alle',
    'beginner': 'Beginner',
    'advanced': 'Gevorderd',
    'diploma': 'Diploma',
  };

  List<Map<String, dynamic>> get _filtered {
    return _students.where((s) {
      final matchesSearch = _search.isEmpty ||
          (s['name'] as String).toLowerCase().contains(_search.toLowerCase());
      final level = s['level'] as String;
      final matchesFilter = _filter == 'all' ||
          (_filter == 'beginner' && level.contains('Beginner')) ||
          (_filter == 'advanced' && (level.contains('Gevorderd'))) ||
          (_filter == 'diploma' && level.contains('Diploma'));
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A1D27), Color(0xFF252836)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mijn Leerlingen', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                Text('${_students.length} actieve leerlingen', style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 13)),
                const SizedBox(height: 16),
                // Stats row
                Row(
                  children: [
                    _StatPill(value: '${_students.length}', label: 'Leerlingen', color: const Color(0xFFFF5C00)),
                    const SizedBox(width: 12),
                    const _StatPill(value: '3', label: 'Locaties', color: Color(0xFF00C1FF)),
                    const SizedBox(width: 12),
                    const _StatPill(value: '85%', label: 'Gem. voortgang', color: Color(0xFF27AE60)),
                  ],
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Transform.translate(
              offset: const Offset(0, -12),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1D27),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(Icons.search, color: Color(0xFF8E9BB3), size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _search = v),
                        style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Zoek leerlingen of ouders...',
                          hintStyle: TextStyle(color: Color(0xFF4A5568), fontSize: 14),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Filter pills
          SizedBox(
            height: 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: _filterLabels.entries.map((entry) {
                final isActive = _filter == entry.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = entry.key),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: isActive ? const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)]) : null,
                        color: isActive ? null : Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isActive ? [BoxShadow(color: const Color(0xFFFF5C00).withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4))] : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                          color: isActive ? Colors.white : const Color(0xFF8E9BB3),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Student cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final student = _filtered[index];
                final gradientColors = student['gradient'] as List<Color>;
                return GestureDetector(
                  onTap: () => context.push('/instructor/progress-update/${student['initial']}'),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1D27),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0, top: 12, bottom: 12,
                          child: Container(
                            width: 3,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: gradientColors),
                              borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16).copyWith(left: 20),
                          child: Row(
                            children: [
                              // Avatar
                              Container(
                                width: 48, height: 48,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: gradientColors),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))],
                                ),
                                child: Center(child: Text(student['initial'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
                              ),
                              const SizedBox(width: 12),
                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(child: Text(student['name'], style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 14, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
                                        if (student['trendUp'] == true) ...[
                                          const SizedBox(width: 4),
                                          const Icon(Icons.trending_up, size: 12, color: Color(0xFF27AE60)),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text('${student['level']} · ${student['age']} jr', style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined, size: 10, color: Color(0xFF4A5568)),
                                        const SizedBox(width: 4),
                                        Text(student['location'], style: const TextStyle(color: Color(0xFF4A5568), fontSize: 10)),
                                        const SizedBox(width: 12),
                                        const Icon(Icons.calendar_today_outlined, size: 10, color: Color(0xFF4A5568)),
                                        const SizedBox(width: 4),
                                        Flexible(child: Text(student['nextLesson'], style: const TextStyle(color: Color(0xFF4A5568), fontSize: 10), overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Progress
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('${student['progress']}%', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFFFF5C00))),
                                  const SizedBox(height: 4),
                                  SizedBox(
                                    width: 40, height: 4,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(2),
                                      child: LinearProgressIndicator(
                                        value: (student['progress'] as int) / 100,
                                        backgroundColor: const Color(0xFF2D3748),
                                        valueColor: const AlwaysStoppedAnimation(Color(0xFFFF5C00)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('${student['lessonsTotal']} lessen', style: const TextStyle(color: Color(0xFF4A5568), fontSize: 9)),
                                ],
                              ),
                              const SizedBox(width: 4),
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
    );
  }
}

class _StatPill extends StatelessWidget {
  final String value, label;
  final Color color;
  const _StatPill({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
            Text(label, style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 9, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
