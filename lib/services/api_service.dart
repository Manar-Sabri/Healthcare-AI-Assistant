import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/api_response.dart';
import '../data/models/auth_models.dart';
import '../data/models/clinic_models.dart';
import '../data/models/appointment_models.dart';

class ApiService {
  static const String _baseUrl = 'https://d3.deltauniv.edu.eg/api';

  Future<Map<String, String>> _getHeaders({bool requiresAuth = false}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (requiresAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        return json.decode(response.body);
      } catch (e) {
        return response.body;
      }
    } else {
      throw Exception('API Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<AuthResponse> login(LoginRequest request) async {
    final url = Uri.parse('$_baseUrl/Auth/login');
    final response = await http.post(url, headers: await _getHeaders(), body: json.encode(request.toJson()));
    if (response.statusCode == 200 || response.statusCode == 202) {
       return AuthResponse.fromJson(json.decode(response.body));
    } else {
       throw Exception('Login Failed: ${response.body}');
    }
  }

  Future<void> register(RegisterRequest request) async {
    final url = Uri.parse('$_baseUrl/Auth/register');
    final response = await http.post(url, headers: await _getHeaders(), body: json.encode(request.toJson()));
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(json.decode(response.body)['message'] ?? 'Registration Failed');
    }
  }

  Future<void> logout() async {
    await http.post(Uri.parse('$_baseUrl/Auth/logout'), headers: await _getHeaders(requiresAuth: true));
  }

  Future<void> forgotPassword(String email) async {
    final url = Uri.parse('$_baseUrl/Auth/password/forgot').replace(queryParameters: {'email': email});
    final response = await http.post(url, headers: await _getHeaders());
    if (response.statusCode >= 400) throw Exception('Failed to send reset link.');
  }

  Future<BaseApiResponse<List<ClinicModel>>> getClinics({int page = 1, int pageSize = 10, String? search}) async {
    final query = {'page': page.toString(), 'pageSize': pageSize.toString(), if (search != null) 'search': search};
    final url = Uri.parse('$_baseUrl/Appointments/clinics').replace(queryParameters: query);
    final response = await http.get(url, headers: await _getHeaders());
    return BaseApiResponse.fromJson(_processResponse(response), (data) => (data as List<dynamic>).map((e) => ClinicModel.fromJson(e)).toList());
  }

  // ADDED: getClinicsBySpecialty method
  Future<BaseApiResponse<List<ClinicModel>>> getClinicsBySpecialty(String specialtyId, {int page = 1, int pageSize = 10}) async {
    final query = {'SpecialtyId': specialtyId, 'page': page.toString(), 'pageSize': pageSize.toString()};
    final url = Uri.parse('$_baseUrl/Appointments/specialty/clinics').replace(queryParameters: query);
    final response = await http.get(url, headers: await _getHeaders());
    return BaseApiResponse.fromJson(_processResponse(response), (data) => (data as List<dynamic>).map((e) => ClinicModel.fromJson(e)).toList());
  }

  Future<BaseApiResponse<List<SpecialtyModel>>> getSpecialties() async {
    final url = Uri.parse('$_baseUrl/Appointments/specialties');
    final response = await http.get(url, headers: await _getHeaders());
    return BaseApiResponse.fromJson(_processResponse(response), (data) => (data as List<dynamic>).map((e) => SpecialtyModel.fromJson(e)).toList());
  }

  Future<BaseApiResponse<List<DoctorModel>>> getDoctorsInClinic(String clinicId) async {
    final url = Uri.parse('$_baseUrl/Appointments/doctors/$clinicId');
    final response = await http.get(url, headers: await _getHeaders());
    return BaseApiResponse.fromJson(_processResponse(response), (data) => (data as List<dynamic>).map((e) => DoctorModel.fromJson(e)).toList());
  }

  Future<BaseApiResponse<List<SlotModel>>> getAvailableSlots(String doctorId, String date) async {
    final url = Uri.parse('$_baseUrl/Appointments/available-slots/$doctorId').replace(queryParameters: {'date': date});
    final response = await http.get(url, headers: await _getHeaders());
    return BaseApiResponse.fromJson(_processResponse(response), (data) => (data as List<dynamic>).map((e) => SlotModel.fromJson(e)).toList());
  }

  Future<void> bookAppointment(BookingRequest request) async {
    final url = Uri.parse('$_baseUrl/Appointments/book');
    final response = await http.post(url, headers: await _getHeaders(requiresAuth: true), body: json.encode(request.toJson()));
    if (response.statusCode != 200 && response.statusCode != 201) {
       throw Exception('Booking Failed: ${response.body}');
    }
  }

  Future<BaseApiResponse<List<AppointmentModel>>> getMyAppointments() async {
    final url = Uri.parse('$_baseUrl/Appointments/my-appointments'); 
    final response = await http.get(url, headers: await _getHeaders(requiresAuth: true));
    return BaseApiResponse.fromJson(_processResponse(response), (data) => (data as List<dynamic>).map((e) => AppointmentModel.fromJson(e)).toList());
  }

  Future<BaseApiResponse<List<AppointmentModel>>> getDoctorAppointments() async {
    final url = Uri.parse('$_baseUrl/Appointments/doctor/schedule'); 
    final response = await http.get(url, headers: await _getHeaders(requiresAuth: true));
    return BaseApiResponse.fromJson(_processResponse(response), (data) => (data as List<dynamic>).map((e) => AppointmentModel.fromJson(e)).toList());
  }
}
