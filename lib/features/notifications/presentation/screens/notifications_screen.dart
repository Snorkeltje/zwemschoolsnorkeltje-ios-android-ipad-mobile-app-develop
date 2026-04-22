import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/utils/smart_back.dart';

class _Notif {
  final String emoji;
  final Color emojiBg;
  final String title;
  final String subtitle;
  final String time;
  final bool unread;
  const _Notif(this.emoji, this.emojiBg, this.title, this.subtitle, this.time, this.unread);
}

const _today = <_Notif>[
  _Notif('📅', Color(0xFFE1EDF8), 'Lesherinnering', 'Morgen ma 15:00 — De Bilt Zwembad', 'Nu', true),
  _Notif('📊', Color(0xFFFFEBE0), 'Voortgang bijgewerkt', "Jan heeft Sami's voortgang van vandaag", '2u', true),
  _Notif('💳', Color(0xFFFDE7E7), 'Knipkaart bijna op', 'Knipkaart loopt af: nog 3 lessen resterend', '1d', true),
];

const _earlier = <_Notif>[
  _Notif('✅', Color(0xFFE3F7ED), 'Les geboekt', 'Extra 1-op-1 geboekt voor 30 apr om 16:00', '2d', false),
  _Notif('💰', Color(0xFFE3F7ED), 'Terugbetaling', '€5,00 terugbetaald — les omgezet naar 1-op-2', '3d', false),
  _Notif('💬', Color(0xFFE1EDF8), 'Nieuw bericht', 'Jan de Vries: Tot maandag om 15:00 🏊', '3d', false),
];

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Column(
        children: [
          // Header with back button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 56, 16, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.canPop() ? context.pop() : null,
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.chevron_left, color: Color(0xFF131827), size: 22),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text('Meldingen',
                        style: TextStyle(color: Color(0xFF131827), fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                ),
                const Text('Alles gelezen',
                    style: TextStyle(color: Color(0xFF0365C4), fontSize: 13, fontWeight: FontWeight.w500)),
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
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text('Vandaag',
                        style: TextStyle(color: Color(0xFF818EA6), fontSize: 12, fontWeight: FontWeight.w500)),
                  ),
                  ..._today.map((n) => _buildCard(n, bg: const Color(0xFFF4F7FD))),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text('Eerder',
                        style: TextStyle(color: Color(0xFF818EA6), fontSize: 12, fontWeight: FontWeight.w500)),
                  ),
                  ..._earlier.map((n) => _buildCard(n, bg: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(_Notif n, {required Color bg}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (n.unread)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(color: Color(0xFF0365C4), shape: BoxShape.circle),
              ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: n.emojiBg, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(n.emoji, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(n.title,
                      style: TextStyle(
                        color: const Color(0xFF131827),
                        fontSize: 13,
                        fontWeight: n.unread ? FontWeight.w700 : FontWeight.normal,
                      )),
                  Text(n.subtitle,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFF818EA6), fontSize: 11)),
                ],
              ),
            ),
            Text(n.time,
                style: const TextStyle(color: Color(0xFF818EA6), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
