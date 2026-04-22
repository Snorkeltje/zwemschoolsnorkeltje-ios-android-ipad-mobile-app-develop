import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/instructor_providers.dart';
import '../theme/instructor_theme.dart';

class InstructorChatListScreen extends ConsumerStatefulWidget {
  const InstructorChatListScreen({super.key});

  @override
  ConsumerState<InstructorChatListScreen> createState() => _InstructorChatListScreenState();
}

class _InstructorChatListScreenState extends ConsumerState<InstructorChatListScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final conversations = ref.watch(conversationsProvider);
    final totalUnread = ref.read(conversationsProvider.notifier).totalUnread;
    final filtered = _search.isEmpty
        ? conversations
        : conversations.where((c) =>
            c.parentName.toLowerCase().contains(_search.toLowerCase()) ||
            c.studentName.toLowerCase().contains(_search.toLowerCase())).toList();
    final hPad = ITheme.hPad(context);
    return Scaffold(
      backgroundColor: ITheme.bg,
      body: Column(
        children: [
          // Header
          ClipRect(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [ITheme.headerGradStart, ITheme.headerGradEnd],
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
                            totalUnread > 0 ? '$totalUnread ongelezen berichten' : 'Alles bijgewerkt',
                            style: const TextStyle(color: ITheme.textMid, fontSize: 13),
                          ),
                        ],
                      ),
                      if (totalUnread > 0)
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)]),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: ITheme.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                          ),
                          child: Center(child: Text('$totalUnread', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700))),
                        ),
                    ],
                  ),
                ),
                // Cyan radial decoration
                Positioned(
                  top: -54, right: -54,
                  child: IgnorePointer(
                    child: Container(
                      width: 180, height: 180,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Color(0x1000C1FF), Colors.transparent],
                          stops: [0.0, 0.7],
                        ),
                      ),
                    ),
                  ),
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
                  color: ITheme.bgElev,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(Icons.search, color: ITheme.textMid, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _search = v),
                        style: const TextStyle(color: ITheme.textHi, fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Zoek gesprekken...',
                          hintStyle: TextStyle(color: ITheme.textLo, fontSize: 14),
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
                const Text('NU ONLINE', style: TextStyle(color: ITheme.textMid, fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 72,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: conversations.where((c) => c.online).map((c) {
                      return GestureDetector(
                        onTap: () => context.push('/instructor/chat/${c.id}'),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 48, height: 48,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: c.gradient),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Center(child: Text(c.initial, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
                                  ),
                                  Positioned(
                                    bottom: 0, right: 0,
                                    child: Container(
                                      width: 14, height: 14,
                                      decoration: BoxDecoration(
                                        color: ITheme.green,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: ITheme.bg, width: 2.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                c.parentName.split(' ').first,
                                style: const TextStyle(color: ITheme.textMid, fontSize: 10, fontWeight: FontWeight.w500),
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
              child: Text('ALLE GESPREKKEN', style: TextStyle(color: ITheme.textMid, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              color: ITheme.primary,
              backgroundColor: ITheme.bgElev,
              onRefresh: () async {
                HapticFeedback.selectionClick();
                await Future.delayed(const Duration(milliseconds: 400));
              },
              child: filtered.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 60),
                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.forum_outlined, size: 48, color: Colors.white.withValues(alpha: 0.2)),
                            const SizedBox(height: 12),
                            const Text('Geen gesprekken',
                                style: TextStyle(color: ITheme.textMid, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 24),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final conv = filtered[index];
                final hasUnread = conv.unread > 0;

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.push('/instructor/chat/${conv.id}');
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: hasUnread ? const Color(0xFFFF5C00).withValues(alpha: 0.06) : const Color(0xFF1A1D27),
                      borderRadius: BorderRadius.circular(16),
                      border: hasUnread ? Border.all(color: ITheme.primary.withValues(alpha: 0.15)) : null,
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 50, height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: conv.gradient),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(child: Text(conv.initial, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
                            ),
                            if (conv.online)
                              Positioned(
                                bottom: 0, right: 0,
                                child: Container(
                                  width: 14, height: 14,
                                  decoration: BoxDecoration(
                                    color: ITheme.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: ITheme.bg, width: 2.5),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(child: Text(conv.parentName, style: TextStyle(color: const Color(0xFFE2E8F0), fontSize: 14, fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500), overflow: TextOverflow.ellipsis)),
                                  Text(conv.time, style: TextStyle(fontSize: 11, fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400, color: hasUnread ? const Color(0xFFFF5C00) : const Color(0xFF4A5568))),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(conv.studentName, style: const TextStyle(color: ITheme.textLo, fontSize: 11)),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  if (conv.isFromMe)
                                    const Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: Icon(Icons.done_all, size: 12, color: Color(0xFF0365C4)),
                                    ),
                                  if (conv.hasAttachment)
                                    const Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: Icon(Icons.attach_file, size: 10, color: ITheme.textLo),
                                    ),
                                  Expanded(
                                    child: Text(
                                      conv.lastMessage,
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
                                boxShadow: [BoxShadow(color: ITheme.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))],
                              ),
                              child: Center(child: Text('${conv.unread}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            ),
          ),
        ],
      ),
    );
  }
}
