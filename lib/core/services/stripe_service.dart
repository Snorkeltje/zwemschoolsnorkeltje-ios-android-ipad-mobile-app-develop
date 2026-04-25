import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

/// Central Stripe service.
/// Production architecture:
///   1. App calls Supabase Edge Function `create-payment-intent`
///   2. Edge Function uses STRIPE_SECRET_KEY (server-only) to create PaymentIntent
///   3. Edge Function returns client_secret
///   4. App opens Stripe PaymentSheet with client_secret → real iDEAL bank picker → real payment
class StripeService {
  StripeService._();

  static bool _initialized = false;
  static String _supabaseUrl = '';
  static String _supabaseAnonKey = '';

  static Future<void> init() async {
    if (_initialized) return;
    final pk = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
    _supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    _supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

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
      Stripe.urlScheme = 'snorkeltje'; // for iDEAL redirect back
      await Stripe.instance.applySettings();
      _initialized = true;
      debugPrint('✅ Stripe initialised (${pk.startsWith('pk_test_') ? 'TEST' : 'LIVE'} mode)');
    } catch (e) {
      debugPrint('⚠️ Stripe init failed: $e');
    }
  }

  static bool get isEnabled => _initialized;

  /// Calls our Supabase Edge Function to create a PaymentIntent.
  /// Returns the client_secret used to confirm the payment from the app.
  static Future<String> _createPaymentIntent({
    required double amount,
    required String description,
    Map<String, String>? metadata,
  }) async {
    if (_supabaseUrl.isEmpty) {
      throw StripeException(error: const LocalizedErrorMessage(
        code: FailureCode.Unknown,
        message: 'Supabase URL not configured',
      ));
    }
    final url = Uri.parse('$_supabaseUrl/functions/v1/create-payment-intent');
    final res = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_supabaseAnonKey',
        'apikey': _supabaseAnonKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'amount': amount,
        'currency': 'eur',
        'payment_method_types': ['ideal'],
        'description': description,
        'metadata': metadata ?? {},
      }),
    );
    if (res.statusCode != 200) {
      debugPrint('PaymentIntent error: ${res.statusCode} ${res.body}');
      throw StripeException(error: LocalizedErrorMessage(
        code: FailureCode.Failed,
        message: 'Payment server error (${res.statusCode})',
      ));
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return data['client_secret'] as String;
  }

  /// Open the Stripe PaymentSheet for an iDEAL payment.
  /// Throws on cancel/failure; returns when the payment is confirmed by the user
  /// (Stripe will then asynchronously notify success via webhook on the server).
  static Future<void> payIDEAL({
    required double amount,
    required String description,
    String? customerName,
    String? customerEmail,
    Map<String, String>? metadata,
  }) async {
    if (!_initialized) {
      throw StripeException(error: const LocalizedErrorMessage(
        code: FailureCode.Unknown,
        message: 'Stripe not initialised',
      ));
    }
    final clientSecret = await _createPaymentIntent(
      amount: amount,
      description: description,
      metadata: metadata,
    );

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Zwemschool Snorkeltje',
        style: ThemeMode.light,
        billingDetails: BillingDetails(
          name: customerName,
          email: customerEmail,
        ),
      ),
    );

    await Stripe.instance.presentPaymentSheet();
  }
}
