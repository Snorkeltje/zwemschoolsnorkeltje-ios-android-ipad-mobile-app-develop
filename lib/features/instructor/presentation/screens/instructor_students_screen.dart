import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../data/models/instructor_models.dart';
import '../providers/instructor_providers.dart';
import '../theme/instructor_theme.dart';

class InstructorStudentsScreen extends ConsumerStatefulWidget {
  const InstructorStudentsScreen({super.key});

  @override
  ConsumerState<InstructorStudentsScreen> createState() => _InstructorStudentsScreenState();
}

class _InstructorStudentsScreenState extends ConsumerState<InstructorStudentsScreen> {
  String _search = '';
  String _filter = 'all';

  final Map<String, String> _filterLabels = {
    'all': 'Alle',
    'beginner': 'Beginner',
    'advanced': 'Gevorderd',
    'diploma': 'Diploma',
  };

  List<Student> _applyFilters(List<Student> students) {
    return students.where((s) {
      final matchesSearch = _search.isEmpty ||
          s.name.toLowerCase().contains(_search.toLowerCase()) ||
          s.parentName.toLowerCase().contains(_search.toLowerCase());
      final matchesFilter = _filter == 'all' ||
          (_filter == 'beginner' && s.level.contains('Beginner')) ||
          (_filter == 'advanced' && s.level.contains('Gevorderd')) ||
          (_filter == 'diploma' && s.level.contains('Diploma'));
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final students = ref.watch(studentsProvider);
    final filtered = _applyFilters(students);
    final stats = ref.watch(instructorStatsProvider);

    final hPad = ITheme.hPad(context);
    return Scaffold(
      backgroundColor: ITheme.bg,
      body: Column(
        children: [
          // Header
          ClipRect(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(hPad, 60, hPad, 24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [ITheme.headerGradStart, ITheme.headerGradEnd],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mijn Leerlingen', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                      Text('${students.length} actieve leerlingen', style: const TextStyle(color: ITheme.textMid, fontSize: 13)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _StatPill(value: '${stats.totalStudents}', label: 'Leerlingen', color: ITheme.primary),
                          const SizedBox(width: 12),
                          _StatPill(value: '${stats.todayLocations}', label: 'Locaties', color: ITheme.blueAlt),
                          const SizedBox(width: 12),
                          _StatPill(value: '${stats.avgProgress}%', label: 'Gem. voortgang', color: ITheme.green),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -67, right: -60,
                  child: IgnorePointer(
                    child: Container(
                      width: 200, height: 200,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Color(0x14FF5C00), Colors.transparent],
                          stops: [0.0, 0.7],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search
          Padding(
            padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 0),
            child: Transform.translate(
              offset: const Offset(0, -12),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: ITheme.bgElev,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ITheme.borderSoft),
                  boxShadow: ITheme.cardShadow,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(Icons.search, color: ITheme.textMid, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _search = v),
                        style: const TextStyle(color: ITheme.textHi, fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Zoek leerlingen of ouders...',
                          hintStyle: TextStyle(color: ITheme.textLo, fontSize: 14),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
          ),

          // Filter pills
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: _filterLabels.entries.map((entry) {
                final isSelected = _filter == entry.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _filter = entry.key);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: isSelected ? ITheme.primaryGradient : null,
                        color: isSelected ? null : Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: isSelected ? [BoxShadow(color: ITheme.primary.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4))] : null,
                      ),
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : ITheme.textMid,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Student list
          Expanded(
            child: RefreshIndicator(
              color: ITheme.primary,
              backgroundColor: ITheme.bgElev,
              onRefresh: () async {
                HapticFeedback.selectionClick();
                await Future.delayed(const Duration(milliseconds: 400));
              },
              child: filtered.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 80),
                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.search_off, size: 48, color: Colors.white.withValues(alpha: 0.2)),
                            const SizedBox(height: 12),
                            const Text('Geen leerlingen gevonden',
                                style: TextStyle(color: ITheme.textMid, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 24),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final s = filtered[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            context.pushNamed(RouteNames.progressUpdate, pathParameters: {'studentInitial': s.initial});
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: ITheme.bgElev,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: ITheme.cardShadow,
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0, top: 12, bottom: 12,
                                  child: Container(
                                    width: 3,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: s.gradient),
                                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48, height: 48,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: s.gradient),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Center(
                                          child: Text(s.initial, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(s.name, style: const TextStyle(color: ITheme.textHi, fontSize: 14, fontWeight: FontWeight.w700)),
                                                if (s.trendUp) ...[
                                                  const SizedBox(width: 6),
                                                  const Icon(Icons.trending_up, size: 12, color: Color(0xFF27AE60)),
                                                ],
                                              ],
                                            ),
                                            Text('${s.level} · ${s.age} jr', style: const TextStyle(color: ITheme.textMid, fontSize: 11)),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(Icons.location_on_outlined, size: 10, color: ITheme.textMid),
                                                const SizedBox(width: 3),
                                                Text(s.location, style: const TextStyle(color: ITheme.textMid, fontSize: 10)),
                                                const SizedBox(width: 8),
                                                const Icon(Icons.calendar_today, size: 10, color: ITheme.textMid),
                                                const SizedBox(width: 3),
                                                Flexible(
                                                  child: Text(s.nextLesson,
                                                      style: const TextStyle(color: ITheme.textMid, fontSize: 10),
                                                      overflow: TextOverflow.ellipsis),
                                                ),
                                              ],
                                            ),
                                            // Medical alert badge (Walter: always visible)
                                            if (s.medicalNotes != 'Geen bijzonderheden' && s.medicalNotes.isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              GestureDetector(
                                                onTap: () => _showMedicalInfo(context, s),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFE74C3C).withValues(alpha: 0.15),
                                                    borderRadius: BorderRadius.circular(999),
                                                  ),
                                                  child: const Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.medical_services_outlined, size: 10, color: Color(0xFFE74C3C)),
                                                      SizedBox(width: 4),
                                                      Text('Medisch',
                                                          style: TextStyle(color: Color(0xFFE74C3C), fontSize: 9, fontWeight: FontWeight.w700)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text('${s.progress}%', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFFFF5C00))),
                                          const SizedBox(height: 4),
                                          Container(
                                            width: 40, height: 4,
                                            decoration: BoxDecoration(color: const Color(0xFF2D3748), borderRadius: BorderRadius.circular(2)),
                                            child: FractionallySizedBox(
                                              alignment: Alignment.centerLeft,
                                              widthFactor: s.progress / 100,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)]),
                                                  borderRadius: BorderRadius.circular(2),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text('${s.lessonsTotal} lessen', style: const TextStyle(color: ITheme.textMid, fontSize: 9)),
                                        ],
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.chevron_right, size: 16, color: ITheme.textMid),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showMedicalInfo(BuildContext context, Student s) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE74C3C).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.medical_services_outlined, color: Color(0xFFE74C3C), size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.name,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                  Text('Medische gegevens · ${s.age} jaar',
                      style: const TextStyle(color: ITheme.textMid, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _infoTile('Medische bijzonderheden', s.medicalNotes, Icons.healing, const Color(0xFFE74C3C)),
          if (s.allergies.isNotEmpty) ...[
            const SizedBox(height: 12),
            _infoTile('Allergieën', s.allergies.join(', '), Icons.warning_amber, const Color(0xFFF5A623)),
          ],
          if (s.emergencyContact.isNotEmpty) ...[
            const SizedBox(height: 12),
            _infoTile('Noodcontact', s.emergencyContact, Icons.phone_in_talk, const Color(0xFF27AE60)),
          ],
          const SizedBox(height: 12),
          _infoTile('Ouder', '${s.parentName}\n${s.parentPhone}', Icons.person, const Color(0xFF0365C4)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE74C3C).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFFE74C3C), size: 14),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Deze gegevens zijn vertrouwelijk en alleen voor instructeurs.',
                      style: TextStyle(color: Color(0xFFE74C3C), fontSize: 11)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

Widget _infoTile(String label, String value, IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: ITheme.textMid, fontSize: 11, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(color: ITheme.textHi, fontSize: 13, fontWeight: FontWeight.w500, height: 1.4)),
            ],
          ),
        ),
      ],
    ),
  );
}

class _StatPill extends StatelessWidget {
  final String value;
  final String label;
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
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 9, color: ITheme.textMid, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
