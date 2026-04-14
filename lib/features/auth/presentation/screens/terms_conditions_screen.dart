import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _Section {
  final IconData icon;
  final Color color;
  final String title;
  final String content;
  const _Section(this.icon, this.color, this.title, this.content);
}

const _sections = <_Section>[
  _Section(
    Icons.description_outlined,
    Color(0xFF0365C4),
    'Artikel 1 — Algemeen',
    'Deze algemene voorwaarden zijn van toepassing op alle overeenkomsten tussen Zwemschool Snorkeltje (KvK: 12345678) en de opdrachtgever/cursist. Afwijkingen van deze voorwaarden zijn alleen geldig indien schriftelijk overeengekomen. Zwemschool Snorkeltje is gevestigd te De Bilt, Utrecht, Nederland.',
  ),
  _Section(
    Icons.credit_card,
    Color(0xFFFF5C00),
    'Artikel 2 — Knipkaarten & Betaling',
    '• 1-op-1 knipkaart (10 lessen): €380,00\n• 1-op-2 knipkaart (10 lessen): €190,00 per kind\n• 1-op-3 knipkaart (10 lessen): €114,00 per kind\n\nBetaling geschiedt via iDEAL, creditcard of Bancontact via Mollie. Knipkaarten zijn niet restitueerbaar tenzij anders vermeld. Bij auto-conversie van 1-op-1 naar 1-op-2 wordt het verschil teruggestort.',
  ),
  _Section(
    Icons.access_time,
    Color(0xFF27AE60),
    'Artikel 3 — Reserveringen & Annulering',
    '• Reserveringen kunnen tot 14 dagen vooruit worden gemaakt.\n• Annulering standaard les: minimaal 24 uur van tevoren.\n• Annulering vakantie-les: minimaal 96 uur (4 dagen) van tevoren.\n• Bij te laat annuleren wordt de les van de knipkaart afgeschreven.\n• No-show wordt als verbruikte les geteld.',
  ),
  _Section(
    Icons.people_outline,
    Color(0xFF9B59B6),
    'Artikel 4 — Wachtlijst & Plaatsing',
    'Plaatsing geschiedt op volgorde van inschrijving. Bij een volle groep wordt de cursist op de wachtlijst geplaatst. Wanneer een plek vrijkomt, ontvangt de eerstvolgende op de wachtlijst een uitnodiging. Deze uitnodiging is 48 uur geldig.',
  ),
  _Section(
    Icons.shield_outlined,
    Color(0xFF0365C4),
    'Artikel 5 — Privacy & Gegevens',
    'Zwemschool Snorkeltje verwerkt persoonsgegevens conform de AVG. Gegevens worden uitsluitend gebruikt voor lesadministratie, communicatie en facturering. Gegevens worden niet aan derden verstrekt tenzij wettelijk verplicht. U heeft recht op inzage, correctie en verwijdering van uw gegevens.',
  ),
  _Section(
    Icons.warning_amber_outlined,
    Color(0xFFE74C3C),
    'Artikel 6 — Aansprakelijkheid',
    'Zwemschool Snorkeltje is niet aansprakelijk voor verlies, diefstal of schade aan persoonlijke eigendommen. Deelname aan zwemlessen geschiedt op eigen risico. De ouder/verzorger is verantwoordelijk voor het doorgeven van medische bijzonderheden. Bij twijfel over de gezondheid van het kind kan de instructeur deelname weigeren.',
  ),
];

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});
  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  int? _expanded = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 58, 20, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 0.6, 1.0],
                    colors: [Color(0xFF0365C4), Color(0xFF0D7FE8), Color(0xFF00C1FF)],
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.chevron_left, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Algemene Voorwaarden',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                        Text('Zwemschool Snorkeltje — 2026',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Intro
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.shield_outlined, color: Color(0xFF0365C4), size: 16),
                        SizedBox(width: 8),
                        Text('Laatst bijgewerkt: 1 januari 2026',
                            style: TextStyle(color: Color(0xFF0365C4), fontSize: 13, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Lees deze voorwaarden zorgvuldig door. Door gebruik te maken van onze diensten gaat u akkoord met onderstaande bepalingen.',
                      style: TextStyle(color: Color(0xFF6B7B94), fontSize: 12, height: 1.6),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Sections
            ...List.generate(_sections.length, (i) {
              final s = _sections[i];
              final isOpen = _expanded == i;
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => setState(() => _expanded = isOpen ? null : i),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: s.color.withValues(alpha: 0.07),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(s.icon, color: s.color, size: 17),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(s.title,
                                    style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w600)),
                              ),
                              Icon(isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: const Color(0xFF8E9BB3), size: 18),
                            ],
                          ),
                        ),
                      ),
                      if (isOpen)
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                          decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: Color(0xFFF0F4FA))),
                          ),
                          child: Text(s.content,
                              style: const TextStyle(color: Color(0xFF4A5568), fontSize: 13, height: 1.7)),
                        ),
                    ],
                  ),
                ),
              );
            }),
            // Contact
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4FD),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: const [
                    Text('Vragen?',
                        style: TextStyle(color: Color(0xFF0365C4), fontSize: 13, fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('Neem contact op via info@snorkeltje.nl',
                        style: TextStyle(color: Color(0xFF4A7DB8), fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
