import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Central Supabase service.
/// Call [SupabaseService.init] once at app startup.
class SupabaseService {
  SupabaseService._();

  static Future<void> init() async {
    final url = dotenv.env['SUPABASE_URL'] ?? '';
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    if (url.isEmpty || anonKey.isEmpty || url.contains('YOUR_PROJECT')) {
      // Silently skip init if credentials are placeholders —
      // the app still runs in local-mock mode.
      return;
    }
    await Supabase.initialize(url: url, anonKey: anonKey);
  }

  /// Returns null when Supabase hasn't been initialised yet (local-mock mode).
  static SupabaseClient? get client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  static bool get isEnabled => client != null;

  static User? get currentUser => client?.auth.currentUser;
}
