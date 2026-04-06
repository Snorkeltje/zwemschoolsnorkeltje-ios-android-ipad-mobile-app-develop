import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InstructorChatListScreen extends StatefulWidget {
  const InstructorChatListScreen({super.key});

  @override
  State<InstructorChatListScreen> createState() => _InstructorChatListScreenState();
}

class _InstructorChatListScreenState extends State<InstructorChatListScreen> {
  String _search = '';

  final List<Map<String, dynamic>> _conversations = [
    {'id': 1, 'parentName': 'Ahmed Khilji', 'initial': 'A', 'studentName': 'Sami & Noor', 'lastMessage': 'Bedankt voor de feedback! We gaan thuis oefenen.', 'time': '14:32', 'unread': 2, 'online': true, 'gradient': const [Color(0xFF0365C4), Color(0xFF00C1FF)], 'isFromMe': false},
    {'id': 2, 'parentName': 'Maria Bos', 'initial': 'M', 'studentName': 'Lisa', 'lastMessage': 'Lisa is volgende week op vakantie, kunnen we de les verplaatsen?', 'time': '13:15', 'unread': 1, 'online': false, 'gradient': const [Color(0xFF27AE60), Color(0xFF2ECC71)], 'isFromMe': false},
    {'id': 3, 'parentName': 'Kees van Dijk', 'initial': 'K', 'studentName': 'Tim', 'lastMessage': 'Video van de oefeningen gestuurd', 'time': '11:40', 'unread': 0, 'online': true, 'gradient': const [Color(0xFF9B59B6), Color(0xFF8E44AD)], 'isFromMe': true, 'hasAttachment': true},
    {'id': 4, 'parentName': 'Pieter Jansen', 'initial': 'P', 'studentName': 'Emma', 'lastMessage': 'Emma heeft echt geweldig gezwommen vandaag!', 'time': 'Gisteren', 'unread': 0, 'online': false, 'gradient': const [Color(0xFFE74C3C), Color(0xFFC0392B)], 'isFromMe': true},
    {'id': 5, 'parentName': 'Anna Bakker', 'initial': 'An', 'studentName': 'Daan', 'lastMessage': 'Daan is een beetje verkouden, hij komt wel.', 'time': 'Gisteren', 'unread': 0, 'online': false, 'gradient': const [Color(0xFFF39C12), Color(0xFFE67E22)], 'isFromMe': false},
    {'id': 6, 'parentName': 'Jan de Wit', 'initial': 'J', 'studentName': 'Sophie', 'lastMessage': 'Super, we zien u maandag!', 'time': 'Ma', 'unread': 0, 'online': false, 'gradient': const [Color(0xFF1ABC9C), Color(0xFF16A085)], 'isFromMe': false},
  ];

  int get _totalUnread => _conversations.fold(0, (sum, c) => sum + (c['unread'] as int));

  List<Map<String, dynamic>> get _filtered {
    if (_search.isEmpty) return _conversations;
    return _conversations.where((c) =>
        (c['parentName'] as String).toLowerCase().contains(_search.toLowerCase()) ||
        (c['studentName'] as String).toLowerCase().contains(_search.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A1D27), Color(0xFF252836)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Berichten', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(
                      _totalUnread > 0 ? '$_totalUnread ongelezen berichten' : 'Alles bijgewerkt',
                      style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 13),
                    ),
                  ],
                ),
                if (_totalUnread > 0)
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)]),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: const Color(0xFFFF5C00).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: Center(child: Text('$_totalUnread', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700))),
                  ),
              ],
            ),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Transform.translate(
              offset: const Offset(0, -8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1D27),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(Icons.search, color: Color(0xFF8E9BB3), size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _search = v),
                        style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Zoek gesprekken...',
                          hintStyle: TextStyle(color: Color(0xFF4A5568), fontSize: 14),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Online now
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('NU ONLINE', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 72,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _conversations.where((c) => c['online'] == true).map((c) {
                      final gradientColors = c['gradient'] as List<Color>;
                      return GestureDetector(
                        onTap: () => context.push('/instructor/chat/${c['id']}'),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 48, height: 48,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: gradientColors),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Center(child: Text(c['initial'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
                                  ),
                                  Positioned(
                                    bottom: 0, right: 0,
                                    child: Container(
                                      width: 14, height: 14,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF27AE60),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: const Color(0xFF0F1117), width: 2.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                (c['parentName'] as String).split(' ').first,
                                style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // All conversations
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text('ALLE GESPREKKEN', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final conv = _filtered[index];
                final gradientColors = conv['gradient'] as List<Color>;
                final hasUnread = (conv['unread'] as int) > 0;

                return GestureDetector(
                  onTap: () => context.push('/instructor/chat/${conv['id']}'),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: hasUnread ? const Color(0xFFFF5C00).withOpacity(0.06) : const Color(0xFF1A1D27),
                      borderRadius: BorderRadius.circular(16),
                      border: hasUnread ? Border.all(color: const Color(0xFFFF5C00).withOpacity(0.15)) : null,
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        Stack(
                          children: [
                            Container(
                              width: 50, height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: gradientColors),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(child: Text(conv['initial'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
                            ),
                            if (conv['online'] == true)
                              Positioned(
                                bottom: 0, right: 0,
                                child: Container(
                                  width: 14, height: 14,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF27AE60),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFF0F1117), width: 2.5),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(child: Text(conv['parentName'], style: TextStyle(color: const Color(0xFFE2E8F0), fontSize: 14, fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500), overflow: TextOverflow.ellipsis)),
                                  Text(conv['time'], style: TextStyle(fontSize: 11, fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400, color: hasUnread ? const Color(0xFFFF5C00) : const Color(0xFF4A5568))),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(conv['studentName'], style: const TextStyle(color: Color(0xFF4A5568), fontSize: 11)),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  if (conv['isFromMe'] == true)
                                    const Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: Icon(Icons.done_all, size: 12, color: Color(0xFF0365C4)),
                                    ),
                                  if (conv['hasAttachment'] == true)
                                    const Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: Icon(Icons.attach_file, size: 10, color: Color(0xFF4A5568)),
                                    ),
                                  Expanded(
                                    child: Text(
                                      conv['lastMessage'],
                                      style: TextStyle(fontSize: 12, color: hasUnread ? const Color(0xFFE2E8F0) : const Color(0xFF4A5568), fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (hasUnread)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Container(
                              width: 24, height: 24,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)]),
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: const Color(0xFFFF5C00).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
                              ),
                              child: Center(child: Text('${conv['unread']}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
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
