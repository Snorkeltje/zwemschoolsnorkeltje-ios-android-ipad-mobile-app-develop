import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../providers/instructor_providers.dart';
import '../theme/instructor_theme.dart';

/// Bottom-nav shell for the instructor panel.
/// 5 tabs: Home · Rooster · Leerlingen · Berichten · Profiel.
class InstructorShell extends ConsumerWidget {
  final Widget child;
  const InstructorShell({super.key, required this.child});

  static final _tabs = <_Tab>[
    _Tab(Icons.home_outlined, Icons.home_rounded, 'Thuis', RouteNames.instructorHome, '/instructor/home'),
    _Tab(Icons.calendar_today_outlined, Icons.calendar_month_rounded, 'Rooster', RouteNames.instructorSchedule, '/instructor/schedule'),
    _Tab(Icons.people_outline, Icons.people_alt_rounded, 'Leerlingen', RouteNames.instructorStudents, '/instructor/students'),
    _Tab(Icons.chat_bubble_outline, Icons.chat_bubble_rounded, 'Chats', RouteNames.instructorChatList, '/instructor/chat-list'),
    _Tab(Icons.person_outline, Icons.person_rounded, 'Profiel', RouteNames.instructorProfile, '/instructor/profile'),
  ];

  int _indexFor(String path) {
    for (var i = 0; i < _tabs.length; i++) {
      if (path.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = GoRouterState.of(context).uri.path;
    final current = _indexFor(path);
    ref.watch(conversationsProvider);
    final chatUnread = ref.read(conversationsProvider.notifier).totalUnread;

    return Scaffold(
      backgroundColor: ITheme.bg,
      extendBody: true,
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: ITheme.bgElev,
          border: Border(top: BorderSide(color: ITheme.borderSoft)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, -4)),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final active = current == i;
                final badge = (i == 3 && chatUnread > 0) ? chatUnread : 0;
                return _NavItem(
                  tab: tab,
                  active: active,
                  badgeCount: badge,
                  onTap: () {
                    if (!active) {
                      HapticFeedback.lightImpact();
                      context.goNamed(tab.routeName);
                    }
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tab {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String routeName;
  final String path;
  const _Tab(this.icon, this.activeIcon, this.label, this.routeName, this.path);
}

class _NavItem extends StatelessWidget {
  final _Tab tab;
  final bool active;
  final int badgeCount;
  final VoidCallback onTap;
  const _NavItem({
    required this.tab,
    required this.active,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: active ? ITheme.primaryGradient : null,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: active ? ITheme.glowShadow(ITheme.primary) : null,
                    ),
                    child: Icon(
                      active ? tab.activeIcon : tab.icon,
                      color: active ? Colors.white : ITheme.textMid,
                      size: 20,
                    ),
                  ),
                  if (badgeCount > 0)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        decoration: BoxDecoration(
                          color: ITheme.blueAlt,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ITheme.bgElev, width: 1.5),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          badgeCount > 9 ? '9+' : '$badgeCount',
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: active ? ITheme.primary : ITheme.textMid,
                  fontSize: 10,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
                child: Text(tab.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
