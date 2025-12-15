import '../models/auth_models.dart';
import '../../services/api_service.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<AuthResponse> login(String email, String password) async {
    return await _apiService.login(LoginRequest(email: email, password: password));
  }

  Future<void> register(RegisterRequest request) async {
    await _apiService.register(request);
  }
  
  // Expose other auth methods similarly...
}
