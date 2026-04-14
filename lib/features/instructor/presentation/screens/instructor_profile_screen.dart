import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InstructorProfileScreen extends StatelessWidget {
  const InstructorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with profile
            Container(
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
                        child: const Center(child: Text('JV', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700))),
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
                  const Text('Jan de Vries', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  const Text('Zweminstructeur', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 13)),
                  const Text('jan.devries@snorkeltje.nl', style: TextStyle(color: Color(0xFF4A5568), fontSize: 12)),
                  const SizedBox(height: 8),
                  // Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(5, (_) => const Icon(Icons.star, color: Color(0xFFFFD700), size: 12)),
                      const SizedBox(width: 6),
                      const Text('4.9', style: TextStyle(color: Color(0xFFF5A623), fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 4),
                      const Text('· 120 reviews', style: TextStyle(color: Color(0xFF4A5568), fontSize: 11)),
                    ],
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _ProfileStat(icon: Icons.calendar_today, value: '24', label: 'Deze week', color: Color(0xFF00C1FF)),
                          _ProfileStat(icon: Icons.emoji_events, value: '38', label: 'Leerlingen', color: Color(0xFFF5A623)),
                          _ProfileStat(icon: Icons.location_on, value: '3', label: 'Locaties', color: Color(0xFF27AE60)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Settings section
                    _SettingsGroup(
                      items: [
                        _SettingsItem(icon: Icons.edit_outlined, label: 'Profiel bewerken', color: const Color(0xFF0365C4), onTap: () => context.push('/edit-profile')),
                        _SettingsItem(icon: Icons.notifications_outlined, label: 'Meldingen', color: const Color(0xFFFF5C00), badge: 'AAN', badgeColor: const Color(0xFF27AE60), onTap: () => context.push('/notification-settings')),
                        _SettingsItem(icon: Icons.language, label: 'Taal', color: const Color(0xFF00C1FF), badge: 'NL', onTap: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Taal instellingen - Binnenkort beschikbaar'))); }),
                        _SettingsItem(icon: Icons.calendar_today, label: 'Beschikbaarheid', color: const Color(0xFF27AE60), onTap: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Beschikbaarheid - Binnenkort beschikbaar'))); }),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Support section
                    _SettingsGroup(
                      items: [
                        _SettingsItem(icon: Icons.help_outline, label: 'Hulp & Support', color: const Color(0xFFF5A623), onTap: () => context.push('/faq')),
                        _SettingsItem(icon: Icons.shield_outlined, label: 'Privacybeleid', color: const Color(0xFF8E44AD), onTap: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Privacybeleid - Binnenkort beschikbaar'))); }),
                        _SettingsItem(icon: Icons.description_outlined, label: 'Voorwaarden', color: const Color(0xFF4A5568), onTap: () => context.pushNamed('termsConditions')),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Sync status
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1D27),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.wifi, size: 14, color: Color(0xFF27AE60)),
                          const SizedBox(width: 12),
                          const Expanded(child: Text('Laatste sync: vandaag 14:32', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12))),
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF27AE60), shape: BoxShape.circle)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Logout button
                    GestureDetector(
                      onTap: () => context.goNamed('login'),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE74C3C).withValues(alpha: 0.3), width: 1.5),
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xFFE74C3C).withValues(alpha: 0.08),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, color: Color(0xFFE74C3C), size: 18),
                            SizedBox(width: 8),
                            Text('Uitloggen', style: TextStyle(color: Color(0xFFE74C3C), fontSize: 15, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Version
                    const Text('Snorkeltje Instructeur App v1.0.0', style: TextStyle(color: Color(0xFF4A5568), fontSize: 11)),
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
        Text(value, style: TextStyle(color: const Color(0xFFE2E8F0), fontSize: 20, fontWeight: FontWeight.w700)),
        Text(label, style: const TextStyle(color: Color(0xFF4A5568), fontSize: 10)),
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
            Expanded(child: Text(label, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 14))),
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
                  color: badge == 'AAN' ? const Color(0xFF27AE60) : const Color(0xFF8E9BB3),
                )),
              ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 16, color: Color(0xFF4A5568)),
          ],
        ),
      ),
    );
  }
}
