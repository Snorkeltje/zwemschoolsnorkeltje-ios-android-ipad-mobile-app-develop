import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProgressUpdateScreen extends StatefulWidget {
  final String studentInitial;
  const ProgressUpdateScreen({super.key, required this.studentInitial});

  @override
  State<ProgressUpdateScreen> createState() => _ProgressUpdateScreenState();
}

class _ProgressUpdateScreenState extends State<ProgressUpdateScreen> {
  int _selectedLevel = 1;
  bool _showLevelPicker = false;
  String _notes = '';
  int? _mood;
  bool _saved = false;

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

  void _handleSave() {
    setState(() => _saved = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
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
              const Text('Ouder is automatisch op de hoogte gebracht.', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 14), textAlign: TextAlign.center),
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
                  onTap: () => context.pop(),
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
                            const Text('Sami Khilji · 7 jr', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
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

                  // Notes
                  const Text('Notities (optioneel)', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1D27),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: TextField(
                      onChanged: (v) => _notes = v,
                      maxLines: 3,
                      style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Geweldige sessie vandaag, Sami is echt verbeterd in...',
                        hintStyle: TextStyle(color: Color(0xFF4A5568), fontSize: 13),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save button
                  GestureDetector(
                    onTap: _handleSave,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF27AE60), Color(0xFF2ECC71)]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: const Color(0xFF27AE60).withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 8))],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text('Opslaan & Ouder Melden', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(child: Text('Ouder krijgt automatisch melding', style: TextStyle(color: Color(0xFF4A5568), fontSize: 11))),
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
