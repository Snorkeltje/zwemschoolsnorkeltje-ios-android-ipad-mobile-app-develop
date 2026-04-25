import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/utils/smart_back.dart';
import '../../../wallet/data/models/wallet_model.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';

/// iDEAL checkout screen.
///
/// Walter 2026-04-22:
///  - Skip the customer-detail step before payment.
///  - Pay-per-lesson: customer covers transaction fee (~€0.39 + 1.4%).
///  - Top-up: no transaction fee passed on (encourage larger packages).
///  - VAT 9% baked into lesson prices (not added on top).
class StripePaymentScreen extends ConsumerStatefulWidget {
  final double? amount;
  final double? balanceAmount;
  final String? description;
  final bool isTopUp;
  final bool isLessonPayPerUse;

  const StripePaymentScreen({
    super.key,
    this.amount,
    this.balanceAmount,
    this.description,
    this.isTopUp = false,
    this.isLessonPayPerUse = false,
  });

  @override
  ConsumerState<StripePaymentScreen> createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends ConsumerState<StripePaymentScreen> {
  bool _processing = false;
  String _bank = 'ING';

  static const _banks = ['ING', 'ABN AMRO', 'Rabobank', 'SNS', 'ASN', 'Knab', 'Bunq', 'Triodos'];

  double get _baseAmount => widget.amount ?? 39.0;

  /// Stripe iDEAL ~€0.39 fixed + 1.4% — only charged for pay-per-lesson.
  double get _transactionFee =>
      widget.isLessonPayPerUse ? (0.39 + _baseAmount * 0.014) : 0.0;

  double get _totalAmount => _baseAmount + _transactionFee;

  String _euro(double v) => '€${v.toStringAsFixed(2)}';

  Future<void> _payNow() async {
    HapticFeedback.mediumImpact();
    setState(() => _processing = true);
    // Simulated iDEAL redirect.
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    if (widget.isTopUp && widget.balanceAmount != null) {
      ref.read(walletProvider.notifier).topUp(widget.balanceAmount!);
      ref.read(walletTxProvider.notifier).add(WalletTransaction(
        id: 't${DateTime.now().millisecondsSinceEpoch}',
        type: WalletTxType.topUp,
        amount: widget.balanceAmount!,
        description: 'Tegoed opgewaardeerd via iDEAL ($_bank)',
        date: DateTime.now(),
      ));
    }
    if (!mounted) return;
    setState(() => _processing = false);
    _showSuccess();
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF27AE60).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Color(0xFF27AE60), size: 40),
            ),
            const SizedBox(height: 16),
            const Text('Betaling gelukt',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 6),
            Text(
              widget.isTopUp && widget.balanceAmount != null
                  ? '${_euro(widget.balanceAmount!)} toegevoegd aan uw tegoed'
                  : 'Uw les is bevestigd',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7B94)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0365C4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  smartBack(context);
                },
                child: const Text('Klaar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => smartBack(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F7FC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.chevron_left, color: Color(0xFF1A1A2E), size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Betalen met iDEAL',
                        style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                  Image.asset('assets/images/snorkeltje_logo.svg.png',
                      height: 28,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.lock, color: Color(0xFF8E9BB3), size: 20)),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount summary card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.description ?? 'Betaling',
                            style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 14),
                          _row('Bedrag', _euro(_baseAmount)),
                          if (widget.isLessonPayPerUse) ...[
                            const SizedBox(height: 6),
                            _row('Transactiekosten', _euro(_transactionFee), color: const Color(0xFF8E9BB3)),
                            const SizedBox(height: 6),
                            const Text(
                              'Tip: Koop tegoed om transactiekosten te vermijden.',
                              style: TextStyle(color: Color(0xFFFF5C00), fontSize: 11, fontWeight: FontWeight.w500),
                            ),
                          ],
                          if (widget.isTopUp && widget.balanceAmount != null) ...[
                            const SizedBox(height: 6),
                            _row('U ontvangt op uw tegoed',
                                _euro(widget.balanceAmount!),
                                color: const Color(0xFF27AE60)),
                          ],
                          const SizedBox(height: 10),
                          Container(height: 1, color: const Color(0xFFE5E7EB)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text('Totaal',
                                  style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 15, fontWeight: FontWeight.w700)),
                              const Spacer(),
                              Text(_euro(_totalAmount),
                                  style: const TextStyle(color: Color(0xFF0365C4), fontSize: 22, fontWeight: FontWeight.w800)),
                            ],
                          ),
                          if (!widget.isTopUp) ...[
                            const SizedBox(height: 4),
                            const Text('Inclusief 9% BTW',
                                style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Bank picker
                    const Text('Kies uw bank',
                        style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        children: List.generate(_banks.length, (i) {
                          final bank = _banks[i];
                          final selected = bank == _bank;
                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() => _bank = bank);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: i == _banks.length - 1
                                      ? BorderSide.none
                                      : const BorderSide(color: Color(0xFFF0F4FA)),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36, height: 36,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEF7FF),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.account_balance, size: 18, color: Color(0xFF0365C4)),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(bank,
                                        style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w600)),
                                  ),
                                  Container(
                                    width: 22, height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selected ? const Color(0xFF0365C4) : const Color(0xFFE0E5EC),
                                        width: 2,
                                      ),
                                      color: selected ? const Color(0xFF0365C4) : Colors.transparent,
                                    ),
                                    child: selected
                                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Security note
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF7FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.lock, size: 16, color: Color(0xFF0365C4)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Veilige betaling via iDEAL. Wij slaan geen bankgegevens op.',
                              style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 12, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Pay button
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.04))),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0365C4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _processing ? null : _payNow,
                  child: _processing
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lock, color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Text('Betaal ${_euro(_totalAmount)}',
                                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {Color? color}) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: Color(0xFF6B7B94), fontSize: 13)),
        ),
        Text(value,
            style: TextStyle(
              color: color ?? const Color(0xFF1A1A2E),
              fontSize: 14, fontWeight: FontWeight.w600,
            )),
      ],
    );
  }
}
