import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'medical_history.dart'; // Import the medical history page
import 'sync.dart';


// Main Home Page
class CareEaseHomePage extends StatefulWidget {
  const CareEaseHomePage({super.key});

  @override
  State<CareEaseHomePage> createState() => _CareEaseHomePageState();
}

class _CareEaseHomePageState extends State<CareEaseHomePage> {
  // Store user-entered stats in memory
  String _height = "cm";
  String _weight = "kg";
  String _bmi = "Calc";
  String _blood = "type";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              // ------------------------------------------------
              // 1) HEADER (Profile Pic, Hello, Lucas & Notification Icon)
              // ------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile picture and greeting text
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 35, // Updated radius from 24 to 35
                        backgroundImage: AssetImage('assets/vhack_profile.jpg'),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Hello, Lucas 👋",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "How do you feel today?",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Notification Icon
                  IconButton(
                    onPressed: () {
                      // TODO: Navigate to notifications
                    },
                    icon: const Icon(Icons.notifications_none),
                    color: Colors.black,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ------------------------------------------------
              // 2) ONGOING HABIT TASK (Circle Percentage)
              // ------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Circular Percentage
                    CustomPaint(
                      foregroundPainter: _CircleProgressPainter(
                        progress: 0.65, // 65% done
                        progressColor: Colors.blueAccent,
                      ),
                      child: const SizedBox(
                        width: 60,
                        height: 60,
                        child: Center(
                          child: Text(
                            "65%",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Habit details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Today's Habit Goals",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Keep going! You're 65% done today's tasks.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // TODO: Navigate to habit detail
                      },
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ------------------------------------------------
              // 3) INTEGRATED WEARABLES FUNCTION (Modern Design)
              // ------------------------------------------------
             
            // Integrated Wearables Function (Modern Design)
Container(
  width: double.infinity,
  padding: const EdgeInsets.all(16),
  // Slightly lighter black background (not grey)
  decoration: BoxDecoration(
    color: const Color(0xFF2A2A2A),
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  ),
  child: Row(
    children: [
      // Smartwatch image (same size as the 65% ring: 60x60)
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: AssetImage('assets/vhack_smartwatch.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(width: 16),
      // Content text aligned with "Today's Habit Goals"
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "SmartWatch Sync",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Connect your watch for health tracking in real time.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      // Orange right arrow icon; on tap, push the SyncPage.
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SyncPage()),
          );
        },
        icon: const Icon(
          CupertinoIcons.right_chevron,
          color: Colors.orange,
          size: 28,
        ),
      ),
    ],
  ),
),


              const SizedBox(height: 24),

              // ------------------------------------------------
              // 4) YOUR HEALTH PROFILE & QUICK STATS (2x2 Grid)
              // ------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Health Profile",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.5,
                      children: [
                        _buildStatButton(
                          context,
                          title: "Height",
                          statValue: _height,
                          defaultValue: "cm",
                          icon: Icons.straighten,
                          color: Colors.blueAccent,
                        ),
                        _buildStatButton(
                          context,
                          title: "Weight",
                          statValue: _weight,
                          defaultValue: "kg",
                          icon: Icons.scale,
                          color: Colors.green,
                        ),
                        _buildStatButton(
                          context,
                          title: "BMI",
                          statValue: _bmi,
                          defaultValue: "Calc",
                          icon: Icons.monitor_heart,
                          color: Colors.orange,
                        ),
                        _buildStatButton(
                          context,
                          title: "Blood",
                          statValue: _blood,
                          defaultValue: "type",
                          icon: Icons.water_drop,
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ------------------------------------------------
              // 5) NEW SECTION: HEALTH RECORDS
              // ------------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    Text(
                      "Health Records",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ------------------------------------------------
              // 6) COMPREHENSIVE HEALTH INFO (Each in separate bar)
              // ------------------------------------------------
              Column(
                children: [
                  _buildSeparateBar(
                    context,
                    icon: Icons.medical_services_outlined,
                    iconColor: Colors.blueAccent,
                    title: "Medical Conditions",
                    subtitle: "Track your health conditions",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MedicalHistoryPage(
                          recordType: "Medical Conditions",
                        ),
                      ),
                    ),
                  ),
                  _buildSeparateBar(
                    context,
                    icon: Icons.medication_outlined,
                    iconColor: Colors.orangeAccent,
                    title: "Medications",
                    subtitle: "Track your medication history",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MedicalHistoryPage(
                          recordType: "Medications",
                        ),
                      ),
                    ),
                  ),
                  _buildSeparateBar(
                    context,
                    icon: Icons.fitness_center_outlined,
                    iconColor: Colors.green,
                    title: "Lifestyle Habits",
                    subtitle: "Track your daily lifestyle habits",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MedicalHistoryPage(
                          recordType: "Lifestyle Habits",
                        ),
                      ),
                    ),
                  ),
                  _buildSeparateBar(
                    context,
                    icon: Icons.family_restroom,
                    iconColor: Colors.purple,
                    title: "Family History",
                    subtitle: "Track family health information",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MedicalHistoryPage(
                          recordType: "Family History",
                        ),
                      ),
                    ),
                  ),
                  _buildSeparateBar(
                    context,
                    icon: Icons.local_hospital_outlined,
                    iconColor: Colors.redAccent,
                    title: "Previous Hospitalizations",
                    subtitle: "Track your past hospital visits",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MedicalHistoryPage(
                          recordType: "Previous Hospitalizations",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build a single stat button cell in the 2x2 grid
  Widget _buildStatButton(
    BuildContext context, {
    required String title,
    required String statValue,
    required String defaultValue,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () => _showEditStatDialog(context, title, statValue),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    statValue,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A modern bar design for each health information type
  Widget _buildSeparateBar(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Left icon with colored background
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 16),
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Right arrow
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Dialog to edit stats using Cupertino style for Height, Weight, and Blood.
  void _showEditStatDialog(BuildContext context, String title, String current) {
    // Special handling for BMI: auto-calculate and skip dialog.
    if (title == "BMI") {
      try {
        if (_height != "cm" && _weight != "kg") {
          final height = double.parse(_height) / 100; // convert to meters
          final weight = double.parse(_weight);
          final bmi = weight / (height * height);
          setState(() => _bmi = bmi.toStringAsFixed(1));
        }
      } catch (e) {
        // handle error
      }
      return;
    }

    // For Blood: use CupertinoAlertDialog with text input.
    if (title == "Blood") {
      TextEditingController controller = TextEditingController(text: current);
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text("Enter your $title"),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CupertinoTextField(
              controller: controller,
              placeholder: "e.g. A+, O-, etc.",
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              child: const Text("Save"),
              onPressed: () {
                setState(() => _blood = controller.text.trim());
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
      return;
    }

    // For Height & Weight: use CupertinoAlertDialog.
    if (title == "Height" || title == "Weight") {
      String defaultVal = title == "Height" ? "cm" : "kg";
      TextEditingController controller = TextEditingController(
          text: current == defaultVal ? "" : current);
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text("Enter your $title"),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CupertinoTextField(
              controller: controller,
              keyboardType: TextInputType.number,
              placeholder: defaultVal,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              child: const Text("Save"),
              onPressed: () {
                setState(() {
                  if (title == "Height") {
                    _height = controller.text.trim().isEmpty ? defaultVal : controller.text.trim();
                  } else {
                    _weight = controller.text.trim().isEmpty ? defaultVal : controller.text.trim();
                  }
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
      return;
    }

    // For other cases, fallback to Material AlertDialog.
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Enter your $title"),
        content: TextField(
          controller: TextEditingController(text: current),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}

// Custom painter for circular progress
class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;

  _CircleProgressPainter({
    required this.progress,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background circle (gray)
    final bgPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2, // Start from top
      2 * math.pi * progress, // Arc angle
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircleProgressPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.progressColor != progressColor;
}
