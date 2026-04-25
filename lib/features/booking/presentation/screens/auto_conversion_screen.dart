import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

/// DEPRECATED — Walter 2026-04-22: auto-conversion removed.
/// Legacy route kept for backwards compatibility; redirects to wallet.
class AutoConversionScreen extends StatelessWidget {
  const AutoConversionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.goNamed(RouteNames.myPunchCards);
    });
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
