import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/wallet_model.dart';
import '../../data/wallet_repository.dart';

/// Real Supabase-backed wallet repository.
final walletRepoProvider = Provider<WalletRepository>(
  (_) => WalletRepository(Supabase.instance.client),
);

/// Current authenticated user id (null if logged out).
String? _userId() {
  return Supabase.instance.client.auth.currentUser?.id;
}

/// Wallet balance for the logged-in user. Returns €0 for guests.
class WalletNotifier extends AsyncNotifier<WalletBalance> {
  @override
  Future<WalletBalance> build() async {
    final id = _userId();
    if (id == null) return WalletBalance(amount: 0, updatedAt: DateTime.now());
    return ref.read(walletRepoProvider).fetchBalance(id);
  }

  Future<void> refresh() async {
    final id = _userId();
    if (id == null) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(walletRepoProvider).fetchBalance(id));
  }

  Future<bool> recordTopUp({
    required int payAmountCents,
    required int balanceCents,
    String? paymentIntentId,
  }) async {
    final id = _userId();
    if (id == null) return false;
    await ref.read(walletRepoProvider).recordTopUp(
      userId: id, payAmountCents: payAmountCents,
      balanceCents: balanceCents, paymentIntentId: paymentIntentId,
    );
    await refresh();
    ref.invalidate(walletTxProvider);
    return true;
  }

  Future<bool> debitLesson({
    required int costCents,
    required String description,
    String? reservationId,
  }) async {
    final id = _userId();
    if (id == null) return false;
    final ok = await ref.read(walletRepoProvider).debitLesson(
      userId: id, costCents: costCents,
      description: description, reservationId: reservationId,
    );
    await refresh();
    ref.invalidate(walletTxProvider);
    return ok;
  }
}

final walletProvider = AsyncNotifierProvider<WalletNotifier, WalletBalance>(
  WalletNotifier.new,
);

/// Live transaction history.
final walletTxProvider = FutureProvider<List<WalletTransaction>>((ref) async {
  final id = _userId();
  if (id == null) return const <WalletTransaction>[];
  return ref.read(walletRepoProvider).fetchTransactions(id);
});
