import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../data/models/auth_models.dart';

enum UserRole { patient, doctor, clinicAdmin }

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;
  UserRole _userRole = UserRole.patient;

  String? _userName;
  String? _userEmail;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  UserRole get userRole => _userRole;
  String? get userName => _userName;
  String? get userEmail => _userEmail;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final roleString = prefs.getString('auth_role');
    
    if (token != null) {
      _isAuthenticated = true;
      _userName = prefs.getString('auth_name');
      _userEmail = prefs.getString('auth_email');
      
      if (roleString == 'doctor') _userRole = UserRole.doctor;
      else if (roleString == 'clinicAdmin') _userRole = UserRole.clinicAdmin;
      else _userRole = UserRole.patient;
      
      notifyListeners();
    }
  }

  void setUserRole(UserRole role) {
    _userRole = role;
    notifyListeners();
  }

  String _sanitizeErrorMessage(dynamic error) {
    String message = "An unknown error occurred.";
    if (error is DioError && error.response?.data != null && error.response!.data['message'] != null) {
      message = error.response!.data['message'];
    } else if (error is Exception) {
      message = error.toString().replaceAll('Exception: ', '');
    }

    if (message.toLowerCase().contains('otp') || message.toLowerCase().contains('not confirmed')) {
      return 'Login failed. Please check your credentials.';
    }
    
    return message;
  }

  // --- MODIFIED LOGIN FUNCTION FOR TESTING ---
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate a network delay to mimic a real API call
      await Future.delayed(const Duration(seconds: 1));

      // --- API Call is Bypassed ---
      // final response = await _apiService.login(LoginRequest(email: email, password: password));

      // --- Assume login is always successful ---
      const fakeToken = 'fake-token-for-testing-purposes';
      final fakeUserName = email.split('@').first; // Use part of the email as a mock username
      
      await _saveAuthData(fakeToken, fakeUserName, email, _userRole);
      _isAuthenticated = true;

    } catch (e) {
      _errorMessage = "An unexpected error occurred during the mock login.";
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // --- END OF MODIFIED LOGIN FUNCTION ---

  // --- MODIFIED REGISTER FUNCTION FOR TESTING ---
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    UserRole? role,
    String? specialization,
    String? licenseNumber,
    String? clinicName,
    String? clinicAddress,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate a network delay
      await Future.delayed(const Duration(seconds: 1));

      // --- API Call is Bypassed ---
      // Assume registration is always successful by doing nothing and not throwing an error.
      // The UI will then show a success message and navigate.
      
    } catch (e) {
      _errorMessage = "An unexpected error occurred during mock registration.";
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // --- END OF MODIFIED REGISTER FUNCTION ---

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> _saveAuthData(String token, String name, String email, UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    final roleString = role.toString().split('.').last;
    
    await prefs.setString('auth_token', token);
    await prefs.setString('auth_name', name);
    await prefs.setString('auth_email', email);
    await prefs.setString('auth_role', roleString);
    
    _userRole = role;
    notifyListeners();
  }
}
