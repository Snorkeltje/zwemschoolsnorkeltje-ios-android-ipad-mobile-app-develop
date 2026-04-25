import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/utils/smart_back.dart';
import '../../data/models/fixed_schedule_models.dart';
import '../providers/fixed_schedule_provider.dart';

/// Parent-side: when an instructor marks a child as "taking exam",
/// the parent has 24h to confirm if the child continues to the next level.
class ExamContinuationScreen extends ConsumerStatefulWidget {
  const ExamContinuationScreen({super.key});

  @override
  ConsumerState<ExamContinuationScreen> createState() => _ExamContinuationScreenState();
}

class _ExamContinuationScreenState extends ConsumerState<ExamContinuationScreen> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _countdown(Duration d) {
    if (d.isNegative) return 'Verlopen';
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    return '${h}u ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(examContinuationProvider);
    final pending = all.where((e) => e.status == ExamContinuationStatus.pending && !e.isExpired).toList();
    final history = all.where((e) => e.status != ExamContinuationStatus.pending || e.isExpired).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24),
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 58, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => smartBack(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.chevron_left, color: Colors.white, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Examen vervolgkeuze',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                        Text('Wilt u doorgaan naar het volgende niveau?',
                            style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pending.isEmpty && history.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.school_outlined, size: 48, color: Colors.black.withValues(alpha: 0.15)),
                            const SizedBox(height: 12),
                            const Text('Geen vervolgkeuzes op dit moment',
                                style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 13)),
                          ],
                        ),
                      ),
                    ),

                  for (final ec in pending)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _PendingCard(ec: ec, countdown: _countdown(ec.timeLeft)),
                    ),

                  if (history.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Text('Eerdere antwoorden',
                        style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    for (final ec in history)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _HistoryCard(ec: ec),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingCard extends ConsumerWidget {
  final ExamContinuation ec;
  final String countdown;
  const _PendingCard({required this.ec, required this.countdown});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canContinue = ec.nextLevel != null;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF0365C4).withValues(alpha: 0.25), width: 1.5),
        boxShadow: [
          BoxShadow(color: const Color(0xFF0365C4).withValues(alpha: 0.1), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFF5A623)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.emoji_events, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Examen ${ec.currentLevel} aankomend',
                        style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.w700)),
                    Text('Voor ${ec.childName}',
                        style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF7FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              canContinue
                  ? 'Wilt u dat ${ec.childName} na het examen doorgaat naar niveau ${ec.nextLevel}?'
                  : '${ec.childName} doet binnenkort het laatste examen. Laat ons weten of u nog door wilt gaan met extra lessen.',
              style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13, height: 1.5),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 14, color: Color(0xFFE74C3C)),
              const SizedBox(width: 6),
              Text('Antwoord binnen $countdown',
                  style: const TextStyle(color: Color(0xFFE74C3C), fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ref.read(examContinuationProvider.notifier).respond(ec.id, false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${ec.childName} stopt na het examen.'),
                        backgroundColor: const Color(0xFF8E9BB3),
                      ),
                    );
                  },
                  child: const Text('Nee, stoppen na examen',
                      style: TextStyle(color: Color(0xFF6B7B94), fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF27AE60),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    ref.read(examContinuationProvider.notifier).respond(ec.id, true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Geweldig! ${ec.childName} gaat door naar ${ec.nextLevel ?? "extra lessen"}.'),
                        backgroundColor: const Color(0xFF27AE60),
                      ),
                    );
                  },
                  child: Text(canContinue ? 'Ja, doorgaan' : 'Ja, doorgaan',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final ExamContinuation ec;
  const _HistoryCard({required this.ec});

  Color get _color => switch (ec.status) {
    ExamContinuationStatus.continuing => const Color(0xFF27AE60),
    ExamContinuationStatus.leaving => const Color(0xFF8E9BB3),
    ExamContinuationStatus.expired => const Color(0xFFE74C3C),
    _ => const Color(0xFF8E9BB3),
  };

  String get _label => switch (ec.status) {
    ExamContinuationStatus.continuing => 'Doorgaan',
    ExamContinuationStatus.leaving => 'Stoppen',
    ExamContinuationStatus.expired => 'Verlopen (geen antwoord)',
    _ => '',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 8, height: 32,
            decoration: BoxDecoration(color: _color, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${ec.childName} — Examen ${ec.currentLevel}',
                    style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13, fontWeight: FontWeight.w600)),
                Text(_label,
                    style: TextStyle(color: _color, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
