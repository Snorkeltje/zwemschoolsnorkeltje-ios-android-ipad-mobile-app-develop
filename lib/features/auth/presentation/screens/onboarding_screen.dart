import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class _Slide {
  final IconData icon;
  final List<Color> iconBg;
  final Color decorColor;
  final String title;
  final String titleHighlight;
  final String subtitle;
  final Color color;
  final List<String> features;
  const _Slide({
    required this.icon,
    required this.iconBg,
    required this.decorColor,
    required this.title,
    required this.titleHighlight,
    required this.subtitle,
    required this.color,
    required this.features,
  });
}

const _slides = <_Slide>[
  _Slide(
    icon: Icons.event_available,
    iconBg: [Color(0xFF0365C4), Color(0xFF00C1FF)],
    decorColor: Color(0xFF00C1FF),
    title: 'Boek lessen',
    titleHighlight: 'wanneer je wilt.',
    subtitle: 'Vaste tijdslots, extra lessen en vakantie-\nzwemlessen — alles op één plek.',
    color: Color(0xFF0365C4),
    features: ['Vast tijdstip reserveren', 'Extra & inhaallessen', 'Vakantie-zwemles'],
  ),
  _Slide(
    icon: Icons.bar_chart,
    iconBg: [Color(0xFFFF5C00), Color(0xFFF5A623)],
    decorColor: Color(0xFFFF5C00),
    title: 'Volg de voortgang',
    titleHighlight: 'van uw kind.',
    subtitle: 'Zie vaardigheden, doelen en feedback\nna elke les van de instructeur.',
    color: Color(0xFFFF5C00),
    features: ['Zwemniveau tracking', 'Skill-per-skill voortgang', 'Instructeur feedback'],
  ),
  _Slide(
    icon: Icons.chat_bubble_outline,
    iconBg: [Color(0xFF27AE60), Color(0xFF00C1FF)],
    decorColor: Color(0xFF27AE60),
    title: 'Blijf verbonden',
    titleHighlight: 'met de instructeur.',
    subtitle: 'Chat, ontvang oefeningen voor thuis\nen volg elke stap van de ontwikkeling.',
    color: Color(0xFF27AE60),
    features: ['Direct chatten', 'Thuisoefeningen', 'Push notificaties'],
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _current = 0;

  void _next() {
    if (_current < _slides.length - 1) {
      setState(() => _current++);
    } else {
      context.goNamed(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_current];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Padding(
              padding: const EdgeInsets.only(right: 24, top: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => context.goNamed(RouteNames.login),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FC),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text('Overslaan',
                        style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            ),

            // Illustration
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.38,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [slide.decorColor.withValues(alpha: 0.03), Colors.transparent],
                        stops: const [0.0, 0.7],
                      ),
                    ),
                  ),
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: slide.decorColor.withValues(alpha: 0.12),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: slide.iconBg),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(color: slide.decorColor.withValues(alpha: 0.3), blurRadius: 40, offset: const Offset(0, 20)),
                      ],
                    ),
                    child: Icon(slide.icon, color: Colors.white, size: 56),
                  ),
                  ..._buildFeaturePills(slide),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                              color: Color(0xFF1A1A2E),
                            ),
                            children: [
                              TextSpan(text: '${slide.title}\n'),
                              TextSpan(text: slide.titleHighlight, style: TextStyle(color: slide.color)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(slide.subtitle,
                            style: const TextStyle(color: Color(0xFF6B7B94), fontSize: 15, height: 1.6)),
                      ],
                    ),
                    Column(
                      children: [
                        // Dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_slides.length, (i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: GestureDetector(
                                onTap: () => setState(() => _current = i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  width: i == _current ? 28 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: i == _current ? slide.color : const Color(0xFFE5E7EB),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 24),
                        // Button
                        GestureDetector(
                          onTap: _next,
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: slide.iconBg),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(color: slide.color.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 8)),
                              ],
                            ),
                            child: Text(
                              _current == _slides.length - 1 ? 'Aan de slag! 🏊‍♂️' : 'Volgende →',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFeaturePills(_Slide slide) {
    const positions = [
      (top: 0.15, left: 0.08, right: null as double?, bottom: null as double?, rotate: -5.0),
      (top: 0.10, left: null as double?, right: 0.05, bottom: null as double?, rotate: 3.0),
      (top: null as double?, left: 0.12, right: null as double?, bottom: 0.20, rotate: 2.0),
    ];
    return List.generate(slide.features.length, (i) {
      final p = positions[i];
      final h = MediaQuery.of(context).size.height * 0.38;
      final w = MediaQuery.of(context).size.width;
      return Positioned(
        top: p.top != null ? p.top! * h : null,
        bottom: p.bottom != null ? p.bottom! * h : null,
        left: p.left != null ? p.left! * w : null,
        right: p.right != null ? p.right! * w : null,
        child: Transform.rotate(
          angle: p.rotate * 3.14159 / 180,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 4))],
            ),
            child: Text(
              '✓ ${slide.features[i]}',
              style: TextStyle(color: slide.color, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );
    });
  }
}
