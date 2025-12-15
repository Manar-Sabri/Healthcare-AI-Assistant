import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import 'package:intl/intl.dart';

class HomeVisitScreen extends StatefulWidget {
  const HomeVisitScreen({super.key});

  @override
  _HomeVisitScreenState createState() => _HomeVisitScreenState();
}

class _HomeVisitScreenState extends State<HomeVisitScreen> {
  String? _selectedDoctor;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Mock data
  final List<String> _doctors = ['Dr. Smith', 'Dr. Jones', 'Dr. Williams'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _confirmBooking(BuildContext context, S s) {
    if (_selectedDoctor == null || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(s.confirmBooking),
          content: Text('Doctor: $_selectedDoctor\nDate: ${DateFormat.yMd().format(_selectedDate!)}\nTime: ${_selectedTime!.format(context)}'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                // Add booking logic here
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to the previous screen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.homeVisit),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Selection
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: s.selectDoctor, border: const OutlineInputBorder()),
              value: _selectedDoctor,
              items: _doctors.map((String doctor) {
                return DropdownMenuItem<String>(
                  value: doctor,
                  child: Text(doctor),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedDoctor = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            // Date Selection
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Colors.grey),
              ),
              title: Text(_selectedDate == null ? s.selectDate : DateFormat.yMd().format(_selectedDate!)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 20),
            // Time Selection
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Colors.grey),
              ),
              title: Text(_selectedTime == null ? s.selectTime : _selectedTime!.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            const Spacer(),
            // Confirm Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => _confirmBooking(context, s),
              child: Text(s.confirmBooking),
            ),
          ],
        ),
      ),
    );
  }
}
