import 'package:flutter/material.dart';

/// Fixed weekly schedule — Walter 2026-04-22 / Excel-mirroring.
/// Each slot is a permanent weekly assignment: Monday 15:00 at De Bilt = Sami.
/// When a student stops, the slot is freed and offered to interested waitlist.

enum WeekDay { maandag, dinsdag, woensdag, donderdag, vrijdag, zaterdag, zondag }

extension WeekDayLabel on WeekDay {
  String get short => const ['Ma', 'Di', 'Wo', 'Do', 'Vr', 'Za', 'Zo'][index];
  String get full => const ['Maandag', 'Dinsdag', 'Woensdag', 'Donderdag', 'Vrijdag', 'Zaterdag', 'Zondag'][index];
}

/// One permanent weekly slot.
///
/// Walter's Excel grid (image 2026-04-22): 15-minute row granularity from
/// 08:30 to 19:00. A lesson is 30 minutes long and starts on any 15-min
/// boundary (so a slot could start at 09:00, 09:15, 09:30, etc.).
///
/// 1-op-2 / 1-op-3 lessons share a slot — multiple children listed (separated
/// by "/" in the Excel). [assignedChildren] holds all of them.
class FixedSlot {
  final String id;
  final WeekDay day;
  final String time;       // 'HH:mm' start (any 15-min boundary)
  final String endTime;    // 'HH:mm' end (start + 30 min)
  final String location;
  final Color locationColor;
  /// All children sharing this slot. Empty = free slot.
  final List<AssignedChild> assignedChildren;
  final String instructorId;
  final String instructorName;
  final String lessonType; // '1-op-1' / '1-op-2' / '1-op-3'
  /// True = student is preparing to leave (exam-no flow); slot will free soon.
  final bool pendingRelease;

  const FixedSlot({
    required this.id,
    required this.day,
    required this.time,
    required this.endTime,
    required this.location,
    required this.locationColor,
    this.assignedChildren = const [],
    required this.instructorId,
    required this.instructorName,
    required this.lessonType,
    this.pendingRelease = false,
  });

  /// Backwards-compatible accessors.
  String? get assignedChildId =>
      assignedChildren.isEmpty ? null : assignedChildren.first.id;
  String? get assignedChildName => assignedChildren.isEmpty
      ? null
      : assignedChildren.map((c) => c.name).join(' / ');

  bool get isEmpty => assignedChildren.isEmpty;

  FixedSlot copyWith({
    List<AssignedChild>? assignedChildren,
    String? assignedChildId,    // legacy single-child convenience
    String? assignedChildName,
    bool? pendingRelease,
  }) {
    final children = assignedChildren ??
        (assignedChildId != null
            ? [AssignedChild(id: assignedChildId, name: assignedChildName ?? '')]
            : (assignedChildName == null && assignedChildId == null && this.assignedChildren.isNotEmpty
                ? this.assignedChildren
                : <AssignedChild>[]));
    return FixedSlot(
      id: id, day: day, time: time, endTime: endTime,
      location: location, locationColor: locationColor,
      assignedChildren: children,
      instructorId: instructorId, instructorName: instructorName,
      lessonType: lessonType,
      pendingRelease: pendingRelease ?? this.pendingRelease,
    );
  }
}

/// One child assigned to a fixed slot.
class AssignedChild {
  final String id;
  final String name;
  const AssignedChild({required this.id, required this.name});
}

/// A parent's standing interest in a specific slot.
/// Walter 2026-04-23: parents indicate which slots they want; on opening,
/// system notifies all interested parents with 24h response window;
/// highest priority (earliest registration) wins.
class SlotInterest {
  final String id;
  final String parentId;
  final String parentName;
  final String childId;
  final String childName;
  final String slotKey;     // composite: "${day.index}-${time}-${location}"
  final WeekDay day;
  final String time;
  final String location;
  final DateTime registeredAt;

  const SlotInterest({
    required this.id,
    required this.parentId,
    required this.parentName,
    required this.childId,
    required this.childName,
    required this.slotKey,
    required this.day,
    required this.time,
    required this.location,
    required this.registeredAt,
  });
}

/// 24h response challenge from a slot offer.
class SlotOffer {
  final String id;
  final String slotId;
  final String parentId;
  final String parentName;
  final String childName;
  final WeekDay day;
  final String time;
  final String location;
  final DateTime sentAt;
  final DateTime expiresAt;
  final SlotOfferStatus status;

  const SlotOffer({
    required this.id,
    required this.slotId,
    required this.parentId,
    required this.parentName,
    required this.childName,
    required this.day,
    required this.time,
    required this.location,
    required this.sentAt,
    required this.expiresAt,
    required this.status,
  });

  Duration get timeLeft => expiresAt.difference(DateTime.now());
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

enum SlotOfferStatus { pending, accepted, declined, expired, lost }

/// Exam continuation prompt sent to parent (Walter 2026-04-23).
class ExamContinuation {
  final String id;
  final String childId;
  final String childName;
  final String currentLevel;       // 'Diploma A' / 'B' / 'C'
  final String? nextLevel;         // null if final exam
  final DateTime examDate;
  final DateTime sentAt;
  final DateTime expiresAt;        // 24h
  final ExamContinuationStatus status;
  final String? response;          // 'doorgaan' | 'stoppen' | null

  const ExamContinuation({
    required this.id,
    required this.childId,
    required this.childName,
    required this.currentLevel,
    this.nextLevel,
    required this.examDate,
    required this.sentAt,
    required this.expiresAt,
    required this.status,
    this.response,
  });

  Duration get timeLeft => expiresAt.difference(DateTime.now());
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

enum ExamContinuationStatus { pending, continuing, leaving, expired }

/// Standard locations + color codes — exact match to Walter's Excel legend.
class Locations {
  Locations._();
  static const ampt = Color(0xFFFFB370);     // orange
  static const badHulck = Color(0xFFFFE680); // yellow
  static const deBilt = Color(0xFFFF6B6B);   // red
  static const garderen = Color(0xFFE8B4D8); // pink/purple (per Excel)
  static const wolfheze = Color(0xFFB8E994); // green (per Excel)
  static const swadde = Color(0xFF8FE3DD);   // teal
  static const mineo = Color(0xFFC9C9C9);    // grey
  static const doorwerth = Color(0xFFE0E0E0); // lighter grey

  static const Map<String, Color> byName = {
    'Ampt v. Nijkerk': ampt,
    'Bad Hulckesteijn': badHulck,
    'De Bilt': deBilt,
    'Garderen': garderen,
    'Wolfheze': wolfheze,
    'Swaddecuen': swadde,
    'Mineo': mineo,
    'Doorwerth': doorwerth,
  };
}

/// Schedule grid spec from Walter's Excel:
///   - Operating hours: 08:30 → 19:00 (10.5 hours)
///   - Row granularity: 15 minutes (every slot start time is on :00/:15/:30/:45)
///   - Lesson length: 30 minutes (always)
///   - Cells = (day × 15-min slot) — one student (or 2-3 for group lessons) per cell
class ScheduleGrid {
  ScheduleGrid._();
  static const String dayStart = '08:30';
  static const String dayEnd = '19:00';
  static const int slotMinutes = 15;
  static const int lessonMinutes = 30;

  /// Generate every 15-minute start time string from dayStart to dayEnd.
  static List<String> allStartTimes() {
    final out = <String>[];
    var h = 8, m = 30;
    while (h < 19 || (h == 19 && m == 0)) {
      out.add('${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}');
      m += slotMinutes;
      if (m >= 60) { m -= 60; h += 1; }
    }
    return out;
  }
}
