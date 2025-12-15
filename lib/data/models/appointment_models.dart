class AppointmentModel {
  final String id;
  final String patientName;
  final String doctorName;
  final String clinicName;
  final String appointmentDate;
  final String status;
  final String? reason;

  const AppointmentModel({
    required this.id,
    required this.patientName,
    required this.doctorName,
    required this.clinicName,
    required this.appointmentDate,
    required this.status,
    this.reason,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String? ?? '',
      patientName: json['patientName'] as String? ?? '',
      doctorName: json['doctorName'] as String? ?? '',
      clinicName: json['clinicName'] as String? ?? '',
      appointmentDate: json['appointmentDate'] as String? ?? '',
      status: json['status'] as String? ?? '',
      reason: json['reason'] as String?,
    );
  }
}
