import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0;
  Timer? _progressTimer;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      setState(() => _progress = (_progress + 2).clamp(0, 100));
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.5, -1),
            end: Alignment(0.5, 1),
            stops: [0.0, 0.4, 1.0],
            colors: [Color(0xFF0365C4), Color(0xFF034DA9), Color(0xFF023B82)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.2,
                child: CustomPaint(
                  size: const Size(double.infinity, 220),
                  painter: _WavePainter(),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.15,
              left: size.width * 0.10,
              child: Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0x2600C1FF), Colors.transparent],
                    stops: [0.0, 0.7],
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
                    stops: [0.0, 0.7],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/snorkeltje_logo.svg',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Jouw zwemlessen, altijd bij je.',
                    textAlign: TextAlign.center,
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
            Positioned(
              left: 0,
              right: 0,
              bottom: 120,
              child: Center(
                child: SizedBox(
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      height: 3,
                      color: Colors.white.withOpacity(0.15),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _progress / 100,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFF00C1FF), Color(0xFFFF5C00)],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 60,
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
    final w = size.width;
    final h = size.height;
    void drawWave(Color color, double topY1, double topY2) {
      final path = Path()
        ..moveTo(0, topY1)
        ..quadraticBezierTo(w * 0.25, topY1 - 60, w * 0.5, topY1)
        ..quadraticBezierTo(w * 0.75, topY2, w, topY1)
        ..lineTo(w, h)
        ..lineTo(0, h)
        ..close();
      canvas.drawPath(path, Paint()..color = color);
    }
    drawWave(const Color(0xFF00C1FF), 120, 60);
    drawWave(const Color(0xFF5BC1DB), 150, 30);
    drawWave(const Color(0xFF00AEFF), 180, 0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
