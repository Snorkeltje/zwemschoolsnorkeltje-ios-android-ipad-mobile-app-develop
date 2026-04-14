import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? token;
  const ResetPasswordScreen({super.key, this.token});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _showPass = false;
  bool _success = false;
  String _focused = '';

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  int get _strength {
    int s = 0;
    final p = _passCtrl.text;
    if (p.length >= 8) s++;
    if (p.contains(RegExp(r'[A-Z]'))) s++;
    if (p.contains(RegExp(r'[0-9]'))) s++;
    if (p.contains(RegExp(r'[!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:,.<>?]'))) s++;
    return s;
  }

  bool get _hasMinLength => _passCtrl.text.length >= 8;
  bool get _hasUppercase => _passCtrl.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => _passCtrl.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial => _passCtrl.text.contains(RegExp(r'[!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:,.<>?]'));
  bool get _passwordsMatch => _passCtrl.text.isNotEmpty && _passCtrl.text == _confirmCtrl.text;

  Color get _strengthColor {
    switch (_strength) {
      case 0: case 1: return const Color(0xFFE74C3C);
      case 2: return const Color(0xFFF39C12);
      case 3: return const Color(0xFF27AE60);
      default: return const Color(0xFF1A6FBF);
    }
  }

  String get _strengthLabel {
    switch (_strength) {
      case 0: case 1: return 'Zwak';
      case 2: return 'Redelijk';
      case 3: return 'Sterk';
      default: return 'Zeer sterk';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_success) return _buildSuccessView();
    return _buildFormView();
  }

  Widget _buildSuccessView() {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [Color(0xFFE8F8F0), Color(0xFFD4F5E0)]),
                  ),
                  child: const Icon(Icons.shield, size: 40, color: Color(0xFF27AE60)),
                ),
                const SizedBox(height: 24),
                const Text('Wachtwoord gewijzigd!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                const SizedBox(height: 8),
                const Text('Je wachtwoord is succesvol gewijzigd. Je kunt nu inloggen met je nieuwe wachtwoord.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF4A4A6A), height: 1.5)),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () => context.goNamed(RouteNames.login),
                  child: Container(
                    width: double.infinity, height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: const Color(0xFF1A6FBF),
                    ),
                    alignment: Alignment.center,
                    child: const Text('Terug naar inloggen',
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8)]),
                      child: const Icon(Icons.chevron_left, size: 20, color: Color(0xFF1A1A2E)),
                    ),
                  ),
                ]),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Lock icon
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(colors: [Color(0xFFE8F4FD), Color(0xFFD0E4F7)]),
                      ),
                      child: const Icon(Icons.lock_outline, size: 36, color: Color(0xFF0365C4)),
                    ),
                    const SizedBox(height: 20),
                    const Text('Nieuw wachtwoord',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                    const SizedBox(height: 8),
                    const Text('Kies een sterk en veilig wachtwoord.',
                      style: TextStyle(fontSize: 14, color: Color(0xFF4A4A6A))),

                    const SizedBox(height: 28),
                    // New password field
                    _buildPassField('password', 'Nieuw wachtwoord', _passCtrl),
                    const SizedBox(height: 12),

                    // Strength indicator
                    if (_passCtrl.text.isNotEmpty) ...[
                      Row(children: List.generate(4, (i) => Expanded(
                        child: Container(
                          height: 4,
                          margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: i < _strength ? _strengthColor : const Color(0xFFE5E7EB),
                          ),
                        ),
                      ))),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(_strengthLabel, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _strengthColor)),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Confirm password field
                    _buildPassField('confirm', 'Bevestig wachtwoord', _confirmCtrl),
                    if (_confirmCtrl.text.isNotEmpty && !_passwordsMatch)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Wachtwoorden komen niet overeen',
                            style: TextStyle(fontSize: 12, color: Color(0xFFE74C3C))),
                        ),
                      ),

                    const SizedBox(height: 20),
                    // Requirements
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Vereisten:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF4A5568))),
                          const SizedBox(height: 8),
                          _buildReq('Minimaal 8 tekens', _hasMinLength),
                          _buildReq('Minstens 1 hoofdletter', _hasUppercase),
                          _buildReq('Minstens 1 cijfer', _hasNumber),
                          _buildReq('Minstens 1 speciaal teken', _hasSpecial),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                    // Submit button
                    GestureDetector(
                      onTap: (_passwordsMatch && _strength >= 2) ? () => setState(() => _success = true) : null,
                      child: Container(
                        width: double.infinity, height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: const Color(0xFF1A6FBF),
                        ),
                        alignment: Alignment.center,
                        child: const Text('Wachtwoord wijzigen',
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPassField(String key, String label, TextEditingController ctrl) {
    final isFocused = _focused == key;
    return Column(
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
              color: Colors.white,
              border: Border.all(color: isFocused ? const Color(0xFF0365C4) : const Color(0xFFE8ECF4), width: 2),
            ),
            child: Row(children: [
              const SizedBox(width: 16),
              Icon(Icons.lock_outline, size: 18, color: isFocused ? const Color(0xFF0365C4) : const Color(0xFFA0AEC0)),
              const SizedBox(width: 8),
              Expanded(child: TextField(
                controller: ctrl,
                obscureText: !_showPass,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(hintText: key == 'password' ? 'Min. 8 tekens' : 'Herhaal wachtwoord',
                  border: InputBorder.none, hintStyle: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 14)),
                style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
              )),
              GestureDetector(
                onTap: () => setState(() => _showPass = !_showPass),
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(_showPass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 18, color: const Color(0xFFA0AEC0)),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildReq(String text, bool met) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(children: [
        Container(width: 18, height: 18, decoration: BoxDecoration(shape: BoxShape.circle,
          color: met ? const Color(0xFF27AE60) : const Color(0xFFE8ECF4)),
          child: Icon(Icons.check, size: 10, color: met ? Colors.white : const Color(0xFFA0AEC0))),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7B94))),
      ]),
    );
  }
}
