import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/swim_decoration.dart';
import '../../../../shared/utils/smart_back.dart';

class _FAQ {
  final String q;
  final String a;
  final String cat;
  const _FAQ(this.q, this.a, this.cat);
}

const _faqs = <_FAQ>[
  _FAQ('Hoe boek ik een vast tijdstip?', 'Log in en ga naar Boeken → Vast tijdstip. Kies een locatie, dag en tijd.', 'booking'),
  _FAQ('Kan ik een les annuleren?', 'Ja, tot 24 uur van tevoren voor standaard lessen en 96 uur voor vakantielessen.', 'booking'),
  _FAQ('Hoe werken knipkaarten?', 'Koop een knipkaart met een aantal lessen. Per les wordt 1 credit afgeschreven.', 'payment'),
  _FAQ('Wat is een inhaalles?', 'Een les die u kunt boeken als vervanging voor een gemiste les (mits tijdig geannuleerd).', 'lessons'),
  _FAQ('Hoe zie ik de voortgang van mijn kind?', 'Ga naar Thuis → Voortgang om niveaus, vaardigheden en stappen te bekijken.', 'lessons'),
  _FAQ('14-dagenregel: hoe werkt dit?', 'Binnen 14 dagen worden beschikbare plekken opengesteld voor alle ouders, niet alleen vaste leerlingen.', 'booking'),
];

const _categories = [
  ('all', 'Alle'),
  ('booking', 'Boeken'),
  ('payment', 'Betalen'),
  ('lessons', 'Lessen'),
  ('account', 'Account'),
];

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});
  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  String _filter = 'all';
  int _open = 0;
  String _search = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_FAQ> get _filtered => _faqs.where((f) =>
      (_filter == 'all' || f.cat == _filter) &&
      (_search.isEmpty || f.q.toLowerCase().contains(_search.toLowerCase())))
    .toList();

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Stack(
        children: [
          // Swim theme decoration (Walter's feedback)
          const SwimDecoration(size: 160, opacity: 0.08),
          Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => smartBack(context),
                  child: const Icon(Icons.chevron_left, color: Color(0xFF131827), size: 24),
                ),
                const SizedBox(width: 12),
                const Text('Help & Veelgestelde vragen',
                    style: TextStyle(color: Color(0xFF131827), fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      children: [
                        const Text('🔍', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: (v) => setState(() => _search = v),
                            decoration: const InputDecoration(
                              hintText: 'Zoeken in vragen...',
                              hintStyle: TextStyle(color: Color(0xFF818EA6), fontSize: 14),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: const TextStyle(color: Color(0xFF131827), fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Categories
                  SizedBox(
                    height: 30,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final c = _categories[i];
                        final sel = _filter == c.$1;
                        return GestureDetector(
                          onTap: () => setState(() => _filter = c.$1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: sel ? const Color(0xFF0365C4) : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            alignment: Alignment.center,
                            child: Text(c.$2,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: sel ? FontWeight.w700 : FontWeight.normal,
                                  color: sel ? Colors.white : const Color(0xFF818EA6),
                                )),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // FAQ items
                  ...List.generate(list.length, (i) {
                    final faq = list[i];
                    final isOpen = _open == i;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => setState(() => _open = isOpen ? -1 : i),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(faq.q,
                                          style: TextStyle(
                                            color: const Color(0xFF131827),
                                            fontSize: 14,
                                            fontWeight: isOpen ? FontWeight.w700 : FontWeight.normal,
                                          )),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(isOpen ? '▲' : '▼',
                                        style: const TextStyle(color: Color(0xFF818EA6), fontSize: 14)),
                                  ],
                                ),
                              ),
                            ),
                            if (isOpen)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(faq.a,
                                      style: const TextStyle(color: Color(0xFF44516B), fontSize: 12)),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
        ],
      ),
    );
  }
}
