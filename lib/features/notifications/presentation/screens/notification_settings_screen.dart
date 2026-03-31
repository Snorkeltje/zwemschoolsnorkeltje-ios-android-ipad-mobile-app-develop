import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // Push notifications
  bool _pushEnabled = true;
  bool _pushBookings = true;
  bool _pushPayments = true;
  bool _pushProgress = true;
  bool _pushChat = true;
  bool _pushReminders = true;

  // Email notifications
  bool _emailEnabled = true;
  bool _emailBookings = true;
  bool _emailPayments = true;
  bool _emailProgress = false;
  bool _emailNewsletter = false;

  bool _isSaving = false;

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Instellingen opgeslagen'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notificatie-instellingen'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppDimensions.md),

            // Push notifications section
            Container(
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.screenPadding,
                      AppDimensions.md,
                      AppDimensions.screenPadding,
                      AppDimensions.sm,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusSm),
                          ),
                          child: const Icon(
                            Icons.notifications_active_outlined,
                            color: AppColors.primaryBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Push-notificaties',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Switch(
                          value: _pushEnabled,
                          onChanged: (val) =>
                              setState(() => _pushEnabled = val),
                          activeColor: AppColors.primaryBlue,
                        ),
                      ],
                    ),
                  ),
                  if (_pushEnabled) ...[
                    _buildDivider(),
                    _buildToggleRow(
                      'Boekingen',
                      'Bevestigingen en wijzigingen van lessen',
                      _pushBookings,
                      (val) => setState(() => _pushBookings = val),
                    ),
                    _buildDivider(),
                    _buildToggleRow(
                      'Betalingen',
                      'Betalingsbevestigingen en facturen',
                      _pushPayments,
                      (val) => setState(() => _pushPayments = val),
                    ),
                    _buildDivider(),
                    _buildToggleRow(
                      'Voortgang',
                      'Updates over de voortgang van uw kind',
                      _pushProgress,
                      (val) => setState(() => _pushProgress = val),
                    ),
                    _buildDivider(),
                    _buildToggleRow(
                      'Berichten',
                      'Nieuwe berichten van instructeurs',
                      _pushChat,
                      (val) => setState(() => _pushChat = val),
                    ),
                    _buildDivider(),
                    _buildToggleRow(
                      'Herinneringen',
                      'Lesherinneringen en knipkaart-waarschuwingen',
                      _pushReminders,
                      (val) => setState(() => _pushReminders = val),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.md),

            // Email notifications section
            Container(
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.screenPadding,
                      AppDimensions.md,
                      AppDimensions.screenPadding,
                      AppDimensions.sm,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primaryOrange.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusSm),
                          ),
                          child: const Icon(
                            Icons.email_outlined,
                            color: AppColors.primaryOrange,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'E-mail notificaties',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Switch(
                          value: _emailEnabled,
                          onChanged: (val) =>
                              setState(() => _emailEnabled = val),
                          activeColor: AppColors.primaryBlue,
                        ),
                      ],
                    ),
                  ),
                  if (_emailEnabled) ...[
                    _buildDivider(),
                    _buildToggleRow(
                      'Boekingsbevestigingen',
                      'Ontvang een e-mail bij elke boeking',
                      _emailBookings,
                      (val) => setState(() => _emailBookings = val),
                    ),
                    _buildDivider(),
                    _buildToggleRow(
                      'Facturen',
                      'Ontvang facturen per e-mail',
                      _emailPayments,
                      (val) => setState(() => _emailPayments = val),
                    ),
                    _buildDivider(),
                    _buildToggleRow(
                      'Voortgangsrapporten',
                      'Wekelijks rapport over de voortgang',
                      _emailProgress,
                      (val) => setState(() => _emailProgress = val),
                    ),
                    _buildDivider(),
                    _buildToggleRow(
                      'Nieuwsbrief',
                      'Nieuws en updates van Snorkeltje',
                      _emailNewsletter,
                      (val) => setState(() => _emailNewsletter = val),
                    ),
                  ],
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
                      : const Text(
                          'Opslaan',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      child: Divider(height: 1, color: AppColors.divider),
    );
  }
}
