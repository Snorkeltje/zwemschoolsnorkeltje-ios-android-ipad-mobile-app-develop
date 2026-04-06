import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class ConfirmOrderScreen extends StatefulWidget {
  final String? lessonType;
  final int? lessons;
  final double? price;

  const ConfirmOrderScreen({
    super.key,
    this.lessonType,
    this.lessons,
    this.price,
  });

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for all 11 fields
  final _voornaamKindController = TextEditingController();
  final _achternaamKindController = TextEditingController();
  final _geboortedatumKindController = TextEditingController();
  final _naamOuderController = TextEditingController();
  final _mobielController = TextEditingController();
  final _emailController = TextEditingController();
  final _woonplaatsController = TextEditingController();
  final _locatieController = TextEditingController();
  final _typeZwemlesController = TextEditingController();
  final _dagController = TextEditingController();
  final _tijdstipController = TextEditingController();

  bool _autoConversion = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill lesson type if provided
    _typeZwemlesController.text = widget.lessonType ?? '1-op-1';
  }

  @override
  void dispose() {
    _voornaamKindController.dispose();
    _achternaamKindController.dispose();
    _geboortedatumKindController.dispose();
    _naamOuderController.dispose();
    _mobielController.dispose();
    _emailController.dispose();
    _woonplaatsController.dispose();
    _locatieController.dispose();
    _typeZwemlesController.dispose();
    _dagController.dispose();
    _tijdstipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Logo header bar
            _buildLogoHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Breadcrumb
                    _buildBreadcrumb(),

                    // BEVESTIG banner
                    _buildBevestigBanner(),

                    // Form fields
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormField(
                              'Voornaam kind',
                              _voornaamKindController,
                            ),
                            _buildFormField(
                              'Achternaam kind',
                              _achternaamKindController,
                            ),
                            _buildFormField(
                              'Geboortedatum kind',
                              _geboortedatumKindController,
                              hintText: 'dd-mm-jjjj',
                            ),
                            _buildFormField(
                              'Voor+achternaam ouder',
                              _naamOuderController,
                            ),
                            _buildFormField(
                              'Mobiel',
                              _mobielController,
                              keyboardType: TextInputType.phone,
                            ),
                            _buildFormField(
                              'E-mail',
                              _emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            _buildFormField(
                              'Woonplaats',
                              _woonplaatsController,
                            ),
                            _buildFormField(
                              'Locatie',
                              _locatieController,
                            ),
                            _buildFormField(
                              'Type zwemles',
                              _typeZwemlesController,
                            ),
                            _buildFormField(
                              'Dag',
                              _dagController,
                            ),
                            _buildFormField(
                              'Tijdstip zwemles',
                              _tijdstipController,
                              hintText: 'bijv. 14:00',
                            ),

                            const SizedBox(height: 24),

                            // Auto-conversion section
                            _buildAutoConversionSection(),

                            const SizedBox(height: 20),

                            // Knipkaart info text
                            _buildKnipkaartInfoText(),

                            const SizedBox(height: 28),

                            // Buttons row
                            _buildButtons(),

                            const SizedBox(height: 20),
                          ],
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
    );
  }

  Widget _buildLogoHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Snorkeltje logo placeholder
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF0365C4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.pool,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Zwemschool Snorkeltje',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumb() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: const Color(0xFFF3F4F6),
      child: const Text(
        '\u{1F3E0} / Gegevens',
        style: TextStyle(
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildBevestigBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      color: const Color(0xFFC7D1D1),
      alignment: Alignment.center,
      child: const Text(
        'BEVESTIG',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller, {
    String? hintText,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 155,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 36,
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFDBE6F0)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF5492B5),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoConversionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Automatische omzetting',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Wilt u dat uw knipkaart automatisch wordt omgezet naar een '
            'vaste lesplaats wanneer er een plek vrijkomt?',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildRadioOption('Ja', true),
              const SizedBox(width: 20),
              _buildRadioOption('Nee', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String label, bool value) {
    final isSelected = _autoConversion == value;
    return GestureDetector(
      onTap: () => setState(() => _autoConversion = value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF5492B5)
                    : const Color(0xFFD1D5DB),
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF5492B5),
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKnipkaartInfoText() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFDBE6F0)),
      ),
      child: const Text(
        'Een knipkaart is 365 dagen geldig na aankoop. U kunt lessen flexibel '
        'inplannen via de app of telefonisch. Annuleren kan kosteloos tot 24 '
        'uur voor aanvang van de les.',
        style: TextStyle(
          fontSize: 13,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        // Terug button (outlined)
        Expanded(
          child: SizedBox(
            height: 46,
            child: OutlinedButton(
              onPressed: () => context.pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF5492B5),
                side: const BorderSide(color: Color(0xFF5492B5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '\u2190 Terug',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Bevestig button (filled)
        Expanded(
          child: SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: _handleConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5492B5),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '\u2713 Bevestig',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleConfirm() {
    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF18BB68).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF18BB68),
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bestelling bevestigd!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Uw gegevens zijn succesvol verzonden. '
              'U ontvangt een bevestiging per e-mail.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.pop();
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5492B5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Sluiten',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
