import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class FaqDetailScreen extends StatelessWidget {
  final String faqId;

  const FaqDetailScreen({super.key, required this.faqId});

  // Mock data - in real app, this would come from a provider/repository
  Map<String, dynamic> get _faqData => {
        'question': 'Hoe boek ik een zwemles?',
        'answer': '''Om een zwemles te boeken volgt u deze stappen:

1. Open de app en ga naar het tabblad "Boeken" onderaan het scherm.

2. Kies het type les dat u wilt boeken:
   - Vast tijdstip: uw wekelijkse vaste les
   - Extra 1-op-1: een individuele extra les
   - Extra 1-op-2: een gedeelde extra les
   - Vakantie zwemles: lessen tijdens schoolvakanties

3. Selecteer de gewenste datum op de kalender. Groene bolletjes geven beschikbare tijdsloten aan.

4. Kies een beschikbaar tijdstip uit de lijst.

5. Controleer het boekingsoverzicht met de gegevens van de les, locatie en prijs.

6. Kies uw betaalmethode (creditcard of knipkaart).

7. Tik op "Bevestig boeking" om de boeking af te ronden.

U ontvangt een bevestiging per e-mail en een push-notificatie. De les verschijnt ook in uw reserveringen.''',
        'category': 'Boekingen',
        'relatedQuestions': [
          'Kan ik een les annuleren?',
          'Wat is de 14-dagenregel?',
          'Hoe boek ik een extra les?',
        ],
      };

  @override
  Widget build(BuildContext context) {
    final data = _faqData;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Vraag & Antwoord'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question header
            Container(
              width: double.infinity,
              color: AppColors.white,
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      data['category'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data['question'] as String,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.sm),

            // Answer
            Container(
              width: double.infinity,
              color: AppColors.white,
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb_outline,
                          size: 18, color: AppColors.primaryOrange),
                      SizedBox(width: 8),
                      Text(
                        'Antwoord',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data['answer'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.md),

            // Was this helpful?
            Container(
              width: double.infinity,
              color: AppColors.white,
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: Column(
                children: [
                  const Text(
                    'Was dit antwoord nuttig?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFeedbackButton(
                        icon: Icons.thumb_up_outlined,
                        label: 'Ja',
                        color: AppColors.success,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Bedankt voor uw feedback!'),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildFeedbackButton(
                        icon: Icons.thumb_down_outlined,
                        label: 'Nee',
                        color: AppColors.error,
                        onTap: () {
                          // TODO: Show feedback form
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.md),

            // Related questions
            Container(
              width: double.infinity,
              color: AppColors.white,
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gerelateerde vragen',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...(data['relatedQuestions'] as List<String>).map(
                    (q) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () {
                          // TODO: Navigate to related FAQ
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusSm),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.help_outline,
                                  size: 18, color: AppColors.primaryBlue),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  q,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const Icon(Icons.chevron_right,
                                  size: 18, color: AppColors.textLight),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
