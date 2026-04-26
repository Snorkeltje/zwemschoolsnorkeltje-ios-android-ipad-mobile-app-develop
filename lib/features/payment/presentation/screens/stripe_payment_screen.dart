import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart' show StripeException;
import 'package:go_router/go_router.dart';
import '../../../../core/services/stripe_service.dart';
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
  String? _error;

  double get _baseAmount => widget.amount ?? 39.0;

  /// Stripe iDEAL ~€0.39 fixed + 1.4% — only charged for pay-per-lesson.
  double get _transactionFee =>
      widget.isLessonPayPerUse ? (0.39 + _baseAmount * 0.014) : 0.0;

  double get _totalAmount => _baseAmount + _transactionFee;

  String _euro(double v) => '€${v.toStringAsFixed(2)}';

  Future<void> _payNow() async {
    HapticFeedback.mediumImpact();
    setState(() {
      _processing = true;
      _error = null;
    });

    try {
      // Real Stripe iDEAL flow — opens native PaymentSheet → bank picker → bank app → return.
      await StripeService.payIDEAL(
        amount: _totalAmount,
        description: widget.description ?? 'Zwemschool Snorkeltje betaling',
        metadata: {
          'type': widget.isTopUp ? 'wallet_topup' : 'lesson_payment',
          if (widget.isTopUp && widget.balanceAmount != null)
            'balance_credit': widget.balanceAmount!.toStringAsFixed(2),
        },
      );

      // PaymentSheet returned without throwing → user completed iDEAL.
      if (!mounted) return;
      if (widget.isTopUp && widget.balanceAmount != null) {
        await ref.read(walletProvider.notifier).recordTopUp(
          payAmountCents: (widget.amount! * 100).round(),
          balanceCents: (widget.balanceAmount! * 100).round(),
        );
      }
      if (!mounted) return;
      setState(() => _processing = false);
      _showSuccess();
    } on StripeException catch (e) {
      if (!mounted) return;
      setState(() {
        _processing = false;
        _error = e.error.localizedMessage ?? e.error.message ?? 'Betaling geannuleerd';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _processing = false;
        _error = 'Er ging iets mis: $e';
      });
    }
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

                    // iDEAL info
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF7FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.account_balance, size: 22, color: Color(0xFF0365C4)),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('iDEAL',
                                    style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                                SizedBox(height: 2),
                                Text('U kiest uw bank na "Betalen"',
                                    style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.check_circle, color: Color(0xFF27AE60), size: 22),
                        ],
                      ),
                    ),

                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE74C3C).withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, size: 16, color: Color(0xFFE74C3C)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(_error!,
                                  style: const TextStyle(color: Color(0xFFE74C3C), fontSize: 12, height: 1.4)),
                            ),
                          ],
                        ),
                      ),
                    ],

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
                              'Veilige betaling via Stripe + iDEAL. Wij slaan geen bankgegevens op.',
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
