import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/wallet_model.dart';

/// Real Supabase-backed wallet repository.
/// Uses `credit_vouchers` + `voucher_transactions` tables (RLS-scoped to current user).
class WalletRepository {
  WalletRepository(this._client);
  final SupabaseClient _client;

  /// Returns the user's combined wallet balance (sum across vouchers).
  /// Walter spec: customers see ONE balance, regardless of which voucher generated it.
  Future<WalletBalance> fetchBalance(String userId) async {
    final rows = await _client
        .from('credit_vouchers')
        .select('current_balance_cents, created_at')
        .eq('parent_id', userId);
    if (rows.isEmpty) {
      return WalletBalance(amount: 0, updatedAt: DateTime.now());
    }
    int totalCents = 0;
    DateTime latest = DateTime.fromMillisecondsSinceEpoch(0);
    for (final r in rows) {
      totalCents += (r['current_balance_cents'] as int);
      final t = DateTime.tryParse(r['created_at'] as String? ?? '');
      if (t != null && t.isAfter(latest)) latest = t;
    }
    return WalletBalance(
      amount: totalCents / 100.0,
      updatedAt: latest.millisecondsSinceEpoch == 0 ? DateTime.now() : latest,
    );
  }

  /// Returns recent transactions across all of the user's vouchers, newest first.
  Future<List<WalletTransaction>> fetchTransactions(String userId, {int limit = 50}) async {
    final rows = await _client
        .from('voucher_transactions')
        .select('id, amount_cents, description, created_at, voucher_id, credit_vouchers!inner(parent_id)')
        .eq('credit_vouchers.parent_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);
    return rows.map<WalletTransaction>((r) {
      final cents = r['amount_cents'] as int;
      final amount = cents / 100.0;
      return WalletTransaction(
        id: r['id'] as String,
        type: _typeFromAmount(cents, r['description'] as String?),
        amount: amount,
        description: (r['description'] as String?) ?? '',
        date: DateTime.parse(r['created_at'] as String),
      );
    }).toList();
  }

  WalletTxType _typeFromAmount(int cents, String? desc) {
    final d = (desc ?? '').toLowerCase();
    if (d.contains('terug') || d.contains('refund')) return WalletTxType.refund;
    if (d.contains('correctie') || d.contains('adjust')) return WalletTxType.adjustment;
    return cents >= 0 ? WalletTxType.topUp : WalletTxType.lessonDebit;
  }

  /// Add a top-up voucher and link the iDEAL paymentIntent id.
  Future<void> recordTopUp({
    required String userId,
    required int payAmountCents,
    required int balanceCents,
    String? paymentIntentId,
  }) async {
    final voucher = await _client
        .from('credit_vouchers')
        .insert({
          'parent_id': userId,
          'initial_amount_cents': payAmountCents,
          'bonus_cents': balanceCents - payAmountCents,
          'current_balance_cents': balanceCents,
          'stripe_payment_intent_id': paymentIntentId,
        })
        .select('id')
        .single();
    await _client.from('voucher_transactions').insert({
      'voucher_id': voucher['id'],
      'amount_cents': balanceCents,
      'description': 'Tegoed opgewaardeerd via iDEAL',
    });
  }

  /// Deduct lesson cost from oldest voucher with sufficient balance.
  /// Returns false if insufficient total balance.
  Future<bool> debitLesson({
    required String userId,
    required int costCents,
    required String description,
    String? reservationId,
  }) async {
    final vouchers = await _client
        .from('credit_vouchers')
        .select('id, current_balance_cents')
        .eq('parent_id', userId)
        .gt('current_balance_cents', 0)
        .order('created_at', ascending: true);
    var remaining = costCents;
    for (final v in vouchers) {
      if (remaining <= 0) break;
      final bal = v['current_balance_cents'] as int;
      final take = bal >= remaining ? remaining : bal;
      await _client
          .from('credit_vouchers')
          .update({'current_balance_cents': bal - take})
          .eq('id', v['id']);
      await _client.from('voucher_transactions').insert({
        'voucher_id': v['id'],
        'reservation_id': reservationId,
        'amount_cents': -take,
        'description': description,
      });
      remaining -= take;
    }
    return remaining == 0;
  }
}
