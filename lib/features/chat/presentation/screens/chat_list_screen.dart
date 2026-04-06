import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class _Chat {
  final String id;
  final String initial;
  final String name;
  final String role;
  final String msg;
  final String time;
  final int unread;
  final Color color;
  final Color bg;
  const _Chat(this.id, this.initial, this.name, this.role, this.msg, this.time, this.unread, this.color, this.bg);
}

const _chats = <_Chat>[
  _Chat('1', 'J', 'Jan de Vries', 'Uw Instructeur', 'See you Monday at 15:00 🏊', '14:33', 2, Color(0xFF1A6FBF), Color(0xFFE8F4FD)),
  _Chat('2', 'M', 'Maria Jansen', 'Extra Les Instructeur', 'Great session today! Sami really...', 'Gisteren', 0, Color(0xFF27AE60), Color(0xFFE8F7ED)),
  _Chat('3', 'S', 'Snorkeltje Admin', 'Schooladministratie', 'Uw knipkaart verloopt over 30 dagen.', '2d', 1, Color(0xFFF5A623), Color(0xFFFEF3DB)),
];

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 12),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 22),
                Text('Berichten',
                    style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w700)),
                Icon(Icons.edit_outlined, color: Color(0xFF1A6FBF), size: 22),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: _chats.length,
              separatorBuilder: (_, __) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 1, color: Color(0xFFE5E7EB)),
              ),
              itemBuilder: (context, i) {
                final chat = _chats[i];
                return GestureDetector(
                  onTap: () => context.pushNamed(RouteNames.chat, pathParameters: {'id': chat.id}),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(color: chat.bg, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: Text(chat.initial,
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: chat.color)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(chat.name,
                                      style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700)),
                                  Text(chat.time,
                                      style: const TextStyle(color: Color(0xFF8E8EA0), fontSize: 11)),
                                ],
                              ),
                              Text(chat.role,
                                  style: const TextStyle(color: Color(0xFF8E8EA0), fontSize: 11)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(chat.msg,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Color(0xFF4A4A6A), fontSize: 12)),
                                  ),
                                  if (chat.unread > 0) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: const BoxDecoration(color: Color(0xFF1A6FBF), shape: BoxShape.circle),
                                      alignment: Alignment.center,
                                      child: Text('${chat.unread}',
                                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
