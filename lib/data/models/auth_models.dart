class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

class RegisterRequest {
  final String email;
  final String password;
  final String fullName; // Admin/Doctor/Patient Name
  
  final String? role;
  
  // Doctor Specific
  final String? specialization;
  final String? licenseNumber;

  // Clinic Specific
  final String? clinicName;
  final String? clinicAddress;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.fullName,
    this.role,
    this.specialization,
    this.licenseNumber,
    this.clinicName,
    this.clinicAddress,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'fullName': fullName,
    };
    
    if (role != null) data['userRole'] = role;
    if (specialization != null) data['specialization'] = specialization;
    if (licenseNumber != null) data['medicalLicenseNumber'] = licenseNumber;
    if (clinicName != null) data['clinicName'] = clinicName;
    if (clinicAddress != null) data['clinicAddress'] = clinicAddress;
    
    return data;
  }
}

// ... (rest of the Auth models remain the same)

class AuthResponse {
  final String? token;
  final String? refreshToken;
  final String? email;
  final String? userName;
  final String? userId;
  final bool? isAuthenticated;
  final String? message;

  AuthResponse({
    this.token,
    this.refreshToken,
    this.email,
    this.userName,
    this.userId,
    this.isAuthenticated,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
      email: json['email'] as String?,
      userName: json['userName'] as String?,
      userId: json['userId'] as String?,
      isAuthenticated: json['isAuthenticated'] as bool?,
      message: json['message'] as String?,
    );
  }
}

class PasswordResetTokenResponse {
  final String? resetToken;
  final String? email;
  final String? message;

  PasswordResetTokenResponse({this.resetToken, this.email, this.message});

  factory PasswordResetTokenResponse.fromJson(Map<String, dynamic> json) {
    return PasswordResetTokenResponse(
      resetToken: json['resetToken'] as String?,
      email: json['email'] as String?,
      message: json['message'] as String?,
    );
  }
}
