class Doctor {
  final String name;
  final String photoUrl;
  final String specialty;
  final String state;  // Malaysian state
  final List<DateTime> slots;  // available times
  final List<String> diseases;
  final int patientsTreated;
  final int yearsExperience;

  Doctor({
    required this.name,
    required this.photoUrl,
    required this.specialty,
    required this.state,
    required this.slots,
    required this.diseases,
    required this.patientsTreated,
    required this.yearsExperience,
  });
}
