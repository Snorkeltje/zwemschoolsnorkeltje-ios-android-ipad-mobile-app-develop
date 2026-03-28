class PunchCardModel {
  final String id;
  final String userId;
  final String lessonType;
  final int totalLessons;
  final int usedLessons;
  final int remainingLessons;
  final DateTime validUntil;
  final bool isActive;

  const PunchCardModel({
    required this.id,
    required this.userId,
    required this.lessonType,
    required this.totalLessons,
    required this.usedLessons,
    required this.remainingLessons,
    required this.validUntil,
    required this.isActive,
  });

  double get usagePercentage =>
      totalLessons > 0 ? usedLessons / totalLessons : 0;

  bool get isExpired => validUntil.isBefore(DateTime.now());

  bool get isUsable => isActive && !isExpired && remainingLessons > 0;

  String get displayName => '$totalLessons x $lessonType';

  factory PunchCardModel.fromJson(Map<String, dynamic> json) {
    return PunchCardModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      lessonType: json['lesson_type'] as String,
      totalLessons: json['total_lessons'] as int,
      usedLessons: json['used_lessons'] as int,
      remainingLessons: json['remaining_lessons'] as int,
      validUntil: DateTime.parse(json['valid_until'] as String),
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'lesson_type': lessonType,
      'total_lessons': totalLessons,
      'used_lessons': usedLessons,
      'remaining_lessons': remainingLessons,
      'valid_until': validUntil.toIso8601String(),
      'is_active': isActive,
    };
  }
}
