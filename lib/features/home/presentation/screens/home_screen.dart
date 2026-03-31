import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedChild = 0;
  bool _showChildPicker = false;

  final _children = const [
    (name: 'Sami Khilji', initial: 'S', age: 7, level: 'Gevorderd Beginner', progress: 0.72, colors: [Color(0xFF0365C4), Color(0xFF00C1FF)]),
    (name: 'Noor Khilji', initial: 'N', age: 5, level: 'Beginner', progress: 0.35, colors: [Color(0xFFFF5C00), Color(0xFFF5A623)]),
  ];

  @override
  Widget build(BuildContext context) {
    final child = _children[_selectedChild];
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Goedemorgen' : hour < 18 ? 'Goedemiddag' : 'Goedenavond';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ===== HEADER =====
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFF0365C4), Color(0xFF0D7FE8), Color(0xFF00C1FF)]),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
            ),
            child: Stack(children: [
              // Wave decoration
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: CustomPaint(size: Size(MediaQuery.of(context).size.width, 40), painter: _HeaderWavePainter()),
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12, left: 20, right: 20, bottom: 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(16)),
                      alignment: Alignment.center,
                      child: const Text('A', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 12),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('$greeting,', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                      const Text('Ahmed Khilji', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                    ]),
                  ]),
                  GestureDetector(
                    onTap: () => context.pushNamed(RouteNames.notifications),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
                      child: Stack(alignment: Alignment.center, children: [
                        const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
                        Positioned(top: 6, right: 6, child: Container(
                          width: 18, height: 18,
                          decoration: BoxDecoration(color: const Color(0xFFFF5C00), shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: const Color(0xFFFF5C00).withOpacity(0.4), blurRadius: 6, offset: const Offset(0, 2))]),
                          alignment: Alignment.center,
                          child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                        )),
                      ]),
                    ),
                  ),
                ]),
              ),
            ]),
          ),

          // ===== CHILD PICKER =====
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(children: [
              GestureDetector(
                onTap: () => setState(() => _showChildPicker = !_showChildPicker),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE8F0FE), width: 1.5),
                    boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 12, offset: Offset(0, 4))],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(children: [
                    Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: child.colors)),
                      alignment: Alignment.center, child: Text(child.initial, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(child.name, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                      Text('${child.level} · ${child.age} jaar', style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                    ])),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(20)),
                      child: Text('${_children.length} kinderen', style: const TextStyle(color: Color(0xFF0365C4), fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(turns: _showChildPicker ? 0.5 : 0, duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF8E9BB3), size: 18)),
                  ]),
                ),
              ),
              if (_showChildPicker)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                    boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 24, offset: Offset(0, 8))]),
                  child: Column(children: List.generate(_children.length, (i) {
                    final c = _children[i];
                    return GestureDetector(
                      onTap: () => setState(() { _selectedChild = i; _showChildPicker = false; }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: i == _selectedChild ? const Color(0xFFF0F6FF) : Colors.transparent,
                          border: i > 0 ? const Border(top: BorderSide(color: Color(0xFFF0F4FA))) : null,
                        ),
                        child: Row(children: [
                          Container(width: 32, height: 32, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: c.colors)),
                            alignment: Alignment.center, child: Text(c.initial, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700))),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(c.name, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13, fontWeight: FontWeight.w600)),
                            Text(c.level, style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 10)),
                          ])),
                          if (i == _selectedChild) Container(width: 20, height: 20, decoration: const BoxDecoration(color: Color(0xFF0365C4), shape: BoxShape.circle),
                            alignment: Alignment.center, child: const Text('✓', style: TextStyle(color: Colors.white, fontSize: 11))),
                        ]),
                      ),
                    );
                  })),
                ),
            ]),
          ),

          // ===== NEXT LESSON CARD =====
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [Color(0xFFFF5C00), Color(0xFFF5A623)]),
                boxShadow: const [BoxShadow(color: Color(0x40FF5C00), blurRadius: 32, offset: Offset(0, 12))],
              ),
              padding: const EdgeInsets.all(20),
              child: Stack(children: [
                Positioned(top: -10, right: -10, child: Icon(Icons.waves, size: 80, color: Colors.white.withOpacity(0.1))),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(width: 24, height: 24, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                        child: const Icon(Icons.access_time, size: 13, color: Colors.white)),
                      const SizedBox(width: 8),
                      Expanded(child: Text('Volgende les — ${child.name.split(' ')[0]}',
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w500))),
                    ]),
                    const SizedBox(height: 8),
                    const Text('Maandag, 28 april', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text('15:00 – 15:30', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 15)),
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(Icons.location_on, size: 14, color: Colors.white.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Text('De Bilt', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                    ]),
                  ])),
                  Column(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                      child: const Text('1-op-1', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => context.pushNamed(RouteNames.reservationDetail, pathParameters: {'id': '1'}),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 4))]),
                        child: const Row(mainAxisSize: MainAxisSize.min, children: [
                          Text('Bekijk', style: TextStyle(color: Color(0xFFFF5C00), fontSize: 12, fontWeight: FontWeight.w700)),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right, color: Color(0xFFFF5C00), size: 14),
                        ]),
                      ),
                    ),
                  ]),
                ]),
              ]),
            ),
          ),

          // ===== QUICK ACTIONS =====
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Snelle acties', style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.5,
                children: [
                  _QuickAction(icon: Icons.calendar_month_rounded, label: 'Boek een les',
                    colors: const [Color(0xFF0365C4), Color(0xFF00C1FF)], shadow: const Color(0x330365C4),
                    onTap: () => context.goNamed(RouteNames.bookLesson)),
                  _QuickAction(icon: Icons.list_alt_rounded, label: 'Reserveringen',
                    colors: const [Color(0xFFFF5C00), Color(0xFFF5A623)], shadow: const Color(0x33FF5C00),
                    onTap: () => context.pushNamed(RouteNames.myReservations)),
                  _QuickAction(icon: Icons.credit_card_rounded, label: 'Knipkaarten',
                    colors: const [Color(0xFF27AE60), Color(0xFF2ECC71)], shadow: const Color(0x3327AE60),
                    onTap: () => context.goNamed(RouteNames.myPunchCards)),
                  _QuickAction(icon: Icons.bar_chart_rounded, label: 'Voortgang',
                    colors: const [Color(0xFF9B59B6), Color(0xFF8E44AD)], shadow: const Color(0x339B59B6),
                    onTap: () => context.pushNamed(RouteNames.childProgress)),
                ],
              ),
            ]),
          ),

          // ===== CHILD PROGRESS SUMMARY =====
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Voortgang ${child.name.split(' ')[0]}',
                  style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.w700)),
                GestureDetector(onTap: () => context.pushNamed(RouteNames.childProgress),
                  child: const Text('Details →', style: TextStyle(color: Color(0xFF0365C4), fontSize: 12, fontWeight: FontWeight.w600))),
              ]),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18),
                  boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 16, offset: Offset(0, 4))]),
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Row(children: [
                    Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: child.colors)),
                      alignment: Alignment.center, child: Text(child.initial, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(child.name, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                      Text('Niveau: ${child.level}', style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
                    ])),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('${(child.progress * 100).round()}%',
                        style: const TextStyle(color: Color(0xFF0365C4), fontSize: 20, fontWeight: FontWeight.w700)),
                      const Text('totaal', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 10)),
                    ]),
                  ]),
                  const SizedBox(height: 12),
                  Container(
                    height: 6,
                    decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(4)),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: child.progress,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)]),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    _SkillDot(label: 'Ademhaling', pct: _selectedChild == 0 ? 100 : 50, color: const Color(0xFF27AE60)),
                    _SkillDot(label: 'Drijven', pct: _selectedChild == 0 ? 80 : 30, color: const Color(0xFF0365C4)),
                    _SkillDot(label: 'Borstcrawl', pct: _selectedChild == 0 ? 45 : 10, color: const Color(0xFFFF5C00)),
                  ]),
                ]),
              ),
            ]),
          ),

          // ===== RECENT NOTIFICATIONS =====
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Recente meldingen', style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.w700)),
                GestureDetector(onTap: () => context.pushNamed(RouteNames.notifications),
                  child: const Text('Alles →', style: TextStyle(color: Color(0xFF0365C4), fontSize: 12, fontWeight: FontWeight.w600))),
              ]),
              const SizedBox(height: 12),
              ...[
                (icon: Icons.calendar_month_rounded, title: 'Lesherinnering', subtitle: 'Morgen 15:00 — De Bilt', time: 'Nu', color: const Color(0xFF0365C4), bg: const Color(0xFFE8F4FD)),
                (icon: Icons.bar_chart_rounded, title: 'Voortgang bijgewerkt', subtitle: 'Sami: Ademhaling voltooid ✓', time: '2u', color: const Color(0xFF27AE60), bg: const Color(0xFFE8F8F0)),
                (icon: Icons.credit_card_rounded, title: 'Knipkaart status', subtitle: 'Nog 8 lessen resterend', time: '1d', color: const Color(0xFFFF5C00), bg: const Color(0xFFFEF0E7)),
              ].map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                    boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))]),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(children: [
                    Container(width: 40, height: 40, decoration: BoxDecoration(color: item.bg, borderRadius: BorderRadius.circular(12)),
                      child: Icon(item.icon, size: 18, color: item.color)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(item.title, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13, fontWeight: FontWeight.w700)),
                      Text(item.subtitle, style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                    ])),
                    Text(item.time, style: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 11)),
                  ]),
                ),
              )),
            ]),
          ),

          // ===== PUNCH CARD BANNER =====
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: GestureDetector(
              onTap: () => context.pushNamed(RouteNames.purchasePunchCard),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFE8F4FD), Color(0xFFF0F6FF)]),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFD0E4F7), width: 1.5),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  Container(width: 44, height: 44, decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)])),
                    child: const Icon(Icons.credit_card_rounded, color: Colors.white, size: 20)),
                  const SizedBox(width: 16),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Bestel een knipkaart', style: TextStyle(color: Color(0xFF0365C4), fontSize: 14, fontWeight: FontWeight.w700)),
                    Text('Vanaf €12,50 per les', style: TextStyle(color: Color(0xFF6B99C7), fontSize: 12)),
                  ])),
                  const Icon(Icons.chevron_right, color: Color(0xFF0365C4), size: 18),
                ]),
              ),
            ),
          ),

          // ===== SWIMMING CHARACTERS DECORATION =====
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFE8F8FF), Color(0xFFF0F6FF)]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD0E8F7), width: 1.5),
              ),
              padding: const EdgeInsets.all(16),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('🏊', style: TextStyle(fontSize: 32)),
                SizedBox(width: 16),
                Column(children: [
                  Text('Leren zwemmen', style: TextStyle(color: Color(0xFF0365C4), fontSize: 13, fontWeight: FontWeight.w700)),
                  Text('met plezier!', style: TextStyle(color: Color(0xFF0365C4), fontSize: 11)),
                ]),
                SizedBox(width: 16),
                Text('🏊‍♀️', style: TextStyle(fontSize: 32)),
              ]),
            ),
          ),

          // ===== REVIEWS BANNER =====
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFFF8F0), Color(0xFFFFF5E8)]),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFF5DCC0), width: 1.5),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  Container(width: 44, height: 44, decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)])),
                    child: const Icon(Icons.star, color: Colors.white, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      const Text('9.6/10', style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 6),
                      ...List.generate(5, (_) => const Icon(Icons.star, size: 11, color: Color(0xFFFFD700))),
                    ]),
                    const Text('240+ tevreden ouders', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                  ])),
                  const Icon(Icons.chevron_right, color: Color(0xFFFF5C00), size: 18),
                ]),
              ),
            ),
          ),

          const SizedBox(height: 100),
        ]),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> colors;
  final Color shadow;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.colors, required this.shadow, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: shadow, blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
            boxShadow: [BoxShadow(color: shadow, blurRadius: 16, offset: const Offset(0, 6))],
          ), child: Icon(icon, color: Colors.white, size: 22)),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}

class _SkillDot extends StatelessWidget {
  final String label;
  final int pct;
  final Color color;
  const _SkillDot({required this.label, required this.pct, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text('$label $pct%', style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 10)),
    ]);
  }
}

class _HeaderWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.15);
    final path = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.75, size.height, size.width, size.height * 0.5)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
