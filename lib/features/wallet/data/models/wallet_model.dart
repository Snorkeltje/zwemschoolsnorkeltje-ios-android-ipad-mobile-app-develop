/// Unified wallet/balance model — replaces the old per-lesson-type punch card.
/// Parents have ONE balance used for any lesson type (1-on-1, 1-on-2, 1-on-3).
class WalletBalance {
  /// Current available balance in euro.
  final double amount;
  /// Last top-up / deduction timestamp.
  final DateTime updatedAt;

  const WalletBalance({required this.amount, required this.updatedAt});

  String get formatted => '€${amount.toStringAsFixed(2)}';

  WalletBalance copyWith({double? amount, DateTime? updatedAt}) =>
      WalletBalance(
        amount: amount ?? this.amount,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}

/// One wallet transaction — top-up (credit) or lesson-booking (debit) or refund.
class WalletTransaction {
  final String id;
  final WalletTxType type;
  /// Positive for credit, negative for debit — displayed with sign in UI.
  final double amount;
  final String description;
  final DateTime date;
  /// Optional reference — e.g. lesson id for debits, iDEAL txn id for credits.
  final String? reference;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
    this.reference,
  });

  String get signed =>
      '${amount >= 0 ? '+' : '-'}€${amount.abs().toStringAsFixed(2)}';
}

enum WalletTxType { topUp, lessonDebit, refund, adjustment }

/// Top-up package — Walter's pricing: small bonus on top-up encourages larger packages.
class WalletPackage {
  /// Amount the customer pays (in euro).
  final int payAmount;
  /// Balance the customer receives (pay + bonus).
  final double balanceAmount;

  const WalletPackage({required this.payAmount, required this.balanceAmount});

  double get bonus => balanceAmount - payAmount;
  String get payFormatted => '€$payAmount';
  String get balanceFormatted => '€${balanceAmount.toStringAsFixed(balanceAmount.truncateToDouble() == balanceAmount ? 0 : 2)}';
}

/// Canonical package list per Walter's spec (2026-04-22).
const kWalletPackages = <WalletPackage>[
  WalletPackage(payAmount: 200, balanceAmount: 202),
  WalletPackage(payAmount: 400, balanceAmount: 405),
  WalletPackage(payAmount: 1000, balanceAmount: 1015),
];

/// Lesson pricing per Walter's spec (2026-04-22).
/// Deducted from wallet balance at booking time.
class LessonPricing {
  const LessonPricing._();
  static const double oneOnOne = 39.0;   // 1-op-1
  static const double oneOnTwo = 28.0;   // 1-op-2
  static const double oneOnThree = 22.0; // 1-op-3 (new)

  static double forType(String type) {
    switch (type) {
      case '1-op-1': return oneOnOne;
      case '1-op-2': return oneOnTwo;
      case '1-op-3': return oneOnThree;
      default: return oneOnOne;
    }
  }

  /// Dutch VAT — 9% on lessons.
  static const double vatRate = 0.09;
}
