import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/router/route_names.dart';
import '../providers/chat_provider.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(conversationsProvider);
    final chats = async.value ?? const [];
    final me = Supabase.instance.client.auth.currentUser?.id;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
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
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(conversationsProvider);
                await ref.read(conversationsProvider.future);
              },
              child: async.isLoading && chats.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : chats.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 80),
                            Center(
                              child: Column(
                                children: [
                                  Icon(Icons.forum_outlined, size: 48,
                                      color: Colors.black.withValues(alpha: 0.15)),
                                  const SizedBox(height: 12),
                                  const Text('Nog geen gesprekken',
                                      style: TextStyle(color: Color(0xFF8E8EA0), fontSize: 13)),
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                          itemCount: chats.length,
                          separatorBuilder: (_, __) => const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(height: 1, color: Color(0xFFE5E7EB)),
                          ),
                          itemBuilder: (context, i) {
                            final chat = chats[i];
                            // For parent view: counterpart = instructor; for instructor view: counterpart = parent.
                            final isParent = me == chat.parentId;
                            final counterpartName = isParent ? chat.instructorName : chat.parentName;
                            final counterpartInitial = counterpartName.isEmpty ? '?' : counterpartName[0].toUpperCase();
                            final role = isParent ? 'Uw Instructeur' : 'Ouder van ${chat.childName}';
                            return GestureDetector(
                              onTap: () => context.pushNamed(RouteNames.chat, pathParameters: {'id': chat.id}),
                              child: Container(
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 52, height: 52,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: chat.gradient),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(counterpartInitial,
                                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(counterpartName,
                                                    style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700),
                                                    overflow: TextOverflow.ellipsis),
                                              ),
                                              Text(chat.relativeTime(),
                                                  style: const TextStyle(color: Color(0xFF8E8EA0), fontSize: 11)),
                                            ],
                                          ),
                                          Text(role,
                                              style: const TextStyle(color: Color(0xFF8E8EA0), fontSize: 11)),
                                          const SizedBox(height: 4),
                                          Text(chat.lastMessage,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(color: Color(0xFF4A4A6A), fontSize: 12)),
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
          ),
        ],
      ),
    );
  }
}
