import 'package:flutter/material.dart';
import 'dart:math';
import 'disease_report_form.dart'; // Ensure this file exists in your project

// Main component for Infectious Disease Spotter module
class InfectiousDiseaseTracker extends StatefulWidget {
  const InfectiousDiseaseTracker({Key? key}) : super(key: key);

  @override
  State<InfectiousDiseaseTracker> createState() => _InfectiousDiseaseTrackerState();
}

class _InfectiousDiseaseTrackerState extends State<InfectiousDiseaseTracker> {
  final TextEditingController _searchController = TextEditingController();
  bool _isUSMSearched = false;
  bool _isLoading = false;
  final List<DiseaseCase> _diseaseCases = [];
  String _userName = "LUCAS";

  // Variables for custom map gestures (zoom & pan)
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  double _previousScale = 1.0;
  Offset _previousOffset = Offset.zero;
  Offset _startFocalPoint = Offset.zero;

  @override
  void initState() {
    super.initState();
    _generateSampleData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Generate sample disease cases (but initially not shown)
  void _generateSampleData() {
    final random = Random();
    final diseases = ['Dengue', 'Influenza A', 'COVID-19', 'Measles'];
    for (int i = 0; i < 15; i++) {
      final disease = diseases[random.nextInt(diseases.length)];
      final daysAgo = 1 + random.nextInt(14);
      final severity = 1 + random.nextInt(5);
      // Random offsets (simulate within USM campus area)
      final xOffset = -50 + random.nextInt(100).toDouble();
      final yOffset = -50 + random.nextInt(100).toDouble();
      _diseaseCases.add(
        DiseaseCase(
          id: 'case-$i',
          disease: disease,
          daysAgo: daysAgo,
          severity: severity,
          xOffset: xOffset,
          yOffset: yOffset,
          caseCount: random.nextInt(4) + 1, // values between 1 and 4
        ),
      );
    }
  }

  // Trigger search when user submits query
  void _search() {
    final query = _searchController.text.trim().toLowerCase();
    if (query == 'usm') {
      setState(() {
        _isLoading = true;
      });
      // Simulate loading delay then set USM view and update active cases
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          _isUSMSearched = true;
          _isLoading = false;
          // Zoom in to USM campus
          _scale = 2.5;
          _offset = Offset.zero;
          _previousScale = _scale;
          _previousOffset = _offset;
        });
      });
    } else {
      setState(() {
        _isUSMSearched = false;
        _scale = 1.0;
        _offset = Offset.zero;
      });
    }
  }

  // Filter cases by disease type
  List<DiseaseCase> _getCasesByDisease(String disease) {
    return _diseaseCases.where((c) => c.disease == disease).toList();
  }

  // Get display radius (in meters) for each disease type (sample values)
  int _getRadiusForDisease(String diseaseName) {
    switch (diseaseName) {
      case 'Dengue':
        return 200;
      case 'Influenza A':
        return 1000;
      case 'COVID-19':
        return 500;
      case 'Measles':
        return 300;
      default:
        return 300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // iOS-like grey background
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar Container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (_) => _search(),
                  decoration: InputDecoration(
                    hintText: 'Search location (e.g., USM)',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: const Icon(Icons.search, color: Colors.blue),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            // Map Container with Interactive Gestures
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Stack(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onScaleStart: (details) {
                      _startFocalPoint = details.focalPoint;
                      _previousScale = _scale;
                      _previousOffset = _offset;
                    },
                    onScaleUpdate: (details) {
                      setState(() {
                        _scale = (_previousScale * details.scale).clamp(0.5, 3.0);
                        _offset = _previousOffset + (details.focalPoint - _startFocalPoint);
                      });
                    },
                    onScaleEnd: (details) {
                      _previousScale = _scale;
                      _previousOffset = _offset;
                    },
                    child: ClipRect(
                      child: Transform(
                        transform: Matrix4.identity()
                          ..translate(_offset.dx, _offset.dy)
                          ..scale(_scale),
                        child: CustomMapView(
                          isUSMVisible: _isUSMSearched,
                          diseaseCases: _isUSMSearched ? _diseaseCases : [],
                        ),
                      ),
                    ),
                  ),
                  // Report Case Button (inside map container at bottom right)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Material(
                      color: Colors.transparent,
                      child: FloatingActionButton(
                        onPressed: () => _showReportForm(context),
                        child: const Icon(Icons.add_circle_outline),
                        backgroundColor: Colors.blue,
                        elevation: 4,
                      ),
                    ),
                  ),
                  // Loading overlay
                  if (_isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  // Instructions overlay (wrapped in IgnorePointer so it doesn't block taps)
                  if (!_isUSMSearched && !_isLoading)
                    IgnorePointer(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        padding: const EdgeInsets.all(32),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 64,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'To view map, kindly use the search box to check for infectious diseases.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // "Active Cases" header (left-aligned, black font, size 20)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Active Cases',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(height: 1, color: Colors.grey),
            // Disease Cases List
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    _buildDiseaseCard(
                      'Dengue',
                      _isUSMSearched ? _getCasesByDisease('Dengue').length : 0,
                      _getRadiusForDisease('Dengue'),
                      Colors.red,
                      Icons.bug_report,
                    ),
                    _buildDiseaseCard(
                      'Influenza A',
                      _isUSMSearched ? _getCasesByDisease('Influenza A').length : 0,
                      _getRadiusForDisease('Influenza A'),
                      Colors.orange,
                      Icons.air,
                    ),
                    _buildDiseaseCard(
                      'COVID-19',
                      _isUSMSearched ? _getCasesByDisease('COVID-19').length : 0,
                      _getRadiusForDisease('COVID-19'),
                      Colors.purple,
                      Icons.coronavirus,
                    ),
                    _buildDiseaseCard(
                      'Measles',
                      _isUSMSearched ? _getCasesByDisease('Measles').length : 0,
                      _getRadiusForDisease('Measles'),
                      Colors.green,
                      Icons.healing,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseCard(String disease, int caseCount, int radius, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    disease,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'within ${radius}m radius',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                caseCount.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show the report form (bottom sheet)
  void _showReportForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DiseaseReportForm(),
    );
  }
}

// A realistic interactive map view using CustomPainter
class CustomMapView extends StatelessWidget {
  final bool isUSMVisible;
  final List<DiseaseCase> diseaseCases;

  const CustomMapView({
    Key? key,
    required this.isUSMVisible,
    required this.diseaseCases,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          color: Colors.grey[200],
          child: CustomPaint(
            painter: MapPainter(
              isUSMVisible: isUSMVisible,
              diseaseCases: diseaseCases,
            ),
            size: Size(constraints.maxWidth, constraints.maxHeight),
          ),
        );
      },
    );
  }
}

// Custom painter that simulates a realistic map with gradient, roads, houses, and disease markers
class MapPainter extends CustomPainter {
  final bool isUSMVisible;
  final List<DiseaseCase> diseaseCases;

  MapPainter({
    required this.isUSMVisible,
    required this.diseaseCases,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background: subtle gradient to simulate land
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Gradient gradient = LinearGradient(
      colors: [Colors.green[100]!, Colors.green[50]!],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final Paint backgroundPaint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, backgroundPaint);

    // Draw realistic roads
    final Paint roadPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0;
    // Horizontal road
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      roadPaint,
    );
    // Vertical road
    canvas.drawLine(
      Offset(size.width * 0.5, 0),
      Offset(size.width * 0.5, size.height),
      roadPaint,
    );

    // Draw houses as small brown rectangles along roads
    final Paint housePaint = Paint()..color = Colors.brown;
    final List<Offset> housePositions = [
      Offset(size.width * 0.3, size.height * 0.5 - 30),
      Offset(size.width * 0.3, size.height * 0.5 + 30),
      Offset(size.width * 0.7, size.height * 0.5 - 20),
      Offset(size.width * 0.7, size.height * 0.5 + 20),
      Offset(size.width * 0.5 - 40, size.height * 0.3),
      Offset(size.width * 0.5 + 40, size.height * 0.7),
    ];
    for (final pos in housePositions) {
      canvas.drawRect(Rect.fromCenter(center: pos, width: 20, height: 20), housePaint);
    }
    
    if (isUSMVisible) {
      // Draw USM campus area (simulate with a circle)
      final campusCenter = Offset(size.width / 2, size.height / 2);
      final double campusRadius = size.width * 0.2;
      final Paint campusPaint = Paint()
        ..color = Colors.blue.withOpacity(0.15)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(campusCenter, campusRadius, campusPaint);

      final Paint borderPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(campusCenter, campusRadius, borderPaint);

      // Draw USM label at the center of campus
      final textStyle = TextStyle(
        color: Colors.blue,
        fontSize: campusRadius * 0.24,
        fontWeight: FontWeight.bold,
      );
      final textSpan = TextSpan(text: 'USM', style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(minWidth: 0, maxWidth: size.width);
      textPainter.paint(
        canvas,
        Offset(campusCenter.dx - textPainter.width / 2, campusCenter.dy - textPainter.height / 2),
      );
      
      // Draw disease markers on the USM campus as location icons.
      // Only draw markers if active cases exist.
      for (final diseaseCase in diseaseCases) {
        final markerX = campusCenter.dx + (diseaseCase.xOffset * campusRadius / 100);
        final markerY = campusCenter.dy + (diseaseCase.yOffset * campusRadius / 100);
        final markerSize = (campusRadius * 0.1) + (diseaseCase.severity * 0.5);
        
        // Render location icon using Material icon via TextPainter
        final locationIcon = String.fromCharCode(Icons.location_on.codePoint);
        final iconStyle = TextStyle(
          fontFamily: Icons.location_on.fontFamily,
          package: Icons.location_on.fontPackage,
          fontSize: markerSize,
          color: _getDiseaseColor(diseaseCase.disease),
        );
        final iconSpan = TextSpan(text: locationIcon, style: iconStyle);
        final iconPainter = TextPainter(
          text: iconSpan,
          textDirection: TextDirection.ltr,
        );
        iconPainter.layout();
        iconPainter.paint(
          canvas,
          Offset(markerX - iconPainter.width / 2, markerY - iconPainter.height / 2),
        );
      }
    }
  }

  Color _getDiseaseColor(String disease) {
    switch (disease) {
      case 'Dengue': return Colors.red;
      case 'Influenza A': return Colors.orange;
      case 'COVID-19': return Colors.purple;
      case 'Measles': return Colors.green;
      default: return Colors.blue;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DiseaseCase {
  final String id;
  final String disease;
  final int daysAgo;
  final int severity;
  final double xOffset;
  final double yOffset;
  final int caseCount;
  
  DiseaseCase({
    required this.id,
    required this.disease,
    required this.daysAgo,
    required this.severity,
    required this.xOffset,
    required this.yOffset,
    required this.caseCount,
  });
}
