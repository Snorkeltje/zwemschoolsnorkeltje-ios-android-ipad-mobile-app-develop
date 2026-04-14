import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InstructorChatScreen extends StatefulWidget {
  final String chatId;
  const InstructorChatScreen({super.key, required this.chatId});

  @override
  State<InstructorChatScreen> createState() => _InstructorChatScreenState();
}

class _InstructorChatScreenState extends State<InstructorChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {'from': 'parent', 'text': 'Hoi Jan! Hoe ging de les vandaag met Sami?', 'time': '14:20', 'read': true},
    {'from': 'instructor', 'text': 'Hoi Ahmed! Het ging echt heel goed vandaag. Sami heeft voor het eerst 10 meter vrije slag zonder stoppen gezwommen! 🎉', 'time': '14:22', 'read': true},
    {'from': 'parent', 'text': 'Wauw, wat geweldig! Daar zijn we echt blij mee!', 'time': '14:24', 'read': true},
    {'from': 'instructor', 'text': 'Ja, hij doet het echt fantastisch. Zijn ademhaling wordt steeds beter. Ik stuur zo de thuisoefeningen door.', 'time': '14:26', 'read': true},
    {'from': 'instructor', 'text': 'Tip voor thuis: laat Sami in bad oefenen met blazen in het water. 3x per dag 10 keer. Dit helpt enorm met de ademhaling.', 'time': '14:28', 'read': true},
    {'from': 'parent', 'text': 'Bedankt voor de feedback! We gaan thuis oefenen. Tot maandag! 👍', 'time': '14:32', 'read': true},
  ];

  final List<String> _quickReplies = [
    'Goede voortgang vandaag!',
    'Tot de volgende les!',
    'Thuis oefenen a.u.b.',
    'Les verplaatst ✓',
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'from': 'instructor',
        'text': _controller.text.trim(),
        'time': TimeOfDay.now().format(context),
        'read': false,
      });
      _controller.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A1D27), Color(0xFF252836)],
              ),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.chevron_left, color: Color(0xFFE2E8F0), size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF0365C4), Color(0xFF00C1FF)]),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Center(child: Text('A', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ahmed Khilji', style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 15, fontWeight: FontWeight.w700)),
                      Row(
                        children: [
                          Container(width: 7, height: 7, decoration: const BoxDecoration(color: Color(0xFF27AE60), shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          const Text('Online', style: TextStyle(color: Color(0xFF27AE60), fontSize: 11)),
                          const Text(' · Sami & Noor', style: TextStyle(color: Color(0xFF4A5568), fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.phone_outlined, color: Color(0xFFE2E8F0), size: 18),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.more_vert, color: Color(0xFFE2E8F0), size: 18),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length + 1, // +1 for date separator
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1D27),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Vandaag', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                    ),
                  );
                }
                final msg = _messages[index - 1];
                final isInstructor = msg['from'] == 'instructor';

                return Align(
                  alignment: isInstructor ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: isInstructor
                          ? const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)])
                          : null,
                      color: isInstructor ? null : const Color(0xFF1A1D27),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(isInstructor ? 18 : 6),
                        bottomRight: Radius.circular(isInstructor ? 6 : 18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isInstructor ? const Color(0xFFFF5C00).withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(msg['text'], style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5)),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: isInstructor ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            Text(
                              msg['time'],
                              style: TextStyle(
                                fontSize: 10,
                                color: isInstructor ? Colors.white.withValues(alpha: 0.6) : const Color(0xFF4A5568),
                              ),
                            ),
                            if (isInstructor) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.done_all,
                                size: 12,
                                color: msg['read'] == true ? const Color(0xFF00C1FF) : Colors.white.withValues(alpha: 0.4),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Quick replies
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: _quickReplies.map((reply) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => _controller.text = reply,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: Text(reply, style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11, fontWeight: FontWeight.w500)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // Input area
          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1D27),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Color(0xFF4A5568), size: 20),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Typ een bericht...',
                        hintStyle: TextStyle(color: Color(0xFF4A5568), fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 40, height: 40,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        gradient: _controller.text.trim().isNotEmpty
                            ? const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)])
                            : null,
                        color: _controller.text.trim().isEmpty ? Colors.white.withValues(alpha: 0.06) : null,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: _controller.text.trim().isNotEmpty
                            ? [BoxShadow(color: const Color(0xFFFF5C00).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]
                            : null,
                      ),
                      child: Icon(
                        Icons.arrow_upward,
                        size: 20,
                        color: _controller.text.trim().isNotEmpty ? Colors.white : const Color(0xFF4A5568),
                      ),
                    ),
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
