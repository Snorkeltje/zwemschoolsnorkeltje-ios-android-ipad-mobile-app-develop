import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class _Child {
  final int id;
  final String name;
  final String initial;
  final int age;
  final String level;
  final int progress;
  final List<Color> gradient;
  const _Child(this.id, this.name, this.initial, this.age, this.level, this.progress, this.gradient);
}

const _children = <_Child>[
  _Child(1, 'Sami Khilji', 'S', 7, 'Gevorderd Beginner', 72, [Color(0xFF0365C4), Color(0xFF00C1FF)]),
  _Child(2, 'Noor Khilji', 'N', 5, 'Beginner', 35, [Color(0xFFFF5C00), Color(0xFFF5A623)]),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedChild = 0;
  bool _showChildPicker = false;

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Goedemorgen';
    if (h < 18) return 'Goedemiddag';
    return 'Goedenavond';
  }

  @override
  Widget build(BuildContext context) {
    final child = _children[_selectedChild];
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildChildSwitcher(child),
            const SizedBox(height: 16),
            _buildNextLessonCard(child),
            const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 24),
            _buildChildProgress(child),
            const SizedBox(height: 24),
            _buildRecentNotifications(child),
            const SizedBox(height: 24),
            _buildPunchCardBanner(),
            const SizedBox(height: 16),
            _buildCharactersBanner(),
            const SizedBox(height: 16),
            _buildReviewsBanner(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 58, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.6, 1.0],
                colors: [Color(0xFF0365C4), Color(0xFF0D7FE8), Color(0xFF00C1FF)],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Text('A',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$_greeting,',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                      const Text('Ahmed Khilji',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => context.pushNamed(RouteNames.notifications),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
                      ),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5C00),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: const Color(0xFFFF5C00).withValues(alpha: 0.4), blurRadius: 6, offset: const Offset(0, 2)),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Text('3',
                              style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChildSwitcher(_Child child) {
    if (_children.length <= 1) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _showChildPicker = !_showChildPicker),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8F0FE), width: 1.5),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: child.gradient),
                    ),
                    alignment: Alignment.center,
                    child: Text(child.initial,
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(child.name, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                        Text('${child.level} · ${child.age} jaar', style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(999)),
                    child: Text('${_children.length} kinderen',
                        style: const TextStyle(color: Color(0xFF0365C4), fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: _showChildPicker ? 0.5 : 0,
                    child: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF8E9BB3), size: 16),
                  ),
                ],
              ),
            ),
          ),
          if (_showChildPicker)
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 24, offset: const Offset(0, 8))],
              ),
              child: Column(
                children: List.generate(_children.length, (i) {
                  final c = _children[i];
                  final isSel = i == _selectedChild;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedChild = i;
                      _showChildPicker = false;
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSel ? const Color(0xFFF0F6FF) : Colors.transparent,
                        border: i > 0 ? const Border(top: BorderSide(color: Color(0xFFF0F4FA))) : null,
                        borderRadius: i == 0 ? const BorderRadius.vertical(top: Radius.circular(14)) : i == _children.length - 1 ? const BorderRadius.vertical(bottom: Radius.circular(14)) : null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: c.gradient),
                            ),
                            alignment: Alignment.center,
                            child: Text(c.initial, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.name, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13, fontWeight: FontWeight.w600)),
                                Text(c.level, style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 10)),
                              ],
                            ),
                          ),
                          if (isSel)
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(color: Color(0xFF0365C4), shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: const Icon(Icons.check, color: Colors.white, size: 12),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNextLessonCard(_Child child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF5C00), Color(0xFFF5A623)],
          ),
          boxShadow: [BoxShadow(color: const Color(0xFFFF5C00).withValues(alpha: 0.25), blurRadius: 32, offset: const Offset(0, 12))],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -10,
              right: -5,
              child: Icon(Icons.waves, size: 80, color: Colors.white.withValues(alpha: 0.1)),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: const Icon(Icons.access_time, color: Colors.white, size: 13),
                          ),
                          const SizedBox(width: 8),
                          Text('Volgende les — ${child.name}',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Maandag, 28 april',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                      Text('15:00 – 15:30',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 15)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.white.withValues(alpha: 0.7), size: 14),
                          const SizedBox(width: 6),
                          Text('De Bilt', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(999)),
                      child: const Text('1-op-1', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () => context.pushNamed(RouteNames.reservationDetail, pathParameters: {'id': '1'}),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4))],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Bekijk', style: TextStyle(color: Color(0xFFFF5C00), fontSize: 12, fontWeight: FontWeight.w700)),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right, color: Color(0xFFFF5C00), size: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final items = [
      (Icons.calendar_today, 'Les boeken', [const Color(0xFF0365C4), const Color(0xFF00C1FF)], const Color(0x330365C4), RouteNames.bookLesson),
      (Icons.list_alt, 'Reserveringen', [const Color(0xFFFF5C00), const Color(0xFFF5A623)], const Color(0x33FF5C00), RouteNames.myReservations),
      (Icons.credit_card, 'Strippenkaarten', [const Color(0xFF27AE60), const Color(0xFF2ECC71)], const Color(0x3327AE60), RouteNames.myPunchCards),
      (Icons.bar_chart, 'Voortgang', [const Color(0xFF9B59B6), const Color(0xFF8E44AD)], const Color(0x339B59B6), RouteNames.childProgress),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Snelle acties',
              style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            children: items.map((it) {
              return GestureDetector(
                onTap: () => context.pushNamed(it.$5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: it.$4, blurRadius: 16, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: it.$3),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: it.$4, blurRadius: 16, offset: const Offset(0, 6))],
                        ),
                        child: Icon(it.$1, color: Colors.white, size: 22),
                      ),
                      const SizedBox(height: 10),
                      Text(it.$2,
                          style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChildProgress(_Child child) {
    final skills = _selectedChild == 0
        ? [('Ademhaling', 100, const Color(0xFF27AE60)), ('Drijven', 80, const Color(0xFF0365C4)), ('Borstcrawl', 45, const Color(0xFFFF5C00))]
        : [('Ademhaling', 50, const Color(0xFF27AE60)), ('Drijven', 30, const Color(0xFF0365C4)), ('Borstcrawl', 10, const Color(0xFFFF5C00))];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Voortgang van ${child.name.split(' ').first}',
                  style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.w700)),
              GestureDetector(
                onTap: () => context.pushNamed(RouteNames.childProgress),
                child: const Text('Details →',
                    style: TextStyle(color: Color(0xFF0365C4), fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 4))],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: child.gradient),
                      ),
                      alignment: Alignment.center,
                      child: Text(child.initial,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(child.name, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                          Text('Niveau: ${child.level}', style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${child.progress}%',
                            style: const TextStyle(color: Color(0xFF0365C4), fontSize: 20, fontWeight: FontWeight.w700)),
                        const Text('totaal', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 10)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    height: 6,
                    color: const Color(0xFFE8F0FE),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: child.progress / 100,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)]),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: skills.map((s) {
                    return Row(
                      children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: s.$3, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text('${s.$1} ${s.$2}%',
                            style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 10)),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentNotifications(_Child child) {
    final items = [
      (Icons.calendar_today, 'Les herinnering', 'Morgen 15:00 — De Bilt', 'nu', const Color(0xFF0365C4), const Color(0xFFE8F4FD)),
      (Icons.bar_chart, 'Voortgang bijgewerkt', '${child.name.split(' ').first}: Ademhaling voltooid ✓', '2u', const Color(0xFF27AE60), const Color(0xFFE8F8F0)),
      (Icons.credit_card, 'Strippenkaart', 'Nog 8 lessen over', '1d', const Color(0xFFFF5C00), const Color(0xFFFEF0E7)),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent',
                  style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.w700)),
              GestureDetector(
                onTap: () => context.pushNamed(RouteNames.notifications),
                child: const Text('Alle →',
                    style: TextStyle(color: Color(0xFF0365C4), fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((it) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: it.$6, borderRadius: BorderRadius.circular(12)),
                        child: Icon(it.$1, color: it.$5, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(it.$2,
                                style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13, fontWeight: FontWeight.w700)),
                            Text(it.$3, style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                          ],
                        ),
                      ),
                      Text(it.$4, style: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 11)),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPunchCardBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => context.pushNamed(RouteNames.purchasePunchCard),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE8F4FD), Color(0xFFF0F6FF)],
            ),
            border: Border.all(color: const Color(0xFFD0E4F7), width: 1.5),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.credit_card, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Strippenkaart bestellen',
                        style: TextStyle(color: Color(0xFF0365C4), fontSize: 14, fontWeight: FontWeight.w700)),
                    Text('Vanaf €60', style: TextStyle(color: Color(0xFF6B99C7), fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF0365C4), size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharactersBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F8FF), Color(0xFFF0F6FF)],
          ),
          border: Border.all(color: const Color(0xFFD0E8F7), width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.pool, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            const Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Leer zwemmen',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color(0xFF0365C4), fontSize: 13, fontWeight: FontWeight.w700)),
                  Text('met plezier',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color(0x990365C4), fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.waves, color: Colors.white, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF8F0), Color(0xFFFFF5E8)],
          ),
          border: Border.all(color: const Color(0xFFF5DCC0), width: 1.5),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.star, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('9.6/10',
                          style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 6),
                      ...List.generate(5, (_) => const Icon(Icons.star, color: Color(0xFFFFD700), size: 11)),
                    ],
                  ),
                  const Text('240+ tevreden ouders',
                      style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFFF5C00), size: 18),
          ],
        ),
      ),
    );
  }
}
