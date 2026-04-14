import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _lang = 'NL';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          children: [
            _buildHeader(),
            _buildStats(),
            _buildChildren(),
            _buildSettings(),
            _buildSupport(),
            _buildInfo(),
            _buildSocial(),
            _buildLegal(),
            _buildLogout(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 58, 20, 32),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.6, 1.0],
            colors: [Color(0xFF0365C4), Color(0xFF0D7FE8), Color(0xFF00C1FF)],
          ),
        ),
        child: Column(
          children: [
            const Text('Profiel',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 3),
                  ),
                  alignment: Alignment.center,
                  child: const Text('A',
                      style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w700)),
                ),
                Positioned(
                  bottom: -4,
                  right: -4,
                  child: GestureDetector(
                    onTap: () => context.pushNamed(RouteNames.editProfile),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5C00),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF0365C4), width: 3),
                        boxShadow: [BoxShadow(color: const Color(0xFFFF5C00).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 13),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Ahmed Khilji',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
            Text('ahmed@snorkeltje.nl',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    final stats = [
      ('24', 'Lessen', Icons.calendar_today, const Color(0xFF0365C4)),
      ('8', 'Credits', Icons.credit_card, const Color(0xFFFF5C00)),
      ('72%', 'Voortgang', Icons.emoji_events, const Color(0xFF27AE60)),
    ];
    return Transform.translate(
      offset: const Offset(0, -16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: stats.map((s) {
              return Column(
                children: [
                  Icon(s.$3, color: s.$4, size: 18),
                  const SizedBox(height: 4),
                  Text(s.$1, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w700)),
                  Text(s.$2, style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 10)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildChildren() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Mijn kinderen',
                  style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
              GestureDetector(
                onTap: () => context.pushNamed(RouteNames.addEditChild),
                child: const Row(
                  children: [
                    Icon(Icons.person_add_alt_1, color: Color(0xFF0365C4), size: 14),
                    SizedBox(width: 4),
                    Text('Toevoegen',
                        style: TextStyle(color: Color(0xFF0365C4), fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => context.pushNamed(RouteNames.childProgress),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)]),
                    ),
                    alignment: Alignment.center,
                    child: const Text('S',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sami Khilji',
                            style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                        Text('Gev. Beginner · 7 jaar',
                            style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                      ],
                    ),
                  ),
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF27AE60), shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  const Text('Actief',
                      style: TextStyle(color: Color(0xFF27AE60), fontSize: 11, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, color: Color(0xFFC4CDD9), size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGroup(List<_MenuItem> items) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: List.generate(items.length, (i) {
            final it = items[i];
            return InkWell(
              onTap: it.onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: i > 0 ? const Border(top: BorderSide(color: Color(0xFFF0F4FA))) : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: it.color.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(it.icon, color: it.color, size: 17),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(it.label,
                          style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14)),
                    ),
                    if (it.badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: it.badgeBg ?? const Color(0xFFF0F4FA),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(it.badge!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: it.badgeColor ?? const Color(0xFF8E9BB3),
                            )),
                      ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right, color: Color(0xFFC4CDD9), size: 16),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSettings() {
    return _buildMenuGroup([
      _MenuItem(Icons.edit, 'Profiel bewerken', const Color(0xFF0365C4), () => context.pushNamed(RouteNames.editProfile)),
      _MenuItem(Icons.notifications_outlined, 'Notificaties', const Color(0xFFFF5C00),
          () => context.pushNamed(RouteNames.notificationSettings),
          badge: 'Aan', badgeBg: const Color(0xFFE8F8F0), badgeColor: const Color(0xFF27AE60)),
      _MenuItem(Icons.language, 'Taal', const Color(0xFF00C1FF), _showLangModal, badge: _lang),
    ]);
  }

  Widget _buildSupport() {
    return _buildMenuGroup([
      _MenuItem(Icons.emoji_events, 'Diploma\'s', const Color(0xFF0365C4), () => context.pushNamed(RouteNames.zwemdiplom)),
      _MenuItem(Icons.receipt_long, 'Facturen', const Color(0xFFFF5C00), () => context.pushNamed(RouteNames.paymentHistory)),
      _MenuItem(Icons.warning_amber, 'Noodcontacten', const Color(0xFFE74C3C), () => context.pushNamed(RouteNames.emergencyContacts)),
    ]);
  }

  Widget _buildInfo() {
    return _buildMenuGroup([
      _MenuItem(Icons.info_outline, 'Over ons', const Color(0xFF0365C4), () => context.pushNamed(RouteNames.aboutUs)),
      _MenuItem(Icons.phone, 'Contact', const Color(0xFF27AE60), () => context.pushNamed(RouteNames.contactScreen)),
      _MenuItem(Icons.star_outline, 'Reviews', const Color(0xFFF5A623), () => context.pushNamed(RouteNames.reviewsScreen)),
    ]);
  }

  Widget _buildSocial() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text('Volg ons',
                style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12, fontWeight: FontWeight.w600)),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.facebook, color: Color(0xFF1877F2), size: 18),
                      SizedBox(width: 8),
                      Text('Facebook', style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, color: Color(0xFFE4405F), size: 18),
                      SizedBox(width: 8),
                      Text('Instagram', style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegal() {
    return _buildMenuGroup([
      _MenuItem(Icons.help_outline, 'Help & Veelgestelde vragen', const Color(0xFFF5A623), () => context.pushNamed(RouteNames.faq)),
      _MenuItem(Icons.shield_outlined, 'Algemene voorwaarden', const Color(0xFF8E44AD), () => context.pushNamed(RouteNames.termsConditions)),
    ]);
  }

  Widget _buildLogout() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GestureDetector(
        onTap: () => context.goNamed(RouteNames.login),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFFEE4E4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: Color(0xFFE74C3C), size: 18),
              SizedBox(width: 8),
              Text('Uitloggen',
                  style: TextStyle(color: Color(0xFFE74C3C), fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }

  void _showLangModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: const Color(0xFFE0E5EC), borderRadius: BorderRadius.circular(999)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Taal kiezen',
                    style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w700)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(color: Color(0xFFF4F7FC), shape: BoxShape.circle),
                    child: const Icon(Icons.close, color: Color(0xFF8E9BB3), size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _langOption('🇳🇱', 'Nederlands', 'Nederlands', 'NL'),
            const SizedBox(height: 12),
            _langOption('🇬🇧', 'Engels', 'English', 'EN'),
          ],
        ),
      ),
    );
  }

  Widget _langOption(String flag, String name, String sub, String code) {
    final isSel = _lang == code;
    return GestureDetector(
      onTap: () {
        setState(() => _lang = code);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSel ? null : const Color(0xFFF8FAFE),
          gradient: isSel
              ? const LinearGradient(colors: [Color(0xFFE8F4FD), Color(0xFFF0F6FF)])
              : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSel ? const Color(0xFF0365C4) : Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 15, fontWeight: FontWeight.w700)),
                  Text(sub, style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
                ],
              ),
            ),
            if (isSel)
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)]),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final String? badge;
  final Color? badgeColor;
  final Color? badgeBg;
  _MenuItem(this.icon, this.label, this.color, this.onTap, {this.badge, this.badgeColor, this.badgeBg});
}
