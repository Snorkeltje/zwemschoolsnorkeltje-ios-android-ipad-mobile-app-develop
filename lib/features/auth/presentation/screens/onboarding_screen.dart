import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _current = 0;

  static const slides = [
    (
      icon: Icons.calendar_month_rounded,
      colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
      decor: Color(0xFF00C1FF),
      mainColor: Color(0xFF0365C4),
      title: 'Boek lessen',
      highlight: 'wanneer je wilt.',
      subtitle: 'Vaste tijdslots, extra lessen en vakantie-\nzwemlessen — alles op één plek.',
      f1: 'Vast tijdstip reserveren',
      f2: 'Extra & inhaallessen',
      f3: 'Vakantie-zwemles',
    ),
    (
      icon: Icons.bar_chart_rounded,
      colors: [Color(0xFFFF5C00), Color(0xFFF5A623)],
      decor: Color(0xFFFF5C00),
      mainColor: Color(0xFFFF5C00),
      title: 'Volg de voortgang',
      highlight: 'van uw kind.',
      subtitle: 'Zie vaardigheden, doelen en feedback\nna elke les van de instructeur.',
      f1: 'Zwemniveau tracking',
      f2: 'Skill-per-skill voortgang',
      f3: 'Instructeur feedback',
    ),
    (
      icon: Icons.chat_bubble_rounded,
      colors: [Color(0xFF27AE60), Color(0xFF00C1FF)],
      decor: Color(0xFF27AE60),
      mainColor: Color(0xFF27AE60),
      title: 'Blijf verbonden',
      highlight: 'met de instructeur.',
      subtitle: 'Chat, ontvang oefeningen voor thuis\nen volg elke stap van de ontwikkeling.',
      f1: 'Direct chatten',
      f2: 'Thuisoefeningen',
      f3: 'Push notificaties',
    ),
  ];

  void _next() {
    if (_current < slides.length - 1) setState(() => _current++);
    else context.goNamed(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final s = slides[_current];
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Column(children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, right: 20),
            child: GestureDetector(
              onTap: () => context.goNamed(RouteNames.login),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFF4F7FC), borderRadius: BorderRadius.circular(20)),
                child: const Text('Overslaan', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.38,
          child: Stack(alignment: Alignment.center, children: [
            Container(width: 220, height: 220, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: s.decor.withOpacity(0.15), width: 2))),
            Container(width: 280, height: 280, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [s.decor.withOpacity(0.08), Colors.transparent]))),
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: s.colors),
                boxShadow: [BoxShadow(color: s.decor.withOpacity(0.3), blurRadius: 40, offset: const Offset(0, 20))],
              ),
              child: Icon(s.icon, size: 56, color: Colors.white),
            ),
            Positioned(top: size.height * 0.045, left: size.width * 0.06, child: _Pill(text: '✓ ${s.f1}', color: s.mainColor, angle: -0.087)),
            Positioned(top: size.height * 0.03, right: size.width * 0.04, child: _Pill(text: '✓ ${s.f2}', color: s.mainColor, angle: 0.052)),
            Positioned(bottom: size.height * 0.06, left: size.width * 0.08, child: _Pill(text: '✓ ${s.f3}', color: s.mainColor, angle: 0.035)),
          ]),
        ),
        Expanded(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            RichText(text: TextSpan(
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, height: 1.2, color: Color(0xFF1A1A2E)),
              children: [TextSpan(text: '${s.title}\n'), TextSpan(text: s.highlight, style: TextStyle(color: s.mainColor))],
            )),
            const SizedBox(height: 12),
            Text(s.subtitle, style: const TextStyle(color: Color(0xFF6B7B94), fontSize: 15, height: 1.6)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(slides.length, (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == _current ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(color: i == _current ? s.mainColor : const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(4)),
              )),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _next,
              child: Container(
                width: double.infinity, height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: s.colors),
                  boxShadow: [BoxShadow(color: s.decor.withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 8))],
                ),
                alignment: Alignment.center,
                child: Text(
                  _current == slides.length - 1 ? 'Aan de slag! 🏊' : 'Volgende →',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.3),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ]),
        )),
      ])),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text; final Color color; final double angle;
  const _Pill({required this.text, required this.color, required this.angle});
  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: angle,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 4))]),
      child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    ),
  );
}
