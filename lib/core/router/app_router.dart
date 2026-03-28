import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/booking/presentation/screens/booking_type_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // === AUTH ROUTES ===
      GoRoute(
        path: '/',
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // === MAIN APP (with bottom nav shell) ===
      ShellRoute(
        builder: (context, state, child) {
          return ScaffoldWithBottomNav(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: RouteNames.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/book',
            name: RouteNames.bookLesson,
            builder: (context, state) => const BookingTypeScreen(),
          ),
          GoRoute(
            path: '/cards',
            name: RouteNames.myPunchCards,
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Mijn Knipkaarten')),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: RouteNames.profile,
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Profiel')),
            ),
          ),
        ],
      ),

      // === BOOKING FLOW ===
      GoRoute(
        path: '/booking/summary',
        name: RouteNames.bookingSummary,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Boekingsoverzicht')),
        ),
      ),
      GoRoute(
        path: '/booking/success',
        name: RouteNames.bookingSuccess,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Boeking Bevestigd!')),
        ),
      ),

      // === NOTIFICATIONS ===
      GoRoute(
        path: '/notifications',
        name: RouteNames.notifications,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Meldingen')),
        ),
      ),
    ],
  );
});

/// Bottom navigation shell for main app screens
class ScaffoldWithBottomNav extends StatelessWidget {
  final Widget child;

  const ScaffoldWithBottomNav({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Thuis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Boeken',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_outlined),
            activeIcon: Icon(Icons.credit_card),
            label: 'Kaarten',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profiel',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/book')) return 1;
    if (location.startsWith('/cards')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed(RouteNames.home);
        break;
      case 1:
        context.goNamed(RouteNames.bookLesson);
        break;
      case 2:
        context.goNamed(RouteNames.myPunchCards);
        break;
      case 3:
        context.goNamed(RouteNames.profile);
        break;
    }
  }
}
