import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/supabase_service.dart';
import '../../data/auth_service.dart';
import '../../data/models/child_model.dart';
import '../../data/models/user_model.dart';

/// Auth state holding the current user
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    bool clearUser = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Auth state notifier — backed by Supabase when configured, otherwise mock.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _hydrate();
  }

  final _auth = AuthService.instance;

  /// If already signed in at app startup, hydrate user.
  Future<void> _hydrate() async {
    if (!SupabaseService.isEnabled) return;
    if (!_auth.isSignedIn) return;
    try {
      final profile = await _auth.fetchProfile();
      if (profile != null) {
        state = AuthState(user: _profileToUser(profile));
      }
    } catch (_) {}
  }

  UserModel _profileToUser(Map<String, dynamic> p) {
    final roleStr = (p['role'] as String?) ?? 'parent';
    final role = roleStr == 'instructor'
        ? UserRole.instructor
        : roleStr == 'admin'
            ? UserRole.admin
            : UserRole.customer;
    return UserModel(
      id: p['id'] as String,
      email: p['email'] as String? ?? '',
      firstName: p['first_name'] as String? ?? '',
      lastName: p['last_name'] as String? ?? '',
      phone: p['phone'] as String?,
      role: role,
      profileImage: p['avatar_url'] as String?,
      children: const [],
    );
  }

  /// Sign in with email + password. REAL Supabase only — no mock.
  /// Fails if user has not registered yet.
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    if (!SupabaseService.isEnabled) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Server niet bereikbaar. Probeer later opnieuw.',
      );
      return false;
    }
    try {
      await _auth.signIn(email: email, password: password);
      final profile = await _auth.fetchProfile();
      if (profile == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Account niet gevonden. Maak eerst een account aan.',
        );
        return false;
      }
      state = AuthState(user: _profileToUser(profile));
      return true;
    } catch (e, st) {
      debugPrint('🔴 LOGIN ERROR: $e');
      debugPrint('🔴 STACK: $st');
      state = state.copyWith(
        isLoading: false,
        errorMessage: _friendlyError(e),
      );
      return false;
    }
  }

  /// Register new parent account. REAL Supabase only.
  /// After success, user is auto-logged in (email is auto-confirmed).
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    if (!SupabaseService.isEnabled) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Server niet bereikbaar. Probeer later opnieuw.',
      );
      return false;
    }
    try {
      // signUp also auto-signs-in + trigger creates profile row
      await _auth.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        role: 'parent',
      );

      // Give the trigger a tiny moment to commit before we read
      Map<String, dynamic>? profile;
      for (var i = 0; i < 3; i++) {
        profile = await _auth.fetchProfile();
        if (profile != null) break;
        await Future<void>.delayed(const Duration(milliseconds: 300));
      }

      if (profile != null) {
        state = AuthState(user: _profileToUser(profile));
        return true;
      }

      // Signup OK but profile not visible yet — tell user to log in manually
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Account aangemaakt! Log nu in met uw e-mail en wachtwoord.',
      );
      return false;
    } catch (e, st) {
      debugPrint('🔴 REGISTER ERROR: $e');
      debugPrint('🔴 STACK: $st');
      state = state.copyWith(isLoading: false, errorMessage: _friendlyError(e));
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (_) {}
    state = const AuthState();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.resetPassword(email);
    } catch (_) {}
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  String _friendlyError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('invalid login') || msg.contains('invalid credentials')) {
      return 'E-mail of wachtwoord is onjuist.';
    }
    if (msg.contains('already registered') ||
        msg.contains('already exists') ||
        msg.contains('user already') ||
        msg.contains('duplicate key')) {
      return 'Dit e-mailadres is al in gebruik. Log in of gebruik een ander e-mailadres.';
    }
    if (msg.contains('rate limit') || msg.contains('too many')) {
      return 'Te veel pogingen. Wacht een minuut en probeer opnieuw.';
    }
    if (msg.contains('invalid email') || msg.contains('email address')) {
      return 'Vul een geldig e-mailadres in.';
    }
    if (msg.contains('weak password') ||
        msg.contains('password should be') ||
        msg.contains('password') && msg.contains('char')) {
      return 'Wachtwoord moet minimaal 6 tekens zijn.';
    }
    if (msg.contains('network') || msg.contains('socket') ||
        msg.contains('failed host') || msg.contains('connection')) {
      return 'Geen internetverbinding. Controleer je netwerk.';
    }
    if (msg.contains('confirmation') || msg.contains('email not confirmed')) {
      return 'Controleer je e-mail om je account te bevestigen.';
    }
    // Surface the raw error in debug mode
    return kDebugMode ? 'Fout: $msg' : 'Er ging iets mis. Probeer het opnieuw.';
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});

final childrenProvider = Provider<List<ChildModel>>((ref) {
  return ref.watch(authProvider).user?.children ?? [];
});
