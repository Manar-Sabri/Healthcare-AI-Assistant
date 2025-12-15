import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/models/clinic_models.dart';
import '../../providers/auth_provider.dart';
import '../../screens/role_selection_screen.dart';
import '../../theme/app_theme.dart';

class ManageDoctorsScreen extends StatefulWidget {
  const ManageDoctorsScreen({super.key});

  @override
  State<ManageDoctorsScreen> createState() => _ManageDoctorsScreenState();
}

class _ManageDoctorsScreenState extends State<ManageDoctorsScreen> {
  // --- MOCK DATA ---
  late final List<DoctorModel> _mockDoctors;

  @override
  void initState() {
    super.initState();
    // Initialize the list here, inside a non-constant context
    _mockDoctors = [
      DoctorModel(id: '1', fullName: 'Dr. Ali Hassan', specialty: 'Cardiology', imageUrl: 'https://placeimg.com/100/100/people?id=1'),
      DoctorModel(id: '2', fullName: 'Dr. Mona Said', specialty: 'Dermatology', imageUrl: 'https://placeimg.com/100/100/people?id=2'),
      DoctorModel(id: '3', fullName: 'Dr. Omar Youssef', specialty: 'Pediatrics', imageUrl: 'https://placeimg.com/100/100/people?id=3'),
      DoctorModel(id: '4', fullName: 'Dr. Hoda Kamal', specialty: 'Neurology', imageUrl: 'https://placeimg.com/100/100/people?id=4'),
    ];
  }
  // --- END OF MOCK DATA ---

  @override
  Widget build(BuildContext context) {
    final doctors = _mockDoctors;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Manage Doctors', style: TextStyle(fontWeight: FontWeight.bold)),
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
      body: doctors.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // Padding for FAB
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return _buildDoctorCard(context, doctor, index);
            },
          ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Add Doctor'),
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.group_off_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('No doctors found in your clinic.', style: TextStyle(color: Colors.grey, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, DoctorModel doctor, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shadowColor: AppTheme.shadowDark.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(doctor.imageUrl!),
        ),
        title: Text(doctor.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        subtitle: Text(doctor.specialty, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 15)),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.grey),
          onPressed: () { /* TODO: Show edit/delete options */ },
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2);
  }
}
