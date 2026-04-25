import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/wallet_model.dart';

class WalletNotifier extends StateNotifier<WalletBalance> {
  WalletNotifier()
      : super(WalletBalance(amount: 164.50, updatedAt: DateTime.now()));

  /// Add funds (iDEAL top-up).
  void topUp(double amount) {
    state = state.copyWith(
      amount: state.amount + amount,
      updatedAt: DateTime.now(),
    );
  }

  /// Deduct lesson price. Returns false if insufficient funds.
  bool debitLesson(double price) {
    if (state.amount < price) return false;
    state = state.copyWith(
      amount: state.amount - price,
      updatedAt: DateTime.now(),
    );
    return true;
  }

  /// Refund (cancellation).
  void refund(double amount) {
    state = state.copyWith(
      amount: state.amount + amount,
      updatedAt: DateTime.now(),
    );
  }

  bool canAfford(double price) => state.amount >= price;
}

final walletProvider = StateNotifierProvider<WalletNotifier, WalletBalance>(
  (ref) => WalletNotifier(),
);

/// Transaction history.
class WalletTxNotifier extends StateNotifier<List<WalletTransaction>> {
  WalletTxNotifier()
      : super([
          WalletTransaction(
            id: 't1', type: WalletTxType.topUp, amount: 202,
            description: 'Tegoed opgewaardeerd',
            date: DateTime.now().subtract(const Duration(days: 2)),
            reference: 'iDEAL #TX83921',
          ),
          WalletTransaction(
            id: 't2', type: WalletTxType.lessonDebit, amount: -39,
            description: 'Les van Jan de Vries · 1-op-1',
            date: DateTime.now().subtract(const Duration(days: 1)),
            reference: 'Les #L1029',
          ),
          WalletTransaction(
            id: 't3', type: WalletTxType.lessonDebit, amount: -28,
            description: 'Les van Jan de Vries · 1-op-2',
            date: DateTime.now().subtract(const Duration(hours: 4)),
            reference: 'Les #L1030',
          ),
        ]);

  void add(WalletTransaction tx) {
    state = [tx, ...state];
  }
}

final walletTxProvider =
    StateNotifierProvider<WalletTxNotifier, List<WalletTransaction>>(
  (ref) => WalletTxNotifier(),
);
