import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class ClinicRegistrationScreen extends StatefulWidget {
  const ClinicRegistrationScreen({super.key});

  @override
  State<ClinicRegistrationScreen> createState() => _ClinicRegistrationScreenState();
}

class _ClinicRegistrationScreenState extends State<ClinicRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _adminNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _clinicNameController = TextEditingController();
  final _clinicAddressController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: isDark ? [const Color(0xFF0F172A), const Color(0xFF1E293B)] : [const Color(0xFFF0F9FF), const Color(0xFFE0F2FE)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.storefront, size: 60, color: AppTheme.primary).animate().scale(),
                  const SizedBox(height: 20),
                  Text('Register Your Clinic', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primary)),
                  const SizedBox(height: 30),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Clinic Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const Divider(height: 20),
                            TextFormField(
                              controller: _clinicNameController,
                              decoration: const InputDecoration(labelText: 'Clinic Name', prefixIcon: Icon(Icons.local_hospital_outlined)),
                              validator: (value) => value!.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _clinicAddressController,
                              decoration: const InputDecoration(labelText: 'Clinic Address', prefixIcon: Icon(Icons.location_on_outlined)),
                              validator: (value) => value!.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 24),
                            const Text('Admin Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const Divider(height: 20),
                            TextFormField(
                              controller: _adminNameController,
                              decoration: const InputDecoration(labelText: 'Your Full Name', prefixIcon: Icon(Icons.person_outline)),
                              validator: (value) => value!.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(labelText: 'Admin Email', prefixIcon: Icon(Icons.email_outlined)),
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
                              validator: (value) => value!.length < 6 ? 'Min 6 characters' : null,
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: authProvider.isLoading ? null : () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      await authProvider.register(
                                        fullName: _adminNameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        role: UserRole.clinicAdmin,
                                        clinicName: _clinicNameController.text,
                                        clinicAddress: _clinicAddressController.text,
                                      );
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Clinic Registered!')));
                                        Navigator.of(context).popUntil((route) => route.isFirst);
                                      }
                                    } catch (e) {
                                       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                    }
                                  }
                                },
                                child: authProvider.isLoading ? const CircularProgressIndicator() : const Text('Submit for Review'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
