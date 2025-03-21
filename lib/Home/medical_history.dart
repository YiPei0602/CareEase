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
  Widget _buildConditionItem(String condition, bool isSelected, bool isExpanded) {
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

    // Special case for "Allergy"
    if (condition == "Allergy") {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controllers["type"]!,
              label: "Type of allergy",
              hint: "e.g., Food, Medication, Seasonal",
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controllers["duration"]!,
              label: "How long have you had it?",
              hint: "e.g., Since childhood, 5 years",
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controllers["severity"]!,
              label: "Severity",
              hint: "e.g., Mild, Moderate, Severe",
            ),
          ],
        ),
      );
    }

    // Special case for "Asthma"
    if (condition == "Asthma") {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controllers["diagnosed"]!,
              label: "When were you diagnosed?",
              hint: "e.g., 2010, Childhood",
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controllers["medications"]!,
              label: "Current medications",
              hint: "e.g., Albuterol, Advair",
            ),
          ],
        ),
      );
    }

    // Generic form for other conditions
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controllers["diagnosisYear"]!,
            label: "Year Diagnosed",
            hint: "e.g., 2015",
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controllers["notes"]!,
            label: "Additional Notes",
            hint: "Any additional information",
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // Helper to build consistent text fields
  Widget _buildTextField(
    TextEditingController controller, {
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  // Bottom sheet for "Others" to specify custom condition
  void _showCustomConditionBottomSheet() {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Specify Condition",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Enter your condition...",
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // Here you would add the custom condition to your data
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // DUMMY IMPLEMENTATION of save function
  void _saveMedicalHistory() {
    // Create a map of all selected conditions and their details
    final Map<String, Map<String, String>> data = {};

    for (final condition in _conditions) {
      if (_selected[condition] == true) {
        final detailMap = <String, String>{};
        final controllers = _detailControllers[condition]!;

        for (final entry in controllers.entries) {
          detailMap[entry.key] = entry.value.text;
        }

        data[condition] = detailMap;
      }
    }

    // TODO: Save this data to your backend or local storage
    print("Saving medical history data: $data");

    // Show success message and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Medical information saved successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back to home screen after short delay
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }
}