import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../data/models/appointment_models.dart';
import '../../theme/app_theme.dart';

class DoctorAppointmentsScreen extends StatelessWidget {
  const DoctorAppointmentsScreen({super.key});

  // --- MOCK DATA ---
  final List<AppointmentModel> _mockAppointments = const [
    AppointmentModel(
      id: '1',
      patientName: 'Ahmed Hassan',
      doctorName: 'Dr. You',
      clinicName: 'Delta Healing Center',
      appointmentDate: '2024-10-28 10:00:00',
      status: 'Confirmed',
      reason: 'General Checkup'
    ),
    AppointmentModel(
      id: '2',
      patientName: 'Fatma Ibrahim',
      doctorName: 'Dr. You',
      clinicName: 'Delta Healing Center',
      appointmentDate: '2024-10-28 11:30:00',
      status: 'Confirmed',
      reason: 'Follow-up visit'
    ),
    AppointmentModel(
      id: '3',
      patientName: 'Youssef Mahmoud',
      doctorName: 'Dr. You',
      clinicName: 'Delta Healing Center',
      appointmentDate: '2024-10-29 09:00:00',
      status: 'Pending',
      reason: 'New complaint: Persistent headache'
    ),
    AppointmentModel(
      id: '4',
      patientName: 'Nour Abdullah',
      doctorName: 'Dr. You',
      clinicName: 'Delta Healing Center',
      appointmentDate: '2024-10-30 15:00:00',
      status: 'Completed',
      reason: 'Annual physical exam'
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
    final formattedDate = DateFormat('E, MMM d').format(date);
    final formattedTime = DateFormat('h:mm a').format(date);
    final statusColor = _getStatusColor(appointment.status);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: AppTheme.shadowDark.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: statusColor.withOpacity(0.1),
                  // Get first letter of patient name for avatar
                  child: Text(
                    appointment.patientName.isNotEmpty ? appointment.patientName[0] : 'P',
                    style: TextStyle(color: statusColor, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appointment.patientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.textPrimary)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                           Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                           const SizedBox(width: 4),
                           Text('$formattedDate at $formattedTime', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                   decoration: BoxDecoration(
                     color: statusColor.withOpacity(0.1),
                     borderRadius: BorderRadius.circular(20),
                   ),
                   child: Text(
                     appointment.status,
                     style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                   ),
                ),
              ],
            ),
            if (appointment.reason != null && appointment.reason!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  'Reason: ${appointment.reason}',
                  style: TextStyle(color: AppTheme.textSecondary, fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.1);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return AppTheme.success;
      case 'Pending':
        return Colors.orange.shade700;
      case 'Completed':
        return Colors.grey.shade600;
      default:
        return AppTheme.primary;
    }
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.calendar_today_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text('No appointments scheduled yet.', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
