import 'package:flutter/material.dart';
import '../../generated/l10n.dart';

class HealthRecordsScreen extends StatefulWidget {
  const HealthRecordsScreen({super.key});

  @override
  _HealthRecordsScreenState createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen> {
  // Mock data - replace with a provider later
  final _medicationsController = TextEditingController(text: 'Aspirin, 500mg\nIbuprofen, 200mg');
  final _vaccinationsController = TextEditingController(text: 'COVID-19 (Pfizer)\nFlu Shot (2023)');
  final _historyController = TextEditingController(text: 'Asthma (diagnosed 2010)');

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildRecordCard(
            context,
            title: s.currentMedications,
            contentController: _medicationsController,
            icon: Icons.medical_services_outlined,
          ),
          const SizedBox(height: 16),
          _buildRecordCard(
            context,
            title: s.vaccinations,
            contentController: _vaccinationsController,
            icon: Icons.vaccines_outlined,
          ),
          const SizedBox(height: 16),
          _buildRecordCard(
            context,
            title: s.medicalHistory,
            contentController: _historyController,
            icon: Icons.history_edu_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(BuildContext context, {required String title, required TextEditingController contentController, required IconData icon}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor, size: 28),
                const SizedBox(width: 12),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              maxLines: null, // Allows for multiline input
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                hintText: 'Add details here...',
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Save logic will be added here using a provider
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$title saved!')),
                  );
                },
                child: const Text('Save'),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _medicationsController.dispose();
    _vaccinationsController.dispose();
    _historyController.dispose();
    super.dispose();
  }
}
