import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/repositories/clinic_repository.dart';
import '../../data/models/clinic_models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart'; 
import '../../widgets/neumorphic_button.dart'; 
import 'all_specialties_screen.dart';
import '../clinic_dashboard/clinic_main_screen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
      appBar: const CustomAppBar(title: 'MedSync', showBackButton: false), // Using our new App Bar
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section with Neumorphic Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: AppTheme.shadowLight, offset: const Offset(-8, -8), blurRadius: 16),
                  BoxShadow(color: AppTheme.shadowDark, offset: const Offset(8, 8), blurRadius: 16),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How are you feeling?',
                          style: TextStyle(color: AppTheme.textPrimary, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Find the best doctors nearby.',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.favorite, color: AppTheme.error, size: 48)
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(duration: 1000.ms, begin: const Offset(1, 1), end: const Offset(1.2, 1.2)),
                ],
              ),
            ).animate().slideY(begin: -0.1, duration: 600.ms, curve: Curves.easeOut),

            const SizedBox(height: 32),

            // Specialties Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Specialties', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                NeumorphicButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AllSpecialtiesScreen())),
                  child: const Text('View All', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Horizontal Specialties List
            SizedBox(
              height: 150,
              child: FutureBuilder<List<SpecialtyModel>>(
                future: _specialtiesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  final specialties = snapshot.data ?? [];
                  if (specialties.isEmpty) return _buildMockSpecialties();

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: specialties.length,
                    itemBuilder: (context, index) {
                      final specialty = specialties[index];
                      return _buildSpecialtyCard(specialty, Icons.medical_services, index);
                    },
                  );
                },
              ),
            ),
            
            const SizedBox(height: 32),
            const Text('Services', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 20),
            
            // Vertical Services List (Neumorphic Style)
            Column(
              children: [
                _buildServiceItem('Book Consultation', Icons.calendar_month, Colors.blue),
                const SizedBox(height: 20),
                _buildServiceItem('Order Medicine', Icons.medication, Colors.green),
                const SizedBox(height: 20),
                _buildServiceItem('Lab Tests', Icons.science, Colors.orange),
              ],
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialtyCard(SpecialtyModel specialty, IconData icon, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, bottom: 20), // Padding for shadow
      child: NeumorphicButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ClinicMainScreen(specialtyFilter: specialty)));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.primary, size: 40).animate().scale(delay: (100 * index).ms),
            const SizedBox(height: 12),
            Text(
              specialty.name,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (50 * index).ms).slideX();
  }
  
  Widget _buildServiceItem(String title, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppTheme.shadowLight, offset: const Offset(-6, -6), blurRadius: 12),
          BoxShadow(color: AppTheme.shadowDark, offset: const Offset(6, 6), blurRadius: 12),
        ],
      ),
      child: Row(
        children: [
          // Icon Container (Pressed/Inverted look for contrast)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.background, 
              shape: BoxShape.circle,
              boxShadow: [
                 BoxShadow(color: Colors.white, offset: const Offset(-2, -2), blurRadius: 4),
                 BoxShadow(color: AppTheme.shadowDark, offset: const Offset(2, 2), blurRadius: 4),
              ],
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 24),
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _buildMockSpecialties() {
    final mocks = [SpecialtyModel(id: '1', name: 'Cardiology'), SpecialtyModel(id: '2', name: 'Dentist'), SpecialtyModel(id: '3', name: 'General')];
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: mocks.length,
      itemBuilder: (context, index) {
        return _buildSpecialtyCard(mocks[index], Icons.favorite, index);
      },
    );
  }
}
