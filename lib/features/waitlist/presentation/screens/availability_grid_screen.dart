/// Walter 2026-08-16 — Customer-facing availability grid.
///
/// Replicates the "Set your availability" page from wachtlijst.zwemschoolsnorkeltje.nl.
/// Parent drags across time cells (7 days × 30-min slots, 09:30–18:30) to
/// select when they're available for lessons; drag over a selected block to
/// deselect. Water-freedom rating (1–5) and lesson preference dropdown at the
/// top. Save button at the bottom persists to waitlist.availability_grid.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/waitlist_models.dart';
import '../../data/repositories/waitlist_repository.dart';

/// Public route wrapper — pass the waitlist entry to edit.
class AvailabilityGridScreen extends ConsumerStatefulWidget {
  final WaitlistEntry entry;
  const AvailabilityGridScreen({super.key, required this.entry});

  @override
  ConsumerState<AvailabilityGridScreen> createState() =>
      _AvailabilityGridScreenState();
}

class _AvailabilityGridScreenState
    extends ConsumerState<AvailabilityGridScreen> {
  // Grid config — matches Walter's original i-Reserve system.
  static const _days = <String>[
    'sunday', 'monday', 'tuesday', 'wednesday',
    'thursday', 'friday', 'saturday',
  ];
  static const _dayLabelsNL = <String>[
    'Zondag', 'Maandag', 'Dinsdag', 'Woensdag',
    'Donderdag', 'Vrijdag', 'Zaterdag',
  ];
  static const _slotStart = 9.5; // 09:30
  static const _slotHalfHours = 18; // 9 hours × 2 → 18:30

  // State
  late int _waterFree;
  late WaitlistLessonType _lesson;
  // Selected cells: Set of "day_index_slot_index" strings.
  final Set<String> _selected = <String>{};
  bool _saving = false;

  // Drag state
  bool _dragging = false;
  bool _dragMode = true; // true = adding, false = removing
  String? _dragAnchor;

  @override
  void initState() {
    super.initState();
    _waterFree = widget.entry.waterFreeRating ?? 3;
    _lesson = widget.entry.lessonType;
    _loadFromEntry();
  }

  void _loadFromEntry() {
    for (var d = 0; d < _days.length; d++) {
      final blocks = widget.entry.availability.blocks[_days[d]] ?? const [];
      for (final block in blocks) {
        if (block.length != 2) continue;
        final start = _timeToSlotIndex(block[0]);
        final end = _timeToSlotIndex(block[1]);
        for (var s = start; s < end; s++) {
          if (s >= 0 && s < _slotHalfHours) _selected.add('${d}_$s');
        }
      }
    }
  }

  int _timeToSlotIndex(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return -1;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    final total = h + m / 60.0;
    return ((total - _slotStart) * 2).round();
  }

  String _slotIndexToTime(int idx) {
    final total = _slotStart + idx * 0.5;
    final h = total.floor();
    final m = ((total - h) * 60).round();
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  /// Serialise selected cells back into contiguous [start,end] blocks per day.
  AvailabilityGrid _serialiseGrid() {
    final result = <String, List<List<String>>>{};
    for (var d = 0; d < _days.length; d++) {
      final slotIndices = <int>[];
      for (var s = 0; s < _slotHalfHours; s++) {
        if (_selected.contains('${d}_$s')) slotIndices.add(s);
      }
      if (slotIndices.isEmpty) continue;
      slotIndices.sort();
      // Merge contiguous runs.
      final blocks = <List<String>>[];
      var runStart = slotIndices.first;
      var prev = slotIndices.first;
      for (var i = 1; i < slotIndices.length; i++) {
        final cur = slotIndices[i];
        if (cur == prev + 1) {
          prev = cur;
          continue;
        }
        blocks.add([_slotIndexToTime(runStart), _slotIndexToTime(prev + 1)]);
        runStart = cur;
        prev = cur;
      }
      blocks.add([_slotIndexToTime(runStart), _slotIndexToTime(prev + 1)]);
      result[_days[d]] = blocks;
    }
    return AvailabilityGrid(blocks: result);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final grid = _serialiseGrid();
    final ok = await WaitlistRepository().updateMyAvailability(
      waitlistId: widget.entry.id,
      grid: grid,
      waterFreeRating: _waterFree,
      lessonType: _lesson,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✓ Beschikbaarheid opgeslagen')),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Opslaan mislukt — probeer opnieuw'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Stel uw beschikbaarheid in'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1A1A2E),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildWaterFreedom(),
              const SizedBox(height: 20),
              _buildLessonPreference(),
              const SizedBox(height: 24),
              _buildInstructions(),
              const SizedBox(height: 16),
              _buildGridWidget(),
              const SizedBox(height: 24),
              _buildSaveButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.pool, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Beschikbaarheid instellen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.entry.listType.label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterFreedom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Waterfree niveau',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(width: 6),
            InkWell(
              onTap: _showWaterFreeInfo,
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(2),
                child: Icon(Icons.info_outline, size: 16, color: Color(0xFF0365C4)),
              ),
            ),
          ],
        ),
        const Text(
          '1 = helemaal niet waterfree, 5 = volledig waterfree',
          style: TextStyle(fontSize: 12, color: Color(0xFF6B7B94)),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: List.generate(5, (i) {
            final rating = i + 1;
            final selected = rating == _waterFree;
            return InkWell(
              onTap: () => setState(() => _waterFree = rating),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF00C1FF) : const Color(0xFFF8FAFC),
                  border: Border.all(
                    color: selected ? const Color(0xFF00C1FF) : const Color(0xFFE8ECF4),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '💧' * rating,
                  style: TextStyle(
                    fontSize: 14,
                    color: selected ? Colors.white : const Color(0xFF1A1A2E),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  void _showWaterFreeInfo() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Wat betekent waterfree?'),
        content: const Text(
          'Waterfree geeft aan hoe comfortabel uw kind zich al voelt in het '
          'water:\n\n'
          '1 💧 — huilt bij eerste contact met water\n'
          '2 💧💧 — durft alleen aan de rand\n'
          '3 💧💧💧 — durft in het ondiepe te staan\n'
          '4 💧💧💧💧 — durft kort onder water\n'
          '5 💧💧💧💧💧 — springt en zwemt al kort\n\n'
          'Instructeurs gebruiken dit om lessen af te stemmen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Sluiten'),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonPreference() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lesvoorkeur',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            border: Border.all(color: const Color(0xFFE8ECF4)),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<WaitlistLessonType>(
            value: _lesson,
            underline: const SizedBox(),
            isExpanded: true,
            items: WaitlistLessonType.values
                .map((t) => DropdownMenuItem(
                      value: t,
                      child: Text(t.label, style: const TextStyle(fontSize: 14)),
                    ))
                .toList(),
            onChanged: (t) {
              if (t != null) setState(() => _lesson = t);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        border: Border.all(color: const Color(0xFFBFDBFE)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.touch_app, size: 16, color: Color(0xFF1E40AF)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Sleep met uw vinger over tijdblokken om aan te geven wanneer u '
              'beschikbaar bent. Sleep opnieuw over een geselecteerd blok om '
              'het te verwijderen. Onze instructeurs plannen lessen binnen '
              'deze tijden.',
              style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridWidget() {
    // The whole grid is one big gesture listener — track (day, slot) under
    // the finger and toggle. This is the "drag to paint" pattern from the
    // web version.
    return LayoutBuilder(
      builder: (context, constraints) {
        const timeColW = 52.0;
        final gridW = constraints.maxWidth - timeColW;
        final dayW = gridW / _days.length;
        const rowH = 26.0;
        const totalH = rowH * _slotHalfHours;

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE8ECF4)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              // Header row — day names
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  border: Border(bottom: BorderSide(color: Color(0xFFE8ECF4))),
                ),
                child: Row(
                  children: [
                    SizedBox(width: timeColW),
                    ..._dayLabelsNL.map((d) => SizedBox(
                          width: dayW,
                          height: 32,
                          child: Center(
                            child: Text(
                              d.substring(0, 3),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF6B7B94),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              // Body — one big gesture area
              GestureDetector(
                onPanStart: (details) =>
                    _handlePan(details.localPosition, timeColW, dayW, rowH, isStart: true),
                onPanUpdate: (details) =>
                    _handlePan(details.localPosition, timeColW, dayW, rowH),
                onPanEnd: (_) {
                  _dragging = false;
                  _dragAnchor = null;
                },
                onTapDown: (details) {
                  _handleTap(details.localPosition, timeColW, dayW, rowH);
                },
                child: SizedBox(
                  height: totalH,
                  child: Row(
                    children: [
                      // Time column
                      SizedBox(
                        width: timeColW,
                        child: Column(
                          children: List.generate(_slotHalfHours, (i) {
                            final t = _slotIndexToTime(i);
                            return SizedBox(
                              height: rowH,
                              child: Center(
                                child: Text(
                                  i.isEven ? t : '',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF6B7B94),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      // Day columns
                      ...List.generate(_days.length, (d) {
                        return SizedBox(
                          width: dayW,
                          child: Column(
                            children: List.generate(_slotHalfHours, (s) {
                              final key = '${d}_$s';
                              final selected = _selected.contains(key);
                              final onHour = s.isEven;
                              return Container(
                                height: rowH,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFF00C1FF)
                                      : Colors.white,
                                  border: Border(
                                    top: BorderSide(
                                      color: onHour
                                          ? const Color(0xFFE8ECF4)
                                          : const Color(0xFFF0F4FA),
                                      width: onHour ? 1 : 0.5,
                                    ),
                                    right: const BorderSide(
                                      color: Color(0xFFE8ECF4),
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleTap(
    Offset localPos, double timeColW, double dayW, double rowH,
  ) {
    final key = _keyForPosition(localPos, timeColW, dayW, rowH);
    if (key == null) return;
    setState(() {
      if (_selected.contains(key)) {
        _selected.remove(key);
      } else {
        _selected.add(key);
      }
    });
  }

  void _handlePan(
    Offset localPos, double timeColW, double dayW, double rowH, {
    bool isStart = false,
  }) {
    final key = _keyForPosition(localPos, timeColW, dayW, rowH);
    if (key == null) return;
    if (isStart) {
      _dragging = true;
      _dragMode = !_selected.contains(key); // add if empty, remove if filled
      _dragAnchor = key;
    }
    if (!_dragging || key == _dragAnchor) {
      _dragAnchor = key;
    }
    setState(() {
      if (_dragMode) {
        _selected.add(key);
      } else {
        _selected.remove(key);
      }
    });
  }

  String? _keyForPosition(
    Offset localPos, double timeColW, double dayW, double rowH,
  ) {
    if (localPos.dx < timeColW) return null;
    final d = ((localPos.dx - timeColW) / dayW).floor();
    final s = (localPos.dy / rowH).floor();
    if (d < 0 || d >= _days.length) return null;
    if (s < 0 || s >= _slotHalfHours) return null;
    return '${d}_$s';
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saving ? null : _save,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: const Color(0xFF00C1FF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: _saving
            ? const SizedBox(
                height: 20, width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text('Opslaan (${_selected.length} tijdblokken)'),
      ),
    );
  }
}
