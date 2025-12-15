import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/models/clinic_models.dart';
import '../../theme/app_theme.dart';
import 'doctors_list_screen.dart';

class ClinicMainScreen extends StatefulWidget {
  final SpecialtyModel? specialtyFilter;

  const ClinicMainScreen({super.key, this.specialtyFilter});

  @override
  State<ClinicMainScreen> createState() => _ClinicMainScreenState();
}

class _ClinicMainScreenState extends State<ClinicMainScreen> {
  // --- MOCK DATA ---
  final List<ClinicModel> _allClinics = [
    ClinicModel(
        id: '1',
        name: 'Delta Healing Center',
        description: 'Comprehensive care with a focus on holistic wellness. Our experts are here for you.',
        address: '123 Health St, Cairo, Egypt',
        imageUrl: 'https://placeimg.com/640/480/arch?id=1'),
    ClinicModel(
        id: '2',
        name: 'Nile View Specialized Clinic',
        description: 'State-of-the-art facilities and top-tier medical professionals by the Nile.',
        address: '456 Nile Corniche, Giza, Egypt',
        imageUrl: 'https://placeimg.com/640/480/arch?id=2'),
    ClinicModel(
        id: '3',
        name: 'Alexandria Modern Care',
        description: 'Bringing the future of healthcare to Alexandria with a patient-first approach.',
        address: '789 Port Said St, Alexandria, Egypt',
        imageUrl: 'https://placeimg.com/640/480/arch?id=3'),
    ClinicModel(
        id: '4',
        name: 'Oasis Community Hospital',
        description: 'A friendly and welcoming environment for all your family\'s health needs.',
        address: '101 Desert Rd, 6th of October, Egypt',
        imageUrl: 'https://placeimg.com/640/480/arch?id=4'),
  ];
  // --- END OF MOCK DATA ---

  // --- STATE FOR SEARCH ---
  bool _isSearching = false;
  final _searchController = TextEditingController();
  List<ClinicModel> _filteredClinics = [];
  // --- END OF STATE FOR SEARCH ---

  @override
  void initState() {
    super.initState();
    _filteredClinics = _allClinics;
    _searchController.addListener(_filterClinics);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterClinics() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredClinics = _allClinics.where((clinic) {
        return clinic.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _filteredClinics.length,
        itemBuilder: (context, index) {
          final clinic = _filteredClinics[index];
          return _buildClinicCard(context, clinic, index);
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    if (_isSearching) {
      return AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _toggleSearch),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search clinics...',
            border: InputBorder.none,
          ),
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppTheme.textPrimary),
            onPressed: () => _searchController.clear(),
          )
        ],
      );
    }

    return AppBar(
      title: Text(
        widget.specialtyFilter != null ? widget.specialtyFilter!.name : 'Find Clinics',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      automaticallyImplyLeading: widget.specialtyFilter != null,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppTheme.textPrimary),
          onPressed: _toggleSearch,
        )
      ],
    );
  }

  Widget _buildClinicCard(BuildContext context, ClinicModel clinic, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppTheme.shadowDark.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 5)),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorsListScreen(clinicId: clinic.id, clinicName: clinic.name),
            ),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                image: DecorationImage(image: NetworkImage(clinic.imageUrl!), fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(clinic.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Text(clinic.description, style: const TextStyle(color: AppTheme.textSecondary, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 18, color: Colors.grey[400]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(clinic.address, style: TextStyle(color: Colors.grey[600], fontSize: 14), maxLines: 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (50 * index).ms).slideY(begin: 0.1);
  }
}
