import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/fixed_schedule_models.dart';

/// Demo fixed weekly schedule mimicking Walter's Excel layout.
class FixedScheduleNotifier extends StateNotifier<List<FixedSlot>> {
  FixedScheduleNotifier() : super(_seed());

  static List<FixedSlot> _seed() => [
    // Monday — De Bilt (15:00 = single, 15:30 = 1-op-2 shared, 16:00 = 1-op-3 shared)
    const FixedSlot(id: 'fs1', day: WeekDay.maandag, time: '15:00', endTime: '15:30',
        location: 'De Bilt', locationColor: Locations.deBilt,
        assignedChildren: [AssignedChild(id: 'c1', name: 'Sami Khilji')],
        instructorId: 'i1', instructorName: 'Jan de Vries', lessonType: '1-op-1'),
    const FixedSlot(id: 'fs2', day: WeekDay.maandag, time: '15:30', endTime: '16:00',
        location: 'De Bilt', locationColor: Locations.deBilt,
        assignedChildren: [
          AssignedChild(id: 'c2', name: 'Noor Khilji'),
          AssignedChild(id: 'c3', name: 'Daan Bakker'),
        ],
        instructorId: 'i1', instructorName: 'Jan de Vries', lessonType: '1-op-2'),
    const FixedSlot(id: 'fs3', day: WeekDay.maandag, time: '16:15', endTime: '16:45',
        location: 'De Bilt', locationColor: Locations.deBilt,
        assignedChildren: [
          AssignedChild(id: 'c4', name: 'Sophie d.W.'),
          AssignedChild(id: 'c5', name: 'Finn M.'),
          AssignedChild(id: 'c6', name: 'Max V.'),
        ],
        instructorId: 'i1', instructorName: 'Jan de Vries', lessonType: '1-op-3'),
    const FixedSlot(id: 'fs4', day: WeekDay.maandag, time: '16:30', endTime: '17:00',
        location: 'De Bilt', locationColor: Locations.deBilt,
        instructorId: 'i1', instructorName: 'Jan de Vries', lessonType: '1-op-1'),
    // Wednesday — Garderen
    const FixedSlot(id: 'fs5', day: WeekDay.woensdag, time: '14:00', endTime: '14:30',
        location: 'Garderen', locationColor: Locations.garderen,
        assignedChildren: [AssignedChild(id: 'c7', name: 'Lisa Bos')],
        instructorId: 'i1', instructorName: 'Jan de Vries', lessonType: '1-op-1'),
    const FixedSlot(id: 'fs6', day: WeekDay.woensdag, time: '14:45', endTime: '15:15',
        location: 'Garderen', locationColor: Locations.garderen,
        assignedChildren: [
          AssignedChild(id: 'c8', name: 'Tim van Dijk'),
          AssignedChild(id: 'c9', name: 'Mila D.'),
        ],
        instructorId: 'i1', instructorName: 'Jan de Vries', lessonType: '1-op-2'),
    const FixedSlot(id: 'fs7', day: WeekDay.woensdag, time: '15:30', endTime: '16:00',
        location: 'Garderen', locationColor: Locations.garderen,
        instructorId: 'i1', instructorName: 'Jan de Vries', lessonType: '1-op-3'),
    // Friday — Bad Hulckesteijn
    const FixedSlot(id: 'fs8', day: WeekDay.vrijdag, time: '16:00', endTime: '16:30',
        location: 'Bad Hulckesteijn', locationColor: Locations.badHulck,
        assignedChildren: [AssignedChild(id: 'c10', name: 'Emma Jansen')],
        instructorId: 'i1', instructorName: 'Jan de Vries', lessonType: '1-op-1'),
    const FixedSlot(id: 'fs9', day: WeekDay.vrijdag, time: '16:30', endTime: '17:00',
        location: 'Bad Hulckesteijn', locationColor: Locations.badHulck,
        instructorId: 'i1', instructorName: 'Jan de Vries', lessonType: '1-op-1'),
    // Wednesday — Doorwerth (newly supported per Excel legend)
    const FixedSlot(id: 'fs10', day: WeekDay.woensdag, time: '17:00', endTime: '17:30',
        location: 'Doorwerth', locationColor: Locations.doorwerth,
        assignedChildren: [AssignedChild(id: 'c11', name: 'Noah B.')],
        instructorId: 'i2', instructorName: 'Maria Jansen', lessonType: '1-op-1'),
  ];

  /// Free a slot (e.g. student stops or chooses not to continue after exam).
  void releaseSlot(String slotId) {
    state = [
      for (final s in state)
        if (s.id == slotId)
          s.copyWith(assignedChildren: const [], pendingRelease: false)
        else
          s,
    ];
  }

  /// Mark slot as pending release (exam-continuation flow waiting).
  void markPendingRelease(String slotId, bool pending) {
    state = [
      for (final s in state)
        if (s.id == slotId) s.copyWith(pendingRelease: pending) else s,
    ];
  }

  /// Assign a slot to one or more children. For 1-op-2 / 1-op-3 lessons
  /// pass multiple. Existing assignments are replaced.
  void assignSlot(String slotId, List<AssignedChild> children) {
    state = [
      for (final s in state)
        if (s.id == slotId)
          s.copyWith(assignedChildren: children)
        else
          s,
    ];
  }

  /// Convenience for single-child 1-op-1 assignment.
  void assignSlotSingle(String slotId, String childId, String childName) =>
      assignSlot(slotId, [AssignedChild(id: childId, name: childName)]);

  List<FixedSlot> emptySlots() => state.where((s) => s.isEmpty).toList();
  List<FixedSlot> forDay(WeekDay day) =>
      state.where((s) => s.day == day).toList()
        ..sort((a, b) => a.time.compareTo(b.time));
}

final fixedScheduleProvider =
    StateNotifierProvider<FixedScheduleNotifier, List<FixedSlot>>(
  (ref) => FixedScheduleNotifier(),
);

// ===================== SLOT INTEREST =====================

class SlotInterestNotifier extends StateNotifier<List<SlotInterest>> {
  SlotInterestNotifier() : super([]);

  String keyFor(WeekDay day, String time, String location) =>
      '${day.index}-$time-$location';

  void register({
    required String parentId,
    required String parentName,
    required String childId,
    required String childName,
    required WeekDay day,
    required String time,
    required String location,
  }) {
    final slotKey = keyFor(day, time, location);
    // Idempotent: don't double-register
    if (state.any((i) => i.parentId == parentId && i.childId == childId && i.slotKey == slotKey)) {
      return;
    }
    state = [
      ...state,
      SlotInterest(
        id: 'si${DateTime.now().millisecondsSinceEpoch}',
        parentId: parentId, parentName: parentName,
        childId: childId, childName: childName,
        slotKey: slotKey, day: day, time: time, location: location,
        registeredAt: DateTime.now(),
      ),
    ];
  }

  void cancel(String interestId) {
    state = state.where((i) => i.id != interestId).toList();
  }

  /// Find interested parents for a freed slot, ordered by registration date (priority).
  List<SlotInterest> interestedFor(WeekDay day, String time, String location) {
    final key = keyFor(day, time, location);
    final matches = state.where((i) => i.slotKey == key).toList();
    matches.sort((a, b) => a.registeredAt.compareTo(b.registeredAt));
    return matches;
  }

  List<SlotInterest> forParent(String parentId) =>
      state.where((i) => i.parentId == parentId).toList();
}

final slotInterestProvider =
    StateNotifierProvider<SlotInterestNotifier, List<SlotInterest>>(
  (ref) => SlotInterestNotifier(),
);

// ===================== SLOT OFFERS (24h challenge) =====================

class SlotOfferNotifier extends StateNotifier<List<SlotOffer>> {
  SlotOfferNotifier() : super([]);

  /// Fan out a 24h offer to every interested parent for the given slot.
  void offerSlot(FixedSlot slot, List<SlotInterest> interested) {
    final now = DateTime.now();
    final exp = now.add(const Duration(hours: 24));
    final newOffers = [
      for (final i in interested)
        SlotOffer(
          id: 'so${now.millisecondsSinceEpoch}-${i.parentId}',
          slotId: slot.id,
          parentId: i.parentId, parentName: i.parentName,
          childName: i.childName,
          day: slot.day, time: slot.time, location: slot.location,
          sentAt: now, expiresAt: exp,
          status: SlotOfferStatus.pending,
        ),
    ];
    state = [...newOffers, ...state];
  }

  /// Parent accepts. First-come basis is handled by the provider/admin —
  /// the highest-priority parent wins.
  void respond(String offerId, bool accept) {
    state = [
      for (final o in state)
        if (o.id == offerId)
          SlotOffer(
            id: o.id, slotId: o.slotId, parentId: o.parentId,
            parentName: o.parentName, childName: o.childName,
            day: o.day, time: o.time, location: o.location,
            sentAt: o.sentAt, expiresAt: o.expiresAt,
            status: accept ? SlotOfferStatus.accepted : SlotOfferStatus.declined,
          )
        else o,
    ];
  }

  /// Mark losers when a slot is awarded to one parent.
  void markLost(String slotId, String winnerOfferId) {
    state = [
      for (final o in state)
        if (o.slotId == slotId && o.id != winnerOfferId && o.status == SlotOfferStatus.pending)
          SlotOffer(
            id: o.id, slotId: o.slotId, parentId: o.parentId,
            parentName: o.parentName, childName: o.childName,
            day: o.day, time: o.time, location: o.location,
            sentAt: o.sentAt, expiresAt: o.expiresAt,
            status: SlotOfferStatus.lost,
          )
        else o,
    ];
  }

  List<SlotOffer> pendingForParent(String parentId) =>
      state.where((o) =>
          o.parentId == parentId &&
          o.status == SlotOfferStatus.pending &&
          !o.isExpired).toList();
}

final slotOfferProvider =
    StateNotifierProvider<SlotOfferNotifier, List<SlotOffer>>(
  (ref) => SlotOfferNotifier(),
);

// ===================== EXAM CONTINUATION =====================

class ExamContinuationNotifier extends StateNotifier<List<ExamContinuation>> {
  ExamContinuationNotifier() : super([]);

  void send({
    required String childId,
    required String childName,
    required String currentLevel,
    String? nextLevel,
    required DateTime examDate,
  }) {
    final now = DateTime.now();
    final exp = now.add(const Duration(hours: 24));
    state = [
      ExamContinuation(
        id: 'ec${now.millisecondsSinceEpoch}',
        childId: childId, childName: childName,
        currentLevel: currentLevel, nextLevel: nextLevel,
        examDate: examDate, sentAt: now, expiresAt: exp,
        status: ExamContinuationStatus.pending,
      ),
      ...state,
    ];
  }

  void respond(String id, bool wantsToContinue) {
    state = [
      for (final ec in state)
        if (ec.id == id)
          ExamContinuation(
            id: ec.id, childId: ec.childId, childName: ec.childName,
            currentLevel: ec.currentLevel, nextLevel: ec.nextLevel,
            examDate: ec.examDate, sentAt: ec.sentAt, expiresAt: ec.expiresAt,
            status: wantsToContinue
                ? ExamContinuationStatus.continuing
                : ExamContinuationStatus.leaving,
            response: wantsToContinue ? 'doorgaan' : 'stoppen',
          )
        else ec,
    ];
  }

  List<ExamContinuation> pending() =>
      state.where((e) => e.status == ExamContinuationStatus.pending && !e.isExpired).toList();
}

final examContinuationProvider =
    StateNotifierProvider<ExamContinuationNotifier, List<ExamContinuation>>(
  (ref) => ExamContinuationNotifier(),
);
