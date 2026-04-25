import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

/// Legacy route — redirects to the unified top-up screen.
/// Walter 2026-04-22: no more separate 1-op-1/1-op-2 packages.
class PurchasePunchCardScreen extends StatelessWidget {
  const PurchasePunchCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.goNamed(RouteNames.purchasePunchCard);
    });
    return const Scaffold(
      backgroundColor: Color(0xFFF4F7FC),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
