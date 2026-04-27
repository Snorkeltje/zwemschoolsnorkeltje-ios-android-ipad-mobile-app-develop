import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppNotification {
  final String id;
  final String type;
  final String title;
  final String body;
  final bool read;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.read,
    required this.createdAt,
  });

  String get emoji => switch (type) {
        'lesson_reminder' || 'lesson' => '🏊',
        'progress' => '📈',
        'message' => '💬',
        'payment' => '💳',
        'waitlist' => '🎫',
        'schedule' => '📅',
        'admin' => '📢',
        'review' => '⭐',
        'system' => 'ℹ️',
        _ => '🔔',
      };

  Color get color => switch (type) {
        'lesson_reminder' || 'lesson' => const Color(0xFF0365C4),
        'progress' => const Color(0xFF27AE60),
        'message' => const Color(0xFF9B59B6),
        'payment' => const Color(0xFFFF5C00),
        'waitlist' => const Color(0xFFF5A623),
        'schedule' => const Color(0xFFFF5C00),
        'admin' => const Color(0xFF0365C4),
        _ => const Color(0xFF8E9BB3),
      };

  String relativeTime() {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'Nu';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}u';
    if (diff.inDays == 1) return 'Gisteren';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${(diff.inDays / 7).floor()}w';
  }
}

class NotificationsRepository {
  NotificationsRepository(this._client);
  final SupabaseClient _client;

  Future<List<AppNotification>> fetchForCurrentUser({int limit = 50}) async {
    final id = _client.auth.currentUser?.id;
    if (id == null) return const [];
    final rows = await _client
        .from('notifications')
        .select('id, type, title, body, read, created_at')
        .eq('user_id', id)
        .order('created_at', ascending: false)
        .limit(limit);
    return rows.map<AppNotification>((j) => AppNotification(
          id: j['id'] as String,
          type: (j['type'] as String?) ?? 'system',
          title: (j['title'] as String?) ?? '',
          body: (j['body'] as String?) ?? '',
          read: (j['read'] as bool?) ?? false,
          createdAt: DateTime.parse(j['created_at'] as String),
        )).toList();
  }

  Future<int> unreadCount() async {
    final id = _client.auth.currentUser?.id;
    if (id == null) return 0;
    final rows = await _client
        .from('notifications')
        .select('id')
        .eq('user_id', id)
        .eq('read', false);
    return rows.length;
  }

  Future<void> markAllRead() async {
    final id = _client.auth.currentUser?.id;
    if (id == null) return;
    await _client
        .from('notifications')
        .update({'read': true})
        .eq('user_id', id)
        .eq('read', false);
  }

  Future<void> markRead(String notificationId) async {
    await _client
        .from('notifications')
        .update({'read': true})
        .eq('id', notificationId);
  }
}
