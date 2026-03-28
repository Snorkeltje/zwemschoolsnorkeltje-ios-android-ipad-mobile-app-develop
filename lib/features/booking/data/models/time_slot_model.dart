class TimeSlotModel {
  final String id;
  final String startTime;
  final String endTime;
  final String instructorName;
  final int availableSpots;
  final int maxSpots;
  final bool isAvailable;

  const TimeSlotModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.instructorName,
    required this.availableSpots,
    required this.maxSpots,
    required this.isAvailable,
  });

  String get displayTime => '$startTime - $endTime';

  double get occupancyRate =>
      maxSpots > 0 ? (maxSpots - availableSpots) / maxSpots : 0;

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      instructorName: json['instructor_name'] as String,
      availableSpots: json['available_spots'] as int,
      maxSpots: json['max_spots'] as int,
      isAvailable: json['is_available'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_time': startTime,
      'end_time': endTime,
      'instructor_name': instructorName,
      'available_spots': availableSpots,
      'max_spots': maxSpots,
      'is_available': isAvailable,
    };
  }
}
