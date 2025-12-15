import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'auth/login_screen.dart';
import '../providers/auth_provider.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: CircleAvatar(radius: 200, backgroundColor: AppTheme.primary.withOpacity(0.05)),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: CircleAvatar(radius: 150, backgroundColor: AppTheme.accent.withOpacity(0.05)),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
                      ],
                    ),
                    child: const Icon(Icons.health_and_safety, size: 60, color: Colors.white),
                  ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                  
                  const SizedBox(height: 40),
                  
                  const Text(
                    'MedSync',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  const Text(
                    'Select your role to get started.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                  ),
                  
                  const Spacer(),

                  _buildRoleButton(
                    context, 
                    title: 'I am a Patient', 
                    icon: Icons.person_search,
                    role: UserRole.patient,
                  ).animate().fadeIn(delay: 400.ms).slideX(),
                  
                  const SizedBox(height: 16),

                  _buildRoleButton(
                    context, 
                    title: 'I am a Doctor', 
                    icon: Icons.medical_services,
                    role: UserRole.doctor,
                  ).animate().fadeIn(delay: 500.ms).slideX(),

                  const SizedBox(height: 16),

                  // NEW: Clinic Admin Role
                  _buildRoleButton(
                    context, 
                    title: 'I am a Clinic Admin', 
                    icon: Icons.storefront,
                    role: UserRole.clinicAdmin, // Assuming you add this to the enum
                    isOutlined: true,
                  ).animate().fadeIn(delay: 600.ms).slideX(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleButton(BuildContext context, {
    required String title, 
    required IconData icon, 
    required UserRole role,
    bool isOutlined = false,
  }) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          // In a real app, you might have a different login screen for Clinic Admins
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen(userRole: role)),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.white : AppTheme.primary,
          foregroundColor: isOutlined ? AppTheme.primary : Colors.white,
          elevation: isOutlined ? 0 : 4,
          side: isOutlined ? const BorderSide(color: AppTheme.primary, width: 2) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
