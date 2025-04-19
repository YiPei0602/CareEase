import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

  @override
  _SymptomsScreenState createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  List<String> selectedSymptoms = [];
  List<String> otherSymptoms = [];
  TextEditingController otherSymptomController = TextEditingController();

  final Map<String, List<String>> symptoms = {
    "Mild Symptoms": ["Runny Nose", "Sore Throat", "Cough", "Fatigue"],
    "Moderate Symptoms": ["Fever", "Headache", "Body aches & Joint Pain"],
    "Severe Symptoms": [
      "Difficulty Breathing",
      "Persistent Chest",
      "Body Confusion"
    ],
  };

  final Map<String, IconData> categoryIcons = {
    "Mild Symptoms": Icons.sentiment_satisfied_alt,
    "Moderate Symptoms": Icons.sentiment_neutral,
    "Severe Symptoms": Icons.sentiment_very_dissatisfied,
  };

  void _addOtherSymptom() {
    String symptom = otherSymptomController.text.trim();
    if (symptom.isNotEmpty && !otherSymptoms.contains(symptom)) {
      setState(() {
        otherSymptoms.add(symptom);
        selectedSymptoms.add(symptom);
        otherSymptomController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Select Symptoms",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, selectedSymptoms);
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.blue)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ...symptoms.entries.map((entry) {
              return FadeInUp(
                duration: const Duration(milliseconds: 400),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(categoryIcons[entry.key], color: Colors.blue),
                            const SizedBox(width: 10),
                            Text(
                              entry.key.toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...entry.value.map((symptom) => CheckboxListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Text(symptom),
                              value: selectedSymptoms.contains(symptom),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedSymptoms.add(symptom);
                                  } else {
                                    selectedSymptoms.remove(symptom);
                                  }
                                });
                              },
                              activeColor: Colors.blue,
                            )),
                      ],
                    ),
                  ),
                ),
              );
            }),

            // Others section
            FadeInUp(
              duration: const Duration(milliseconds: 400),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.add, color: Colors.blue),
                          SizedBox(width: 10),
                          Text(
                            "Others",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: otherSymptomController,
                        decoration: InputDecoration(
                          hintText: "Enter other symptom...",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.add_circle,
                                color: Colors.blue),
                            onPressed: _addOtherSymptom,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Display other symptoms as checkboxes
                      ...otherSymptoms.map((symptom) => CheckboxListTile(
                            title: Text(symptom),
                            value: selectedSymptoms.contains(symptom),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedSymptoms.add(symptom);
                                } else {
                                  selectedSymptoms.remove(symptom);
                                }
                              });
                            },
                            activeColor: Colors.blue,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
