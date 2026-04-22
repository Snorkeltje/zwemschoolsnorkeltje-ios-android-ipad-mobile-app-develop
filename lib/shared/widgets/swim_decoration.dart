import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Decorative swim characters positioned at the bottom of a screen.
/// Per Walter's feedback: reflect more of the swimming school theme.
/// Usage: wrap your body with a Stack and add [SwimDecoration()] as last child.
class SwimDecoration extends StatelessWidget {
  final double size;
  final double opacity;
  final Alignment alignment;

  const SwimDecoration({
    super.key,
    this.size = 140,
    this.opacity = 0.1,
    this.alignment = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Opacity(
            opacity: opacity,
            child: SvgPicture.asset(
              'assets/images/swim_characters.svg',
              width: size,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

/// Subtle wave line used to separate sections with a swim theme.
class WaveDivider extends StatelessWidget {
  final Color color;
  final double height;

  const WaveDivider({
    super.key,
    this.color = const Color(0xFF0365C4),
    this.height = 24,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size(double.infinity, height),
        painter: _WavePainter(color: color),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final Color color;
  _WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.75, size.height, size.width, size.height * 0.5);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
