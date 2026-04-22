import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/utils/smart_back.dart';

class _Setting {
  final String key;
  final String label;
  final String desc;
  final bool bold;
  const _Setting(this.key, this.label, this.desc, {this.bold = false});
}

const _settings = <_Setting>[
  _Setting('all', 'Alle meldingen', 'Hoofdschakelaar voor alle meldingen', bold: true),
  _Setting('lesson', 'Lesherinneringen', '24 uur voor elke les'),
  _Setting('progress', 'Voortgangsupdates', 'Wanneer instructeur voortgang bijwerkt'),
  _Setting('payment', 'Betalingsmeldingen', 'Bevestigingen en terugbetalingen'),
  _Setting('punchcard', 'Knipkaartmeldingen', 'Laag saldo en vervalwaarschuwingen'),
  _Setting('waitlist', 'Wachtlijstupdates', 'Wanneer een plek beschikbaar wordt'),
  _Setting('messages', 'Berichten', 'Nieuwe chatberichten'),
];

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final Map<String, bool> _toggles = {
    'all': true,
    'lesson': true,
    'progress': true,
    'payment': false,
    'punchcard': true,
    'waitlist': true,
    'messages': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => smartBack(context),
                  child: const Icon(Icons.arrow_back, color: Color(0xFF1A1A2E), size: 22),
                ),
                const Expanded(
                  child: Center(
                    child: Text('Meldingen',
                        style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 22),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                children: List.generate(_settings.length, (i) {
                  final s = _settings[i];
                  final isOn = _toggles[s.key] ?? false;
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s.label,
                                      style: TextStyle(
                                        color: const Color(0xFF1A1A2E),
                                        fontSize: 14,
                                        fontWeight: s.bold ? FontWeight.w700 : FontWeight.normal,
                                      )),
                                  const SizedBox(height: 2),
                                  Text(s.desc,
                                      style: const TextStyle(color: Color(0xFF8E8EA0), fontSize: 12)),
                                ],
                              ),
                            ),
                            // Custom toggle matching Figma 48x26 with 20px knob
                            GestureDetector(
                              onTap: () => setState(() => _toggles[s.key] = !isOn),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: 48,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: isOn ? const Color(0xFF1A6FBF) : const Color(0xFFE5E7EB),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Stack(
                                  children: [
                                    AnimatedPositioned(
                                      duration: const Duration(milliseconds: 180),
                                      curve: Curves.easeInOut,
                                      left: isOn ? 25 : 3,
                                      top: 3,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (i < _settings.length - 1)
                        Container(height: 1, color: const Color(0xFFE5E7EB)),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
