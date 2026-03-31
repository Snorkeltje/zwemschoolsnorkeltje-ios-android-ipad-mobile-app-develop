import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Algemene voorwaarden'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: const Column(
                children: [
                  Text(
                    'Zwemschool Snorkeltje',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Algemene Voorwaarden',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Laatst bijgewerkt: 1 januari 2026',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.sectionSpacing),

            _buildSection(
              '1. Algemeen',
              'Deze algemene voorwaarden zijn van toepassing op alle diensten van Zwemschool Snorkeltje, gevestigd te De Bilt, ingeschreven bij de Kamer van Koophandel. Door gebruik te maken van onze diensten gaat u akkoord met deze voorwaarden.',
            ),
            _buildSection(
              '2. Inschrijving en wachtlijst',
              'Inschrijving geschiedt via de wachtlijst in de app of via de website. Na goedkeuring ontvangt u een uitnodiging om een account aan te maken. Inschrijving is pas definitief na bevestiging per e-mail en betaling van de eerste les of knipkaart.',
            ),
            _buildSection(
              '3. Zwemlessen',
              'Zwemlessen worden gegeven op de in de app aangegeven locaties en tijdstippen. Een standaard les duurt 30 minuten. De ouder/verzorger is verantwoordelijk voor het op tijd aanwezig zijn van het kind. Kinderen dienen minimaal 10 minuten voor aanvang aanwezig te zijn.',
            ),
            _buildSection(
              '4. Boekingen en annuleringen',
              'Lessen kunnen via de app worden geboekt, afhankelijk van beschikbaarheid. Annulering is kosteloos tot 24 uur voor aanvang van de les. Bij annulering binnen 24 uur wordt de les volledig in rekening gebracht. Niet nagekomen lessen worden niet terugbetaald.',
            ),
            _buildSection(
              '5. Betalingen',
              'Betaling geschiedt via de app middels creditcard (Stripe) of knipkaart. Knipkaarten zijn 12 maanden geldig na aankoopdatum. Prijzen zijn inclusief BTW tenzij anders vermeld. Zwemschool Snorkeltje behoudt zich het recht voor tarieven aan te passen.',
            ),
            _buildSection(
              '6. Knipkaarten',
              'Knipkaarten zijn persoonsgebonden en niet overdraagbaar. Bij verlies van een knipkaart kan contact worden opgenomen met de administratie. Resterende lessen op een verlopen knipkaart komen te vervallen zonder recht op restitutie.',
            ),
            _buildSection(
              '7. Aansprakelijkheid',
              'Zwemschool Snorkeltje spant zich in voor een veilige lesomgeving, maar is niet aansprakelijk voor schade of letsel opgelopen tijdens of rondom de les, tenzij sprake is van opzet of grove nalatigheid van de instructeur.',
            ),
            _buildSection(
              '8. Privacy',
              'Wij gaan zorgvuldig om met uw persoonsgegevens in overeenstemming met de Algemene Verordening Gegevensbescherming (AVG). Uw gegevens worden uitsluitend gebruikt voor het verlenen van onze diensten. Zie ons Privacybeleid voor meer informatie.',
            ),
            _buildSection(
              '9. Intellectueel eigendom',
              'Alle content in de app, waaronder teksten, afbeeldingen en het logo, is eigendom van Zwemschool Snorkeltje en mag niet zonder toestemming worden gekopieerd of verspreid.',
            ),
            _buildSection(
              '10. Wijzigingen',
              'Zwemschool Snorkeltje behoudt zich het recht voor deze voorwaarden te wijzigen. Bij belangrijke wijzigingen wordt u hiervan op de hoogte gesteld via de app of per e-mail.',
            ),
            _buildSection(
              '11. Contact',
              'Voor vragen over deze voorwaarden kunt u contact opnemen via:\n\nZwemschool Snorkeltje\nE-mail: info@snorkeltje.nl\nTelefoon: +31 30 123 4567\nAdres: Kerkstraat 1, 3732 AA De Bilt',
            ),

            const SizedBox(height: AppDimensions.sectionSpacing),

            // Divider
            const Divider(color: AppColors.divider),
            const SizedBox(height: AppDimensions.md),

            // Footer
            const Center(
              child: Text(
                'Zwemschool Snorkeltje - Zwemles op maat',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textLight,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sectionSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
