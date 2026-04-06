import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _Msg {
  final int id;
  final String from;
  final String text;
  final String time;
  const _Msg(this.id, this.from, this.text, this.time);
}

const _messages = <_Msg>[
  _Msg(1, 'instructor', 'Hoi! Sami deed het vandaag erg goed. De ademhaling verbetert', '14:30'),
  _Msg(2, 'parent', 'Dat is fijn! Moeten we daar volgende week ook op focussen?', '14:32'),
  _Msg(3, 'instructor', 'Ja, ook de thuisoefeningen die ik stuurde helpen hierbij.', '14:33'),
  _Msg(4, 'parent', 'Perfect, we gaan zeker oefenen! Bedankt!', '14:35'),
  _Msg(5, 'instructor', 'Tot maandag om 15:00 🏊', '14:36'),
];

class ChatScreen extends StatefulWidget {
  final String chatId;
  const ChatScreen({super.key, required this.chatId});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _inputCtrl = TextEditingController();

  @override
  void dispose() {
    _inputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(Icons.arrow_back, color: Color(0xFF131827), size: 22),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(color: Color(0xFFF0F4FC), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const Text('J',
                      style: TextStyle(color: Color(0xFF0365C4), fontSize: 18, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jan de Vries',
                        style: TextStyle(color: Color(0xFF131827), fontSize: 15, fontWeight: FontWeight.w700)),
                    Text('Instructeur · Online',
                        style: TextStyle(color: Color(0xFF18BB68), fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) {
                final msg = _messages[i];
                final isParent = msg.from == 'parent';
                return Column(
                  crossAxisAlignment: isParent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isParent ? const Color(0xFF0365C4) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(msg.text,
                            style: TextStyle(
                              color: isParent ? Colors.white : const Color(0xFF131827),
                              fontSize: 12,
                            )),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(msg.time,
                        style: TextStyle(
                          color: isParent ? const Color(0xFFB2D9FF) : const Color(0xFF818EA6),
                          fontSize: 10,
                        )),
                  ],
                );
              },
            ),
          ),
          // Input
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4FC),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: _inputCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Typ een bericht...',
                        hintStyle: TextStyle(color: Color(0xFF818EA6), fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(color: Color(0xFF131827), fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(color: Color(0xFF0365C4), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
