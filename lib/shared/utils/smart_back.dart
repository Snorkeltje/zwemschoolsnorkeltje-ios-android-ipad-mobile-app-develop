import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/route_names.dart';

/// Universal back navigation that never fails.
/// - Pops if there's a previous route
/// - Otherwise navigates to home (parent) or instructor home (instructor)
/// Use this instead of `context.pop()` on every custom back button.
void smartBack(BuildContext context, {String? fallbackRouteName}) {
  final router = GoRouter.of(context);
  if (router.canPop()) {
    router.pop();
    return;
  }
  // No route to pop — fallback to home based on current location
  final location = GoRouterState.of(context).uri.path;
  final isInstructor = location.startsWith('/instructor');
  final fallback = fallbackRouteName ??
      (isInstructor ? RouteNames.instructorHome : RouteNames.home);
  context.goNamed(fallback);
}
