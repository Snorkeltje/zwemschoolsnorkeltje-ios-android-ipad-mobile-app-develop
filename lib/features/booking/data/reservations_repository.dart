import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReservationItem {
  final String id;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String location;
  final String instructor;
  final String type;          // '1-op-1' / '1-op-2' / '1-op-3'
  final String childName;
  final String status;        // confirmed/completed/cancelled
  final int amountCents;
  final Color accentColor;

  const ReservationItem({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.instructor,
    required this.type,
    required this.childName,
    required this.status,
    required this.amountCents,
    required this.accentColor,
  });

  bool get isUpcoming => status == 'confirmed' || status == 'pending_payment';
  bool get isHistory => status == 'completed' || status == 'cancelled';
}

class ReservationsRepository {
  ReservationsRepository(this._client);
  final SupabaseClient _client;

  Future<List<ReservationItem>> fetchForParent(String parentId) async {
    final rows = await _client
        .from('reservations')
        .select('''
          id, status, amount_cents,
          children:child_id ( first_name, last_name, avatar_color ),
          lessons:lesson_id (
            date, start_time, end_time, type,
            locations:location_id ( name ),
            profiles:instructor_id ( first_name, last_name )
          )
        ''')
        .eq('parent_id', parentId)
        .order('confirmed_at', ascending: false);
    return rows.map<ReservationItem>(_map).toList();
  }

  Future<List<ReservationItem>> fetchForInstructor(String instructorId) async {
    final rows = await _client
        .from('reservations')
        .select('''
          id, status, amount_cents,
          children:child_id ( first_name, last_name, avatar_color ),
          lessons:lesson_id!inner (
            date, start_time, end_time, type, instructor_id,
            locations:location_id ( name ),
            profiles:instructor_id ( first_name, last_name )
          )
        ''')
        .eq('lessons.instructor_id', instructorId)
        .order('confirmed_at', ascending: false);
    return rows.map<ReservationItem>(_map).toList();
  }

  ReservationItem _map(Map<String, dynamic> r) {
    final lesson = (r['lessons'] as Map?) ?? const {};
    final child = (r['children'] as Map?) ?? const {};
    final loc = (lesson['locations'] as Map?) ?? const {};
    final instr = (lesson['profiles'] as Map?) ?? const {};
    final type = (lesson['type'] as String?) ?? '1-op-1';
    return ReservationItem(
      id: r['id'] as String,
      date: DateTime.parse(lesson['date'] as String? ?? DateTime.now().toIso8601String()),
      startTime: (lesson['start_time'] as String?) ?? '00:00',
      endTime: (lesson['end_time'] as String?) ?? '00:00',
      location: (loc['name'] as String?) ?? '—',
      instructor: '${(instr['first_name'] as String?) ?? ''} ${(instr['last_name'] as String?) ?? ''}'.trim(),
      type: type,
      childName: '${(child['first_name'] as String?) ?? ''} ${(child['last_name'] as String?) ?? ''}'.trim(),
      status: (r['status'] as String?) ?? 'confirmed',
      amountCents: (r['amount_cents'] as int?) ?? 0,
      accentColor: _colorForType(type),
    );
  }

  Color _colorForType(String t) => switch (t) {
        '1-op-1' => const Color(0xFF0365C4),
        '1-op-2' => const Color(0xFFFF5C00),
        '1-op-3' => const Color(0xFF27AE60),
        _ => const Color(0xFF8E9BB3),
      };
}
