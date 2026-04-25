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
class FixedSlot {
  final String id;
  final WeekDay day;
  final String time;       // 'HH:mm' start
  final String endTime;    // 'HH:mm' end (always +30 min per Walter)
  final String location;
  final Color locationColor;
  final String? assignedChildId;     // null = empty/free slot
  final String? assignedChildName;   // display
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
    this.assignedChildId,
    this.assignedChildName,
    required this.instructorId,
    required this.instructorName,
    required this.lessonType,
    this.pendingRelease = false,
  });

  bool get isEmpty => assignedChildId == null;

  FixedSlot copyWith({
    String? assignedChildId,
    String? assignedChildName,
    bool? pendingRelease,
  }) =>
      FixedSlot(
        id: id, day: day, time: time, endTime: endTime,
        location: location, locationColor: locationColor,
        assignedChildId: assignedChildId,
        assignedChildName: assignedChildName,
        instructorId: instructorId, instructorName: instructorName,
        lessonType: lessonType,
        pendingRelease: pendingRelease ?? this.pendingRelease,
      );
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

/// Standard locations + color codes (Walter's Excel).
class Locations {
  Locations._();
  static const ampt = Color(0xFFFFB370);    // orange
  static const badHulck = Color(0xFFFFE680); // yellow
  static const deBilt = Color(0xFFFF6B6B);   // red
  static const garderen = Color(0xFFB8E994); // green
  static const wolfheze = Color(0xFFB6CFFF); // blue
  static const swadde = Color(0xFFD4A5FF);   // purple
  static const mineo = Color(0xFFC9C9C9);    // grey

  static const Map<String, Color> byName = {
    'Ampt v. Nijkerk': ampt,
    'Bad Hulckesteijn': badHulck,
    'De Bilt': deBilt,
    'Garderen': garderen,
    'Wolfheze': wolfheze,
    'Swaddecuen': swadde,
    'Mineo': mineo,
  };
}
