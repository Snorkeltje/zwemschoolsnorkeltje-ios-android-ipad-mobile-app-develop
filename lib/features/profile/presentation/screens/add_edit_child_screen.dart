import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class AddEditChildScreen extends StatefulWidget {
  const AddEditChildScreen({super.key});
  @override
  State<AddEditChildScreen> createState() => _AddEditChildScreenState();
}

class _AddEditChildScreenState extends State<AddEditChildScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _dob = TextEditingController();
  final _notes = TextEditingController();
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _firstName.addListener(() => setState(() {}));
    _lastName.addListener(() => setState(() {}));
    _dob.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _dob.dispose();
    _notes.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _firstName.text.trim().isNotEmpty &&
      _lastName.text.trim().isNotEmpty &&
      _dob.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (_saved) return _buildSuccess();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            padding: const EdgeInsets.fromLTRB(16, 56, 16, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 40, height: 40,
                    decoration: const BoxDecoration(color: Color(0xFFF4F7FC), shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const Icon(Icons.chevron_left, color: Color(0xFF1A1A2E), size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Kind toevoegen',
                    style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 96, height: 96,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft, end: Alignment.bottomRight,
                              colors: [Color(0xFF1A6FBF), Color(0xFF0D4F8C)],
                            ),
                          ),
                          alignment: Alignment.center,
                          child: _firstName.text.isNotEmpty
                              ? Text(_firstName.text.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700))
                              : Icon(Icons.person, color: Colors.white.withValues(alpha: 0.6), size: 36),
                        ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5A623),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text('Tik om foto toe te voegen',
                        style: TextStyle(color: Color(0xFF8E8EA0), fontSize: 12)),
                  ),
                  const SizedBox(height: 24),

                  _formField(Icons.person_outline, 'Voornaam kind *', _firstName, 'Voornaam'),
                  const SizedBox(height: 16),
                  _formField(Icons.person_outline, 'Achternaam kind *', _lastName, 'Achternaam'),
                  const SizedBox(height: 16),
                  _formField(Icons.calendar_today, 'Geboortedatum *', _dob, 'DD-MM-YYYY'),
                  const SizedBox(height: 16),
                  _formField(Icons.description_outlined, 'Opmerkingen (optioneel)', _notes,
                      'Bijv. allergieën, angst voor water, etc.', maxLines: 3),

                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F4FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ℹ️', style: TextStyle(fontSize: 20)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Zwemniveau',
                                  style: TextStyle(color: Color(0xFF1A6FBF), fontSize: 13, fontWeight: FontWeight.w600)),
                              SizedBox(height: 4),
                              Text('Het zwemniveau wordt automatisch ingesteld op "Beginner" en bijgewerkt door de instructeur na elke les.',
                                  style: TextStyle(color: Color(0xFF1A6FBF), fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _isValid ? () => setState(() => _saved = true) : null,
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: _isValid ? const Color(0xFF1A6FBF) : const Color(0xFFBDC3C7),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _isValid
                            ? [BoxShadow(color: const Color(0xFF1A6FBF).withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2))]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: const Text('Kind opslaan',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
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

  Widget _formField(IconData icon, String label, TextEditingController ctrl, String placeholder, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Icon(icon, size: 14, color: const Color(0xFF4A4A6A)),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(color: Color(0xFF4A4A6A), fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: maxLines > 1 ? 12 : 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: ctrl,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(color: Color(0xFF8E8EA0), fontSize: 14),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: maxLines == 1 ? 16 : 0),
            ),
            style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96, height: 96,
                decoration: const BoxDecoration(color: Color(0xFFE8F8F0), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle, color: Color(0xFF27AE60), size: 48),
              ),
              const SizedBox(height: 24),
              const Text('Kind toegevoegd!',
                  style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('${_firstName.text} ${_lastName.text} is succesvol toegevoegd aan je profiel.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF4A4A6A), fontSize: 14)),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () => context.goNamed(RouteNames.profile),
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A6FBF),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: const Color(0xFF1A6FBF).withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  alignment: Alignment.center,
                  child: const Text('Naar profiel',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
