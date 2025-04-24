import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'doctor_profile.dart';
import 'doctor_card.dart';
import 'doctor_detail.dart';

class AppointmentScreen extends StatefulWidget {
  final String specialty; // e.g. "Cardiologist Specialist"
  final String userState; // e.g. "Penang"

  const AppointmentScreen({
    Key? key,
    required this.specialty,
    required this.userState,
  }) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late final List<Doctor> _allDoctors;
  List<Doctor> _filteredDoctors = [];
  String _selectedState = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // master list by specialty
    _allDoctors = _dummyDoctors
        .where((d) => d.specialty == widget.specialty)
        .toList();
    // start with All
    _selectedState = 'All';
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredDoctors = _allDoctors.where((d) {
        final matchState =
            _selectedState == 'All' || d.state == _selectedState;
        final matchSearch = d.name.toLowerCase().contains(_searchQuery);
        return matchState && matchSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // — "Looking for" intro —
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Looking for:',
                    style: TextStyle(
                        fontSize: 14, color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text(widget.specialty,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // — search bar —
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CupertinoSearchTextField(
              borderRadius: BorderRadius.circular(12),
              backgroundColor: CupertinoColors.systemGrey5,
              placeholder: 'Search doctor by name…',
              onChanged: (q) {
                _searchQuery = q.toLowerCase();
                _applyFilters();
              },
            ),
          ),

          // — filter row —
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Text('Suggested doctors',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                const Spacer(),
                IconButton(
                  icon: const Icon(CupertinoIcons.slider_horizontal_3),
                  tooltip: 'Filter by state',
                  onPressed: _showStatePicker,
                ),
              ],
            ),
          ),

          // — doctor list —
          Expanded(
            child: _filteredDoctors.isEmpty
                ? const Center(child: Text('No doctors found.'))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: _filteredDoctors.length,
                    itemBuilder: (_, i) {
                      final doc = _filteredDoctors[i];
                      return DoctorCard(
                        doctor: doc,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DoctorDetailScreen(doctor: doc),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showStatePicker() {
    final states = ['All', ..._malaysiaStates];
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: ListView(
          children: states.map((s) {
            return ListTile(
              title: Text(s),
              onTap: () {
                Navigator.pop(context);
                _selectedState = s;
                _applyFilters();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

/*── Malaysian states, alphabetical ──*/
const List<String> _malaysiaStates = [
  'Johor',
  'Kedah',
  'Kelantan',
  'Malacca',
  'Negeri Sembilan',
  'Pahang',
  'Penang',
  'Perak',
  'Perlis',
  'Sabah',
  'Sarawak',
  'Selangor',
  'Terengganu',
];

/*── demo slots ──*/
List<DateTime> _demoSlots() {
  final now = DateTime.now();
  final List<DateTime> slots = [];
  
  // Generate two slots per day for the next 6 days
  for (int i = 0; i < 6; i++) {
    // Morning slot (10:00 AM)
    slots.add(DateTime(now.year, now.month, now.day + i, 10));
    // Afternoon slot (14:00 PM)
    slots.add(DateTime(now.year, now.month, now.day + i, 14 + (i % 3)));
  }
  
  return slots;
}

/*── sample doctors ──*/
final _dummyDoctors = [
  Doctor(
    name: 'Dr. Mohd Firdaus Hafni Bin Ahmad',
    photoUrl: 'assets/doctor_2.jpeg',
    specialty: 'Cardiologist Specialist',
    state: 'Selangor',
    slots: _demoSlots(),
    diseases: ['Coronary Artery Disease', 'Hypertension'],
    patientsTreated: 1500,
    yearsExperience: 12,
  ),
  Doctor(
    name: 'Dr. Lim Han Sim',
    photoUrl: 'assets/doctor_4.jpg',
    specialty: 'Cardiologist Specialist',
    state: 'Penang',
    slots: _demoSlots(),
    diseases: ['Arrhythmia', 'Heart Failure'],
    patientsTreated: 900,
    yearsExperience: 8,
  ),
  Doctor(
    name: 'Dr. Yap See Hien',
    photoUrl: 'assets/doctor_3.jpeg',
    specialty: 'Cardiologist Specialist',
    state: 'Johor',
    slots: _demoSlots(),
    diseases: ['Angina', 'Pericarditis'],
    patientsTreated: 1100,
    yearsExperience: 15,
  ),
  Doctor(
    name: 'Dr. Norazlina Binti Mohd Yusof',
    photoUrl: 'assets/doctor_5.jpeg',
    specialty: 'Cardiologist Specialist',
    state: 'Johor',
    slots: _demoSlots(),
    diseases: ['Valvular Disease', 'Cardiomyopathy'],
    patientsTreated: 850,
    yearsExperience: 9,
  ),
  Doctor(
    name: 'Dr. Shanker Vinayagamoorthy',
    photoUrl: 'assets/doctor_1.jpg',
    specialty: 'Cardiologist Specialist',
    state: 'Johor',
    slots: _demoSlots(),
    diseases: ['Congenital Heart Disease', 'Myocarditis'],
    patientsTreated: 780,
    yearsExperience: 20,
  ),
];
