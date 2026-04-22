import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/utils/smart_back.dart';

const _days = ['Ma', 'Di', 'Wo', 'Do', 'Vr', 'Za', 'Zo'];
const _locations = ['De Bilt', 'Bad Hulckesteijn', 'Garderen', 'Wolfheze'];

class WaitlistScreen extends StatefulWidget {
  const WaitlistScreen({super.key});
  @override
  State<WaitlistScreen> createState() => _WaitlistScreenState();
}

class _WaitlistScreenState extends State<WaitlistScreen> {
  final Set<String> _selectedDays = {'Ma', 'Wo', 'Vr'};
  final Set<String> _selectedLocs = {'De Bilt', 'Bad Hulckesteijn'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Column(
        children: [
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
                const Text('Wachtlijst',
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
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text('Wij melden u automatisch als er een plek vrijkomt.',
                        style: TextStyle(color: Color(0xFF44516B), fontSize: 14)),
                  ),

                  // Lesson type
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text('Lestype',
                        style: TextStyle(color: Color(0xFF818EA6), fontSize: 12, fontWeight: FontWeight.w500)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFDCE4F0), width: 1.5),
                    ),
                    child: const Text('1-op-1 Zwemles  ▼',
                        style: TextStyle(color: Color(0xFF131827), fontSize: 14)),
                  ),

                  const SizedBox(height: 16),
                  // Preferred locations
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text('Voorkeursloc.',
                        style: TextStyle(color: Color(0xFF818EA6), fontSize: 12, fontWeight: FontWeight.w500)),
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 5.5,
                    children: _locations.map((loc) {
                      final sel = _selectedLocs.contains(loc);
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (sel) {
                            _selectedLocs.remove(loc);
                          } else {
                            _selectedLocs.add(loc);
                          }
                        }),
                        child: Container(
                          decoration: BoxDecoration(
                            color: sel ? const Color(0xFFF0F4FC) : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: sel ? const Color(0xFF0365C4) : const Color(0xFFDCE4F0),
                              width: sel ? 2 : 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text('${sel ? "✓ " : ""}$loc',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: sel ? FontWeight.w700 : FontWeight.normal,
                                color: sel ? const Color(0xFF0365C4) : const Color(0xFF818EA6),
                              )),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),
                  // Days
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text('Voorkeursdagen',
                        style: TextStyle(color: Color(0xFF818EA6), fontSize: 12, fontWeight: FontWeight.w500)),
                  ),
                  Row(
                    children: _days.map((day) {
                      final sel = _selectedDays.contains(day);
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            if (sel) {
                              _selectedDays.remove(day);
                            } else {
                              _selectedDays.add(day);
                            }
                          }),
                          child: Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: sel ? const Color(0xFF0365C4) : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(day,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: sel ? FontWeight.w700 : FontWeight.normal,
                                  color: sel ? Colors.white : const Color(0xFF818EA6),
                                )),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),
                  // Time preference
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text('Tijdvoorkeur',
                        style: TextStyle(color: Color(0xFF818EA6), fontSize: 12, fontWeight: FontWeight.w500)),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          child: const Text('Van: 14:00',
                              style: TextStyle(color: Color(0xFF131827), fontSize: 14)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          child: const Text('Tot: 18:00',
                              style: TextStyle(color: Color(0xFF131827), fontSize: 14)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  // Info banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3DB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('ℹ️  Bij een vrije plek krijgt u direct bericht',
                        style: TextStyle(color: Color(0xFFFCAA00), fontSize: 13, fontWeight: FontWeight.w500)),
                  ),

                  const SizedBox(height: 16),
                  // Submit
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0365C4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: const Text('Aanmelden voor wachtlijst',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
