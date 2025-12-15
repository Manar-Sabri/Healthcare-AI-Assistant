import 'package:flutter/material.dart';
import '../../generated/l10n.dart';

class WearablesScreen extends StatelessWidget {
  const WearablesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildWearableCard(
            context,
            title: s.steps,
            value: '8,234 / 10,000',
            progress: 0.82,
            icon: Icons.directions_walk,
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildWearableCard(
            context,
            title: s.heartRate,
            value: '72 BPM',
            progress: 0.72, // Assuming a range, e.g., 0-100
            icon: Icons.favorite_border,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          _buildWearableCard(
            context,
            title: s.calories,
            value: '1,250 / 2,000 kcal',
            progress: 0.62,
            icon: Icons.local_fire_department_outlined,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildWearableCard(
            context,
            title: s.sleep,
            value: '6h 45m / 8h',
            progress: 0.84,
            icon: Icons.nightlight_round,
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildWearableCard(BuildContext context, {required String title, required String value, required double progress, required IconData icon, required Color color}) {
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
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 12),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('${(progress * 100).toInt()}%'),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.2),
              color: color,
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }
}
