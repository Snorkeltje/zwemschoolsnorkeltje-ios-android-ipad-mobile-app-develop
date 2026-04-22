import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  SupabaseClient? get _client => SupabaseService.client;

  User? get currentUser => _client?.auth.currentUser;
  Session? get currentSession => _client?.auth.currentSession;
  bool get isSignedIn => currentUser != null;

  Stream<AuthState> get onAuthChange =>
      _client?.auth.onAuthStateChange ?? const Stream<AuthState>.empty();

  /// Sign in with email + password.
  /// Returns the authenticated user or throws.
  Future<User> signIn({required String email, required String password}) async {
    final c = _client;
    if (c == null) {
      throw const AuthException('Supabase niet geconfigureerd');
    }
    final res = await c.auth.signInWithPassword(email: email, password: password);
    final user = res.user;
    if (user == null) {
      throw const AuthException('Login mislukt');
    }
    return user;
  }

  /// Sign up. Profile row is created automatically by the server-side trigger
  /// `handle_new_user` using metadata passed here (bypasses RLS).
  Future<User> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    String? city,
    String role = 'parent',
  }) async {
    final c = _client;
    if (c == null) {
      throw const AuthException('Supabase niet geconfigureerd');
    }
    final res = await c.auth.signUp(
      email: email,
      password: password,
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'role': role,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        if (city != null && city.isNotEmpty) 'city': city,
      },
    );
    final user = res.user;
    if (user == null) {
      throw const AuthException('Registratie mislukt');
    }

    // Ensure we're signed in (needed for fetchProfile that follows)
    if (c.auth.currentSession == null) {
      try {
        await c.auth.signInWithPassword(email: email, password: password);
      } catch (_) {}
    }

    return user;
  }

  Future<void> signOut() async {
    await _client?.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    final c = _client;
    if (c == null) return;
    await c.auth.resetPasswordForEmail(email);
  }

  /// Fetch user's profile (role, name, etc.)
  Future<Map<String, dynamic>?> fetchProfile() async {
    final c = _client;
    final uid = currentUser?.id;
    if (c == null || uid == null) return null;
    final res = await c.from('profiles').select().eq('id', uid).maybeSingle();
    return res;
  }
}
