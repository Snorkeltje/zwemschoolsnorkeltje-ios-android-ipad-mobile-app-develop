import 'package:flutter/material.dart';

/// Instructor panel design system — centralized colors & text styles.
/// Use these everywhere instead of raw hex values so the whole panel
/// stays visually consistent and contrast-safe.
class ITheme {
  ITheme._();

  // === Backgrounds ===
  static const Color bg = Color(0xFF0F1117);
  static const Color bgElev = Color(0xFF1A1D27);
  static const Color bgElev2 = Color(0xFF252836);
  static const Color headerGradStart = Color(0xFF1A1D27);
  static const Color headerGradEnd = Color(0xFF252836);

  // === Brand (orange = primary CTA) ===
  static const Color primary = Color(0xFFFF5C00);
  static const Color primaryAlt = Color(0xFFF5A623);
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryAlt],
  );

  // === Secondary accents ===
  static const Color blue = Color(0xFF0365C4);
  static const Color blueAlt = Color(0xFF00C1FF);
  static const Color green = Color(0xFF27AE60);
  static const Color greenAlt = Color(0xFF2ECC71);
  static const Color purple = Color(0xFF9B59B6);
  static const Color purpleAlt = Color(0xFF8E44AD);
  static const Color red = Color(0xFFE74C3C);
  static const Color amber = Color(0xFFF5A623);

  // === Text (contrast-safe) ===
  static const Color textHi = Color(0xFFE8ECF4);     // was #E2E8F0 — bumped for better contrast
  static const Color textMid = Color(0xFFB4BDD1);    // was #8E9BB3 — bumped to meet WCAG AA on dark bg
  static const Color textLo = Color(0xFF7A8599);     // was #4A5568 — too dim on dark bg
  static const Color textDim = Color(0xFF5A6275);    // only for decorative elements

  // === Borders / dividers ===
  static const Color border = Color(0x1FFFFFFF);     // 12% white
  static const Color borderSoft = Color(0x14FFFFFF); // 8% white

  // === Status ===
  static const Color online = Color(0xFF27AE60);
  static const Color offline = Color(0xFF7A8599);

  // === Text styles ===
  static const TextStyle h1 = TextStyle(color: textHi, fontSize: 22, fontWeight: FontWeight.w700, height: 1.2);
  static const TextStyle h2 = TextStyle(color: textHi, fontSize: 18, fontWeight: FontWeight.w700);
  static const TextStyle h3 = TextStyle(color: textHi, fontSize: 16, fontWeight: FontWeight.w700);
  static const TextStyle body = TextStyle(color: textHi, fontSize: 14, fontWeight: FontWeight.w500);
  static const TextStyle bodySm = TextStyle(color: textHi, fontSize: 13, fontWeight: FontWeight.w500);
  static const TextStyle label = TextStyle(color: textMid, fontSize: 12, fontWeight: FontWeight.w500);
  static const TextStyle labelSm = TextStyle(color: textMid, fontSize: 11, fontWeight: FontWeight.w500);
  static const TextStyle caption = TextStyle(color: textLo, fontSize: 10, fontWeight: FontWeight.w500);
  static const TextStyle sectionLabel = TextStyle(
    color: textMid, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1,
  );

  // === Responsive helpers ===
  static double hPad(BuildContext c) =>
      MediaQuery.of(c).size.width < 360 ? 16 : 20;
  static double scale(BuildContext c, double base) {
    final w = MediaQuery.of(c).size.width;
    if (w < 360) return base * 0.92;
    if (w > 430) return base * 1.04;
    return base;
  }

  // === Shadows ===
  static List<BoxShadow> cardShadow = [
    BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 12, offset: const Offset(0, 4)),
  ];
  static List<BoxShadow> glowShadow(Color c) => [
    BoxShadow(color: c.withValues(alpha: 0.28), blurRadius: 16, offset: const Offset(0, 6)),
  ];
}

/// Dutch weekday+date formatter used across the instructor panel.
String formatDutchDate(DateTime d) {
  const days = ['Maandag', 'Dinsdag', 'Woensdag', 'Donderdag', 'Vrijdag', 'Zaterdag', 'Zondag'];
  const months = ['januari', 'februari', 'maart', 'april', 'mei', 'juni',
                  'juli', 'augustus', 'september', 'oktober', 'november', 'december'];
  return '${days[d.weekday - 1]} ${d.day} ${months[d.month - 1]}';
}
