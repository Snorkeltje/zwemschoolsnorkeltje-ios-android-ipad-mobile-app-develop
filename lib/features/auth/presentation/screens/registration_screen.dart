import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/router/route_names.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _step = 1;
  bool _showPass = false;
  bool _agreed = false;
  String _focused = '';

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  bool get _hasMinLength => _passwordCtrl.text.length >= 8;
  bool get _hasUppercase => _passwordCtrl.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => _passwordCtrl.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial => _passwordCtrl.text.contains(RegExp(r'[!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:,.<>?]'));

  void _next() {
    if (_step == 1) {
      setState(() => _step = 2);
    } else {
      context.goNamed(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top gradient bg
          Positioned(
            top: 0, left: 0, right: 0, height: 200,
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

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_step > 1) {
                            setState(() => _step--);
                          } else {
                            context.goNamed(RouteNames.login);
                          }
                        },
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F7FC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.chevron_left, size: 20, color: Color(0xFF1A1A2E)),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text('Account aanmaken',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                            Text('Stap $_step van 2',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF8E9BB3))),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                // Progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0365C4), Color(0xFF00C1FF)],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: _step >= 2
                                ? const LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)])
                                : null,
                            color: _step < 2 ? const Color(0xFFE8ECF4) : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Logo
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SvgPicture.asset('assets/images/snorkeltje_logo.svg', height: 48,
                    colorFilter: const ColorFilter.mode(Color(0xFF0365C4), BlendMode.srcIn)),
                ),

                // Form content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _step == 1 ? _buildStep1() : _buildStep2(),
                  ),
                ),

                // Bottom button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: (_step == 2 && !_agreed) ? null : _next,
                        child: Container(
                          width: double.infinity, height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft, end: Alignment.bottomRight,
                              colors: [Color(0xFF0365C4), Color(0xFF0D7FE8)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0365C4).withOpacity(0.3),
                                blurRadius: 24, offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: (_step == 2 && !_agreed) ? 0.5 : 1.0,
                            child: Text(
                              _step == 1 ? 'Volgende' : 'Account aanmaken',
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                      if (_step == 1) ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Heeft u al een account? ',
                              style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 13)),
                            GestureDetector(
                              onTap: () => context.goNamed(RouteNames.login),
                              child: const Text('Inloggen',
                                style: TextStyle(color: Color(0xFF0365C4), fontSize: 13, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('Persoonlijke gegevens',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
        const SizedBox(height: 4),
        const Text('Vul uw gegevens in om een account aan te maken.',
          style: TextStyle(fontSize: 13, color: Color(0xFF8E9BB3))),
        _buildField('firstName', 'Voornaam', Icons.person_outline, _firstNameCtrl, hint: 'Jan'),
        _buildField('lastName', 'Achternaam', Icons.person_outline, _lastNameCtrl, hint: 'de Vries'),
        _buildField('email', 'E-mailadres', Icons.email_outlined, _emailCtrl, hint: 'jan@voorbeeld.nl', keyType: TextInputType.emailAddress),
        _buildField('phone', 'Telefoonnummer', Icons.phone_outlined, _phoneCtrl, hint: '+31 6 12345678', keyType: TextInputType.phone),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('Wachtwoord instellen',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
        const SizedBox(height: 4),
        const Text('Kies een veilig wachtwoord voor uw account.',
          style: TextStyle(fontSize: 13, color: Color(0xFF8E9BB3))),
        _buildField('password', 'Wachtwoord', Icons.lock_outline, _passwordCtrl,
          hint: 'Min. 8 tekens', isPassword: true),
        _buildField('confirmPassword', 'Bevestig wachtwoord', Icons.lock_outline, _confirmPassCtrl,
          hint: 'Herhaal wachtwoord', isPassword: true),

        // Password requirements
        Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7FC),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Wachtwoord vereisten:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF4A5568))),
              const SizedBox(height: 8),
              _buildRequirement('Minimaal 8 tekens', _hasMinLength),
              _buildRequirement('Minstens 1 hoofdletter', _hasUppercase),
              _buildRequirement('Minstens 1 cijfer', _hasNumber),
              _buildRequirement('Minstens 1 speciaal teken', _hasSpecial),
            ],
          ),
        ),

        // Terms checkbox
        GestureDetector(
          onTap: () => setState(() => _agreed = !_agreed),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22, height: 22,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: _agreed
                      ? const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                          colors: [Color(0xFF0365C4), Color(0xFF00C1FF)])
                      : null,
                    color: _agreed ? null : const Color(0xFFF4F7FC),
                    border: _agreed ? null : Border.all(color: const Color(0xFFD0D5DD), width: 2),
                  ),
                  child: _agreed
                    ? const Icon(Icons.check, size: 13, color: Colors.white)
                    : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 12, color: Color(0xFF4A5568), height: 1.4),
                      children: [
                        const TextSpan(text: 'Ik ga akkoord met de '),
                        TextSpan(
                          text: 'Algemene Voorwaarden',
                          style: const TextStyle(color: Color(0xFF0365C4), fontWeight: FontWeight.w600),
                        ),
                        const TextSpan(text: ' en het '),
                        TextSpan(
                          text: 'Privacybeleid',
                          style: const TextStyle(color: Color(0xFF0365C4), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRequirement(String text, bool met) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Container(
            width: 18, height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: met ? const Color(0xFF27AE60) : const Color(0xFFE8ECF4),
            ),
            child: Icon(Icons.check, size: 10, color: met ? Colors.white : const Color(0xFFA0AEC0)),
          ),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7B94))),
        ],
      ),
    );
  }

  Widget _buildField(String key, String label, IconData icon, TextEditingController ctrl,
      {String hint = '', TextInputType? keyType, bool isPassword = false}) {
    final isFocused = _focused == key;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4A5568))),
          const SizedBox(height: 6),
          Focus(
            onFocusChange: (f) => setState(() => _focused = f ? key : ''),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isFocused ? const Color(0xFF0365C4) : const Color(0xFFE8ECF4),
                  width: 2,
                ),
                boxShadow: isFocused
                  ? [BoxShadow(color: const Color(0xFF0365C4).withOpacity(0.08), blurRadius: 8)]
                  : null,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(icon, size: 18, color: isFocused ? const Color(0xFF0365C4) : const Color(0xFFA0AEC0)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: ctrl,
                      obscureText: isPassword && !_showPass,
                      keyboardType: keyType,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: hint,
                        border: InputBorder.none,
                        hintStyle: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 14),
                      ),
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
                    ),
                  ),
                  if (isPassword)
                    GestureDetector(
                      onTap: () => setState(() => _showPass = !_showPass),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          _showPass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 18, color: const Color(0xFFA0AEC0),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
