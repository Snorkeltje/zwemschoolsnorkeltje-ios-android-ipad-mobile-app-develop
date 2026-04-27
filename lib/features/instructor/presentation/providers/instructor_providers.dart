import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../children/presentation/providers/children_provider.dart';
import '../../data/models/instructor_models.dart';

SupabaseClient _supa() => Supabase.instance.client;

// ============= STUDENTS =============
class StudentsNotifier extends StateNotifier<List<Student>> {
  StudentsNotifier()
      : super([
          Student(id: 1, name: 'Sami Khilji', initial: 'S', age: 7, level: 'Gevorderd Beginner', progress: 72, gradient: const [Color(0xFF0365C4), Color(0xFF00C1FF)], location: 'De Bilt', nextLesson: 'Ma 28 apr · 15:00', parentName: 'Ahmed Khilji', parentPhone: '+31 6 12345678', lessonsTotal: 24, trendUp: true, medicalNotes: 'Geen bijzonderheden', allergies: const [], emergencyContact: 'Fatima Khilji · +31 6 87654321'),
          Student(id: 2, name: 'Noor Khilji', initial: 'N', age: 5, level: 'Beginner', progress: 35, gradient: const [Color(0xFFFF5C00), Color(0xFFF5A623)], location: 'De Bilt', nextLesson: 'Ma 28 apr · 15:30', parentName: 'Ahmed Khilji', parentPhone: '+31 6 12345678', lessonsTotal: 12, trendUp: true, medicalNotes: 'Astma — inhaler altijd bij zich', allergies: const ['Pollen'], emergencyContact: 'Fatima Khilji · +31 6 87654321'),
          Student(id: 3, name: 'Lisa Bos', initial: 'L', age: 8, level: 'Gevorderd', progress: 88, gradient: const [Color(0xFF27AE60), Color(0xFF2ECC71)], location: 'Bad Hulckesteijn', nextLesson: 'Wo 30 apr · 14:00', parentName: 'Maria Bos', parentPhone: '+31 6 23456789', lessonsTotal: 42, trendUp: true, medicalNotes: 'Geen bijzonderheden', allergies: const [], emergencyContact: 'Peter Bos · +31 6 98765432'),
          Student(id: 4, name: 'Tim van Dijk', initial: 'T', age: 6, level: 'Beginner', progress: 20, gradient: const [Color(0xFF9B59B6), Color(0xFF8E44AD)], location: 'Ampt v. Nijkerk', nextLesson: 'Do 1 mei · 10:00', parentName: 'Kees van Dijk', lessonsTotal: 8, trendUp: false, medicalNotes: 'Bang voor water — extra voorzichtig in diep bad', allergies: const ['Chloor-gevoelig']),
          Student(id: 5, name: 'Emma Jansen', initial: 'E', age: 9, level: 'Diploma A', progress: 95, gradient: const [Color(0xFFE74C3C), Color(0xFFC0392B)], location: 'De Bilt', nextLesson: 'Vr 2 mei · 16:00', parentName: 'Pieter Jansen', lessonsTotal: 56, trendUp: true),
          Student(id: 6, name: 'Daan Bakker', initial: 'D', age: 7, level: 'Beginner', progress: 45, gradient: const [Color(0xFFF39C12), Color(0xFFE67E22)], location: 'Garderen', nextLesson: 'Ma 28 apr · 16:00', parentName: 'Anna Bakker', lessonsTotal: 18, trendUp: true, medicalNotes: 'Diabetes type 1 — suikerbalans in de gaten houden', allergies: const ['Noten']),
          Student(id: 7, name: 'Sophie de Wit', initial: 'So', age: 6, level: 'Beginner', progress: 30, gradient: const [Color(0xFF1ABC9C), Color(0xFF16A085)], location: 'Bad Hulckesteijn', nextLesson: 'Wo 30 apr · 15:00', parentName: 'Jan de Wit', lessonsTotal: 10, trendUp: false),
          Student(id: 8, name: 'Finn Mulder', initial: 'F', age: 10, level: 'Gevorderd Beginner', progress: 60, gradient: const [Color(0xFF3498DB), Color(0xFF2980B9)], location: 'Ampt v. Nijkerk', nextLesson: 'Do 1 mei · 11:00', parentName: 'Tom Mulder', lessonsTotal: 28, trendUp: true),
        ]);

  void updateStudent(int id, {int? progress, int? lessonsTotal, String? level}) {
    state = state.map((s) {
      if (s.id == id) {
        return s.copyWith(progress: progress, lessonsTotal: lessonsTotal, level: level);
      }
      return s;
    }).toList();
  }

  Student? getById(int id) {
    try {
      return state.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Student? getByInitial(String initial) {
    try {
      return state.firstWhere((s) => s.initial == initial);
    } catch (_) {
      return null;
    }
  }
}

final studentsProvider = StateNotifierProvider<StudentsNotifier, List<Student>>((ref) => StudentsNotifier());

// ============= LESSONS (SCHEDULE) =============
class ScheduleNotifier extends StateNotifier<Map<int, List<Lesson>>> {
  ScheduleNotifier()
      : super({
          28: [
            const Lesson(id: 'l1', time: '09:00', end: '09:30', location: 'De Bilt', students: 1, type: '1-op-1', studentNames: ['Emma J.']),
            const Lesson(id: 'l2', time: '09:30', end: '10:00', location: 'De Bilt', students: 2, type: '1-op-2', studentNames: ['Sami K.', 'Noor K.']),
            const Lesson(id: 'l3', time: '13:00', end: '13:30', location: 'De Bilt', students: 2, type: '1-op-2', studentNames: ['Lisa B.', 'Tim v.D.'], done: true),
            const Lesson(id: 'l4', time: '14:00', end: '14:30', location: 'De Bilt', students: 1, type: '1-op-1', studentNames: ['Daan B.'], done: true),
            const Lesson(id: 'l5', time: '15:00', end: '15:30', location: 'De Bilt', students: 3, type: '1-op-3', studentNames: ['Sophie d.W.', 'Finn M.', 'Max V.'], current: true),
            const Lesson(id: 'l6', time: '16:00', end: '16:30', location: 'Bad Hulck.', students: 2, type: '1-op-2', studentNames: ['Eva K.', 'Luuk S.']),
            const Lesson(id: 'l7', time: '16:30', end: '17:00', location: 'Bad Hulck.', students: 1, type: '1-op-1', studentNames: ['Anna P.']),
            const Lesson(id: 'l8', time: '17:00', end: '17:30', location: 'Bad Hulck.', students: 1, type: '1-op-1', studentNames: ['Noah B.']),
          ],
          29: [
            const Lesson(id: 'l9', time: '09:00', end: '09:30', location: 'Garderen', students: 2, type: '1-op-2', studentNames: ['Mila D.', 'Sem J.']),
            const Lesson(id: 'l10', time: '10:00', end: '10:30', location: 'Garderen', students: 1, type: '1-op-1', studentNames: ['Lotte V.']),
            const Lesson(id: 'l11', time: '14:00', end: '14:30', location: 'De Bilt', students: 2, type: '1-op-2', studentNames: ['Sami K.', 'Lisa B.']),
          ],
          30: [
            const Lesson(id: 'l12', time: '09:00', end: '09:30', location: 'Ampt v. Nijkerk', students: 1, type: '1-op-1', studentNames: ['Tim v.D.']),
            const Lesson(id: 'l13', time: '14:00', end: '14:30', location: 'Bad Hulck.', students: 2, type: '1-op-2', studentNames: ['Emma J.', 'Daan B.']),
            const Lesson(id: 'l14', time: '15:00', end: '15:30', location: 'Bad Hulck.', students: 1, type: '1-op-1', studentNames: ['Sophie d.W.']),
            const Lesson(id: 'l15', time: '16:00', end: '16:30', location: 'Bad Hulck.', students: 2, type: '1-op-2', studentNames: ['Finn M.', 'Noah B.']),
          ],
          1: [
            const Lesson(id: 'l16', time: '10:00', end: '10:30', location: 'Ampt v. Nijkerk', students: 1, type: '1-op-1', studentNames: ['Tim v.D.']),
            const Lesson(id: 'l17', time: '11:00', end: '11:30', location: 'Ampt v. Nijkerk', students: 1, type: '1-op-1', studentNames: ['Finn M.']),
          ],
          2: [
            const Lesson(id: 'l18', time: '14:00', end: '14:30', location: 'De Bilt', students: 2, type: '1-op-2', studentNames: ['Sami K.', 'Noor K.']),
            const Lesson(id: 'l19', time: '15:00', end: '15:30', location: 'De Bilt', students: 1, type: '1-op-1', studentNames: ['Lisa B.']),
            const Lesson(id: 'l20', time: '16:00', end: '16:30', location: 'De Bilt', students: 1, type: '1-op-1', studentNames: ['Emma J.']),
          ],
          3: [],
          4: [],
        });

  void markLessonDone(String lessonId) {
    final newMap = <int, List<Lesson>>{};
    state.forEach((day, lessons) {
      newMap[day] = lessons.map((l) => l.id == lessonId ? l.copyWith(done: true, current: false) : l).toList();
    });
    state = newMap;
  }

  List<Lesson> get todayLessons => state[28] ?? [];
  Lesson? get currentLesson {
    try {
      return todayLessons.firstWhere((l) => l.current);
    } catch (_) {
      return null;
    }
  }
  Lesson? get nextLesson {
    try {
      return todayLessons.firstWhere((l) => !l.done && !l.current);
    } catch (_) {
      return null;
    }
  }
}

final scheduleProvider = StateNotifierProvider<ScheduleNotifier, Map<int, List<Lesson>>>((ref) => ScheduleNotifier());

// ============= CHAT / MESSAGES =============
class ConversationsNotifier extends StateNotifier<List<Conversation>> {
  ConversationsNotifier()
      : super([
          Conversation(id: 1, parentName: 'Ahmed Khilji', initial: 'A', studentName: 'Sami & Noor', lastMessage: 'Bedankt voor de feedback! We gaan thuis oefenen.', time: '14:32', unread: 2, online: true, gradient: const [Color(0xFF0365C4), Color(0xFF00C1FF)], isFromMe: false),
          Conversation(id: 2, parentName: 'Maria Bos', initial: 'M', studentName: 'Lisa', lastMessage: 'Lisa is volgende week op vakantie, kunnen we de les verplaatsen?', time: '13:15', unread: 1, online: false, gradient: const [Color(0xFF27AE60), Color(0xFF2ECC71)], isFromMe: false),
          Conversation(id: 3, parentName: 'Kees van Dijk', initial: 'K', studentName: 'Tim', lastMessage: 'Video van de oefeningen gestuurd', time: '11:40', unread: 0, online: true, gradient: const [Color(0xFF9B59B6), Color(0xFF8E44AD)], isFromMe: true, hasAttachment: true),
          Conversation(id: 4, parentName: 'Pieter Jansen', initial: 'P', studentName: 'Emma', lastMessage: 'Emma heeft echt geweldig gezwommen vandaag!', time: 'Gisteren', unread: 0, online: false, gradient: const [Color(0xFFE74C3C), Color(0xFFC0392B)], isFromMe: true),
          Conversation(id: 5, parentName: 'Anna Bakker', initial: 'An', studentName: 'Daan', lastMessage: 'Daan is een beetje verkouden, hij komt wel.', time: 'Gisteren', unread: 0, online: false, gradient: const [Color(0xFFF39C12), Color(0xFFE67E22)], isFromMe: false),
          Conversation(id: 6, parentName: 'Jan de Wit', initial: 'J', studentName: 'Sophie', lastMessage: 'Super, we zien u maandag!', time: 'Ma', unread: 0, online: false, gradient: const [Color(0xFF1ABC9C), Color(0xFF16A085)], isFromMe: false),
        ]);

  void markRead(int conversationId) {
    state = state.map((c) {
      if (c.id == conversationId) {
        c.unread = 0;
      }
      return c;
    }).toList();
    state = [...state];
  }

  void updateLastMessage(int conversationId, String message, String time) {
    state = state.map((c) {
      if (c.id == conversationId) {
        c.lastMessage = message;
        c.time = time;
        c.isFromMe = true;
      }
      return c;
    }).toList();
    state = [...state];
  }

  Conversation? getById(int id) {
    try {
      return state.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  int get totalUnread => state.fold(0, (sum, c) => sum + c.unread);
}

final conversationsProvider = StateNotifierProvider<ConversationsNotifier, List<Conversation>>((ref) => ConversationsNotifier());

// Messages per conversation
class MessagesNotifier extends StateNotifier<Map<int, List<ChatMessage>>> {
  MessagesNotifier()
      : super({
          1: [
            ChatMessage(id: 1, conversationId: 1, from: 'parent', text: 'Hoi Jan! Hoe ging de les vandaag met Sami?', time: '14:20', read: true),
            ChatMessage(id: 2, conversationId: 1, from: 'instructor', text: 'Hoi Ahmed! Het ging echt heel goed vandaag. Sami heeft voor het eerst 10 meter vrije slag zonder stoppen gezwommen! 🎉', time: '14:22', read: true),
            ChatMessage(id: 3, conversationId: 1, from: 'parent', text: 'Wauw, wat geweldig! Daar zijn we echt blij mee!', time: '14:24', read: true),
            ChatMessage(id: 4, conversationId: 1, from: 'instructor', text: 'Ja, hij doet het echt fantastisch.', time: '14:26', read: true),
            ChatMessage(id: 5, conversationId: 1, from: 'parent', text: 'Bedankt voor de feedback!', time: '14:32', read: false),
          ],
          2: [
            ChatMessage(id: 6, conversationId: 2, from: 'parent', text: 'Lisa is volgende week op vakantie, kunnen we de les verplaatsen?', time: '13:15', read: false),
          ],
        });

  void sendMessage(int conversationId, String text) {
    final now = TimeOfDay.now();
    final time = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final existing = state[conversationId] ?? [];
    final nextId = (existing.isNotEmpty ? existing.last.id : 100) + 1;
    final newMessage = ChatMessage(
      id: nextId,
      conversationId: conversationId,
      from: 'instructor',
      text: text,
      time: time,
      read: false,
    );
    state = {
      ...state,
      conversationId: [...existing, newMessage],
    };
  }

  List<ChatMessage> getMessages(int conversationId) => state[conversationId] ?? [];
}

final messagesProvider = StateNotifierProvider<MessagesNotifier, Map<int, List<ChatMessage>>>((ref) => MessagesNotifier());

// ============= AVAILABILITY =============
class AvailabilityNotifier extends StateNotifier<List<AvailabilitySubmission>> {
  AvailabilityNotifier()
      : super([
          const AvailabilitySubmission(id: 'a1', label: 'Ma-vr 21-25 apr', status: 'Goedgekeurd', statusColor: Color(0xFF27AE60), statusBg: Color(0xFF1D3028), days: {}, startTime: '13:00', endTime: '18:00', notes: ''),
          const AvailabilitySubmission(id: 'a2', label: 'Ma-wo 7-9 apr', status: 'In behandeling', statusColor: Color(0xFFF5A623), statusBg: Color(0xFF322F22), days: {}, startTime: '13:00', endTime: '18:00', notes: ''),
        ]);

  void submitAvailability({
    required Set<int> days,
    required String startTime,
    required String endTime,
    required String notes,
  }) {
    if (days.isEmpty) return;
    final sortedDays = days.toList()..sort();
    final label = 'Dagen ${sortedDays.first}-${sortedDays.last} apr';
    final newSubmission = AvailabilitySubmission(
      id: 'a${DateTime.now().millisecondsSinceEpoch}',
      label: label,
      status: 'In behandeling',
      statusColor: const Color(0xFFF5A623),
      statusBg: const Color(0xFF322F22),
      days: days,
      startTime: startTime,
      endTime: endTime,
      notes: notes,
    );
    state = [newSubmission, ...state];
  }
}

final availabilityProvider = StateNotifierProvider<AvailabilityNotifier, List<AvailabilitySubmission>>((ref) => AvailabilityNotifier());

// ============= INSTRUCTOR PROFILE =============
final profileProvider = StateNotifierProvider<ProfileNotifier, InstructorProfile>((ref) => ProfileNotifier());

class ProfileNotifier extends StateNotifier<InstructorProfile> {
  ProfileNotifier()
      : super(InstructorProfile(
          firstName: 'Jan',
          lastName: 'de Vries',
          email: 'jan.devries@snorkeltje.nl',
          title: 'Zweminstructeur',
          initial: 'JV',
          notificationsOn: true,
          language: 'NL',
        ));

  void toggleNotifications() {
    state = state.copyWith(notificationsOn: !state.notificationsOn);
  }

  void setLanguage(String lang) {
    state = state.copyWith(language: lang);
  }
}

// ============= STATS (derived) =============
final instructorStatsProvider = Provider<InstructorStats>((ref) {
  final schedule = ref.watch(scheduleProvider);
  final students = ref.watch(studentsProvider);

  final today = schedule[28] ?? [];
  final locations = today.map((l) => l.location).toSet().length;
  final studentsToday = today.fold<int>(0, (sum, l) => sum + l.students);
  final avgProgress = students.isEmpty ? 0 : students.fold<int>(0, (sum, s) => sum + s.progress) ~/ students.length;

  return InstructorStats(
    todayLessons: today.length,
    todayStudents: studentsToday,
    todayLocations: locations,
    weekLessons: schedule.values.fold(0, (sum, list) => sum + list.length),
    totalStudents: students.length,
    avgProgress: avgProgress,
    rating: 4.9,
    reviews: 120,
  );
});

// ============= NOTIFICATIONS (unread count) =============
final unreadNotificationsProvider = StateProvider<int>((ref) => 5);

// ============= LIVE LESSONS (Supabase-backed) =============
/// Today's lessons for the current instructor, from `lessons` table.
final instructorTodayLessonsProvider = FutureProvider<List<Lesson>>((ref) async {
  final client = _supa();
  final uid = client.auth.currentUser?.id;
  if (uid == null) return const [];
  final today = DateTime.now();
  final dateStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  final rows = await client
      .from('lessons')
      .select('id, start_time, end_time, type, locations:location_id ( name )')
      .eq('instructor_id', uid)
      .eq('date', dateStr)
      .order('start_time', ascending: true);
  return rows.map<Lesson>((r) {
    final loc = (r['locations'] as Map?) ?? const {};
    final start = (r['start_time'] as String?) ?? '00:00';
    final end = (r['end_time'] as String?) ?? '00:00';
    return Lesson(
      id: r['id'] as String,
      time: start.length >= 5 ? start.substring(0, 5) : start,
      end: end.length >= 5 ? end.substring(0, 5) : end,
      location: (loc['name'] as String?) ?? '—',
      students: 0,
      type: (r['type'] as String?) ?? '1-op-1',
      studentNames: const <String>[],
    );
  }).toList();
});

// ============= LIVE STUDENTS (Supabase-backed) =============
/// Derives Student objects from real Supabase children rows.
/// Replaces the hardcoded studentsProvider seed data.
final liveStudentsProvider = FutureProvider<List<Student>>((ref) async {
  final children = await ref.watch(allChildrenProvider.future);
  // Stable color palette for avatars cycled by index.
  const palettes = <List<Color>>[
    [Color(0xFF0365C4), Color(0xFF00C1FF)],
    [Color(0xFFFF5C00), Color(0xFFF5A623)],
    [Color(0xFF27AE60), Color(0xFF2ECC71)],
    [Color(0xFF9B59B6), Color(0xFF8E44AD)],
    [Color(0xFFE74C3C), Color(0xFFC0392B)],
    [Color(0xFF1ABC9C), Color(0xFF16A085)],
    [Color(0xFFF39C12), Color(0xFFE67E22)],
    [Color(0xFF3498DB), Color(0xFF2980B9)],
  ];
  final list = <Student>[];
  for (var i = 0; i < children.length; i++) {
    final c = children[i];
    list.add(Student(
      id: c.id.hashCode & 0x7fffffff,
      name: c.name,
      initial: c.initials.isEmpty ? 'K' : c.initials.substring(0, 1).toUpperCase(),
      age: c.age,
      level: c.currentLevel,
      progress: 0,
      gradient: palettes[i % palettes.length],
      location: '—',
      nextLesson: '—',
      parentName: '—',
      lessonsTotal: 0,
      trendUp: true,
      medicalNotes: 'Zie volledig profiel',
      allergies: const [],
      emergencyContact: '',
    ));
  }
  return list;
});
