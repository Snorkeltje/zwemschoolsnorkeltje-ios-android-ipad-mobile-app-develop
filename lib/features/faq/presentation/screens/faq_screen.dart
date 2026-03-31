import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/route_names.dart';

class _FaqItem {
  final String id;
  final String question;
  final String answer;
  final String category;

  const _FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
  });
}

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Alle';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'Alle',
    'Algemeen',
    'Boekingen',
    'Betalingen',
    'Zwemlessen',
  ];

  final List<_FaqItem> _faqItems = const [
    _FaqItem(
      id: 'faq_001',
      question: 'Hoe maak ik een account aan?',
      answer:
          'U kunt alleen een account aanmaken via een uitnodiging van Zwemschool Snorkeltje. Neem contact op met de administratie om een uitnodiging te ontvangen.',
      category: 'Algemeen',
    ),
    _FaqItem(
      id: 'faq_002',
      question: 'Hoe wijzig ik mijn profielgegevens?',
      answer:
          'Ga naar Profiel > Profiel bewerken om uw naam, e-mailadres of telefoonnummer te wijzigen. Vergeet niet om de wijzigingen op te slaan.',
      category: 'Algemeen',
    ),
    _FaqItem(
      id: 'faq_003',
      question: 'Op welke locaties wordt er lesgegeven?',
      answer:
          'Zwemschool Snorkeltje geeft les op meerdere locaties waaronder De Bilt, Soestduinen, Nijkerk, Garderen, Wolfheze en Dordrecht. Niet alle lestypes zijn op elke locatie beschikbaar.',
      category: 'Algemeen',
    ),
    _FaqItem(
      id: 'faq_004',
      question: 'Hoe boek ik een zwemles?',
      answer:
          'Ga naar het tabblad "Boeken" en kies het type les dat u wilt boeken. Selecteer een datum en tijdstip, controleer de gegevens en bevestig uw boeking.',
      category: 'Boekingen',
    ),
    _FaqItem(
      id: 'faq_005',
      question: 'Kan ik een les annuleren?',
      answer:
          'Ja, u kunt een les annuleren tot 24 uur voor aanvang. Ga naar "Mijn reserveringen" en tik op "Annuleer reservering". Bij annulering binnen 24 uur wordt de les wel in rekening gebracht.',
      category: 'Boekingen',
    ),
    _FaqItem(
      id: 'faq_006',
      question: 'Wat is de 14-dagenregel?',
      answer:
          'U kunt uw vaste wekelijkse les maximaal 14 dagen vooruit boeken. Dit geldt alleen voor het vaste tijdstip. Extra lessen kunnen verder vooruit worden geboekt indien beschikbaar.',
      category: 'Boekingen',
    ),
    _FaqItem(
      id: 'faq_007',
      question: 'Hoe boek ik een extra les?',
      answer:
          'Ga naar Boeken > Extra 1-op-1 of Extra 1-op-2, kies een locatie en datum, selecteer een beschikbaar tijdstip en bevestig uw boeking.',
      category: 'Boekingen',
    ),
    _FaqItem(
      id: 'faq_008',
      question: 'Welke betaalmethoden worden geaccepteerd?',
      answer:
          'U kunt betalen met een creditcard (via Stripe) of met een knipkaart. Knipkaarten bieden korting bij het boeken van meerdere lessen tegelijk.',
      category: 'Betalingen',
    ),
    _FaqItem(
      id: 'faq_009',
      question: 'Hoe koop ik een knipkaart?',
      answer:
          'Ga naar het tabblad "Kaarten" en tik op "Koop knipkaart". Kies het type kaart en het aantal lessen, en betaal veilig via Stripe.',
      category: 'Betalingen',
    ),
    _FaqItem(
      id: 'faq_010',
      question: 'Hoe lang is een knipkaart geldig?',
      answer:
          'Een knipkaart is 12 maanden geldig na aankoopdatum. De vervaldatum staat vermeld op uw kaart in de app.',
      category: 'Betalingen',
    ),
    _FaqItem(
      id: 'faq_011',
      question: 'Hoe lang duurt een zwemles?',
      answer:
          'Een standaard zwemles duurt 30 minuten. Zorg dat uw kind 10 minuten voor aanvang aanwezig is om zich om te kleden.',
      category: 'Zwemlessen',
    ),
    _FaqItem(
      id: 'faq_012',
      question: 'Hoe volg ik de voortgang van mijn kind?',
      answer:
          'Ga naar "Voortgang kind" op het startscherm. Hier ziet u het huidige niveau, voltooide vaardigheden en de volgende doelen. Na elke les wordt de voortgang bijgewerkt door de instructeur.',
      category: 'Zwemlessen',
    ),
    _FaqItem(
      id: 'faq_013',
      question: 'Wat is het verschil tussen 1-op-1 en 1-op-2 lessen?',
      answer:
          'Bij een 1-op-1 les krijgt uw kind individuele aandacht van de instructeur. Bij een 1-op-2 les deelt uw kind de les met maximaal een ander kind. 1-op-2 lessen zijn voordeliger.',
      category: 'Zwemlessen',
    ),
  ];

  List<_FaqItem> get _filteredItems {
    return _faqItems.where((item) {
      final matchesCategory =
          _selectedCategory == 'Alle' || item.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          item.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.answer.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Veelgestelde vragen'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.screenPadding,
              0,
              AppDimensions.screenPadding,
              AppDimensions.md,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Zoek in veelgestelde vragen...',
                hintStyle: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 14,
                ),
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.textLight),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            color: AppColors.textLight, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMd),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),

          // Category chips
          Container(
            color: AppColors.white,
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPadding,
              ),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Chip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? AppColors.textWhite
                            : AppColors.textSecondary,
                      ),
                    ),
                    backgroundColor: isSelected
                        ? AppColors.primaryBlue
                        : AppColors.background,
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primaryBlue
                          : AppColors.border,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppDimensions.sm),

          // FAQ list
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptySearch()
                : ListView.separated(
                    padding:
                        const EdgeInsets.all(AppDimensions.screenPadding),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppDimensions.sm),
                    itemBuilder: (context, index) {
                      return _FaqTile(
                        item: filtered[index],
                        onTap: () {
                          context.pushNamed(
                            RouteNames.faqDetail,
                            pathParameters: {'faqId': filtered[index].id},
                          );
                        },
                      );
                    },
                  ),
          ),

          // Contact support bar
          Container(
            padding: EdgeInsets.fromLTRB(
              AppDimensions.screenPadding,
              AppDimensions.md,
              AppDimensions.screenPadding,
              MediaQuery.of(context).padding.bottom + AppDimensions.md,
            ),
            decoration: const BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vraag niet gevonden?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Neem contact met ons op',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Open chat or email
                  },
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text('Chat'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearch() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 48, color: AppColors.textLight),
          const SizedBox(height: AppDimensions.md),
          Text(
            'Geen resultaten gevonden voor "$_searchQuery"',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final _FaqItem item;
  final VoidCallback onTap;

  const _FaqTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            title: Text(
              item.question,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            iconColor: AppColors.primaryBlue,
            collapsedIconColor: AppColors.textLight,
            children: [
              const Divider(color: AppColors.divider),
              const SizedBox(height: 8),
              Text(
                item.answer,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.category,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
