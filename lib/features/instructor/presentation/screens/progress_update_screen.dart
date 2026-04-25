import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/instructor_providers.dart';
import '../../../../shared/utils/smart_back.dart';
import '../../../schedule/presentation/providers/fixed_schedule_provider.dart';
import '../theme/instructor_theme.dart';

class ProgressUpdateScreen extends ConsumerStatefulWidget {
  final String studentInitial;
  const ProgressUpdateScreen({super.key, required this.studentInitial});

  @override
  ConsumerState<ProgressUpdateScreen> createState() => _ProgressUpdateScreenState();
}

class _ProgressUpdateScreenState extends ConsumerState<ProgressUpdateScreen> {
  int _selectedLevel = 1;
  bool _showLevelPicker = false;
  final TextEditingController _parentNotesCtrl = TextEditingController();
  final TextEditingController _colleagueNotesCtrl = TextEditingController();
  int? _mood;
  bool _saved = false;
  bool _saving = false;
  bool _notifyParent = false; // Walter: only notify on improvement

  @override
  void dispose() {
    _parentNotesCtrl.dispose();
    _colleagueNotesCtrl.dispose();
    super.dispose();
  }

  final List<Map<String, String>> _levels = [
    {'nl': 'Beginner'},
    {'nl': 'Gevorderd Beginner'},
    {'nl': 'Gevorderd'},
    {'nl': 'Diploma A'},
    {'nl': 'Diploma B'},
  ];

  final List<Map<String, dynamic>> _skills = [
    {'name': 'Vrije slag armen', 'checked': true},
    {'name': 'Ademhaling links/rechts', 'checked': true},
    {'name': 'Rugslag', 'checked': false},
    {'name': 'Drijven op rug', 'checked': false},
    {'name': 'Schoolslag benen', 'checked': false},
  ];

  final List<Map<String, dynamic>> _steps = [
    {'name': 'Beiderzijds ademen', 'done': true},
    {'name': '10m vrije slag zonder stop', 'done': false},
    {'name': '5m rugslag', 'done': false},
  ];

  final List<Map<String, String>> _moods = [
    {'emoji': '😊', 'label': 'Geweldig'},
    {'emoji': '🙂', 'label': 'Goed'},
    {'emoji': '😐', 'label': 'Oké'},
    {'emoji': '😟', 'label': 'Moeilijk'},
    {'emoji': '😢', 'label': 'Verdrietig'},
  ];

  Future<void> _handleSave() async {
    if (_saving) return;
    HapticFeedback.mediumImpact();
    setState(() => _saving = true);
    // Simulate brief backend save so the spinner is visible.
    await Future.delayed(const Duration(milliseconds: 600));
    final student = ref.read(studentsProvider.notifier).getByInitial(widget.studentInitial);
    if (student != null) {
      final skillsCompleted = _skills.where((s) => s['checked'] == true).length;
      final stepsCompleted = _steps.where((s) => s['done'] == true).length;
      final newProgress = ((skillsCompleted * 10) + (stepsCompleted * 5)).clamp(0, 100);
      final newLevel = _levels[_selectedLevel]['nl']!;
      ref.read(studentsProvider.notifier).updateStudent(
        student.id,
        progress: newProgress > student.progress ? newProgress : student.progress,
        lessonsTotal: student.lessonsTotal + 1,
        level: newLevel,
      );
    }
    if (!mounted) return;
    HapticFeedback.lightImpact();
    setState(() { _saving = false; _saved = true; });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final student = ref.read(studentsProvider.notifier).getByInitial(widget.studentInitial);
    final studentName = student?.name ?? 'Sami Khilji';
    final studentAge = student?.age ?? 7;
    if (_saved) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F1117),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [Color(0xFF27AE60), Color(0xFF2ECC71)]),
                  boxShadow: [BoxShadow(color: const Color(0xFF27AE60).withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 8))],
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              const Text('Voortgang opgeslagen!', style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                _notifyParent
                    ? 'Ouder is automatisch op de hoogte gebracht.'
                    : 'Opgeslagen als privé (geen ouder melding).',
                style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

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
                  onTap: () => smartBack(context),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.chevron_left, color: Color(0xFFE2E8F0), size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(child: Text('Voortgang Bijwerken', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700))),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student info card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)]),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: const Color(0xFFFF5C00).withValues(alpha: 0.25), blurRadius: 20, offset: const Offset(0, 6))],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(14)),
                          child: Center(child: Text(widget.studentInitial, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700))),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$studentName · $studentAge jr', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                            Text('Huidig: ${_levels[_selectedLevel]['nl']} · 28 apr', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Level update
                  const Text('Niveauupdate', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => setState(() => _showLevelPicker = !_showLevelPicker),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1D27),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_levels[_selectedLevel]['nl']!, style: const TextStyle(color: Color(0xFFFF5C00), fontSize: 14, fontWeight: FontWeight.w600)),
                          Icon(_showLevelPicker ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 16, color: const Color(0xFF8E9BB3)),
                        ],
                      ),
                    ),
                  ),
                  if (_showLevelPicker)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1D27),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 8))],
                      ),
                      child: Column(
                        children: List.generate(_levels.length, (i) {
                          final isSelected = i == _selectedLevel;
                          return GestureDetector(
                            onTap: () => setState(() { _selectedLevel = i; _showLevelPicker = false; }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                border: i > 0 ? Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.04))) : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_levels[i]['nl']!, style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400, color: isSelected ? const Color(0xFFFF5C00) : const Color(0xFFE2E8F0))),
                                  if (isSelected) const Icon(Icons.check, size: 16, color: Color(0xFFFF5C00)),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Skills
                  const Text('Gewerkte vaardigheden', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  ...List.generate(_skills.length, (i) {
                    final skill = _skills[i];
                    final checked = skill['checked'] as bool;
                    return GestureDetector(
                      onTap: () => setState(() => _skills[i]['checked'] = !checked),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: checked ? const Color(0xFF0365C4).withValues(alpha: 0.1) : const Color(0xFF1A1D27),
                          borderRadius: BorderRadius.circular(12),
                          border: checked ? Border.all(color: const Color(0xFF0365C4).withValues(alpha: 0.3)) : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24, height: 24,
                              decoration: BoxDecoration(
                                gradient: checked ? const LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)]) : null,
                                color: checked ? null : const Color(0xFF2D3748),
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: checked ? [BoxShadow(color: const Color(0xFF0365C4).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))] : null,
                              ),
                              child: checked ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                            ),
                            const SizedBox(width: 12),
                            Text(skill['name'], style: TextStyle(fontSize: 13, fontWeight: checked ? FontWeight.w600 : FontWeight.w400, color: checked ? const Color(0xFFE2E8F0) : const Color(0xFF8E9BB3))),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),

                  // Steps
                  const Text('Stappen afgerond', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  ...List.generate(_steps.length, (i) {
                    final step = _steps[i];
                    final done = step['done'] as bool;
                    return GestureDetector(
                      onTap: () => setState(() => _steps[i]['done'] = !done),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: done ? const Color(0xFF27AE60).withValues(alpha: 0.1) : const Color(0xFF1A1D27),
                          borderRadius: BorderRadius.circular(12),
                          border: done ? Border.all(color: const Color(0xFF27AE60).withValues(alpha: 0.3)) : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24, height: 24,
                              decoration: BoxDecoration(
                                gradient: done ? const LinearGradient(colors: [Color(0xFF27AE60), Color(0xFF2ECC71)]) : null,
                                color: done ? null : const Color(0xFF2D3748),
                                shape: BoxShape.circle,
                                boxShadow: done ? [BoxShadow(color: const Color(0xFF27AE60).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))] : null,
                              ),
                              child: done ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                            ),
                            const SizedBox(width: 12),
                            Text(step['name'], style: TextStyle(fontSize: 13, fontWeight: done ? FontWeight.w600 : FontWeight.w400, color: done ? const Color(0xFFE2E8F0) : const Color(0xFF8E9BB3))),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),

                  // Mood
                  const Text('Stemming leerling', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(color: const Color(0xFF1A1D27), borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(_moods.length, (i) {
                        return GestureDetector(
                          onTap: () => setState(() => _mood = i),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: _mood == null ? 0.7 : (_mood == i ? 1.0 : 0.3),
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 200),
                              scale: _mood == i ? 1.2 : 1.0,
                              child: Column(
                                children: [
                                  Text(_moods[i]['emoji']!, style: const TextStyle(fontSize: 28)),
                                  const SizedBox(height: 4),
                                  Text(_moods[i]['label']!, style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 9)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Parent-visible notes (Walter: what to share with parents)
                  Row(
                    children: const [
                      Icon(Icons.visibility, size: 12, color: Color(0xFF0365C4)),
                      SizedBox(width: 6),
                      Text('Voor ouder zichtbaar',
                          style: TextStyle(color: Color(0xFF0365C4), fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Deze notitie wordt gedeeld met de ouder',
                      style: TextStyle(color: Color(0xFF4A5568), fontSize: 10)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1D27),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF0365C4).withValues(alpha: 0.3)),
                    ),
                    child: TextField(
                      controller: _parentNotesCtrl,
                      maxLines: 3,
                      style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Bijv: Geweldige sessie vandaag! Sami is echt verbeterd in ademhaling 🏊',
                        hintStyle: TextStyle(color: Color(0xFF4A5568), fontSize: 13),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Colleague-only notes (Walter: private notes for colleagues)
                  Row(
                    children: const [
                      Icon(Icons.lock_outline, size: 12, color: Color(0xFFF5A623)),
                      SizedBox(width: 6),
                      Text('Privé — alleen collega\'s',
                          style: TextStyle(color: Color(0xFFF5A623), fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Intern gebruik, niet zichtbaar voor ouder',
                      style: TextStyle(color: Color(0xFF4A5568), fontSize: 10)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1D27),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF5A623).withValues(alpha: 0.3)),
                    ),
                    child: TextField(
                      controller: _colleagueNotesCtrl,
                      maxLines: 3,
                      style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Bijv: Kind is verlegen in water, extra aandacht nodig. Volgende week schoolslag starten.',
                        hintStyle: TextStyle(color: Color(0xFF4A5568), fontSize: 13),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Notify parent toggle (Walter: only on improvement)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1D27),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF27AE60).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.notifications_active_outlined, color: Color(0xFF27AE60), size: 18),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ouder notificeren',
                                  style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 13, fontWeight: FontWeight.w600)),
                              SizedBox(height: 2),
                              Text('Stuur melding alleen bij verbetering',
                                  style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                            ],
                          ),
                        ),
                        Switch(
                          value: _notifyParent,
                          onChanged: (v) => setState(() => _notifyParent = v),
                          activeTrackColor: const Color(0xFF27AE60),
                          activeColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Plan exam button — Walter 2026-04-23 exam continuation flow
                  if (_selectedLevel >= 3) ...[
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        final levelName = _levels[_selectedLevel]['nl']!;
                        final nextLevel = _selectedLevel < _levels.length - 1
                            ? _levels[_selectedLevel + 1]['nl']
                            : null;
                        ref.read(examContinuationProvider.notifier).send(
                          childId: widget.studentInitial,
                          childName: 'Sami Khilji',
                          currentLevel: levelName,
                          nextLevel: nextLevel,
                          examDate: DateTime.now().add(const Duration(days: 7)),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Examen gepland — ouder krijgt 24h vervolgvraag'),
                            backgroundColor: Color(0xFFF5A623),
                          ),
                        );
                      },
                      child: Container(
                        height: 48,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7E6),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFF5A623).withValues(alpha: 0.4)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.emoji_events, color: Color(0xFFF5A623), size: 18),
                            SizedBox(width: 8),
                            Text('Examen plannen — vervolgvraag aan ouder',
                                style: TextStyle(color: Color(0xFFF5A623), fontSize: 13, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // Save button
                  GestureDetector(
                    onTap: _saving ? null : _handleSave,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: _saving
                            ? [ITheme.green.withValues(alpha: 0.5), ITheme.greenAlt.withValues(alpha: 0.5)]
                            : const [ITheme.green, ITheme.greenAlt]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: ITheme.green.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 8))],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_saving)
                            const SizedBox(
                              width: 18, height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          else
                            Icon(_notifyParent ? Icons.send : Icons.save, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            _saving
                                ? 'Opslaan...'
                                : (_notifyParent ? 'Opslaan & Ouder Melden' : 'Opslaan (Privé)'),
                            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      _notifyParent ? 'Ouder krijgt automatisch melding' : 'Geen melding naar ouder',
                      style: const TextStyle(color: ITheme.textMid, fontSize: 11),
                    ),
                  ),
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
