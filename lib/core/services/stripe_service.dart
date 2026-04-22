import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

/// Central Stripe service.
/// Call [StripeService.init] once at app startup AFTER dotenv is loaded.
class StripeService {
  StripeService._();

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    final pk = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
    if (pk.isEmpty || pk.contains('YOUR_KEY')) {
      debugPrint('⚠️ Stripe publishable key not set — skipping init.');
      return;
    }
    try {
      Stripe.publishableKey = pk;
      final merchantId = dotenv.env['STRIPE_MERCHANT_IDENTIFIER'];
      if (merchantId != null && merchantId.isNotEmpty) {
        Stripe.merchantIdentifier = merchantId;
      }
      await Stripe.instance.applySettings();
      _initialized = true;
      debugPrint('✅ Stripe initialised (${pk.startsWith('pk_test_') ? 'TEST' : 'LIVE'} mode)');
    } catch (e) {
      debugPrint('⚠️ Stripe init failed: $e');
    }
  }

  static bool get isEnabled => _initialized;
}
