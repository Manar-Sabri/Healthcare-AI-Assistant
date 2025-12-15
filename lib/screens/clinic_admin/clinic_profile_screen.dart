import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/auth_provider.dart';
import '../../screens/role_selection_screen.dart';
import '../../theme/app_theme.dart';

class ClinicProfileScreen extends StatelessWidget {
  const ClinicProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data for the profile
    const clinicName = "Delta Healing Center";
    const adminName = "Dr. Admin";
    const totalDoctors = 4;
    const appointmentsToday = 12;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Clinic Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Provider.of<AuthProvider>(context, listen: false).logout();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            _buildHeaderCard(clinicName, adminName),
            const SizedBox(height: 24),

            // Stats Row
            _buildStatsRow(totalDoctors, appointmentsToday),
            const SizedBox(height: 24),
            
            // Settings Section
            const Text('Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 16),
            _buildSettingsList(context),

          ].animate(interval: 100.ms).fadeIn().slideY(begin: 0.2),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(String clinicName, String adminName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primary.withOpacity(0.8)],
          begin: Alignment.topLeft, end: Alignment.bottomRight
        ),
        boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(clinicName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text('Managed by: $adminName', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9))),
        ],
      ),
    );
  }

  Widget _buildStatsRow(int doctors, int appointments) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Doctors', doctors.toString(), Icons.medical_services_outlined, Colors.blue)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Today\'s Appointments', appointments.toString(), Icons.calendar_today_outlined, Colors.green)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppTheme.shadowDark.withOpacity(0.05), blurRadius: 10)]
      ),
      child: Column(
        children: [
          Row(children: [Icon(icon, color: color, size: 20), const SizedBox(width: 8), Text(title, style: const TextStyle(color: AppTheme.textSecondary))]),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Column(
      children: [
        _buildSettingTile(context, 'Clinic Information', Icons.store_mall_directory_outlined, () {}),
        _buildSettingTile(context, 'Working Hours', Icons.access_time_filled_outlined, () {}),
        _buildSettingTile(context, 'Payment Settings', Icons.payment_outlined, () {}),
        _buildSettingTile(context, 'Notifications', Icons.notifications_outlined, () {}),
        _buildSettingTile(context, 'Account Security', Icons.security_outlined, () {}),
      ],
    );
  }

  Widget _buildSettingTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: AppTheme.shadowDark.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppTheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}
