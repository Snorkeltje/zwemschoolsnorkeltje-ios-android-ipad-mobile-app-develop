/// Booking rules — Walter 2026-04-22.
///
/// Two facets:
///   1. Extra lessons: any customer can book up to 14 days ahead.
///   2. Fixed-slot customers: their permanent slot must always have at least
///      14 days of forward bookings so no-one else can take their regular spot.
class BookingRules {
  BookingRules._();

  /// Maximum days in advance an extra (ad-hoc) lesson can be booked.
  static const int maxExtraDaysAhead = 14;

  /// How far ahead the system auto-books fixed-slot customers
  /// (so the slot is "owned" and other customers see it as taken).
  static const int fixedSlotForwardWindow = 14;

  /// True if a date is within the 14-day extra-lesson booking window.
  static bool isWithinExtraWindow(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(DateTime(now.year, now.month, now.day)).inDays;
    return diff >= 0 && diff <= maxExtraDaysAhead;
  }

  /// Days remaining inside the extra-lesson window (0 = today is last day, -1 = past).
  static int extraDaysRemaining(DateTime date) {
    final now = DateTime.now();
    return date.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  /// User-friendly explanation of the 14-day rule.
  static const String extraRuleNL =
      'U kunt extra lessen tot 14 dagen vooruit boeken.';
  static const String fixedRuleNL =
      'Vaste lesplaatsen worden automatisch 14 dagen vooruit gereserveerd.';
}
