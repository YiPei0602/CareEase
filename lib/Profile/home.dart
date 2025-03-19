import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'medical_history.dart'; // Import the medical history page

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
  String _blood = "A+";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              // ------------------------------------------------
              // 1) HEADER (Hello, Lucas & Notification Icon)
              // ------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // "Hello, Lucas 👋"
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
              // 3) YOUR HEALTH PROFILE & QUICK STATS (2x2 Grid)
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
                      childAspectRatio: 2.5, // Adjusted for better alignment
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
              // NEW SECTION: HEALTH RECORDS
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
              // 4) COMPREHENSIVE HEALTH INFO
              // Each in separate bar (modern look)
              // Tapping opens a new page with that title
              // ------------------------------------------------
              Column(
                children: [
                  _buildSeparateBar(
                    context,
                    icon: Icons.medical_services_outlined,
                    iconColor: Colors.blueAccent,
                    title: "Medical History",
                    // Updated to navigate to MedicalHistoryPage
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MedicalHistoryPage(
                            recordType: "Medical History",
                          ),
                        ),
                      );
                    },
                  ),
                  _buildSeparateBar(
                    context,
                    icon: Icons.family_restroom,
                    iconColor: Colors.purple,
                    title: "Family History",
                  ),
                  _buildSeparateBar(
                    context,
                    icon: Icons.insert_chart_outlined,
                    iconColor: Colors.deepOrangeAccent,
                    title: "Health Report",
                  ),
                  _buildSeparateBar(
                    context,
                    icon: Icons.fitness_center_outlined,
                    iconColor: Colors.green,
                    title: "Lifestyle Habits",
                  ),
                  _buildSeparateBar(
                    context,
                    icon: Icons.local_hospital_outlined,
                    iconColor: Colors.redAccent,
                    title: "Previous Hospitalizations",
                  ),
                  _buildSeparateBar(
                    context,
                    icon: Icons.call,
                    iconColor: Colors.blueGrey,
                    title: "Emergency Contact",
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ------------------------------------------------
              // 5) SECURITY INFO
              // ------------------------------------------------
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline, color: Colors.blueAccent),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Your data is stored securely with advanced encryption.",
                        style: TextStyle(
                          color: Colors.blueGrey[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // QUICK STAT BUTTON with bottom-sheet
  // Modified to place the icon at the far left and the stat value text bigger with black color.

  Widget _buildStatButton(
    BuildContext context, {
    required String title,
    required String statValue,
    required String defaultValue,
    required IconData icon,
    required Color color,
  }) {
    const statTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    const labelTextStyle = TextStyle(
      fontSize: 12,
      color: Colors.grey,
    );

    return Container(
      height: 60, // Fixed height for consistent alignment
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showValueInputBottomSheet(context, title),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Align items to the left
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon positioned at the far left
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            // Column with the label and stat value
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: labelTextStyle,
                ),
                Text(
                  statValue,
                  style: statTextStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // For "Medical History", "Family History", etc.
  // Each item is its own "bar" with a modern card look
  // Tapping opens a new page with white header, back arrow, center title
  Widget _buildSeparateBar(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap ??
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => InfoPage(title: title)),
              );
            },
        child: Row(
          children: [
            // Circle icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            // Title with updated font size 16
            Expanded(
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // BOTTOM SHEET for entering values
  // "Save" in white color, pinned at bottom
  void _showValueInputBottomSheet(BuildContext context, String paramName) {
    final TextEditingController controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // allow full-height
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            final mediaQuery = MediaQuery.of(context);
            return Container(
              height: mediaQuery.size.height * 0.6, // 60% screen
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  // Title in the middle top
                  Text(
                    paramName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // TextField
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter $paramName value",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const Spacer(), // push button to bottom

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final input = controller.text;
                        if (input.isNotEmpty) {
                          setState(() {
                            // Update corresponding field
                            switch (paramName) {
                              case "Height":
                                _height = "$input cm";
                                break;
                              case "Weight":
                                _weight = "$input kg";
                                break;
                              case "BMI":
                                _bmi = input;
                                break;
                              case "Blood":
                                _blood = input;
                                break;
                            }
                          });
                        }
                        Navigator.pop(context); // close bottom sheet
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white, // White text
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Save", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// New page for medical history, family history, etc.
class InfoPage extends StatelessWidget {
  final String title;
  const InfoPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // White header, back arrow, center title
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Modern placeholder UI
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            "$title Page (modern design placeholder)",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

// Circle progress painter (unchanged)
class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;

  _CircleProgressPainter({required this.progress, required this.progressColor});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 6.0;
    final radius = math.min(size.width, size.height) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), radius, backgroundPaint);

    // Progress circle
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final startAngle = -math.pi / 2; // start from top
    final sweepAngle = 2 * math.pi * progress; // progress portion

    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor;
  }
}
