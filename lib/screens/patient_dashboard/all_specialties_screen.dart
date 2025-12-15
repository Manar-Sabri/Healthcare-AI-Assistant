import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/models/clinic_models.dart';
import '../../data/repositories/clinic_repository.dart';
import '../../theme/app_theme.dart';
import '../clinic_dashboard/clinic_main_screen.dart';

class AllSpecialtiesScreen extends StatefulWidget {
  const AllSpecialtiesScreen({super.key});

  @override
  State<AllSpecialtiesScreen> createState() => _AllSpecialtiesScreenState();
}

class _AllSpecialtiesScreenState extends State<AllSpecialtiesScreen> {
  late Future<List<SpecialtyModel>> _specialtiesFuture;

  @override
  void initState() {
    super.initState();
    _specialtiesFuture = Provider.of<ClinicRepository>(context, listen: false)
        .getSpecialties()
        .then((response) => response.value ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('All Specialties', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<SpecialtyModel>>(
        future: _specialtiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No specialties found.'));
          }

          final specialties = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.1, 
            ),
            itemCount: specialties.length,
            itemBuilder: (context, index) {
              final specialty = specialties[index];
              return InkWell(
                onTap: () {
                  // Navigate to clinics filtered by this specialty
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (_) => ClinicMainScreen(specialtyFilter: specialty), // Pass specialty object
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: AppTheme.shadowDark, blurRadius: 15, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.medical_services_outlined, size: 40, color: AppTheme.primary),
                      const SizedBox(height: 16),
                      Text(
                        specialty.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (100 * index).ms).scale(begin: const Offset(0.9, 0.9));
            },
          );
        },
      ),
    );
  }
}
