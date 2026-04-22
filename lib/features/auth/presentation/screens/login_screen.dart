import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/app_popup.dart';
import '../providers/auth_provider.dart';

enum _SwimSide { left, right }

class _SwimCharacter extends StatelessWidget {
  final _SwimSide side;
  final double size;
  const _SwimCharacter({required this.side, required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        width: size,
        height: size * 1.4,
        child: OverflowBox(
          alignment: side == _SwimSide.left
              ? Alignment.centerLeft
              : Alignment.centerRight,
          maxWidth: size * 2,
          maxHeight: size * 2 * (1350 / 1080),
          child: SvgPicture.asset(
            'assets/images/swim_characters.svg',
            width: size * 2,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isParent = true;
  bool _showPass = false;
  String _focusedField = '';
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // -- Colors --
  static const _blue = Color(0xFF0365C4);
  static const _blueLight = Color(0xFF0D7FE8);
  static const _orange = Color(0xFFFF5C00);
  static const _orangeLight = Color(0xFFF5A623);
  static const _darkText = Color(0xFF1A1A2E);
  static const _subtitleGrey = Color(0xFF6B7B94);
  static const _labelGrey = Color(0xFF4A5568);
  static const _inactive = Color(0xFFA0AEC0);
  static const _borderDefault = Color(0xFFE8ECF4);
  static const _toggleBg = Color(0xFFF0F4FA);

  @override
  Widget build(BuildContext context) {
    final mainColor = _isParent ? _blue : _orange;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top linear gradient (#F0F6FF -> white, 200px)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF0F6FF), Colors.white],
                ),
              ),
            ),
          ),

          // Decorative cyan radial gradient top-right
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x1400C1FF), Colors.transparent],
                ),
              ),
            ),
          ),

          // Swim characters - bottom-left
          Positioned(
            bottom: 100,
            left: -20,
            child: Opacity(
              opacity: 0.15,
              child: _SwimCharacter(side: _SwimSide.left, size: 100),
            ),
          ),
          // Swim characters - bottom-right
          Positioned(
            bottom: 80,
            right: -20,
            child: Opacity(
              opacity: 0.15,
              child: _SwimCharacter(side: _SwimSide.right, size: 100),
            ),
          ),

          // Main scrollable content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // Language toggle top-right
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _blue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _blue.withValues(alpha: 0.15),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.language, size: 14, color: _blue),
                            SizedBox(width: 6),
                            Text(
                              'NL',
                              style: TextStyle(
                                color: _blue,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Logo placeholder (72px top padding from language toggle area)
                    const SizedBox(height: 72),
                    Center(
                      child: SvgPicture.asset(
                        'assets/images/snorkeltje_logo.svg',
                        height: 80,
                        width: 80,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Role toggle: Ouder / Instructeur
                    Container(
                      decoration: BoxDecoration(
                        color: _toggleBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          _buildToggle(
                            isParent: true,
                            icon: Icons.person_rounded,
                            label: 'Ouder',
                            activeColor: _blue,
                          ),
                          _buildToggle(
                            isParent: false,
                            icon: Icons.work_rounded,
                            label: 'Instructeur',
                            activeColor: _orange,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Title
                    Text(
                      _isParent ? 'Welkom, Ouder!' : 'Instructeur Inloggen',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: _darkText,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Subtitle
                    Text(
                      _isParent
                          ? 'Boek lessen & volg de voortgang van uw kind'
                          : 'Beheer uw rooster & leerlingen',
                      style: const TextStyle(
                        color: _subtitleGrey,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Email field
                    _buildLabel('E-mailadres'),
                    const SizedBox(height: 6),
                    _buildInputField(
                      controller: _emailCtrl,
                      hint: 'naam@voorbeeld.nl',
                      icon: Icons.mail_outline,
                      fieldKey: 'email',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 16),

                    // Password field
                    _buildLabel('Wachtwoord'),
                    const SizedBox(height: 6),
                    _buildInputField(
                      controller: _passCtrl,
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      fieldKey: 'pass',
                      obscure: !_showPass,
                      suffix: GestureDetector(
                        onTap: () => setState(() => _showPass = !_showPass),
                        child: Icon(
                          _showPass
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: _inactive,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Forgot password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () =>
                            context.goNamed(RouteNames.forgotPassword),
                        child: Text(
                          'Wachtwoord vergeten?',
                          style: TextStyle(
                            color: mainColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Login button
                    GestureDetector(
                      onTap: _handleLogin,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: _isParent
                                ? [_blue, _blueLight]
                                : [_orange, _orangeLight],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: mainColor.withValues(alpha: 0.3),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _isParent
                              ? 'Inloggen als Ouder'
                              : 'Inloggen als Instructeur',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),

                    // Bottom section: register link or instructor-only text
                    if (_isParent) ...[
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Nieuw hier? ',
                            style: TextStyle(
                              color: _subtitleGrey,
                              fontSize: 13,
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                context.goNamed(RouteNames.registration),
                            child: const Text(
                              'Account aanmaken',
                              style: TextStyle(
                                color: _blue,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'Alleen voor gecertificeerde Snorkeltje instructeurs',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _inactive,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Footer
                    const Center(
                      child: Text(
                        'snorkeltje.nl',
                        style: TextStyle(
                          color: _blue,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;
    if (email.isEmpty || password.isEmpty) {
      await AppPopup.show(
        context,
        type: AppPopupType.warning,
        title: 'Vul alle velden in',
        message: 'E-mail en wachtwoord zijn beide verplicht om in te loggen.',
      );
      return;
    }
    final ok = await ref.read(authProvider.notifier).login(email, password);
    if (!mounted) return;
    if (ok) {
      final role = ref.read(authProvider).user?.role;
      if (role?.name == 'instructor') {
        context.goNamed(RouteNames.instructorHome);
      } else {
        context.goNamed(RouteNames.home);
      }
    } else {
      final err = ref.read(authProvider).errorMessage ?? 'Inloggen mislukt.';
      await AppPopup.show(
        context,
        type: AppPopupType.error,
        title: 'Inloggen mislukt',
        message: err,
        primaryButtonText: 'Opnieuw proberen',
      );
    }
  }

  Widget _buildToggle({
    required bool isParent,
    required IconData icon,
    required String label,
    required Color activeColor,
  }) {
    final isActive = _isParent == isParent;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isParent = isParent),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 44,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
            boxShadow: isActive
                ? [
                    const BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isActive ? activeColor : _inactive,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? activeColor : _inactive,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: _labelGrey,
      ),
    );
  }

  /// Builds an input field that matches the Figma design:
  /// - 52px tall container, 14px radius, 2px border (#E8ECF4 -> #0365C4 on focus)
  /// - Icon absolutely positioned at left-4 (16px from left), vertically centered
  /// - Input has 44px left padding to clear the icon (matches Figma pl-11)
  /// - Right padding 16px (pr-4), 48px if suffix present (pr-12)
  /// - Blue glow on focus (0 0 0 4px rgba(3,101,196,0.08))
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String fieldKey,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffix,
  }) {
    final isFocused = _focusedField == fieldKey;
    final borderColor = isFocused ? _blue : _borderDefault;
    return Focus(
      onFocusChange: (hasFocus) =>
          setState(() => _focusedField = hasFocus ? fieldKey : ''),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: isFocused
              ? [
                  BoxShadow(
                    color: _blue.withValues(alpha: 0.08),
                    blurRadius: 0,
                    spreadRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Absolutely positioned icon at left-4, vertically centered
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: Icon(
                  icon,
                  size: 18,
                  color: isFocused ? _blue : _inactive,
                ),
              ),
            ),
            // Input with pl-11 (44px) and pr-4/pr-12
            Padding(
              padding: EdgeInsets.only(
                left: 44,
                right: suffix != null ? 48 : 16,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                // Reset the global InputDecorationTheme for this TextField
                // so only our outer Container border is visible (app_theme.dart
                // sets a default OutlineInputBorder that would otherwise show).
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: const InputDecorationTheme(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      filled: false,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    obscureText: obscure,
                    keyboardType: keyboardType,
                    cursorColor: _blue,
                    cursorHeight: 18,
                    decoration: InputDecoration(
                      hintText: hint,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      filled: false,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.zero,
                      hintStyle: const TextStyle(
                        color: _inactive,
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      color: _darkText,
                    ),
                  ),
                ),
              ),
            ),
            // Suffix (eye icon) at right-4
            if (suffix != null)
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(child: suffix),
              ),
          ],
        ),
      ),
    );
  }
}
