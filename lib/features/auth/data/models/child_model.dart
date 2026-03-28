class ChildModel {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String currentLevel;
  final String? profileImage;

  const ChildModel({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.currentLevel,
    this.profileImage,
  });

  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'] as String,
      name: json['name'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      currentLevel: json['current_level'] as String,
      profileImage: json['profile_image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'current_level': currentLevel,
      'profile_image': profileImage,
    };
  }

  ChildModel copyWith({
    String? id,
    String? name,
    DateTime? dateOfBirth,
    String? currentLevel,
    String? profileImage,
  }) {
    return ChildModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      currentLevel: currentLevel ?? this.currentLevel,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
