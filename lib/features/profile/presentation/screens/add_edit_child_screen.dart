import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class AddEditChildScreen extends StatefulWidget {
  final String? childId;
  final bool isEditing;

  const AddEditChildScreen({
    super.key,
    this.childId,
    this.isEditing = false,
  });

  @override
  State<AddEditChildScreen> createState() => _AddEditChildScreenState();
}

class _AddEditChildScreenState extends State<AddEditChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _dateOfBirth;
  String _selectedGender = 'Jongen';
  String _selectedLevel = 'Starter';
  bool _isSaving = false;

  final List<String> _genders = ['Jongen', 'Meisje', 'Anders'];
  final List<String> _levels = [
    'Starter',
    'Beginner',
    'Beginner 2',
    'Gevorderd',
    'Diplomazwemmer',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      // Mock data for editing
      _firstNameController.text = 'Emma';
      _lastNameController.text = 'Murtaza';
      _dateOfBirth = DateTime(2020, 5, 15);
      _selectedGender = 'Meisje';
      _selectedLevel = 'Beginner';
      _notesController.text = 'Heeft een lichte angst voor diep water.';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(2018, 1, 1),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
      locale: const Locale('nl'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isEditing
              ? 'Kindgegevens bijgewerkt'
              : 'Kind toegevoegd'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Kind bewerken' : 'Kind toevoegen'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: widget.isEditing
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: () => _showDeleteDialog(),
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: AppDimensions.md),

              // Basic info
              Container(
                width: double.infinity,
                color: AppColors.white,
                padding: const EdgeInsets.all(AppDimensions.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Basisgegevens',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),

                    _buildLabel('Voornaam'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        hintText: 'Voornaam van het kind',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Verplicht veld' : null,
                    ),
                    const SizedBox(height: AppDimensions.md),

                    _buildLabel('Achternaam'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        hintText: 'Achternaam van het kind',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Verplicht veld' : null,
                    ),
                    const SizedBox(height: AppDimensions.md),

                    // Date of birth
                    _buildLabel('Geboortedatum'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickDateOfBirth,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Selecteer geboortedatum',
                            prefixIcon: const Icon(Icons.cake_outlined),
                            suffixIcon: const Icon(Icons.calendar_today,
                                size: 18, color: AppColors.textLight),
                          ),
                          controller: TextEditingController(
                            text: _dateOfBirth != null
                                ? '${_dateOfBirth!.day}-${_dateOfBirth!.month}-${_dateOfBirth!.year}'
                                : '',
                          ),
                          validator: (v) => _dateOfBirth == null
                              ? 'Selecteer een geboortedatum'
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),

                    // Gender
                    _buildLabel('Geslacht'),
                    const SizedBox(height: 8),
                    Row(
                      children: _genders
                          .map(
                            (g) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: g != _genders.last ? 8 : 0,
                                ),
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedGender = g),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _selectedGender == g
                                          ? AppColors.primaryBlue
                                          : AppColors.background,
                                      borderRadius: BorderRadius.circular(
                                          AppDimensions.radiusSm),
                                      border: Border.all(
                                        color: _selectedGender == g
                                            ? AppColors.primaryBlue
                                            : AppColors.border,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      g,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: _selectedGender == g
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
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.md),

              // Swimming info
              Container(
                width: double.infinity,
                color: AppColors.white,
                padding: const EdgeInsets.all(AppDimensions.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Zweminformatie',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),

                    _buildLabel('Huidig niveau'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedLevel,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.pool_outlined),
                      ),
                      items: _levels
                          .map((l) => DropdownMenuItem(
                                value: l,
                                child: Text(l),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedLevel = val);
                      },
                    ),
                    const SizedBox(height: AppDimensions.md),

                    _buildLabel('Opmerkingen (optioneel)'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText:
                            'Eventuele bijzonderheden, allergieën, of aandachtspunten...',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.sectionSpacing),

              // Save button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeight,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : Text(
                            widget.isEditing ? 'Wijzigingen opslaan' : 'Kind toevoegen',
                            style: const TextStyle(fontSize: 16),
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

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        title: const Text(
          'Kind verwijderen',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: const Text(
          'Weet u zeker dat u dit kind wilt verwijderen? Dit kan niet ongedaan worden gemaakt.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Annuleren',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
            ),
            child: const Text('Verwijderen'),
          ),
        ],
      ),
    );
  }
}
