import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppPopupType { error, success, warning, info }

/// Premium animated popup for success/error/info messages.
/// Used for login errors ("email already registered"), success confirmations,
/// warnings, etc. Has scale+fade entry animation, haptic feedback,
/// and auto-dismiss option.
class AppPopup extends StatefulWidget {
  final AppPopupType type;
  final String title;
  final String message;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;
  final Duration? autoDismissAfter;

  const AppPopup({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimary,
    this.onSecondary,
    this.autoDismissAfter,
  });

  static Future<void> show(
    BuildContext context, {
    required AppPopupType type,
    required String title,
    required String message,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimary,
    VoidCallback? onSecondary,
    Duration? autoDismissAfter,
  }) {
    // Haptic feedback matching type
    switch (type) {
      case AppPopupType.error:
        HapticFeedback.heavyImpact();
        break;
      case AppPopupType.success:
        HapticFeedback.lightImpact();
        break;
      case AppPopupType.warning:
        HapticFeedback.mediumImpact();
        break;
      case AppPopupType.info:
        HapticFeedback.selectionClick();
        break;
    }

    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'popup',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (ctx, a1, a2) => AppPopup(
        type: type,
        title: title,
        message: message,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        onPrimary: onPrimary,
        onSecondary: onSecondary,
        autoDismissAfter: autoDismissAfter,
      ),
      transitionBuilder: (ctx, a1, a2, child) {
        // Scale + fade with subtle bounce
        final curved = CurvedAnimation(parent: a1, curve: Curves.easeOutBack);
        return FadeTransition(
          opacity: CurvedAnimation(parent: a1, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<AppPopup> createState() => _AppPopupState();
}

class _AppPopupState extends State<AppPopup> with SingleTickerProviderStateMixin {
  late final AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    if (widget.autoDismissAfter != null) {
      Future.delayed(widget.autoDismissAfter!, () {
        if (mounted) Navigator.of(context).maybePop();
      });
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  ({List<Color> gradient, Color accent, IconData icon, String label}) get _theme {
    switch (widget.type) {
      case AppPopupType.error:
        return (
          gradient: const [Color(0xFFE74C3C), Color(0xFFC0392B)],
          accent: const Color(0xFFE74C3C),
          icon: Icons.close_rounded,
          label: 'Fout',
        );
      case AppPopupType.success:
        return (
          gradient: const [Color(0xFF27AE60), Color(0xFF1E8C4E)],
          accent: const Color(0xFF27AE60),
          icon: Icons.check_rounded,
          label: 'Gelukt',
        );
      case AppPopupType.warning:
        return (
          gradient: const [Color(0xFFF5A623), Color(0xFFFF5C00)],
          accent: const Color(0xFFF5A623),
          icon: Icons.warning_amber_rounded,
          label: 'Let op',
        );
      case AppPopupType.info:
        return (
          gradient: const [Color(0xFF0365C4), Color(0xFF00C1FF)],
          accent: const Color(0xFF0365C4),
          icon: Icons.info_outline_rounded,
          label: 'Informatie',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _theme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 380),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: theme.accent.withValues(alpha: 0.2),
                  blurRadius: 48,
                  offset: const Offset(0, 24),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Decorative corner swirl
                Positioned(
                  top: -30, right: -30,
                  child: IgnorePointer(
                    child: Container(
                      width: 140, height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [theme.accent.withValues(alpha: 0.1), Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Animated icon
                      AnimatedBuilder(
                        animation: _iconController,
                        builder: (_, __) {
                          final v = Curves.elasticOut.transform(_iconController.value.clamp(0, 1));
                          return Transform.scale(
                            scale: v,
                            child: Container(
                              width: 72, height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: theme.gradient,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.accent.withValues(alpha: 0.35),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(theme.icon, color: Colors.white, size: 38),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // Label pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          theme.label.toUpperCase(),
                          style: TextStyle(
                            color: theme.accent,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Title
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF1A1A2E),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Message
                      Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF6B7B94),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Buttons
                      if (widget.secondaryButtonText != null)
                        Row(
                          children: [
                            Expanded(
                              child: _SecondaryButton(
                                text: widget.secondaryButtonText!,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  widget.onSecondary?.call();
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _PrimaryButton(
                                text: widget.primaryButtonText ?? 'OK',
                                gradient: theme.gradient,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  widget.onPrimary?.call();
                                },
                              ),
                            ),
                          ],
                        )
                      else
                        SizedBox(
                          width: double.infinity,
                          child: _PrimaryButton(
                            text: widget.primaryButtonText ?? 'OK',
                            gradient: theme.gradient,
                            onTap: () {
                              Navigator.of(context).pop();
                              widget.onPrimary?.call();
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final List<Color> gradient;
  final VoidCallback onTap;
  const _PrimaryButton({required this.text, required this.gradient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.last.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _SecondaryButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FC),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF4A5568),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
