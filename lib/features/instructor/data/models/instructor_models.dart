import 'package:flutter/material.dart';

class Student {
  final int id;
  final String name;
  final String initial;
  final int age;
  final String level;
  int progress;
  final List<Color> gradient;
  final String location;
  final String nextLesson;
  final String parentName;
  final String parentPhone;
  int lessonsTotal;
  final bool trendUp;
  // Medical info — Walter: always visible to instructor
  final String medicalNotes;
  final List<String> allergies;
  final String emergencyContact;

  Student({
    required this.id,
    required this.name,
    required this.initial,
    required this.age,
    required this.level,
    required this.progress,
    required this.gradient,
    required this.location,
    required this.nextLesson,
    required this.parentName,
    this.parentPhone = '+31 6 12345678',
    required this.lessonsTotal,
    required this.trendUp,
    this.medicalNotes = 'Geen medische bijzonderheden',
    this.allergies = const [],
    this.emergencyContact = '',
  });

  Student copyWith({int? progress, int? lessonsTotal, String? level}) {
    return Student(
      id: id,
      name: name,
      initial: initial,
      age: age,
      level: level ?? this.level,
      progress: progress ?? this.progress,
      gradient: gradient,
      location: location,
      nextLesson: nextLesson,
      parentName: parentName,
      parentPhone: parentPhone,
      lessonsTotal: lessonsTotal ?? this.lessonsTotal,
      trendUp: trendUp,
      medicalNotes: medicalNotes,
      allergies: allergies,
      emergencyContact: emergencyContact,
    );
  }
}

class Lesson {
  final String id;
  final String time;
  final String end;
  final String location;
  final int students;
  final String type;
  final List<String> studentNames;
  final bool done;
  final bool current;

  const Lesson({
    required this.id,
    required this.time,
    required this.end,
    required this.location,
    required this.students,
    required this.type,
    required this.studentNames,
    this.done = false,
    this.current = false,
  });

  Lesson copyWith({bool? done, bool? current}) {
    return Lesson(
      id: id,
      time: time,
      end: end,
      location: location,
      students: students,
      type: type,
      studentNames: studentNames,
      done: done ?? this.done,
      current: current ?? this.current,
    );
  }
}

class Conversation {
  final int id;
  final String parentName;
  final String initial;
  final String studentName;
  String lastMessage;
  String time;
  int unread;
  final bool online;
  final List<Color> gradient;
  bool isFromMe;
  final bool hasAttachment;

  Conversation({
    required this.id,
    required this.parentName,
    required this.initial,
    required this.studentName,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.online,
    required this.gradient,
    required this.isFromMe,
    this.hasAttachment = false,
  });
}

class ChatMessage {
  final int id;
  final int conversationId;
  final String from; // 'instructor' or 'parent'
  final String text;
  final String time;
  bool read;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.from,
    required this.text,
    required this.time,
    this.read = false,
  });
}

class AvailabilitySubmission {
  final String id;
  final String label;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final Set<int> days;
  final String startTime;
  final String endTime;
  final String notes;

  const AvailabilitySubmission({
    required this.id,
    required this.label,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.days,
    required this.startTime,
    required this.endTime,
    required this.notes,
  });
}

class InstructorStats {
  final int todayLessons;
  final int todayStudents;
  final int todayLocations;
  final int weekLessons;
  final int totalStudents;
  final int avgProgress;
  final double rating;
  final int reviews;

  const InstructorStats({
    required this.todayLessons,
    required this.todayStudents,
    required this.todayLocations,
    required this.weekLessons,
    required this.totalStudents,
    required this.avgProgress,
    required this.rating,
    required this.reviews,
  });
}

class InstructorProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String title;
  final String initial;
  final bool notificationsOn;
  final String language;

  InstructorProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.title,
    required this.initial,
    required this.notificationsOn,
    required this.language,
  });

  String get fullName => '$firstName $lastName';

  InstructorProfile copyWith({bool? notificationsOn, String? language}) {
    return InstructorProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
      title: title,
      initial: initial,
      notificationsOn: notificationsOn ?? this.notificationsOn,
      language: language ?? this.language,
    );
  }
}
