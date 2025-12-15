class ClinicModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final String? imageUrl;

  ClinicModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    this.imageUrl,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      address: json['address'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
    );
  }
}

class SpecialtyModel {
  final String id;
  final String name;
  final String? description;

  SpecialtyModel({
    required this.id,
    required this.name,
    this.description,
  });

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
    );
  }
}

class DoctorModel {
  final String id;
  final String fullName;
  final String specialty;
  final String? bio;
  final String? imageUrl;

  DoctorModel({
    required this.id,
    required this.fullName,
    required this.specialty,
    this.bio,
    this.imageUrl,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      specialty: json['specialty'] as String? ?? '',
      bio: json['bio'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}

class SlotModel {
  final String id;
  final String startTime;
  final String endTime;
  final bool isAvailable;

  SlotModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      id: json['id'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      isAvailable: json['isAvailable'] as bool? ?? false,
    );
  }
}

class BookingRequest {
  final String slotId;
  final String reason;

  BookingRequest({required this.slotId, required this.reason});

  Map<String, dynamic> toJson() => {
    'slotId': slotId,
    'reason': reason,
  };
}
