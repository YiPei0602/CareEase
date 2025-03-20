import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Import the home page you want to navigate to
import 'home.dart'; // <-- Ensure this import matches your file structure

class MedicalHistoryPage extends StatefulWidget {
  final String recordType;
  const MedicalHistoryPage({super.key, required this.recordType});

  @override
  State<MedicalHistoryPage> createState() => _MedicalHistoryPageState();
}

class _MedicalHistoryPageState extends State<MedicalHistoryPage> {
  // List of medical conditions
  final List<String> _conditions = [
    "Allergy",
    "Arthritis",
    "Asthma",
    "Brain Infection",
    "Cancer",
    "Chronic Kidney Disease",
    "Chronic Lung Disease",
    "Chronic Skin Illness",
    "Congenital Gastrointestinal Disease",
    "Diabetes Type 1",
    "Diabetes Type 2",
    "Epilepsy",
    "Fibromyalgia",
    "Glaucoma",
    "Hepatitis",
    "Inflammatory Bowel Disease",
    "Jaundice",
    "Kidney Stones",
    "Lupus",
    "Migraine",
    "Neuropathy",
    "Osteoarthritis",
    "Parkinson's Disease",
    "Quinsy",
    "Rheumatoid Arthritis",
    "Sinusitis",
    "Thyroid Disorder",
    "Ulcer",
    "Vertigo",
    "Whooping Cough",
    "Xerostomia",
    "Yersiniosis",
    "Zika Virus",
    "Others"
  ];

  // Search & selection states
  String _searchQuery = "";

  // Toggled conditions
  final Map<String, bool> _selected = {};

  // Expanded boxes for details
  final Map<String, bool> _expanded = {};

  // Instead of one controller per condition, store a map of controllers per condition
  final Map<String, Map<String, TextEditingController>> _detailControllers = {};

  @override
  void initState() {
    super.initState();
    // Initialize detail controllers for each condition
    for (final cond in _conditions) {
      _initControllersFor(cond);
    }
  }

  // Helper to set up the text fields needed for each condition
  void _initControllersFor(String cond) {
    if (cond == "Allergy") {
      _detailControllers[cond] = {
        "type": TextEditingController(),
        "duration": TextEditingController(),
        "severity": TextEditingController(),
      };
    } else if (cond == "Asthma") {
      _detailControllers[cond] = {
        "diagnosed": TextEditingController(),
        "medications": TextEditingController(),
      };
    } else {
      // Generic fields for other conditions
      _detailControllers[cond] = {
        "diagnosisYear": TextEditingController(),
        "notes": TextEditingController(),
      };
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (final map in _detailControllers.values) {
      for (final controller in map.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter conditions based on search query
    final filtered = _conditions.where((cond) {
      return cond.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.recordType,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Body with iOS-style search bar + list of conditions
      body: SafeArea(
        child: Column(
          children: [
            // iOS-style search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CupertinoSearchTextField(
                controller: TextEditingController(text: _searchQuery),
                placeholder: "Search conditions...",
                onChanged: (value) => setState(() => _searchQuery = value),
                borderRadius: BorderRadius.circular(12),
                prefixIcon: const Icon(CupertinoIcons.search),
                suffixIcon: const Icon(CupertinoIcons.xmark_circle_fill),
              ),
            ),

            // Instruction
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Select any medical conditions you have. You may add details by expanding each.",
                style: TextStyle(fontSize: 15),
              ),
            ),

            // List of conditions
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final condition = filtered[index];
                  final isSelected = _selected[condition] ?? false;
                  final isExpanded = _expanded[condition] ?? false;
                  return _buildConditionItem(condition, isSelected, isExpanded);
                },
              ),
            ),

            // "Save" button at bottom
            Container(
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              child: ElevatedButton(
                // Matching the style from your main page, but in blue
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue background
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _saveMedicalHistory,
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build each condition row with a trailing checkmark
  Widget _buildConditionItem(
      String condition, bool isSelected, bool isExpanded) {
    final isOthers = condition == "Others";

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(condition, style: const TextStyle(fontSize: 16)),
            // iPhone-style checkmark if selected
            trailing: isSelected
                ? const Icon(Icons.check, color: Colors.blue)
                : const SizedBox(width: 24), // empty space for alignment
            onTap: () {
              // Tapping toggles selection
              final newValue = !isSelected;
              setState(() {
                _selected[condition] = newValue;
                _expanded[condition] = newValue; // expand if turned on
              });
              if (condition == "Others" && newValue) {
                _showCustomConditionBottomSheet();
              }
            },
          ),

          // Divider (skip if "Others")
          if (!isOthers) Container(height: 1, color: Colors.grey.shade300),

          // Drop-down box if expanded
          if (isExpanded) _buildExpandedDetails(condition),
        ],
      ),
    );
  }

  // Build the expanded details box (optional user input)
  Widget _buildExpandedDetails(String condition) {
    final controllers = _detailControllers[condition]!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Additional Details for $condition:",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          // Allergy
          if (condition == "Allergy") ...[
            _buildDetailTextField(
              controllers["type"]!,
              "What type of allergy?",
            ),
            const SizedBox(height: 8),
            _buildDetailTextField(
              controllers["duration"]!,
              "How long? (years)",
            ),
            const SizedBox(height: 8),
            _buildDetailTextField(
              controllers["severity"]!,
              "Severity? (mild, moderate, severe)",
            ),
          ]
          // Asthma
          else if (condition == "Asthma") ...[
            _buildDetailTextField(
              controllers["diagnosed"]!,
              "When diagnosed?",
            ),
            const SizedBox(height: 8),
            _buildDetailTextField(
              controllers["medications"]!,
              "Current medications?",
            ),
          ]
          // Others & Generic Conditions
          else ...[
            _buildDetailTextField(
              controllers["diagnosisYear"]!,
              "Year of Diagnosis?",
            ),
            const SizedBox(height: 8),
            _buildDetailTextField(
              controllers["notes"]!,
              "Additional Notes",
            ),
          ],
        ],
      ),
    );
  }

  // A helper text field for the expanded details
  Widget _buildDetailTextField(
    TextEditingController controller,
    String placeholder,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: placeholder,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  // If user toggles "Others", show bottom sheet
  void _showCustomConditionBottomSheet() {
    final customCtrl = TextEditingController();

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
        final mediaQuery = MediaQuery.of(ctx);
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return Container(
              height: mediaQuery.size.height * 0.6,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  const Text(
                    "Others Condition",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: customCtrl,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Enter your condition",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final value = customCtrl.text.trim();
                        if (value.isNotEmpty) {
                          setState(() {
                            final idx = _conditions.indexOf("Others");
                            // Insert new condition right before "Others"
                            _conditions.insert(idx, value);
                            _selected[value] = true;
                            _expanded[value] = true;

                            // Initialize a default set of controllers for this new condition
                            _detailControllers[value] = {
                              "diagnosisYear": TextEditingController(),
                              "notes": TextEditingController(),
                            };
                          });
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
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

  // Show a more iOS-like "Success!" dialog and then go back to CareEaseHomePage with a slide-from-left transition
  void _saveMedicalHistory() {
    // Save data if needed, then show the success dialog
    showDialog(
      context: context,
      barrierDismissible: false, // user can't dismiss by tapping outside
      builder: (BuildContext context) {
        // Show the dialog and schedule the navigation
        Future.delayed(const Duration(seconds: 1), () {
          // Close the dialog
          Navigator.of(context).pop();
          // Push the CareEaseHomePage with a custom slide-from-left transition,
          // removing all previous routes.
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const CareEaseHomePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(-1.0, 0.0); // slide in from left
                const end = Offset.zero;
                final tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: Curves.easeInOut));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
            (route) => false,
          );
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Big success icon
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 64,
                ),
                SizedBox(height: 16),
                // Title
                Text(
                  "Success!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                // Message
                Text(
                  "Your medical history has been updated successfully.",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
