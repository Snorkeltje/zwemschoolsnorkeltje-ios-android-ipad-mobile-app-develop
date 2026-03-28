enum BookingStatus { bevestigd, geannuleerd, aanwezig, nietVerschenen }

enum LessonType { vastTijdstip, extra1op1, extra1op2, vakantie }

class BookingModel {
  final String id;
  final String childId;
  final String locationId;
  final String timeSlotId;
  final LessonType lessonType;
  final BookingStatus status;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String instructorName;
  final String locationName;

  const BookingModel({
    required this.id,
    required this.childId,
    required this.locationId,
    required this.timeSlotId,
    required this.lessonType,
    required this.status,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.instructorName,
    required this.locationName,
  });

  String get displayTime => '$startTime - $endTime';

  String get lessonTypeLabel {
    switch (lessonType) {
      case LessonType.vastTijdstip:
        return 'Vast tijdstip';
      case LessonType.extra1op1:
        return 'Extra 1-op-1';
      case LessonType.extra1op2:
        return 'Extra 1-op-2';
      case LessonType.vakantie:
        return 'Vakantie zwemles';
    }
  }

  String get statusLabel {
    switch (status) {
      case BookingStatus.bevestigd:
        return 'Bevestigd';
      case BookingStatus.geannuleerd:
        return 'Geannuleerd';
      case BookingStatus.aanwezig:
        return 'Aanwezig';
      case BookingStatus.nietVerschenen:
        return 'Niet verschenen';
    }
  }

  bool get isUpcoming =>
      date.isAfter(DateTime.now()) && status == BookingStatus.bevestigd;

  bool get canCancel =>
      isUpcoming && date.difference(DateTime.now()).inHours >= 24;

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      childId: json['child_id'] as String,
      locationId: json['location_id'] as String,
      timeSlotId: json['time_slot_id'] as String,
      lessonType: LessonType.values.firstWhere(
        (t) => t.name == json['lesson_type'],
        orElse: () => LessonType.vastTijdstip,
      ),
      status: BookingStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => BookingStatus.bevestigd,
      ),
      date: DateTime.parse(json['date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      instructorName: json['instructor_name'] as String,
      locationName: json['location_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'child_id': childId,
      'location_id': locationId,
      'time_slot_id': timeSlotId,
      'lesson_type': lessonType.name,
      'status': status.name,
      'date': date.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'instructor_name': instructorName,
      'location_name': locationName,
    };
  }
}
