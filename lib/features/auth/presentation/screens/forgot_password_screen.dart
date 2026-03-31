import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _sent = false;
  String _focused = '';

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_sent) return _buildSuccessView();
    return _buildFormView();
  }

  Widget _buildSuccessView() {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: [Color(0xFFE8F8F0), Color(0xFFD4F5E0)],
                    ),
                  ),
                  child: const Icon(Icons.check_circle, size: 40, color: Color(0xFF27AE60)),
                ),
                const SizedBox(height: 24),
                const Text('E-mail verzonden!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Color(0xFF6B7B94), height: 1.5),
                    children: [
                      const TextSpan(text: 'We hebben een herstellink gestuurd naar '),
                      TextSpan(text: _emailCtrl.text,
                        style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                      const TextSpan(text: '. Controleer je inbox.'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () => context.goNamed(RouteNames.login),
                  child: Container(
                    width: double.infinity, height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                        colors: [Color(0xFF0365C4), Color(0xFF0D7FE8)],
                      ),
                      boxShadow: [BoxShadow(color: const Color(0xFF0365C4).withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 8))],
                    ),
                    alignment: Alignment.center,
                    child: const Text('Terug naar inloggen',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
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
    final hasEmail = _emailCtrl.text.isNotEmpty;
    final isFocused = _focused == 'email';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 8),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: const Color(0xFFF4F7FC), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.chevron_left, size: 20, color: Color(0xFF1A1A2E)),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    // Lock icon
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                          colors: [Color(0xFFE8F4FD), Color(0xFFD0E4F7)],
                        ),
                      ),
                      child: const Icon(Icons.lock_outline, size: 36, color: Color(0xFF0365C4)),
                    ),
                    const SizedBox(height: 24),
                    const Text('Wachtwoord vergeten?',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                    const SizedBox(height: 8),
                    const Text('Voer je e-mailadres in en we sturen je een herstellink.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B7B94))),

                    const SizedBox(height: 32),
                    // Email field
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text('E-mailadres',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4A5568))),
                    ),
                    const SizedBox(height: 6),
                    Focus(
                      onFocusChange: (f) => setState(() => _focused = f ? 'email' : ''),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isFocused ? const Color(0xFF0365C4) : const Color(0xFFE8ECF4), width: 2),
                          boxShadow: isFocused ? [BoxShadow(color: const Color(0xFF0365C4).withOpacity(0.08), blurRadius: 8)] : null,
                        ),
                        child: Row(children: [
                          const SizedBox(width: 16),
                          Icon(Icons.email_outlined, size: 18, color: isFocused ? const Color(0xFF0365C4) : const Color(0xFFA0AEC0)),
                          const SizedBox(width: 8),
                          Expanded(child: TextField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              hintText: 'uw@email.nl', border: InputBorder.none,
                              hintStyle: TextStyle(color: Color(0xFFA0AEC0), fontSize: 14)),
                            style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
                          )),
                        ]),
                      ),
                    ),

                    const SizedBox(height: 32),
                    // Submit button
                    GestureDetector(
                      onTap: hasEmail ? () => setState(() => _sent = true) : null,
                      child: Container(
                        width: double.infinity, height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: hasEmail
                            ? const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                                colors: [Color(0xFF0365C4), Color(0xFF0D7FE8)])
                            : null,
                          color: hasEmail ? null : const Color(0xFFBDC3C7),
                          boxShadow: hasEmail
                            ? [BoxShadow(color: const Color(0xFF0365C4).withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 8))]
                            : null,
                        ),
                        alignment: Alignment.center,
                        child: const Text('Herstelmail versturen',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
