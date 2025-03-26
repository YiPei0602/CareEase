import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class GamificationPage extends StatefulWidget {
  const GamificationPage({Key? key}) : super(key: key);

  @override
  State<GamificationPage> createState() => _GamificationPageState();
}

class _GamificationPageState extends State<GamificationPage>
    with SingleTickerProviderStateMixin {
  // Exactly 4 daily tasks.
  List<bool> tasks = [false, false, false, false];
  // Progress is (# tasks done) / 4 => 0.0, 0.25, 0.5, 0.75, 1.0.
  double progress = 0.0;

  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  // Called whenever a task is toggled.
  void updateProgress() {
    final int completed = tasks.where((task) => task).length;
    final double newProgress = completed / tasks.length; // 0, 0.25, 0.5, 0.75, 1.0

    print("Debug: tasks completed = $completed / ${tasks.length}, newProgress = $newProgress");

    setState(() {
      progress = newProgress;
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: progress,
      ).animate(
        CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
      );
      _progressController.forward(from: 0.0);
    });

    // Show an iOS-styled dialog if all tasks are done.
    if (progress == 1.0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("Congratulations!"),
            content: const Text("You've completed all your tasks for today."),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      });
    }
  }

  // Choose which 3D asset to load based on tasks completed.
  String getCurrentAvatar() {
    final int completed = tasks.where((task) => task).length;
    // Only two characters: readyplayer when 0%, and female_dynamic_pose for 25% or more.
    if (completed >= 1) {
      print("Debug: completed=$completed => using avatar path: assets/female_dynamic_pose.glb");
      return 'assets/female_dynamic_pose.glb';
    } else {
      print("Debug: completed=$completed => using avatar path: https://models.readyplayer.me/67e2ae8ad4ed851a615b1e4f.glb");
      return 'https://models.readyplayer.me/67e2ae8ad4ed851a615b1e4f.glb';
    }
  }

  // Returns an encouragement message based on how many tasks are complete.
  String getEncouragementMessage() {
    final int completed = tasks.where((task) => task).length;
    switch (completed) {
      case 0:
        return "Let's get started!";
      case 1:
        return "You have a good start!";
      case 2:
        return "Keep it up!";
      case 3:
        return "You're almost there!";
      case 4:
        return "Congratulations, you've done it!";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CareHabit"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Redesigned Progress Bar with dynamic percentage markers.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Background bar.
                    Container(
                      height: 20,
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Animated progress indicator.
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return Container(
                          height: 20,
                          width: constraints.maxWidth * _progressAnimation.value,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00BCD4), Color(0xFF4CAF50)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        );
                      },
                    ),
                    // Overlay percentage markers.
                    Positioned.fill(
                      child: Row(
                        children: [
                          // For 25%, 50%, 75%, and 100% markers.
                          for (double threshold in [0.25, 0.5, 0.75, 1.0])
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: AnimatedBuilder(
                                  animation: _progressAnimation,
                                  builder: (context, child) {
                                    return _progressAnimation.value >= threshold
                                        ? Text(
                                            "${(threshold * 100).toInt()}%",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : const SizedBox.shrink();
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // 3D Character + Encouragement Message
          Expanded(
            child: Column(
              children: [
                Text(
                  getEncouragementMessage(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ModelViewer(
                      key: ValueKey(getCurrentAvatar()),
                      src: getCurrentAvatar(),
                      alt: "3D Character",
                      autoRotate: true,
                      cameraControls: true,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Section Title for Habit Tasks
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Habit Tasks of the Day",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // List of Habit Tasks (4 tasks)
          ..._buildTaskList(),
        ],
      ),
    );
  }

  // Build the 4 tasks in a ListTile format.
  List<Widget> _buildTaskList() {
    final List<String> habitDescriptions = [
      "Drink 8 glasses of water",
      "30 minutes of exercise",
      "Have my vitamins",
      "No smoking",
    ];

    return List.generate(tasks.length, (index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Card(
          elevation: 2,
          child: ListTile(
            leading: Icon(
              tasks[index] ? Icons.check_circle : Icons.circle_outlined,
              color: tasks[index] ? Colors.green : Colors.blue,
            ),
            title: Text(
              habitDescriptions[index],
              style: TextStyle(
                decoration: tasks[index] ? TextDecoration.lineThrough : null,
                color: tasks[index] ? Colors.grey : Colors.black,
              ),
            ),
            trailing: Switch(
              value: tasks[index],
              activeColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  tasks[index] = value;
                  updateProgress();
                });
              },
            ),
          ),
        ),
      );
    });
  }
}
