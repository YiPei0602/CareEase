import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'dart:math' as math;

class GamificationPage extends StatefulWidget {
  const GamificationPage({Key? key}) : super(key: key);

  @override
  State<GamificationPage> createState() => _GamificationPageState();
}

class _GamificationPageState extends State<GamificationPage> {
  // For a 7-day challenge
  int currentDay = 0; // Ranges from 0 to 6

  // 5 daily habit goals (false means not done)
  List<bool> habits = [false, false, false, false, false];

  // Overall progress (0.0 to 1.0) for the current day
  double progress = 0.0;

  // For demonstration, we use one avatar model for all states.
  // You can replace these URLs with different ones for different progress states.
  final List<String> avatarStates = [
    'https://models.readyplayer.me/67e2ae8ad4ed851a615b1e4f.glb', // 0%
    'https://models.readyplayer.me/67e2ae8ad4ed851a615b1e4f.glb', // 20%
    'https://models.readyplayer.me/67e2ae8ad4ed851a615b1e4f.glb', // 40%
    'https://models.readyplayer.me/67e2ae8ad4ed851a615b1e4f.glb', // 60%
    'https://models.readyplayer.me/67e2ae8ad4ed851a615b1e4f.glb', // 80%
    'https://models.readyplayer.me/67e2ae8ad4ed851a615b1e4f.glb', // 100%
  ];

  // Update progress based on how many habits are completed.
  void updateProgress() {
    int completed = habits.where((habit) => habit).length;
    setState(() {
      progress = completed / habits.length;
    });

    // If all habits are done, check for day completion.
    if (progress == 1.0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _showDayCompletionDialog();
      });
    }
  }

  // When a day is completed, show a congratulatory dialog and then move to next day.
  void _showDayCompletionDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(currentDay < 6 ? "Day ${currentDay + 1} Complete!" : "Challenge Complete!"),
        content: Text(currentDay < 6
            ? "Great job! Get ready for Day ${currentDay + 2}."
            : "You've successfully completed the 7-day challenge!"),
        actions: [
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
              if (currentDay < 6) {
                // Advance to next day
                setState(() {
                  currentDay++;
                  habits = [false, false, false, false, false];
                  progress = 0.0;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  // Calculate avatar state index based on progress
  int getAvatarStateIndex() {
    // We'll use the range 0-5 (six states) from progress (0.0 - 1.0)
    int index = (progress * (avatarStates.length - 1)).round();
    return index.clamp(0, avatarStates.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final int avatarIndex = getAvatarStateIndex();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('7-Day Challenge'),
        backgroundColor: Colors.white,
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 1) Daily Streak Tracker
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(7, (index) {
                    bool isCompleted = index < currentDay;
                    bool isToday = index == currentDay;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? Colors.greenAccent
                              : isToday
                                  ? Colors.orangeAccent
                                  : Colors.white.withOpacity(0.5),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              // 2) 3D Avatar Viewer Card
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ModelViewer(
                        src: avatarStates[avatarIndex],
                        alt: "3D Avatar",
                        autoRotate: true,
                        cameraControls: true,
                      ),
                    ),
                  ),
                ),
              ),
              // 3) Custom Gradient Progress Bar with Motivational Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: Column(
                  children: [
                    Container(
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                      ),
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            widthFactor: progress,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Show motivational text when progress is 80% or more but not yet 100%
                    if (progress >= 0.8 && progress < 1.0)
                      const Text(
                        "You're almost there!",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    else if (progress == 0.0)
                      const Text(
                        "Let's get started!",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      )
                    else if (progress > 0.0 && progress < 0.8)
                      const Text(
                        "Keep going!",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                  ],
                ),
              ),
              // 4) Today's Habit Goals List with CupertinoSwitches
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            _habitTitle(index),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          trailing: CupertinoSwitch(
                            value: habits[index],
                            activeColor: const Color(0xFF2575FC),
                            onChanged: (bool value) {
                              setState(() {
                                habits[index] = value;
                                updateProgress();
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _habitTitle(int index) {
    // Define 5 daily habits. You can adjust these texts as needed.
    switch (index) {
      case 0:
        return 'Drink 10 cups of water';
      case 1:
        return 'Take a vitamin C supplement';
      case 2:
        return 'Do 15 minutes of stretching';
      case 3:
        return 'Meditate for 10 minutes';
      case 4:
        return 'Get at least 8 hours of sleep';
      default:
        return '';
    }
  }
}
