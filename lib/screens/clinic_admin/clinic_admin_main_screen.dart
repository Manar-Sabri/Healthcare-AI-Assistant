import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'manage_doctors_screen.dart';
import 'clinic_appointments_screen.dart';
import 'clinic_profile_screen.dart';

class ClinicAdminMainScreen extends StatefulWidget {
  const ClinicAdminMainScreen({super.key});

  @override
  State<ClinicAdminMainScreen> createState() => _ClinicAdminMainScreenState();
}

class _ClinicAdminMainScreenState extends State<ClinicAdminMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ManageDoctorsScreen(),
    const ClinicAppointmentsScreen(),
    const ClinicProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            activeIcon: Icon(Icons.group),
            label: 'Doctors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            activeIcon: Icon(Icons.storefront),
            label: 'Clinic',
          ),
        ],
      ),
    );
  }
}
