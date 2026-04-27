import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/chat_repository.dart';

final chatRepoProvider = Provider<ChatRepository>(
  (_) => ChatRepository(Supabase.instance.client),
);

/// Conversations involving the current user.
final conversationsProvider = FutureProvider<List<ConversationItem>>(
  (ref) => ref.read(chatRepoProvider).fetchMyConversations(),
);

/// Messages in a single conversation.
final conversationMessagesProvider =
    FutureProvider.family<List<ChatMessageItem>, String>((ref, conversationId) {
  return ref.read(chatRepoProvider).fetchMessages(conversationId);
});
