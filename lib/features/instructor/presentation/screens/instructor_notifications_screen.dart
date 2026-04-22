import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/utils/smart_back.dart';
import '../theme/instructor_theme.dart';

/// Instructor-specific notifications per Walter's feedback.
/// Customer notifications (lesson reminders, payments) are separated out.
/// Instructor sees: vacation approvals, student assignments, admin messages, schedule changes.
class InstructorNotificationsScreen extends ConsumerStatefulWidget {
  const InstructorNotificationsScreen({super.key});

  @override
  ConsumerState<InstructorNotificationsScreen> createState() => _InstructorNotificationsScreenState();
}

class _InstructorNotificationsScreenState extends ConsumerState<InstructorNotificationsScreen> {
  final List<Map<String, dynamic>> _today = [
    {
      'type': 'schedule',
      'emoji': '📅',
      'emojiBg': const Color(0xFFFF5C00),
      'title': 'Rooster wijziging',
      'subtitle': 'Sami Khilji verplaatst van 15:00 naar 15:30',
      'time': 'Nu',
      'unread': true,
    },
    {
      'type': 'admin',
      'emoji': '📢',
      'emojiBg': const Color(0xFF0365C4),
      'title': 'Bericht van hoofdkantoor',
      'subtitle': 'Nieuwe lesplan update voor Diploma B',
      'time': '1u',
      'unread': true,
    },
    {
      'type': 'student',
      'emoji': '🎯',
      'emojiBg': const Color(0xFF27AE60),
      'title': 'Nieuwe leerling toegewezen',
      'subtitle': 'Max V. is toegewezen aan uw woensdag rooster',
      'time': '2u',
      'unread': true,
    },
    {
      'type': 'vacation',
      'emoji': '🏖️',
      'emojiBg': const Color(0xFFF5A623),
      'title': 'Vakantie goedgekeurd',
      'subtitle': '14-21 april goedgekeurd door administratie',
      'time': '3u',
      'unread': false,
    },
  ];

  final List<Map<String, dynamic>> _earlier = [
    {
      'type': 'chat',
      'emoji': '💬',
      'emojiBg': const Color(0xFF9B59B6),
      'title': 'Nieuw bericht van ouder',
      'subtitle': 'Ahmed Khilji: "Dank voor de feedback"',
      'time': 'Gisteren',
      'unread': false,
    },
    {
      'type': 'review',
      'emoji': '⭐',
      'emojiBg': const Color(0xFFFFD700),
      'title': 'Nieuwe review',
      'subtitle': '5 sterren van Pieter Jansen voor Emma',
      'time': '2d',
      'unread': false,
    },
    {
      'type': 'progress',
      'emoji': '📈',
      'emojiBg': const Color(0xFF27AE60),
      'title': 'Mijlpaal bereikt',
      'subtitle': 'Emma heeft Diploma A behaald! 🎉',
      'time': '3d',
      'unread': false,
    },
    {
      'type': 'system',
      'emoji': 'ℹ️',
      'emojiBg': const Color(0xFF4A5568),
      'title': 'App update',
      'subtitle': 'Nieuwe functies voor instructeurs beschikbaar',
      'time': '1w',
      'unread': false,
    },
  ];

  void _markAllRead() {
    HapticFeedback.mediumImpact();
    setState(() {
      for (final n in _today) {
        n['unread'] = false;
      }
      for (final n in _earlier) {
        n['unread'] = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alle meldingen gelezen'),
        backgroundColor: ITheme.green,
      ),
    );
  }

  Future<void> _onRefresh() async {
    HapticFeedback.selectionClick();
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hPad = ITheme.hPad(context);
    return Scaffold(
      backgroundColor: ITheme.bg,
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [ITheme.headerGradStart, ITheme.headerGradEnd],
              ),
            ),
            padding: EdgeInsets.fromLTRB(hPad, 58, hPad, 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    smartBack(context);
                  },
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.chevron_left, color: ITheme.textHi, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Meldingen',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                GestureDetector(
                  onTap: _markAllRead,
                  child: const Text(
                    'Alles gelezen',
                    style: TextStyle(color: ITheme.primary, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              color: ITheme.primary,
              backgroundColor: ITheme.bgElev,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8, left: 4),
                      child: Text('VANDAAG', style: ITheme.sectionLabel),
                    ),
                    ..._today.map((n) => _NotifCard(data: n)),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8, left: 4),
                      child: Text('EERDER', style: ITheme.sectionLabel),
                    ),
                    ..._earlier.map((n) => _NotifCard(data: n)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _NotifCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final unread = data['unread'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: unread
            ? ITheme.primary.withValues(alpha: 0.06)
            : ITheme.bgElev,
        borderRadius: BorderRadius.circular(14),
        border: unread
            ? Border.all(color: ITheme.primary.withValues(alpha: 0.18))
            : null,
      ),
      child: Row(
        children: [
          if (unread)
            Container(
              width: 6, height: 6,
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(color: ITheme.primary, shape: BoxShape.circle),
            ),
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: (data['emojiBg'] as Color).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(data['emoji'] as String, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['title'] as String,
                    style: TextStyle(
                      color: ITheme.textHi,
                      fontSize: 13,
                      fontWeight: unread ? FontWeight.w700 : FontWeight.w600,
                    )),
                const SizedBox(height: 2),
                Text(data['subtitle'] as String,
                    style: const TextStyle(color: ITheme.textMid, fontSize: 11),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Text(data['time'] as String,
              style: TextStyle(
                fontSize: 11,
                fontWeight: unread ? FontWeight.w600 : FontWeight.w400,
                color: unread ? ITheme.primary : ITheme.textMid,
              )),
        ],
      ),
    );
  }
}
