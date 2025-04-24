import 'dart:async';

class SymptomRecord {
  final DateTime dateTime;
  final String symptom;
  final int severityLevel; // 0: Not Present, 1: Present, 2: Mild, 3: Moderate, 4: Severe
  
  SymptomRecord({
    required this.dateTime,
    required this.symptom,
    required this.severityLevel,
  });
}

class SymptomDataService {
  static final SymptomDataService _instance = SymptomDataService._internal();
  factory SymptomDataService() => _instance;
  SymptomDataService._internal();

  final List<SymptomRecord> _records = [];
  final _controller = StreamController<List<SymptomRecord>>.broadcast();

  Stream<List<SymptomRecord>> get recordsStream => _controller.stream;

  void addRecord(SymptomRecord record) {
    _records.add(record);
    _records.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    _controller.add(_records);
  }

  List<SymptomRecord> getRecordsForSymptom(String symptom, {DateTime? startDate, DateTime? endDate}) {
    return _records.where((record) {
      if (record.symptom != symptom) return false;
      if (startDate != null && record.dateTime.isBefore(startDate)) return false;
      if (endDate != null && record.dateTime.isAfter(endDate)) return false;
      return true;
    }).toList();
  }

  void dispose() {
    _controller.close();
  }

  // Convert severity string to level
  static int severityToLevel(String severity) {
    switch (severity.toLowerCase()) {
      case 'not present':
        return 0;
      case 'present':
        return 1;
      case 'mild':
        return 2;
      case 'moderate':
        return 3;
      case 'severe':
        return 4;
      default:
        return 0;
    }
  }

  // Convert level to severity string
  static String levelToSeverity(int level) {
    switch (level) {
      case 0:
        return 'Not Present';
      case 1:
        return 'Present';
      case 2:
        return 'Mild';
      case 3:
        return 'Moderate';
      case 4:
        return 'Severe';
      default:
        return 'Not Present';
    }
  }
} 