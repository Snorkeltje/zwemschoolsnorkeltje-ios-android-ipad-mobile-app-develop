import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../providers/instructor_providers.dart';
import '../theme/instructor_theme.dart';

class InstructorProfileScreen extends ConsumerWidget {
  const InstructorProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final stats = ref.watch(instructorStatsProvider);
    return Scaffold(
      backgroundColor: ITheme.bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with profile
            ClipRect(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 32),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1A1D27), Color(0xFF252836)],
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text('Mijn Profiel', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  // Avatar
                  Stack(
                    children: [
                      Container(
                        width: 88, height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)]),
                          boxShadow: [BoxShadow(color: const Color(0xFFFF5C00).withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 8))],
                        ),
                        child: Center(child: Text(profile.initial, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700))),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFF27AE60),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF252836), width: 3),
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(profile.fullName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(profile.title, style: const TextStyle(color: ITheme.textMid, fontSize: 13)),
                        Text(profile.email, style: const TextStyle(color: ITheme.textLo, fontSize: 12)),
                        const SizedBox(height: 8),
                        // Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...List.generate(5, (_) => const Icon(Icons.star, color: Color(0xFFFFD700), size: 12)),
                            const SizedBox(width: 6),
                            Text('${stats.rating}', style: const TextStyle(color: ITheme.primaryAlt, fontSize: 12, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 4),
                            Text('· ${stats.reviews} reviews', style: const TextStyle(color: ITheme.textMid, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Orange radial top-right
                  Positioned(
                    top: -67, right: -60,
                    child: IgnorePointer(
                      child: Container(
                        width: 200, height: 200,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [Color(0x10FF5C00), Colors.transparent],
                            stops: [0.0, 0.7],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Cyan radial top-left
                  Positioned(
                    top: -45, left: -45,
                    child: IgnorePointer(
                      child: Container(
                        width: 150, height: 150,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [Color(0x0A00C1FF), Colors.transparent],
                            stops: [0.0, 0.7],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Transform.translate(
                offset: const Offset(0, -16),
                child: Column(
                  children: [
                    // Stats card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1D27),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 24, offset: const Offset(0, 8))],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _ProfileStat(icon: Icons.calendar_today, value: '${stats.weekLessons}', label: 'Deze week', color: ITheme.blueAlt),
                          _ProfileStat(icon: Icons.emoji_events, value: '${stats.totalStudents}', label: 'Leerlingen', color: ITheme.primaryAlt),
                          _ProfileStat(icon: Icons.location_on, value: '${stats.todayLocations}', label: 'Locaties', color: ITheme.green),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Settings section
                    _SettingsGroup(
                      items: [
                        _SettingsItem(
                          icon: Icons.edit_outlined, label: 'Profiel bewerken',
                          color: ITheme.blue,
                          onTap: () { HapticFeedback.selectionClick(); context.push('/edit-profile'); },
                        ),
                        _SettingsItem(
                          icon: Icons.notifications_outlined, label: 'Meldingen',
                          color: ITheme.primary, badge: profile.notificationsOn ? 'AAN' : 'UIT', badgeColor: ITheme.green,
                          onTap: () { HapticFeedback.selectionClick(); context.pushNamed(RouteNames.instructorNotifications); },
                        ),
                        _SettingsItem(
                          icon: Icons.language, label: 'Taal',
                          color: ITheme.blueAlt, badge: profile.language,
                          onTap: () { HapticFeedback.selectionClick(); _showLanguagePicker(context, ref, profile.language); },
                        ),
                        _SettingsItem(
                          icon: Icons.event_available, label: 'Beschikbaarheid',
                          color: ITheme.green,
                          onTap: () { HapticFeedback.selectionClick(); context.pushNamed(RouteNames.instructorAvailability); },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Support section
                    _SettingsGroup(
                      items: [
                        _SettingsItem(
                          icon: Icons.help_outline, label: 'Hulp & Support',
                          color: ITheme.primaryAlt,
                          onTap: () { HapticFeedback.selectionClick(); context.push('/faq'); },
                        ),
                        _SettingsItem(
                          icon: Icons.shield_outlined, label: 'Privacybeleid',
                          color: ITheme.purpleAlt,
                          onTap: () { HapticFeedback.selectionClick(); context.push('/about-us'); },
                        ),
                        _SettingsItem(
                          icon: Icons.description_outlined, label: 'Voorwaarden',
                          color: ITheme.textMid,
                          onTap: () { HapticFeedback.selectionClick(); context.pushNamed(RouteNames.termsConditions); },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Sync status
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: ITheme.bgElev,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.wifi, size: 14, color: ITheme.green),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text('Online — Alle data gesynchroniseerd',
                                style: TextStyle(color: ITheme.textMid, fontSize: 12)),
                          ),
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: ITheme.green, shape: BoxShape.circle)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Logout button
                    GestureDetector(
                      onTap: () => _confirmLogout(context),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          border: Border.all(color: ITheme.red.withValues(alpha: 0.3), width: 1.5),
                          borderRadius: BorderRadius.circular(16),
                          color: ITheme.red.withValues(alpha: 0.08),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, color: ITheme.red, size: 18),
                            SizedBox(width: 8),
                            Text('Uitloggen', style: TextStyle(color: ITheme.red, fontSize: 15, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Version
                    const Text('Snorkeltje Instructeur App · v1.0.0',
                        style: TextStyle(color: ITheme.textMid, fontSize: 11)),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref, String current) {
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            const Center(child: Text('Taal', style: ITheme.h2)),
            const SizedBox(height: 16),
            for (final entry in const {'NL': 'Nederlands', 'EN': 'English'}.entries)
              _langOption(context, ref, entry.key, entry.value, current == entry.key),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _langOption(BuildContext context, WidgetRef ref, String code, String label, bool selected) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(profileProvider.notifier).setLanguage(code);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: selected ? ITheme.primary.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? ITheme.primary.withValues(alpha: 0.4) : Colors.transparent),
        ),
        child: Row(
          children: [
            Text(label, style: const TextStyle(color: ITheme.textHi, fontSize: 14, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(code, style: TextStyle(
              color: selected ? ITheme.primary : ITheme.textMid,
              fontSize: 12, fontWeight: FontWeight.w700,
            )),
            if (selected) ...[
              const SizedBox(width: 8),
              const Icon(Icons.check_circle, color: ITheme.primary, size: 18),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ITheme.bgElev,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Uitloggen?', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        content: const Text('Weet je zeker dat je wil uitloggen?',
            style: TextStyle(color: ITheme.textMid, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuleren', style: TextStyle(color: ITheme.textMid)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.goNamed(RouteNames.login);
            },
            child: const Text('Uitloggen', style: TextStyle(color: ITheme.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final IconData icon;
  final String value, label;
  final Color color;
  const _ProfileStat({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: ITheme.textHi, fontSize: 20, fontWeight: FontWeight.w700)),
        Text(label, style: const TextStyle(color: ITheme.textMid, fontSize: 10)),
      ],
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItem> items;
  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D27),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          return Column(
            children: [
              if (i > 0) Divider(height: 1, color: Colors.white.withValues(alpha: 0.04)),
              items[i],
            ],
          );
        }),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String? badge;
  final Color? badgeColor;
  final VoidCallback onTap;

  const _SettingsItem({required this.icon, required this.label, required this.color, this.badge, this.badgeColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 17, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(color: ITheme.textHi, fontSize: 14))),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: (badgeColor ?? Colors.white.withValues(alpha: 0.06)).withValues(alpha: badge == 'AAN' ? 0.15 : 0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(badge!, style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: badge == 'AAN' ? ITheme.green : ITheme.textMid,
                )),
              ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 16, color: ITheme.textMid),
          ],
        ),
      ),
    );
  }
}
