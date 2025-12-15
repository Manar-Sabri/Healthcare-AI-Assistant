import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/repositories/clinic_repository.dart';
import '../../data/models/clinic_models.dart';
import '../../theme/app_theme.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final DoctorModel doctor;

  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedSlotId;
  bool _isBooking = false;

  Future<List<SlotModel>> _fetchSlots() {
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    return Provider.of<ClinicRepository>(context, listen: false)
        .getDoctorSlots(widget.doctor.id, dateStr)
        .then((response) => response.value ?? []);
  }

  Future<void> _bookAppointment() async {
    if (_selectedSlotId == null) return;

    setState(() => _isBooking = true);
    try {
      await Provider.of<ClinicRepository>(context, listen: false)
          .bookAppointment(_selectedSlotId!, "General Checkup");
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Success!', style: TextStyle(color: AppTheme.accent)),
            content: const Text('Your appointment has been booked successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text('OK', style: TextStyle(color: AppTheme.primary)),
              )
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking Failed'), backgroundColor: AppTheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(widget.doctor.fullName, style: const TextStyle(fontWeight: FontWeight.bold))),
      body: Column(
        children: [
          // Doctor Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Hero(
                  tag: 'doctor-image-${widget.doctor.id}',
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: widget.doctor.imageUrl != null ? NetworkImage(widget.doctor.imageUrl!) : null,
                    child: widget.doctor.imageUrl == null ? const Icon(Icons.person, size: 40) : null,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.doctor.fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text(widget.doctor.specialty, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                    ],
                  ),
                )
              ],
            ),
          ),

          // Date Picker Strip
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              height: 85,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 14,
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index));
                  final isSelected = date.day == _selectedDate.day && date.month == _selectedDate.month;
                  
                  return InkWell(
                    onTap: () => setState(() {
                      _selectedDate = date;
                      _selectedSlotId = null;
                    }),
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 70,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primary : AppTheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected ? [
                          BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))
                        ] : [
                          BoxShadow(color: AppTheme.shadowDark, blurRadius: 10, offset: const Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(DateFormat('EEE').format(date).toUpperCase(), 
                               style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(date.day.toString(), 
                               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, 
                                                color: isSelected ? Colors.white : AppTheme.textPrimary)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Divider()),

          // Available Slots Grid
          Expanded(
            child: FutureBuilder<List<SlotModel>>(
              future: _fetchSlots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No available slots for this date.'));
                }

                final slots = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: slots.length,
                  itemBuilder: (context, index) {
                    final slot = slots[index];
                    String timeLabel = "N/A";
                    try { timeLabel = DateFormat('hh:mm a').format(DateTime.parse(slot.startTime)); } catch (e) {}

                    final isSelected = _selectedSlotId == slot.id;
                    final isAvailable = slot.isAvailable;

                    return InkWell(
                      onTap: isAvailable ? () => setState(() => _selectedSlotId = slot.id) : null,
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.accent : (isAvailable ? AppTheme.surface : AppTheme.background),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isAvailable ? AppTheme.primary.withOpacity(0.2) : Colors.transparent),
                          boxShadow: isSelected ? [
                            BoxShadow(color: AppTheme.accent.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
                          ] : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          timeLabel,
                          style: TextStyle(
                            color: isSelected ? Colors.white : (isAvailable ? AppTheme.primary : Colors.grey),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: (50 * index).ms);
                  },
                );
              },
            ),
          ),

          // Book Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: (_selectedSlotId != null && !_isBooking) ? _bookAppointment : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  icon: _isBooking ? const SizedBox.shrink() : const Icon(Icons.check_circle_outline, color: Colors.white),
                  label: _isBooking 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Confirm Booking', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
