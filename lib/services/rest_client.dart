import 'package:dio/dio.dart';
import '../data/models/api_response.dart';
import '../data/models/auth_models.dart';
import '../data/models/clinic_models.dart';

class RestClient {
  final Dio _dio;
  // Using the base URL provided
  static const String baseUrl = 'https://d3.deltauniv.edu.eg/api/';

  RestClient() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  )) {
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    // Here you would add an interceptor to inject the Bearer Token from SharedPreferences
  }

  // --- Auth Endpoints ---

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _dio.post('/Auth/login', data: request.toJson());
    return AuthResponse.fromJson(response.data);
  }

  Future<void> logout() async {
    await _dio.post('/Auth/logout');
  }

  Future<void> register(RegisterRequest request) async {
    await _dio.post('/Auth/register', data: request.toJson());
  }

  Future<void> forgotPassword(String email) async {
    await _dio.post('/Auth/password/forgot', queryParameters: {'email': email});
  }

  // --- Appointments / Clinics Endpoints ---

  Future<BaseApiResponse<List<ClinicModel>>> getClinics({
    int page = 1,
    int pageSize = 10,
    String? search,
  }) async {
    final response = await _dio.get('/Appointments/clinics', queryParameters: {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
    });
    
    return BaseApiResponse.fromJson(
      response.data,
      (json) => (json as List<dynamic>)
          .map((e) => ClinicModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<BaseApiResponse<List<SpecialtyModel>>> getSpecialties() async {
    final response = await _dio.get('/Appointments/specialties');
    
    return BaseApiResponse.fromJson(
      response.data,
      (json) => (json as List<dynamic>)
          .map((e) => SpecialtyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<BaseApiResponse<List<ClinicModel>>> getClinicsBySpecialty(
    String specialtyId, {
    int page = 1,
    int pageSize = 10,
    String? search,
  }) async {
    final response = await _dio.get('/Appointments/specialty/clinics', queryParameters: {
      'SpecialtyId': specialtyId,
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
    });

    return BaseApiResponse.fromJson(
      response.data,
      (json) => (json as List<dynamic>)
          .map((e) => ClinicModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<BaseApiResponse<List<DoctorModel>>> getDoctorsInClinic(String clinicId) async {
    final response = await _dio.get('/Appointments/doctors/$clinicId');
    
    return BaseApiResponse.fromJson(
      response.data,
      (json) => (json as List<dynamic>)
          .map((e) => DoctorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<BaseApiResponse<List<SlotModel>>> getAvailableSlots(String doctorId, String date) async {
    final response = await _dio.get('/Appointments/available-slots/$doctorId', queryParameters: {
      'date': date,
    });
    
    return BaseApiResponse.fromJson(
      response.data,
      (json) => (json as List<dynamic>)
          .map((e) => SlotModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<void> bookAppointment(BookingRequest request) async {
    await _dio.post('/Appointments/book', data: request.toJson());
  }
}
