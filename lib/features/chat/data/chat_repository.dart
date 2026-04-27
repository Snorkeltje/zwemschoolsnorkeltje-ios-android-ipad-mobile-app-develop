import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConversationItem {
  final String id;
  final String parentId;
  final String parentName;
  final String parentInitial;
  final String instructorId;
  final String instructorName;
  final String? childId;
  final String childName;
  final String subject;
  final String lastMessage;
  final DateTime lastMessageAt;
  final List<Color> gradient;
  final bool online;
  final bool isFromMe;
  /// Unread depends on whether current user has read the latest message — needs context.
  final int unread;

  const ConversationItem({
    required this.id,
    required this.parentId,
    required this.parentName,
    required this.parentInitial,
    required this.instructorId,
    required this.instructorName,
    required this.childId,
    required this.childName,
    required this.subject,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.gradient,
    required this.online,
    required this.isFromMe,
    required this.unread,
  });

  String relativeTime() {
    final diff = DateTime.now().difference(lastMessageAt);
    if (diff.inMinutes < 1) return 'Nu';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) {
      final hh = lastMessageAt.hour.toString().padLeft(2, '0');
      final mm = lastMessageAt.minute.toString().padLeft(2, '0');
      return '$hh:$mm';
    }
    if (diff.inDays == 1) return 'Gisteren';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${(diff.inDays / 7).floor()}w';
  }
}

class ChatMessageItem {
  final String id;
  final String conversationId;
  final String senderId;
  final String body;
  final List<String> readBy;
  final DateTime createdAt;

  const ChatMessageItem({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.body,
    required this.readBy,
    required this.createdAt,
  });

  bool get readByOther => readBy.length > 1;
  String get time {
    final hh = createdAt.hour.toString().padLeft(2, '0');
    final mm = createdAt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}

/// Color palettes used as fallbacks for chat avatars when no avatar URL exists.
const _kGradients = <List<Color>>[
  [Color(0xFF0365C4), Color(0xFF00C1FF)],
  [Color(0xFF27AE60), Color(0xFF2ECC71)],
  [Color(0xFFFF5C00), Color(0xFFF5A623)],
  [Color(0xFF9B59B6), Color(0xFF8E44AD)],
  [Color(0xFFE74C3C), Color(0xFFC0392B)],
  [Color(0xFF1ABC9C), Color(0xFF16A085)],
];

class ChatRepository {
  ChatRepository(this._client);
  final SupabaseClient _client;

  /// Conversations involving the current user (parent OR instructor).
  Future<List<ConversationItem>> fetchMyConversations() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return const [];
    final rows = await _client
        .from('conversations')
        .select('''
          id, subject, last_message, last_message_at,
          parent_id, instructor_id, child_id,
          parent:parent_id ( first_name, last_name ),
          instructor:instructor_id ( first_name, last_name ),
          children:child_id ( first_name, last_name )
        ''')
        .or('parent_id.eq.$uid,instructor_id.eq.$uid')
        .order('last_message_at', ascending: false);

    final list = <ConversationItem>[];
    for (var i = 0; i < rows.length; i++) {
      final r = rows[i];
      final parent = (r['parent'] as Map?) ?? const {};
      final instructor = (r['instructor'] as Map?) ?? const {};
      final child = (r['children'] as Map?) ?? const {};
      final parentName = '${(parent['first_name'] as String?) ?? ''} ${(parent['last_name'] as String?) ?? ''}'.trim();
      final instructorName = '${(instructor['first_name'] as String?) ?? ''} ${(instructor['last_name'] as String?) ?? ''}'.trim();
      final childName = '${(child['first_name'] as String?) ?? ''}'.trim();
      list.add(ConversationItem(
        id: r['id'] as String,
        parentId: r['parent_id'] as String,
        parentName: parentName.isEmpty ? 'Ouder' : parentName,
        parentInitial: parentName.isEmpty ? '?' : parentName[0].toUpperCase(),
        instructorId: r['instructor_id'] as String,
        instructorName: instructorName.isEmpty ? 'Instructeur' : instructorName,
        childId: r['child_id'] as String?,
        childName: childName,
        subject: (r['subject'] as String?) ?? '',
        lastMessage: (r['last_message'] as String?) ?? '',
        lastMessageAt: DateTime.parse((r['last_message_at'] as String?) ?? DateTime.now().toIso8601String()),
        gradient: _kGradients[i % _kGradients.length],
        online: false,
        isFromMe: false,
        unread: 0,
      ));
    }
    return list;
  }

  Future<List<ChatMessageItem>> fetchMessages(String conversationId) async {
    final rows = await _client
        .from('messages')
        .select('id, conversation_id, sender_id, body, read_by, created_at')
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true);
    return rows.map<ChatMessageItem>((j) => ChatMessageItem(
          id: j['id'] as String,
          conversationId: j['conversation_id'] as String,
          senderId: j['sender_id'] as String,
          body: (j['body'] as String?) ?? '',
          readBy: ((j['read_by'] as List?)?.cast<String>()) ?? const [],
          createdAt: DateTime.parse(j['created_at'] as String),
        )).toList();
  }

  Future<ChatMessageItem> sendMessage({
    required String conversationId,
    required String body,
  }) async {
    final uid = _client.auth.currentUser!.id;
    final inserted = await _client.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': uid,
      'body': body,
    }).select('id, conversation_id, sender_id, body, read_by, created_at').single();
    // Bump conversation last_message + last_message_at.
    await _client.from('conversations').update({
      'last_message': body,
      'last_message_at': DateTime.now().toIso8601String(),
    }).eq('id', conversationId);
    return ChatMessageItem(
      id: inserted['id'] as String,
      conversationId: inserted['conversation_id'] as String,
      senderId: inserted['sender_id'] as String,
      body: (inserted['body'] as String?) ?? '',
      readBy: ((inserted['read_by'] as List?)?.cast<String>()) ?? const [],
      createdAt: DateTime.parse(inserted['created_at'] as String),
    );
  }
}
