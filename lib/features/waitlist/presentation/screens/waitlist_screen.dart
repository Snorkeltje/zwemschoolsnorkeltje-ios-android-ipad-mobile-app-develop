import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class WaitlistScreen extends StatefulWidget {
  const WaitlistScreen({super.key});

  @override
  State<WaitlistScreen> createState() => _WaitlistScreenState();
}

class _WaitlistScreenState extends State<WaitlistScreen> {
  final _formKey = GlobalKey<FormState>();
  final _childNameController = TextEditingController();
  final _childAgeController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedLocation = 'De Bilt';
  String _selectedLessonType = '1-op-1';
  String _selectedDay = 'Maandag';
  bool _isSubmitting = false;

  final List<String> _locations = [
    'De Bilt',
    'Soestduinen',
    'Nijkerk',
    'Garderen',
    'Wolfheze',
    'Dordrecht',
  ];

  final List<String> _lessonTypes = ['1-op-1', '1-op-2', 'Vakantie'];
  final List<String> _days = [
    'Maandag',
    'Dinsdag',
    'Woensdag',
    'Donderdag',
    'Vrijdag',
    'Zaterdag',
  ];

  @override
  void dispose() {
    _childNameController.dispose();
    _childAgeController.dispose();
    _parentNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitWaitlist() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isSubmitting = false);
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aanmelding ontvangen!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'U bent succesvol op de wachtlijst geplaatst. We nemen contact met u op zodra er een plek beschikbaar is.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Begrepen'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Wachtlijst'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header info
              Container(
                width: double.infinity,
                color: AppColors.white,
                padding: const EdgeInsets.all(AppDimensions.screenPadding),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.hourglass_top,
                        size: 28,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Aanmelden voor de wachtlijst',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Vul het formulier in om uw kind aan te melden voor zwemlessen.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.md),

              // Child info
              Container(
                width: double.infinity,
                color: AppColors.white,
                padding: const EdgeInsets.all(AppDimensions.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gegevens kind',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),

                    _buildLabel('Naam kind'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _childNameController,
                      decoration: const InputDecoration(
                        hintText: 'Volledige naam van het kind',
                        prefixIcon: Icon(Icons.child_care_outlined),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Verplicht veld' : null,
                    ),
                    const SizedBox(height: AppDimensions.md),

                    _buildLabel('Leeftijd kind'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _childAgeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Leeftijd in jaren',
                        prefixIcon: Icon(Icons.cake_outlined),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Verplicht veld' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.md),

              // Parent info
              Container(
                width: double.infinity,
                color: AppColors.white,
                padding: const EdgeInsets.all(AppDimensions.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gegevens ouder/verzorger',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),

                    _buildLabel('Naam'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _parentNameController,
                      decoration: const InputDecoration(
                        hintText: 'Uw volledige naam',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Verplicht veld' : null,
                    ),
                    const SizedBox(height: AppDimensions.md),

                    _buildLabel('E-mailadres'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'naam@voorbeeld.nl',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Verplicht veld';
                        if (!v.contains('@')) return 'Ongeldig e-mailadres';
                        return null;
                      },
                    ),
                    const SizedBox(height: AppDimensions.md),

                    _buildLabel('Telefoonnummer'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: '+31 6 12345678',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Verplicht veld' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.md),

              // Preferences
              Container(
                width: double.infinity,
                color: AppColors.white,
                padding: const EdgeInsets.all(AppDimensions.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Voorkeuren',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),

                    _buildLabel('Voorkeur locatie'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedLocation,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      items: _locations
                          .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedLocation = val);
                      },
                    ),
                    const SizedBox(height: AppDimensions.md),

                    _buildLabel('Type les'),
                    const SizedBox(height: 8),
                    Row(
                      children: _lessonTypes
                          .map(
                            (type) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: type != _lessonTypes.last ? 8 : 0,
                                ),
                                child: GestureDetector(
                                  onTap: () => setState(
                                      () => _selectedLessonType = type),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _selectedLessonType == type
                                          ? AppColors.primaryBlue
                                          : AppColors.background,
                                      borderRadius: BorderRadius.circular(
                                          AppDimensions.radiusSm),
                                      border: Border.all(
                                        color: _selectedLessonType == type
                                            ? AppColors.primaryBlue
                                            : AppColors.border,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      type,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: _selectedLessonType == type
                                            ? Colors.white
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: AppDimensions.md),

                    _buildLabel('Voorkeur dag'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedDay,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                      items: _days
                          .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedDay = val);
                      },
                    ),
                    const SizedBox(height: AppDimensions.md),

                    _buildLabel('Opmerkingen (optioneel)'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Eventuele opmerkingen of bijzonderheden...',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.sectionSpacing),

              // Submit button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeight,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitWaitlist,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : const Text(
                            'Aanmelden',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.xl),
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
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }
}
