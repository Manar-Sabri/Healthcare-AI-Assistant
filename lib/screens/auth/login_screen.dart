import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import 'patient_registration_screen.dart';
import 'doctor_registration_screen.dart';
import '../clinic_admin/clinic_registration_screen.dart';
import 'forgot_password_screen.dart';
import '../patient_dashboard/patient_main_screen.dart';
import '../doctor_dashboard/doctor_main_screen.dart';
import '../clinic_admin/clinic_admin_main_screen.dart';

class LoginScreen extends StatefulWidget {
  final UserRole userRole;
  const LoginScreen({super.key, required this.userRole});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                : [const Color(0xFFF0F9FF), const Color(0xFFE0F2FE)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.health_and_safety, size: 60, color: AppTheme.primary),
                  ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 20),
                  Text(
                    _getLoginTitle(widget.userRole),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primary),
                  ).animate().fadeIn().slideY(begin: 0.3),
                  const SizedBox(height: 40),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (authProvider.errorMessage != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: AppTheme.error.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                                child: Text(authProvider.errorMessage!, style: const TextStyle(color: AppTheme.error)),
                              ).animate().shake(),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined)),
                              validator: (value) => value!.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _isObscure,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () => setState(() => _isObscure = !_isObscure),
                                ),
                              ),
                              validator: (value) => value!.isEmpty ? 'Required' : null,
                            ).animate().fadeIn(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                                child: const Text('Forgot Password?'),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: authProvider.isLoading ? null : () => _handleLogin(authProvider),
                                child: authProvider.isLoading
                                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : const Text('Login'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().slideY(begin: 0.2, duration: 500.ms),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: _navigateToRegister,
                        child: const Text('Register Now', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ).animate().fadeIn(delay: 600.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getLoginTitle(UserRole role) {
    switch (role) {
      case UserRole.doctor:
        return 'Doctor Portal';
      case UserRole.clinicAdmin:
        return 'Clinic Admin Login';
      default:
        return 'Patient Login';
    }
  }

  void _navigateToRegister() {
    Widget screen;
    switch (widget.userRole) {
      case UserRole.doctor:
        screen = const DoctorRegistrationScreen();
        break;
      case UserRole.clinicAdmin:
        screen = const ClinicRegistrationScreen();
        break;
      default:
        screen = const PatientRegistrationScreen();
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  void _handleLogin(AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      authProvider.setUserRole(widget.userRole);
      try {
        await authProvider.login(_emailController.text, _passwordController.text);
        _navigateHome();
      } catch (e) {
        // Error is handled by provider
      }
    }
  }

  void _navigateHome() {
    if (!mounted) return;
    Widget screen;
    switch (widget.userRole) {
      case UserRole.doctor:
        screen = const DoctorMainScreen();
        break;
      case UserRole.clinicAdmin:
        screen = const ClinicAdminMainScreen();
        break;
      default:
        screen = const PatientMainScreen();
    }
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => screen), (route) => false);
  }
}
