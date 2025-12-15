import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../data/models/appointment_models.dart';
import '../../providers/auth_provider.dart';
import '../../screens/role_selection_screen.dart';
import '../../theme/app_theme.dart';

class ClinicAppointmentsScreen extends StatefulWidget {
  const ClinicAppointmentsScreen({super.key});

  @override
  State<ClinicAppointmentsScreen> createState() => _ClinicAppointmentsScreenState();
}

class _ClinicAppointmentsScreenState extends State<ClinicAppointmentsScreen> {
  // --- MOCK DATA ---
  late final List<AppointmentModel> _mockAppointments;

  @override
  void initState() {
    super.initState();
    _mockAppointments = [
      AppointmentModel(id: '1', patientName: 'Ahmed Hassan', doctorName: 'Dr. Ali Hassan', clinicName: 'MyClinic', appointmentDate: '2024-10-28 10:00:00', status: 'Confirmed'),
      AppointmentModel(id: '2', patientName: 'Fatma Ibrahim', doctorName: 'Dr. Mona Said', clinicName: 'MyClinic', appointmentDate: '2024-10-28 11:30:00', status: 'Confirmed'),
      AppointmentModel(id: '3', patientName: 'Youssef Mahmoud', doctorName: 'Dr. Ali Hassan', clinicName: 'MyClinic', appointmentDate: '2024-10-29 09:00:00', status: 'Pending'),
      AppointmentModel(id: '4', patientName: 'Nour Abdullah', doctorName: 'Dr. Hoda Kamal', clinicName: 'MyClinic', appointmentDate: '2024-10-30 15:00:00', status: 'Completed'),
      AppointmentModel(id: '5', patientName: 'Karim Adel', doctorName: 'Dr. Omar Youssef', clinicName: 'MyClinic', appointmentDate: '2024-10-30 16:30:00', status: 'Confirmed'),
    ];
  }
  // --- END OF MOCK DATA ---

  @override
  Widget build(BuildContext context) {
    final appointments = _mockAppointments;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('All Appointments', style: TextStyle(fontWeight: FontWeight.bold)),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppTheme.textPrimary),
            onPressed: () { /* TODO: Implement filter by doctor */ },
          )
        ],
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.calendar_view_week_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('No appointments found for this clinic.', style: TextStyle(color: Colors.grey, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, AppointmentModel appointment, int index) {
    final date = DateTime.parse(appointment.appointmentDate);
    final formattedDate = DateFormat('E, MMM d').format(date);
    final formattedTime = DateFormat('h:mm a').format(date);
    final statusColor = _getStatusColor(appointment.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: AppTheme.shadowDark.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 5,
              height: 70,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appointment.patientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('With ${appointment.doctorName}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text('$formattedDate at $formattedTime', style: TextStyle(color: statusColor, fontWeight: FontWeight.w500, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              appointment.status,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 13),
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
}
