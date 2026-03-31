import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class WaitlistInvitationScreen extends StatelessWidget {
  final String? invitationId;

  const WaitlistInvitationScreen({super.key, this.invitationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Uitnodiging'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          children: [
            // Invitation card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.sectionSpacing),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: AppDimensions.shadowBlur,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Celebration icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.celebration,
                      color: AppColors.success,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Er is een plek vrij!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Goed nieuws! Er is een plek vrijgekomen voor Noah Murtaza bij Zwemschool Snorkeltje.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sectionSpacing),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: AppDimensions.md),

                  // Slot details
                  _buildDetailRow(Icons.child_care_outlined, 'Kind', 'Noah Murtaza'),
                  const SizedBox(height: 14),
                  _buildDetailRow(Icons.location_on_outlined, 'Locatie', 'Soestduinen'),
                  const SizedBox(height: 14),
                  _buildDetailRow(Icons.person_outline, 'Type les', '1-op-2'),
                  const SizedBox(height: 14),
                  _buildDetailRow(Icons.calendar_today_outlined, 'Dag', 'Woensdag'),
                  const SizedBox(height: 14),
                  _buildDetailRow(Icons.access_time, 'Tijdstip', '14:00 - 14:30'),
                  const SizedBox(height: 14),
                  _buildDetailRow(Icons.person, 'Instructeur', 'Lisa Jansen'),

                  const SizedBox(height: AppDimensions.md),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: AppDimensions.md),

                  // Expiry notice
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.08),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSm),
                      border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.schedule, size: 18, color: AppColors.warning),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Deze uitnodiging verloopt op 4 april 2026. Reageer op tijd om uw plek te behouden.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.sectionSpacing),

            // Accept button
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  _showAcceptDialog(context);
                },
                child: const Text(
                  'Plek accepteren',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.md),

            // Decline button
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: OutlinedButton(
                onPressed: () {
                  _showDeclineDialog(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
                child: const Text(
                  'Plek afwijzen',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.md),

            // Contact support
            TextButton(
              onPressed: () {
                // TODO: Navigate to chat/contact
              },
              child: const Text(
                'Heeft u vragen? Neem contact op',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textLight),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  void _showAcceptDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        title: const Text(
          'Plek accepteren',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Wilt u deze plek accepteren? Na bevestiging wordt er een account aangemaakt en kunt u direct lessen boeken.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuleren',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Plek geaccepteerd! Welkom bij Snorkeltje.'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Bevestigen'),
          ),
        ],
      ),
    );
  }

  void _showDeclineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        title: const Text(
          'Plek afwijzen',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Weet u zeker dat u deze plek wilt afwijzen? De plek wordt dan aan de volgende persoon op de wachtlijst aangeboden.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuleren',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Afwijzen'),
          ),
        ],
      ),
    );
  }
}
