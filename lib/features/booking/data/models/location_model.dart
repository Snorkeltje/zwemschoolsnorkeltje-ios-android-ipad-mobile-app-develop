class LocationModel {
  final String id;
  final String name;
  final String address;
  final String city;

  const LocationModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
    };
  }
}
