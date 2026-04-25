import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/services/firebase_service.dart';

/// Wraps the app in a listener that shows a top-banner popup when an
/// FCM push arrives while the app is in the foreground.
/// Walter 2026-04-22: notifications must also appear as pop-up on mobile.
class PushNotificationListener extends StatefulWidget {
  final Widget child;
  const PushNotificationListener({super.key, required this.child});

  @override
  State<PushNotificationListener> createState() => _PushNotificationListenerState();
}

class _PushNotificationListenerState extends State<PushNotificationListener> {
  OverlayEntry? _entry;

  @override
  void initState() {
    super.initState();
    FirebaseService.listenForegroundMessages(_onMessage);
  }

  void _onMessage(RemoteMessage msg) {
    final title = msg.notification?.title ?? msg.data['title']?.toString() ?? 'Zwemschool Snorkeltje';
    final body = msg.notification?.body ?? msg.data['body']?.toString() ?? '';
    if (body.isEmpty) return;
    HapticFeedback.lightImpact();
    _showBanner(title, body);
  }

  void _showBanner(String title, String body) {
    _entry?.remove();
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;
    _entry = OverlayEntry(
      builder: (_) => _PushBanner(
        title: title,
        body: body,
        onDismiss: _dismiss,
      ),
    );
    overlay.insert(_entry!);
    Future.delayed(const Duration(seconds: 5), _dismiss);
  }

  void _dismiss() {
    _entry?.remove();
    _entry = null;
  }

  @override
  void dispose() {
    _dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _PushBanner extends StatefulWidget {
  final String title, body;
  final VoidCallback onDismiss;
  const _PushBanner({required this.title, required this.body, required this.onDismiss});

  @override
  State<_PushBanner> createState() => _PushBannerState();
}

class _PushBannerState extends State<_PushBanner> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    _slide = Tween<Offset>(begin: const Offset(0, -1.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    await _ctrl.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: SlideTransition(
        position: _slide,
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0365C4).withValues(alpha: 0.4),
                      blurRadius: 24, offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.notifications_active, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.title,
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text(widget.body,
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.95), fontSize: 12, height: 1.3),
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 18),
                      onPressed: _close,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
