import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isParent = true;
  bool _showPass = false;
  String _focused = '';
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() { _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final mainColor = _isParent ? const Color(0xFF0365C4) : const Color(0xFFFF5C00);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        // Top gradient bg
        Positioned(top: 0, left: 0, right: 0, height: 200,
          child: Container(decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0xFFF0F6FF), Colors.white])))),
        // Glow circle top-right
        Positioned(top: 0, right: 0,
          child: Container(width: 200, height: 200, decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [Color(0x1400C1FF), Colors.transparent])))),
        // Main scroll content
        SafeArea(child: SingleChildScrollView(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 12),
            // Language toggle
            Align(alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0365C4).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF0365C4).withOpacity(0.15)),
                ),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.language, size: 14, color: Color(0xFF0365C4)),
                  SizedBox(width: 4),
                  Text('🇳🇱 NL', style: TextStyle(color: Color(0xFF0365C4), fontSize: 12, fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            // Logo
            Center(child: SvgPicture.asset('assets/images/snorkeltje_logo.svg', height: 80,
              colorFilter: const ColorFilter.mode(Color(0xFF0365C4), BlendMode.srcIn))),
            const SizedBox(height: 20),
            // Parent / Instructor toggle
            Container(
              decoration: BoxDecoration(color: const Color(0xFFF0F4FA), borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(4),
              child: Row(children: [
                _buildToggle(true, Icons.person_rounded, 'Ouder', const Color(0xFF0365C4)),
                _buildToggle(false, Icons.work_rounded, 'Instructeur', const Color(0xFFFF5C00)),
              ]),
            ),
            const SizedBox(height: 20),
            Text(
              _isParent ? 'Welkom, Ouder!' : 'Instructeur Inloggen',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 4),
            Text(
              _isParent ? 'Boek lessen & volg de voortgang van uw kind' : 'Beheer uw rooster & leerlingen',
              style: const TextStyle(color: Color(0xFF6B7B94), fontSize: 13),
            ),
            const SizedBox(height: 28),
            // Email field
            _buildLabel('E-mailadres'),
            const SizedBox(height: 6),
            _buildInput(
              controller: _emailCtrl,
              hint: 'naam@voorbeeld.nl',
              icon: Icons.email_outlined,
              fieldKey: 'email',
              keyType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Password field
            _buildLabel('Wachtwoord'),
            const SizedBox(height: 6),
            _buildInput(
              controller: _passCtrl,
              hint: '••••••••',
              icon: Icons.lock_outline,
              fieldKey: 'pass',
              obscure: !_showPass,
              suffix: GestureDetector(
                onTap: () => setState(() => _showPass = !_showPass),
                child: Icon(_showPass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 20, color: const Color(0xFFA0AEC0)),
              ),
            ),
            const SizedBox(height: 8),
            // Forgot password
            Align(alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => context.goNamed(RouteNames.forgotPassword),
                child: Text('Wachtwoord vergeten?',
                  style: TextStyle(color: mainColor, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 28),
            // Login button
            GestureDetector(
              onTap: () => context.goNamed(_isParent ? RouteNames.home : RouteNames.instructorHome),
              child: Container(
                width: double.infinity, height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: _isParent
                      ? [const Color(0xFF0365C4), const Color(0xFF0D7FE8)]
                      : [const Color(0xFFFF5C00), const Color(0xFFF5A623)]),
                  boxShadow: [BoxShadow(color: mainColor.withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 8))],
                ),
                alignment: Alignment.center,
                child: Text(
                  _isParent ? 'Inloggen als Ouder' : 'Inloggen als Instructeur',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.3),
                ),
              ),
            ),
            if (_isParent) ...[
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('Nieuw hier? ', style: TextStyle(color: Color(0xFF6B7B94), fontSize: 13)),
                GestureDetector(
                  onTap: () => context.goNamed(RouteNames.registration),
                  child: const Text('Account aanmaken', style: TextStyle(color: Color(0xFF0365C4), fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ]),
            ] else ...[
              const SizedBox(height: 16),
              const Center(child: Text('Alleen voor gecertificeerde Snorkeltje instructeurs',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFA0AEC0), fontSize: 11))),
            ],
            const SizedBox(height: 24),
            const Center(child: Text('snorkeltje.nl',
              style: TextStyle(color: Color(0xFF0365C4), fontSize: 11, fontWeight: FontWeight.w500))),
            const SizedBox(height: 24),
          ]),
        ))),
      ]),
    );
  }

  Widget _buildToggle(bool isParent, IconData icon, String label, Color activeColor) {
    final isActive = _isParent == isParent;
    return Expanded(child: GestureDetector(
      onTap: () => setState(() => _isParent = isParent),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 44,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(13),
          boxShadow: isActive ? [const BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))] : null,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 16, color: isActive ? activeColor : const Color(0xFFA0AEC0)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? activeColor : const Color(0xFFA0AEC0))),
        ]),
      ),
    ));
  }

  Widget _buildLabel(String text) => Text(text,
    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4A5568)));

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String fieldKey,
    TextInputType? keyType,
    bool obscure = false,
    Widget? suffix,
  }) {
    final isFocused = _focused == fieldKey;
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f ? fieldKey : ''),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isFocused ? const Color(0xFF0365C4) : const Color(0xFFE8ECF4), width: 2),
          boxShadow: isFocused ? [const BoxShadow(color: Color(0x140365C4), blurRadius: 8)] : null,
        ),
        child: Row(children: [
          const SizedBox(width: 16),
          Icon(icon, size: 18, color: isFocused ? const Color(0xFF0365C4) : const Color(0xFFA0AEC0)),
          const SizedBox(width: 8),
          Expanded(child: TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyType,
            decoration: InputDecoration(hintText: hint, border: InputBorder.none,
              hintStyle: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 14)),
            style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
          )),
          if (suffix != null) ...[suffix, const SizedBox(width: 12)],
        ]),
      ),
    );
  }
}
