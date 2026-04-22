import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/instructor_providers.dart';
import '../../../../shared/utils/smart_back.dart';

/// VACATION-ONLY mode per Walter's feedback:
/// Instructors have a fixed weekly schedule (which days + location).
/// They are scheduled by default year-round. Only "submit vacation" is possible here.
class AvailabilityRequestScreen extends ConsumerStatefulWidget {
  const AvailabilityRequestScreen({super.key});

  @override
  ConsumerState<AvailabilityRequestScreen> createState() => _AvailabilityRequestScreenState();
}

class _AvailabilityRequestScreenState extends ConsumerState<AvailabilityRequestScreen> {
  static const Color _darkBg = Color(0xFF0F1117);
  static const Color _darkHeader = Color(0xFF1C1F27);
  static const Color _darkCard = Color(0xFF1A1D27);
  static const Color _orange = Color(0xFFFF5C00);
  static const Color _textWhite = Color(0xFFE2E8F0);
  static const Color _textGray = Color(0xFF8E9BB3);
  static const Color _textDarkGray = Color(0xFF4A5568);

  DateTime? _startDate;
  DateTime? _endDate;
  String _reason = '';
  final TextEditingController _notesController = TextEditingController();

  // Fixed schedule data (what Walter's instructors have by default)
  final Map<String, String> _fixedSchedule = {
    'Maandag': 'De Bilt',
    'Dinsdag': 'Garderen',
    'Woensdag': 'Bad Hulckesteijn',
    'Donderdag': 'Ampt v. Nijkerk',
    'Vrijdag': 'De Bilt',
  };

  final List<String> _vacationReasons = [
    'Zomervakantie',
    'Kerstvakantie',
    'Voorjaarsvakantie',
    'Meivakantie',
    'Herfstvakantie',
    'Persoonlijk',
    'Ziekte',
    'Anders',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool start}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: start ? DateTime.now() : (_startDate ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _orange,
              onPrimary: Colors.white,
              surface: _darkCard,
              onSurface: _textWhite,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (start) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = picked;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  int get _dayCount {
    if (_startDate == null || _endDate == null) return 0;
    return _endDate!.difference(_startDate!).inDays + 1;
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  bool _submitting = false;

  Future<void> _submit() async {
    if (_submitting) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Selecteer begin- en einddatum'),
          backgroundColor: const Color(0xFFE74C3C),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    if (_reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Selecteer een reden'),
          backgroundColor: const Color(0xFFE74C3C),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 600));

    // Submit to provider
    final days = <int>{};
    for (int i = 0; i <= _endDate!.difference(_startDate!).inDays; i++) {
      days.add(_startDate!.add(Duration(days: i)).day);
    }
    ref.read(availabilityProvider.notifier).submitAvailability(
      days: days,
      startTime: _formatDate(_startDate!),
      endTime: _formatDate(_endDate!),
      notes: '$_reason${_notesController.text.isNotEmpty ? " — ${_notesController.text}" : ""}',
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Vakantie aangevraagd ($_dayCount dagen)'),
        backgroundColor: _orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    setState(() {
      _startDate = null;
      _endDate = null;
      _reason = '';
      _notesController.clear();
      _submitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final submissions = ref.watch(availabilityProvider);

    return Scaffold(
      backgroundColor: _darkBg,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 58, 16, 16),
              color: _darkHeader,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => smartBack(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.chevron_left, color: _textWhite, size: 20),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Vakantie aanvragen',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fixed schedule info card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _orange.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.info_outline, color: _orange, size: 16),
                              SizedBox(width: 8),
                              Text('Uw vaste rooster',
                                  style: TextStyle(color: _orange, fontSize: 13, fontWeight: FontWeight.w700)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ..._fixedSchedule.entries.map((e) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e.key, style: const TextStyle(color: _textWhite, fontSize: 12)),
                                    Text(e.value, style: const TextStyle(color: _textGray, fontSize: 12, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 8),
                          const Text(
                            'U bent het hele jaar ingepland. Alleen vakantiedagen indienen.',
                            style: TextStyle(color: _textGray, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Date pickers
                    const Text('Periode', style: TextStyle(color: _textGray, fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickDate(start: true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              decoration: BoxDecoration(
                                color: _darkCard,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Van', style: TextStyle(color: _textDarkGray, fontSize: 10)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 14, color: _orange),
                                      const SizedBox(width: 6),
                                      Text(
                                        _startDate == null ? 'Kies datum' : _formatDate(_startDate!),
                                        style: TextStyle(
                                          color: _startDate == null ? _textGray : _textWhite,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickDate(start: false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              decoration: BoxDecoration(
                                color: _darkCard,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Tot', style: TextStyle(color: _textDarkGray, fontSize: 10)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 14, color: _orange),
                                      const SizedBox(width: 6),
                                      Text(
                                        _endDate == null ? 'Kies datum' : _formatDate(_endDate!),
                                        style: TextStyle(
                                          color: _endDate == null ? _textGray : _textWhite,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_dayCount > 0) ...[
                      const SizedBox(height: 8),
                      Text(
                        '$_dayCount ${_dayCount == 1 ? "dag" : "dagen"}',
                        style: const TextStyle(color: _orange, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                    const SizedBox(height: 20),

                    // Reason
                    const Text('Reden', style: TextStyle(color: _textGray, fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _vacationReasons.map((r) {
                        final isSelected = _reason == r;
                        return GestureDetector(
                          onTap: () => setState(() => _reason = r),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)])
                                  : null,
                              color: isSelected ? null : _darkCard,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                            ),
                            child: Text(
                              r,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? Colors.white : _textGray,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Notes
                    const Text('Toelichting (optioneel)', style: TextStyle(color: _textGray, fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: _darkCard,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                      ),
                      child: TextField(
                        controller: _notesController,
                        maxLines: 3,
                        style: const TextStyle(color: _textWhite, fontSize: 13),
                        decoration: const InputDecoration(
                          hintText: 'Bijv. naar buitenland, familiebezoek, etc.',
                          hintStyle: TextStyle(color: _textDarkGray, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit
                    GestureDetector(
                      onTap: _submitting ? null : _submit,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: _submitting
                              ? [const Color(0xFFFF5C00).withValues(alpha: 0.5), const Color(0xFFF5A623).withValues(alpha: 0.5)]
                              : const [Color(0xFFFF5C00), Color(0xFFF5A623)]),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: _orange.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 8))],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_submitting)
                              const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            else
                              const Icon(Icons.beach_access, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(_submitting ? 'Verzenden...' : 'Vakantie indienen',
                                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Previous submissions
                    const Text('Eerdere aanvragen',
                        style: TextStyle(color: _textWhite, fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    if (submissions.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _darkCard,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text('Geen aanvragen', style: TextStyle(color: _textGray, fontSize: 12)),
                      )
                    else
                      ...submissions.map((sub) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: _darkCard,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40, height: 40,
                                    decoration: BoxDecoration(
                                      color: _orange.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.beach_access, color: _orange, size: 18),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(sub.label,
                                            style: const TextStyle(color: _textWhite, fontSize: 13, fontWeight: FontWeight.w700)),
                                        if (sub.notes.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(sub.notes,
                                              style: const TextStyle(color: _textGray, fontSize: 11),
                                              overflow: TextOverflow.ellipsis),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: sub.statusColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(sub.status,
                                        style: TextStyle(color: sub.statusColor, fontSize: 10, fontWeight: FontWeight.w700)),
                                  ),
                                ],
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
