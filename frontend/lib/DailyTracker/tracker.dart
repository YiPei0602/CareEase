import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'symptoms_screen.dart';

class DailyTrackerScreen extends StatefulWidget {
  const DailyTrackerScreen({super.key});

  @override
  _DailyTrackerScreenState createState() => _DailyTrackerScreenState();
}

class _DailyTrackerScreenState extends State<DailyTrackerScreen> {
  bool isNotFeelingWell = false;
  DateTime selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              focusedDay: selectedDay,
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              selectedDayPredicate: (day) => isSameDay(day, selectedDay),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  this.selectedDay = selectedDay;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Not Feeling Well",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Switch(
                  value: isNotFeelingWell,
                  onChanged: (value) {
                    setState(() {
                      isNotFeelingWell = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final selectedSymptom = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SymptomsScreen()),
                );

                if (selectedSymptom != null) {
                  setState(() {
                    print("Selected Symptom: $selectedSymptom");
                  });
                }
              },
              child: const Row(
                children: [
                  Icon(Icons.add_circle_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Text("Symptoms",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Monthly Summary",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("Cough: 3 Days"),
                  SizedBox(height: 10),
                  Text("Health Insight & Suggestions",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text("\u{1F50D} Frequent Cough Detected!"),
                  Text(
                      "It looks like you’ve been coughing more than usual. Here are some tips:"),
                  SizedBox(height: 5),
                  Text("1. Stay hydrated – drink warm water or herbal tea."),
                  Text(
                      "2. Use a humidifier – keeping the air moist can ease irritation."),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
