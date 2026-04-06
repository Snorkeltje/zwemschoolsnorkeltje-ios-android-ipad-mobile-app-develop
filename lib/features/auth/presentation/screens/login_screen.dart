import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  colors: [Color(0x1A00C1FF), Colors.transparent],
                ),
              ),
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
                          color: _blue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _blue.withOpacity(0.15),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.language, size: 14, color: _blue),
                            SizedBox(width: 4),
                            Text(
                              '🇳🇱 NL',
                              style: TextStyle(
                                color: _blue,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
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
                              color: mainColor.withOpacity(0.3),
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

  void _handleLogin() {
    if (_isParent) {
      context.goNamed(RouteNames.home);
    } else {
      context.goNamed(RouteNames.instructorHome);
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
    return Focus(
      onFocusChange: (hasFocus) =>
          setState(() => _focusedField = hasFocus ? fieldKey : ''),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isFocused ? _blue : _borderDefault,
            width: 2,
          ),
          boxShadow: isFocused
              ? [
                  const BoxShadow(
                    color: Color(0x140365C4),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              icon,
              size: 18,
              color: isFocused ? _blue : _inactive,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: obscure,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  isDense: true,
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
            if (suffix != null) ...[suffix, const SizedBox(width: 12)],
          ],
        ),
      ),
    );
  }
}
