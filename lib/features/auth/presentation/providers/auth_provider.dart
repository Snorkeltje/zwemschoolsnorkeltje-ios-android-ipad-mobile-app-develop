import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/models/child_model.dart';

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
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Auth state notifier for managing authentication
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  /// Mock login - replace with real API call
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock user for development
      final mockUser = UserModel(
        id: 'usr_001',
        email: email,
        firstName: 'Sami',
        lastName: 'Murtaza',
        phone: '+31 6 12345678',
        role: UserRole.customer,
        children: [
          ChildModel(
            id: 'child_001',
            name: 'Emma Murtaza',
            dateOfBirth: DateTime(2019, 5, 15),
            currentLevel: 'Beginner',
          ),
          ChildModel(
            id: 'child_002',
            name: 'Noah Murtaza',
            dateOfBirth: DateTime(2021, 9, 3),
            currentLevel: 'Starter',
          ),
        ],
      );

      state = AuthState(user: mockUser);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Inloggen mislukt. Controleer uw gegevens.',
      );
    }
  }

  void logout() {
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Main auth state provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

/// Convenience provider for current user
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});

/// Convenience provider for children list
final childrenProvider = Provider<List<ChildModel>>((ref) {
  return ref.watch(authProvider).user?.children ?? [];
});
