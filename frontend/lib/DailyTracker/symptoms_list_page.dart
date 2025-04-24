import 'package:flutter/material.dart';
import 'symptoms_trend_page.dart';
import 'add_symptom_data_page.dart';

class SymptomsListPage extends StatelessWidget {
  final List<String> symptoms = [
    'Abdominal Cramps',
    'Acne',
    'Appetite Changes',
    'Bladder Incontinence',
    'Bloating',
    'Body and Muscle Ache',
    'Breast Pain',
    'Chest Tightness or Pain',
    'Chills',
    'Congestion',
    'Constipation',
    'Coughing',
    'Depression',
    'Diarrhea',
    'Dizziness',
    'Fatigue',
    'Fever',
    'Headache',
    'Insomnia',
    'Joint Pain',
    'Nausea',
    'Rash',
    'Shortness of Breath',
    'Sore Throat',
    'Vomiting',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Track your symptoms',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: symptoms.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SymptomTrendPage(symptom: symptoms[index]),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getSymptomIcon(symptoms[index]),
                              color: Colors.blue,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              symptoms[index],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getSymptomIcon(String symptom) {
    switch (symptom.toLowerCase()) {
      case 'abdominal cramps':
        return Icons.airline_seat_flat;  // Represents stomach area
      case 'acne':
        return Icons.face;  // Face icon
      case 'appetite changes':
        return Icons.restaurant;  // Food/eating icon
      case 'bladder incontinence':
        return Icons.water_drop;  // Water/fluid icon
      case 'bloating':
        return Icons.circle_outlined;  // Expanded circle for bloating
      case 'body and muscle ache':
        return Icons.accessibility_new;  // Body icon
      case 'breast pain':
        return Icons.favorite;  // Heart/chest area
      case 'chest tightness or pain':
        return Icons.monitor_heart;  // Heart monitor
      case 'chills':
        return Icons.ac_unit;  // Snowflake for chills
      case 'congestion':
        return Icons.masks;  // Face mask for respiratory
      case 'constipation':
        return Icons.block;  // Blocked symbol
      case 'coughing':
        return Icons.coronavirus;  // Virus icon
      case 'depression':
        return Icons.mood_bad;  // Sad face
      case 'diarrhea':
        return Icons.running_with_errors;  // Running icon
      case 'dizziness':
        return Icons.motion_photos_on;  // Spinning motion
      case 'fatigue':
        return Icons.battery_alert;  // Low battery
      case 'fever':
        return Icons.thermostat;  // Temperature
      case 'headache':
        return Icons.psychology;  // Head icon
      case 'insomnia':
        return Icons.bedtime;  // Bed/sleep icon
      case 'joint pain':
        return Icons.architecture;  // Joint/connection icon
      case 'nausea':
        return Icons.sick;  // Sick face
      case 'rash':
        return Icons.texture;  // Texture pattern
      case 'shortness of breath':
        return Icons.air;  // Air/wind icon
      case 'sore throat':
        return Icons.record_voice_over;  // Voice/throat icon
      case 'vomiting':
        return Icons.sick_outlined;  // Sick face outlined
      default:
        return Icons.medical_services;  // Default medical icon
    }
  }
}
