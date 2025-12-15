import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/clinic_repository.dart';
import '../../data/models/clinic_models.dart';
import '../../theme/app_colors.dart';
import 'doctor_details_screen.dart'; // We will create this next

class DoctorsListScreen extends StatefulWidget {
  final String clinicId;
  final String clinicName;

  const DoctorsListScreen({super.key, required this.clinicId, required this.clinicName});

  @override
  State<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  late Future<List<DoctorModel>> _doctorsFuture;

  @override
  void initState() {
    super.initState();
    _doctorsFuture = Provider.of<ClinicRepository>(context, listen: false)
        .getDoctors(widget.clinicId)
        .then((response) => response.value ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.clinicName),
      ),
      body: FutureBuilder<List<DoctorModel>>(
        future: _doctorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading doctors'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No doctors available in this clinic.'));
          }

          final doctors = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primaryLight,
                    backgroundImage: doctor.imageUrl != null ? NetworkImage(doctor.imageUrl!) : null,
                    child: doctor.imageUrl == null 
                        ? const Icon(Icons.person, color: Colors.white, size: 30) 
                        : null,
                  ),
                  title: Text(doctor.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(doctor.specialty),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorDetailsScreen(doctor: doctor),
                        ),
                      );
                    },
                    child: const Text('Book', style: TextStyle(color: Colors.white)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
