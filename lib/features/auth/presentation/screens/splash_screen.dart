import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/router/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;
  Timer? _progressTimer;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 40), (t) {
      if (!mounted) return;
      setState(() {
        _progress = (_progress + 0.02).clamp(0.0, 1.0);
      });
      if (_progress >= 1.0) t.cancel();
    });
    _navTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) context.goNamed(RouteNames.onboarding);
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _navTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.4, 1.0],
            colors: [Color(0xFF0365C4), Color(0xFF034DA9), Color(0xFF023B82)],
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: size.height * 0.15,
              left: size.width * 0.1,
              child: Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0x2600C1FF), Colors.transparent],
                  ),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.25,
              right: size.width * 0.05,
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0x1FFF5C00), Colors.transparent],
                  ),
                ),
              ),
            ),

            // Wave at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                size: Size(size.width, 220),
                painter: _WavePainter(),
              ),
            ),

            // Center content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  SvgPicture.asset(
                    'assets/images/snorkeltje_logo.svg',
                    height: 100,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Jouw zwemlessen, altijd bij je.',
                    style: TextStyle(
                      color: Color(0xFFB2D9FF),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Loading bar
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 200,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: _progress,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00C1FF), Color(0xFFFF5C00)],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Version
            const Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Snorkeltje v2.0',
                  style: TextStyle(
                    color: Color(0xFF6898C9),
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = const Color(0xFF00C1FF).withOpacity(0.2);
    final p1 = Path()
      ..moveTo(0, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.27, size.width * 0.5, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.82, size.width, size.height * 0.55)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(p1, paint);

    paint.color = const Color(0xFF5BC1DB).withOpacity(0.2);
    final p2 = Path()
      ..moveTo(0, size.height * 0.68)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.41, size.width * 0.5, size.height * 0.68)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.95, size.width, size.height * 0.68)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(p2, paint);

    paint.color = const Color(0xFF00AEFF).withOpacity(0.2);
    final p3 = Path()
      ..moveTo(0, size.height * 0.82)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.64, size.width * 0.5, size.height * 0.82)
      ..quadraticBezierTo(size.width * 0.75, size.height, size.width, size.height * 0.82)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(p3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
