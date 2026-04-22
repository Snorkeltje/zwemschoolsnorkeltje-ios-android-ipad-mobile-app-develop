import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../providers/instructor_providers.dart';
import '../theme/instructor_theme.dart';

class InstructorHomeScreen extends ConsumerStatefulWidget {
  const InstructorHomeScreen({super.key});

  @override
  ConsumerState<InstructorHomeScreen> createState() => _InstructorHomeScreenState();
}

class _InstructorHomeScreenState extends ConsumerState<InstructorHomeScreen> {
  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Goedemorgen';
    if (h < 18) return 'Goedemiddag';
    return 'Goedenavond';
  }

  /// Picks today's schedule key. Schedule is currently keyed by day-of-month
  /// (mock data); if today has no entry, falls back to the first populated day
  /// so the demo always shows something.
  int _todayKey(Map<int, List<dynamic>> schedule) {
    final d = DateTime.now().day;
    if (schedule.containsKey(d) && (schedule[d]?.isNotEmpty ?? false)) return d;
    for (final e in schedule.entries) {
      if (e.value.isNotEmpty) return e.key;
    }
    return d;
  }

  /// Parses "HH:mm" and returns minutes-from-now to that time today.
  /// Negative if already past.
  int _minutesUntil(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return 0;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    final now = DateTime.now();
    final target = DateTime(now.year, now.month, now.day, h, m);
    return target.difference(now).inMinutes;
  }

  String _timeUntilLabel(String time) {
    final mins = _minutesUntil(time);
    if (mins < -5) return 'Bezig';
    if (mins < 0) return 'Nu bezig';
    if (mins < 60) return 'Over $mins min';
    final h = mins ~/ 60;
    final m = mins % 60;
    return m == 0 ? 'Over $h u' : 'Over ${h}u ${m}m';
  }

  Future<void> _onRefresh() async {
    HapticFeedback.selectionClick();
    // Rebuild — real app would re-fetch from backend.
    ref.invalidate(scheduleProvider);
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final stats = ref.watch(instructorStatsProvider);
    final schedule = ref.watch(scheduleProvider);
    final key = _todayKey(schedule);
    final todayLessons = schedule[key] ?? [];
    final unread = ref.watch(unreadNotificationsProvider);
    ref.watch(conversationsProvider);
    final totalChatUnread = ref.read(conversationsProvider.notifier).totalUnread;

    final current = todayLessons.cast<dynamic>().where((l) => l.current == true).isEmpty
        ? null
        : todayLessons.cast<dynamic>().firstWhere((l) => l.current == true);
    final upcoming = todayLessons.cast<dynamic>().where((l) => l.done != true && l.current != true).toList();
    final next = current ?? (upcoming.isNotEmpty ? upcoming.first : null);
    final hPad = ITheme.hPad(context);

    return Scaffold(
      backgroundColor: ITheme.bg,
      body: RefreshIndicator(
        color: ITheme.primary,
        backgroundColor: ITheme.bgElev,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context, profile, totalChatUnread, unread, hPad),
              _statsBanner(stats, hPad),
              if (next != null) _nextLesson(context, next, hPad),
              _todaysSchedule(context, todayLessons, hPad),
              _quickActions(context, hPad),
              _syncBanner(hPad),
              const SizedBox(height: 16),
              Center(
                child: Opacity(
                  opacity: 0.2,
                  child: SvgPicture.asset('assets/images/snorkeltje_logo.svg', height: 28),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, dynamic profile, int chatUnread, int unread, double hPad) {
    final initial = (profile.firstName as String).isNotEmpty ? profile.firstName[0] : 'I';
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(hPad, 58, hPad, 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [ITheme.headerGradStart, ITheme.headerGradEnd],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  gradient: ITheme.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: ITheme.glowShadow(ITheme.primary),
                ),
                alignment: Alignment.center,
                child: Text(initial,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$_greeting,', style: ITheme.label),
                    Text(profile.fullName,
                        style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              _iconButton(
                icon: Icons.chat_bubble_outline,
                count: chatUnread,
                color: ITheme.blueAlt,
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.goNamed(RouteNames.instructorChatList);
                },
              ),
              const SizedBox(width: 8),
              _iconButton(
                icon: Icons.notifications_outlined,
                count: unread,
                color: ITheme.primary,
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.pushNamed(RouteNames.instructorNotifications);
                },
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
                gradient: RadialGradient(colors: [Color(0x14FF5C00), Colors.transparent], stops: [0.0, 0.7]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statsBanner(dynamic stats, double hPad) {
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: ITheme.primaryGradient,
                boxShadow: [BoxShadow(color: ITheme.primary.withValues(alpha: 0.3), blurRadius: 32, offset: const Offset(0, 12))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vandaag — ${formatDutchDate(DateTime.now())}',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _stat('${stats.todayLessons}', 'lessen'),
                      _vDivider(),
                      _stat('${stats.todayStudents}', 'leerlingen'),
                      _vDivider(),
                      _stat('${stats.todayLocations}', 'locaties'),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: -40, right: -30,
              child: IgnorePointer(
                child: Container(
                  width: 120, height: 120,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.08)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nextLesson(BuildContext context, dynamic lesson, double hPad) {
    final time = '${lesson.time} – ${lesson.end}';
    final label = _timeUntilLabel(lesson.time);
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Volgende les', style: ITheme.h3),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 12, color: ITheme.primary),
                  const SizedBox(width: 6),
                  Text(label,
                      style: const TextStyle(color: ITheme.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              context.goNamed(RouteNames.instructorSchedule);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ITheme.bgElev,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: ITheme.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(time,
                            style: const TextStyle(color: ITheme.primary, fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 13, color: ITheme.textMid),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(lesson.location,
                                  style: const TextStyle(color: ITheme.textHi, fontSize: 13),
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.people_outline, size: 13, color: ITheme.textMid),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text('${lesson.students} leerlingen · ${lesson.type}',
                                  style: ITheme.label,
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 72, height: 32,
                        child: Stack(
                          children: [
                            _miniAvatar((lesson.studentNames as List).isNotEmpty ? lesson.studentNames[0][0] : 'S',
                                const [ITheme.blue, ITheme.blueAlt], 0),
                            if ((lesson.studentNames as List).length > 1)
                              _miniAvatar(lesson.studentNames[1][0], const [ITheme.green, ITheme.greenAlt], 20),
                            if ((lesson.studentNames as List).length > 2)
                              _miniAvatar(lesson.studentNames[2][0], const [ITheme.primaryAlt, ITheme.primary], 40),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Text('Details',
                              style: TextStyle(color: ITheme.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right, color: ITheme.primary, size: 14),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _todaysSchedule(BuildContext context, List<dynamic> lessons, double hPad) {
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Rooster vandaag', style: ITheme.h3),
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.goNamed(RouteNames.instructorSchedule);
                },
                child: const Text('Volledig rooster →',
                    style: TextStyle(color: ITheme.primary, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (lessons.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ITheme.bgElev,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Text('🏖️', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('Geen lessen vandaag — geniet van je vrije dag!',
                        style: TextStyle(color: ITheme.textMid, fontSize: 13)),
                  ),
                ],
              ),
            )
          else
            ...lessons.map((item) => _scheduleRow(context, item)),
        ],
      ),
    );
  }

  Widget _scheduleRow(BuildContext context, dynamic item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          context.goNamed(RouteNames.instructorSchedule);
        },
        onLongPress: item.done == true ? null : () {
          HapticFeedback.mediumImpact();
          _showLessonActions(context, ref, item.id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: item.current == true ? null : ITheme.bgElev,
            gradient: item.current == true
                ? LinearGradient(colors: [
                    ITheme.primary.withValues(alpha: 0.14),
                    ITheme.primaryAlt.withValues(alpha: 0.06),
                  ])
                : null,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: item.current == true ? ITheme.primary.withValues(alpha: 0.3) : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 3, height: 24,
                decoration: BoxDecoration(color: item.current == true ? ITheme.primary : Colors.transparent),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 52,
                child: Text(
                  item.time,
                  style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700,
                    color: item.done == true ? ITheme.textLo
                        : item.current == true ? ITheme.primary
                        : ITheme.textHi,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  (item.studentNames as List).join(', '),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: item.done == true ? ITheme.textLo : ITheme.textHi,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(item.type, style: const TextStyle(color: ITheme.textMid, fontSize: 10)),
              ),
              const SizedBox(width: 6),
              if (item.done == true)
                _statusPill('✓', ITheme.green)
              else if (item.current == true)
                _statusPill('NU', ITheme.primary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusPill(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(label,
            style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
      );

  Widget _quickActions(BuildContext context, double hPad) {
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Snelle acties', style: ITheme.h3),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _qa(context, Icons.calendar_month, 'Volledig rooster',
                  const [ITheme.blue, ITheme.blueAlt], ITheme.blue, RouteNames.instructorSchedule),
              _qa(context, Icons.people, 'Mijn leerlingen',
                  const [ITheme.primary, ITheme.primaryAlt], ITheme.primary, RouteNames.instructorStudents),
              _qa(context, Icons.chat_bubble_outline, 'Berichten',
                  const [ITheme.green, ITheme.greenAlt], ITheme.green, RouteNames.instructorChatList),
              _qa(context, Icons.event_available, 'Beschikbaarheid',
                  const [ITheme.purple, ITheme.purpleAlt], ITheme.purple, RouteNames.instructorAvailability),
            ],
          ),
        ],
      ),
    );
  }

  Widget _syncBanner(double hPad) {
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: ITheme.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.wifi, size: 14, color: ITheme.green),
            SizedBox(width: 8),
            Expanded(
              child: Text('Online — Alle data gesynchroniseerd',
                  style: TextStyle(color: ITheme.green, fontSize: 12, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  // ========== Sub-widgets ==========

  void _showLessonActions(BuildContext context, WidgetRef ref, String lessonId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ITheme.bgElev,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Les acties', style: ITheme.h2),
            const SizedBox(height: 16),
            _actionTile(ctx, Icons.check_circle, 'Markeer als voltooid', ITheme.green, () {
              HapticFeedback.lightImpact();
              ref.read(scheduleProvider.notifier).markLessonDone(lessonId);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Les gemarkeerd als voltooid'), backgroundColor: ITheme.green),
              );
            }),
            _actionTile(ctx, Icons.edit_note, 'Voortgang bijwerken', ITheme.primary, () {
              HapticFeedback.lightImpact();
              Navigator.pop(ctx);
              context.pushNamed(RouteNames.progressUpdate, pathParameters: {'studentInitial': 'S'});
            }),
            _actionTile(ctx, Icons.cancel_outlined, 'Annuleren', ITheme.red, () {
              HapticFeedback.lightImpact();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Annulering verzonden naar ouder')),
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _actionTile(BuildContext ctx, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
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
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _iconButton({
    required IconData icon,
    required int count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: ITheme.textHi, size: 20),
          ),
          if (count > 0)
            Positioned(
              top: -4, right: -4,
              child: Container(
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 6, offset: const Offset(0, 2))],
                ),
                alignment: Alignment.center,
                child: Text(count > 9 ? '9+' : '$count',
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value,
                style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w700)),
          ),
          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(
        width: 1, height: 40,
        color: Colors.white.withValues(alpha: 0.2),
        margin: const EdgeInsets.symmetric(horizontal: 16),
      );

  Widget _miniAvatar(String l, List<Color> bg, double left) {
    return Positioned(
      left: left,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: bg),
          border: Border.all(color: ITheme.bgElev, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(l, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _qa(BuildContext context, IconData icon, String label, List<Color> gradient, Color shadow, String route) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        // Main tab destinations use goNamed; detail-only routes use pushNamed.
        const tabs = {
          RouteNames.instructorSchedule, RouteNames.instructorStudents,
          RouteNames.instructorChatList, RouteNames.instructorProfile,
        };
        if (tabs.contains(route)) {
          context.goNamed(route);
        } else {
          context.pushNamed(route);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: ITheme.bgElev,
          borderRadius: BorderRadius.circular(18),
          boxShadow: ITheme.cardShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradient),
                borderRadius: BorderRadius.circular(14),
                boxShadow: ITheme.glowShadow(shadow),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(color: ITheme.textHi, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
