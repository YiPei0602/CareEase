import 'package:flutter/material.dart';

class DiseaseReportForm extends StatefulWidget {
  const DiseaseReportForm({super.key});

  @override
  State<DiseaseReportForm> createState() => _DiseaseReportFormState();
}

class _DiseaseReportFormState extends State<DiseaseReportForm> {
  final _formKey = GlobalKey<FormState>();
  String _selectedDisease = 'Dengue';
  final TextEditingController _symptomsController = TextEditingController();
  int _selectedSeverity = 3;
  bool _hasDocument = false;
  final List<String> _diseases = [
    'Dengue',
    'Influenza A',
    'COVID-19',
    'Measles',
    'Other'
  ];

  @override
  void dispose() {
    _symptomsController.dispose();
    super.dispose();
  }

  String _getSeverityLabel(int severity) {
    switch (severity) {
      case 1:
        return 'Very Mild';
      case 2:
        return 'Mild';
      case 3:
        return 'Moderate';
      case 4:
        return 'Severe';
      case 5:
        return 'Critical';
      default:
        return 'Moderate';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Modal handle
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Title row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Report Disease Case',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),
          // Form
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Please provide information about the infectious disease case. Submitting documentation helps verify your report.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Disease Type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedDisease,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      items: _diseases.map((disease) {
                        return DropdownMenuItem(
                          value: disease,
                          child: Text(disease),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDisease = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Symptoms',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _symptomsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Describe the symptoms',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please describe the symptoms';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Severity Level',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Mild',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                          Text('Severe',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      Slider(
                        value: _selectedSeverity.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: _getSeverityLabel(_selectedSeverity),
                        activeColor: Colors.blue,
                        onChanged: (value) {
                          setState(() {
                            _selectedSeverity = value.round();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Medical Documentation',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _hasDocument = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Document uploaded successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _hasDocument
                                  ? Icons.check_circle
                                  : Icons.upload_file,
                              color: _hasDocument ? Colors.green : Colors.blue,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _hasDocument
                                  ? 'Document uploaded'
                                  : 'Tap to upload document',
                              style: TextStyle(
                                color:
                                    _hasDocument ? Colors.green : Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Upload your report or diagnosis document for verification.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Report submitted successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Submit Report',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
