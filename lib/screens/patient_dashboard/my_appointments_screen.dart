import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../data/models/appointment_models.dart';
import '../../theme/app_theme.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  // --- MOCK DATA with fixed dates ---
  final List<AppointmentModel> _mockAppointments = const [
    AppointmentModel(
        id: '1',
        patientName: 'Sara Ali',
        doctorName: 'Ayman El-Sayed',
        clinicName: 'Delta Healing Center',
        appointmentDate: '2024-10-28 14:00:00', // Fixed date
        status: 'Confirmed',
    ),
    AppointmentModel(
        id: '2', 
        patientName: 'Sara Ali',
        doctorName: 'Fatima Al-Zahra', 
        clinicName: 'Nile View Specialized Clinic', 
        appointmentDate: '2024-11-05 11:30:00', // Fixed date
        status: 'Confirmed',
    ),
    AppointmentModel(
        id: '3', 
        patientName: 'Sara Ali',
        doctorName: 'Khaled Al-Masry', 
        clinicName: 'Alexandria Modern Care', 
        appointmentDate: '2024-11-12 16:00:00', // Fixed date
        status: 'Pending',
    ),
  ];
  // --- END OF MOCK DATA ---

  @override
  Widget build(BuildContext context) {
    final appointments = _mockAppointments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        automaticallyImplyLeading: false,
      ),
      body: appointments.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return _buildAppointmentCard(context, appointment, index);
              },
            ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, AppointmentModel appointment, int index) {
    final date = DateTime.parse(appointment.appointmentDate);
    final formattedDate = DateFormat('E, MMM d').format(date); // e.g., Tue, Sep 26
    final formattedTime = DateFormat('h:mm a').format(date); // e.g., 3:00 PM
    final isConfirmed = appointment.status == 'Confirmed';

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: AppTheme.primary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppTheme.primary.withOpacity(0.1),
                  child: Text(DateFormat('d').format(date), style: const TextStyle(color: AppTheme.primary, fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dr. ${appointment.doctorName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.textPrimary)),
                      const SizedBox(height: 4),
                      Text(appointment.clinicName, style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoChip(Icons.calendar_today_outlined, formattedDate),
                _buildInfoChip(Icons.access_time_outlined, formattedTime),
                Container(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                   decoration: BoxDecoration(
                     color: isConfirmed ? AppTheme.success.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                     borderRadius: BorderRadius.circular(20),
                   ),
                   child: Text(
                     appointment.status,
                     style: TextStyle(color: isConfirmed ? AppTheme.success : Colors.orange, fontWeight: FontWeight.bold),
                   ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: -0.2);
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[500], size: 16),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_month_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No upcoming appointments.',
            style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
