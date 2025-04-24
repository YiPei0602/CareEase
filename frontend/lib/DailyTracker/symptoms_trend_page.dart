import 'package:flutter/material.dart';
import 'add_symptom_data_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'services/symptom_data_service.dart';

class SymptomTrendPage extends StatefulWidget {
  final String symptom;

  const SymptomTrendPage({Key? key, required this.symptom}) : super(key: key);

  @override
  _SymptomTrendPageState createState() => _SymptomTrendPageState();
}

class _SymptomTrendPageState extends State<SymptomTrendPage> {
  final List<String> _timeRanges = ['D', 'W', 'M', '6M', 'Y'];
  int _selectedTimeRangeIndex = 1; // Default to Weekly view
  final SymptomDataService _dataService = SymptomDataService();
  List<SymptomRecord> _currentRecords = [];
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _updateDateRange();
    _dataService.recordsStream.listen((records) {
      setState(() {
        _updateRecords();
      });
    });
  }

  void _updateDateRange() {
    final now = DateTime.now();
    switch (_timeRanges[_selectedTimeRangeIndex]) {
      case 'D':
        _startDate = DateTime(now.year, now.month, now.day);
        _endDate = _startDate.add(const Duration(days: 1));
        break;
      case 'W':
        // Start from the most recent Monday
        _startDate = now.subtract(Duration(days: now.weekday - 1));
        _startDate = DateTime(_startDate.year, _startDate.month, _startDate.day);
        _endDate = _startDate.add(const Duration(days: 7));
        break;
      case 'M':
        _startDate = DateTime(now.year, now.month, 1);
        _endDate = DateTime(now.year, now.month + 1, 1);
        break;
      case '6M':
        _startDate = DateTime(now.year, now.month - 5, 1);
        _endDate = DateTime(now.year, now.month + 1, 1);
        break;
      case 'Y':
        _startDate = DateTime(now.year, 1, 1);
        _endDate = DateTime(now.year + 1, 1, 1);
        break;
    }
    _updateRecords();
  }

  void _updateRecords() {
    _currentRecords = _dataService.getRecordsForSymptom(
      widget.symptom,
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  List<FlSpot> _getChartSpots() {
    if (_currentRecords.isEmpty) return [];

    switch (_timeRanges[_selectedTimeRangeIndex]) {
      case 'D':
        return _getDaySpots();
      case 'W':
        return _getWeekSpots();
      case 'M':
        return _getMonthSpots();
      case '6M':
      case 'Y':
        return _getMonthlySpots();
      default:
        return [];
    }
  }

  List<FlSpot> _getWeekSpots() {
    final spots = <FlSpot>[];
    for (var i = 0; i < 7; i++) {
      final day = _startDate.add(Duration(days: i));
      final record = _currentRecords.firstWhere(
        (r) => r.dateTime.year == day.year && 
               r.dateTime.month == day.month && 
               r.dateTime.day == day.day,
        orElse: () => SymptomRecord(
          dateTime: day,
          symptom: widget.symptom,
          severityLevel: -1,
        ),
      );
      if (record.severityLevel >= 0) {
        spots.add(FlSpot(i.toDouble(), record.severityLevel.toDouble()));
      }
    }
    return spots;
  }

  List<FlSpot> _getDaySpots() {
    final spots = <FlSpot>[];
    for (var record in _currentRecords) {
      // Convert hour to nearest interval (0, 6, 12, 18)
      final hour = record.dateTime.hour;
      final interval = (hour / 6).floor() * 6;
      spots.add(FlSpot(interval / 6, record.severityLevel.toDouble()));
    }
    return spots;
  }

  List<FlSpot> _getMonthSpots() {
    final spots = <FlSpot>[];
    for (var record in _currentRecords) {
      // Convert day to nearest week (7, 14, 21, 28)
      final day = record.dateTime.day;
      final weekIndex = ((day - 1) / 7).floor();
      if (weekIndex < 4) { // Only include up to week 4 (day 28)
        spots.add(FlSpot(weekIndex.toDouble(), record.severityLevel.toDouble()));
      }
    }
    return spots;
  }

  List<FlSpot> _getMonthlySpots() {
    if (_timeRanges[_selectedTimeRangeIndex] == '6M') {
      // For 6M view, only show first 6 months
      return _currentRecords
          .where((record) => record.dateTime.month <= 6)
          .map((record) => FlSpot((record.dateTime.month - 1).toDouble(), 
                                record.severityLevel.toDouble()))
          .toList();
    } else {
      // For yearly view, show all months
      return _currentRecords
          .map((record) => FlSpot((record.dateTime.month - 1).toDouble(), 
                                record.severityLevel.toDouble()))
          .toList();
    }
  }

  String _getDateRangeText() {
    final dateFormat = DateFormat('d MMM yyyy');
    return '${dateFormat.format(_startDate)} - ${dateFormat.format(_endDate.subtract(const Duration(days: 1)))}';
  }

  List<String> _getXAxisLabels() {
    switch (_timeRanges[_selectedTimeRangeIndex]) {
      case 'D':
        // Show only 00, 06, 12, 18
        return ['00', '06', '12', '18'];
      case 'W':
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case 'M':
        // Show only 7, 14, 21, 28
        return ['7', '14', '21', '28'];
      case '6M':
        // Show first 6 months
        return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
      case 'Y':
        // Show short form for all months
        return ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.symptom,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddSymptomDataPage(symptom: widget.symptom),
                ),
              );
              setState(() {
                _updateRecords();
              });
            },
            child: const Text(
              'Add Data',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Time range selector
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _timeRanges.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final isSelected = index == _selectedTimeRangeIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTimeRangeIndex = index;
                      _updateDateRange();
                    });
                  },
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _timeRanges[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Chart
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    _getDateRangeText(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 1,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.shade200,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                final labels = _getXAxisLabels();
                                if (value >= 0 && value < labels.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      labels[value.toInt()],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                if (value >= 0 && value < 5) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      SymptomDataService.levelToSeverity(value.toInt()),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                              reservedSize: 100,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        minX: 0,
                        maxX: (_getXAxisLabels().length - 1).toDouble(),
                        minY: 0,
                        maxY: 4,
                        lineBarsData: [
                          LineChartBarData(
                            spots: _getChartSpots(),
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 6,
                                  color: Colors.white,
                                  strokeWidth: 3,
                                  strokeColor: Colors.blue,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.blue.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // About section
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About this Symptom',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getSymptomDescription(widget.symptom),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSymptomDescription(String symptom) {
    // Add descriptions for different symptoms
    switch (symptom.toLowerCase()) {
      case 'coughing':
        return 'A cough is a reflex the body uses to get rid of irritants, triggered by the stimulation of nerve endings in the throat or airways. Sometimes it\'s caused by food caught in the throat or inhaled particles. It can also occur when nerve endings are irritated by inflammation from an infection or disease.';
      default:
        return 'Track the severity and frequency of your symptoms to better understand your health patterns and share accurate information with your healthcare provider.';
    }
  }
}
