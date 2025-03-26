import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class GamificationPage extends StatefulWidget {
  const GamificationPage({Key? key}) : super(key: key);

  @override
  State<GamificationPage> createState() => _GamificationPageState();
}

class _GamificationPageState extends State<GamificationPage>
    with SingleTickerProviderStateMixin {
  // 4 daily habit tasks
  List<bool> tasks = [false, false, false, false];

  // The progress bar will show 0%, 25%, 50%, 75%, 100%.
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

  // Called whenever a task is toggled
  void updateProgress() {
    final int completed = tasks.where((task) => task).length;
    final double newProgress = completed / tasks.length; // 0..1 in 0.25 increments

    print("Debug: tasks completed = $completed, newProgress = $newProgress");

    setState(() {
      progress = newProgress;
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: progress,
      ).animate(
        CurvedAnimation(
          parent: _progressController,
          curve: Curves.easeOut,
        ),
      );
      _progressController.forward(from: 0.0);
    });

    // Show dialog if all tasks are done (progress == 1.0)
    if (progress == 1.0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Congratulations, you've done it!"),
            content: const Text("You've completed all your tasks for today."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      });
    }
  }

  // Choose which 3D asset to load based on tasks completed
  String getCurrentAvatar() {
    final int completed = tasks.where((task) => task).length;
    String path;
    switch (completed) {
      case 0:
        path = 'https://models.readyplayer.me/67e2ae8ad4ed851a615b1e4f.glb';
        break;
      case 1:
        // path = 'assets/female_dynamic_pose.glb';
        path = 'assets/drunk_idle_variation.glb';
        break;
      case 2:
        path = 'assets/drunk_idle_variation.glb';
        break;
      case 3:
       // path = 'assets/jogging.glb';
        path = 'assets/drunk_idle_variation.glb';
        break;
      case 4:
       // path = 'assets/victory.glb';
        path = 'assets/drunk_idle_variation.glb';
        break;
      default:
        path = 'https://models.readyplayer.me/67e2ae8ad4ed851a615b1e4f.glb';
    }

    print("Debug: completed=$completed => using avatar path: $path");
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("7-Day Challenge - Day 1"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      widthFactor: _progressAnimation.value,
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00BCD4), Color(0xFF4CAF50)],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Percentage text
                Positioned.fill(
                  child: Center(
                    child: Text(
                      "${(_progressAnimation.value * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 2,
                            color: Colors.black45,
                            offset: Offset(1, 1),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 3D Character
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ModelViewer(
                key: ValueKey(getCurrentAvatar()),
                src: getCurrentAvatar(),
                alt: "3D Character",
                autoRotate: true,
                cameraControls: true,
              ),
            ),
          ),
          // Habit Tasks
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
          ..._buildTaskList(),
        ],
      ),
    );
  }

  // 4 tasks in a ListTile
  List<Widget> _buildTaskList() {
    final List<String> habitDescriptions = [
      "Drink 8 glasses of water",
      "30 minutes of exercise",
      "Meditate for 10 minutes",
      "Get 7-8 hours of sleep",
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
                decoration:
                    tasks[index] ? TextDecoration.lineThrough : null,
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
