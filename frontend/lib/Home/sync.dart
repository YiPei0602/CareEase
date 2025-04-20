import 'dart:async';
// import 'dart:math' as math;
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Connection states
enum ConnectionStep {
  idle, // Step 0: Initial screen
  searching, // Step 1: Searching for devices (dark background)
  deviceFound, // Step 2: Device list found (dark background)
  connecting, // Step 3: Connecting (dark background)
  connected, // Step 4: Connected (light background)
}

class SyncPage extends StatefulWidget {
  const SyncPage({super.key});

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage>
    with SingleTickerProviderStateMixin {
  ConnectionStep _step = ConnectionStep.idle;
  final bool _showFoundSheet = false;

  // Animation controller for the radar effect during searching
  late AnimationController _searchAnimController;
  late Animation<double> _searchAnimation;

  // List of mock nearby devices
  final List<Map<String, dynamic>> _nearbyDevices = [
    {
      'name': 'CareWatch X1',
      'id': '73:AB:12',
      'type': 'smartwatch',
      'battery': 85
    },
    {
      'name': "Lucas's Watch",
      'id': '4C:D3:87',
      'type': 'smartwatch',
      'battery': 62
    },
    {
      'name': 'Fitness Band Pro',
      'id': '9E:2F:18',
      'type': 'band',
      'battery': 74
    },
  ];

  // Selected device (if any)
  Map<String, dynamic>? _selectedDevice;

  // Timer for simulating device search
  Timer? _searchTimer;
  int _foundDevicesCount = 0;

  @override
  void initState() {
    super.initState();
    _searchAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _searchAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_searchAnimController);
  }

  @override
  void dispose() {
    _searchAnimController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  // Calculate progress bar value (0.0 to 1.0) based on the current step
  double get _progressValue {
    switch (_step) {
      case ConnectionStep.idle:
        return 0.0;
      case ConnectionStep.searching:
        return 0.25;
      case ConnectionStep.deviceFound:
        return 0.50;
      case ConnectionStep.connecting:
        return 0.75;
      case ConnectionStep.connected:
        return 1.0;
    }
  }

  // ---------- Step UIs ----------

  // Step 0: Idle Screen
  Widget _buildIdleContent() {
    return Container(
      color: Colors.grey[100], // Same as home background
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(flex: 1),
            const Text(
              "Connect your smartwatch",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              "Pair your device to track your health data in real time.",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF667085),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Image.asset(
              'assets/vhack_smartwatch2.jpg',
              height: 240,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to png if jpg fails
                return Image.asset(
                  'assets/vhack_smartwatch.png',
                  height: 240,
                  fit: BoxFit.contain,
                );
              },
            ),
            const Spacer(flex: 1),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _startSearching,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7DFF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Connect",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  // Step 1: Searching - show radar animation + message
  Widget _buildSearchingContent() {
    return Container(
      color: const Color(0xFF0A3649),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          // Progress bar at top
          Container(
            width: double.infinity,
            height: 4,
            margin: const EdgeInsets.only(top: 16),
            child: const LinearProgressIndicator(
              value: 0.5,
              backgroundColor: Color(0xFF1D4A5C),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
            ),
          ),
          const SizedBox(height: 60),
          const Text(
            "Searching for Devices...",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const Spacer(flex: 1),
          // Radar animation
          SizedBox(
            height: 250,
            width: 250,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _searchAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: List.generate(3, (index) {
                        final delay = index / 3;
                        final animValue =
                            (_searchAnimation.value + delay) % 1.0;
                        return Opacity(
                          opacity: 1.0 - animValue,
                          child: Container(
                            width: 200 * animValue,
                            height: 200 * animValue,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.lightBlueAccent.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
                // Center search icon
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Color(0xFF66E3E3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 1),
          Text(
            _foundDevicesCount > 0
                ? "$_foundDevicesCount devices found..."
                : "Detecting nearby smartwatches...",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(flex: 1),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  _searchTimer?.cancel();
                  setState(() => _step = ConnectionStep.idle);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // Step 2: Available Devices (Device Found)
  Widget _buildDeviceFoundContent() {
    return Container(
      color: const Color(0xFF0A3649),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress bar at top
          Container(
            width: double.infinity,
            height: 4,
            margin: const EdgeInsets.only(top: 16),
            child: const LinearProgressIndicator(
              value: 0.7,
              backgroundColor: Color(0xFF1D4A5C),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Available Devices",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white, // Title now white
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _nearbyDevices.length,
              itemBuilder: (context, index) {
                final device = _nearbyDevices[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: const Color(0xFF133F52),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFF1D4A5C), width: 1),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D4A5C),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        device['type'] == 'smartwatch'
                            ? Icons.watch_outlined
                            : Icons.fitness_center,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    title: Text(
                      device['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      "ID: ${device['id']} • Battery: ${device['battery']}%",
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => _selectDevice(device),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blue, // Blue button as requested
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size(80, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        "Connect",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  "Make sure your device is turned on and Bluetooth is enabled",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Text(
                  "Tap a device to connect",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Step 3: Connecting - remove the device icon; show only spinner
  Widget _buildConnectingContent() {
    return Container(
      color: const Color(0xFF0A3649),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          // Progress bar at top
          Container(
            width: double.infinity,
            height: 4,
            margin: const EdgeInsets.only(top: 16),
            child: const LinearProgressIndicator(
              value: 0.9,
              backgroundColor: Color(0xFF1D4A5C),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
            ),
          ),
          const SizedBox(height: 60),
          const Spacer(flex: 1),
          // Only the loading spinner now
          Container(
            width: 120,
            height: 120,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF133F52),
              borderRadius: BorderRadius.circular(60),
            ),
            child: AnimatedBuilder(
              animation: _searchAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _searchAnimController.value * 6.3,
                  child: CircularProgressIndicator(
                    value: null,
                    strokeWidth: 3,
                    color: Colors.lightBlueAccent.withOpacity(0.7),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          // Device name and connecting text
          Text(
            _selectedDevice?['name'] ?? "Device",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Connecting to your SmartWatch...",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const Spacer(flex: 2),
          // Cancel button
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _step = ConnectionStep.deviceFound);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.white24, width: 1),
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // Step 4: Connected - simplified screen with grey background and "Continue" button fixed at bottom
  Widget _buildConnectedContent() {
    return Container(
      color: Colors.grey[100],
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 80,
                      color: Color(0xFF12B76A),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Connected Successfully!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${_selectedDevice?['name'] ?? 'Your smartwatch'} is now paired with CareEase",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF667085),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // "Continue" button at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7DFF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build main content based on current step
  Widget _buildContent() {
    switch (_step) {
      case ConnectionStep.idle:
        return _buildIdleContent();
      case ConnectionStep.searching:
        return _buildSearchingContent();
      case ConnectionStep.deviceFound:
        return _buildDeviceFoundContent();
      case ConnectionStep.connecting:
        return _buildConnectingContent();
      case ConnectionStep.connected:
        return _buildConnectedContent();
    }
  }

  // Start searching for device
  void _startSearching() {
    setState(() {
      _step = ConnectionStep.searching;
      _foundDevicesCount = 0;
    });

    // Simulate finding devices gradually
    _searchTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (_foundDevicesCount < _nearbyDevices.length) {
        setState(() {
          _foundDevicesCount++;
        });
      } else {
        timer.cancel();
        if (mounted) {
          setState(() => _step = ConnectionStep.deviceFound);
        }
      }
    });
  }

  // Function to select a device and start connecting
  void _selectDevice(Map<String, dynamic> device) {
    setState(() {
      _selectedDevice = device;
      _step = ConnectionStep.connecting;
    });

    // Simulate connection process
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _step = ConnectionStep.connected);
    });
  }

  // Helper method for AppBar title color & text
  String _getAppBarTitle() {
    switch (_step) {
      case ConnectionStep.idle:
        return "Connect Device";
      case ConnectionStep.searching:
        return "Searching";
      case ConnectionStep.deviceFound:
        return "Available Devices";
      case ConnectionStep.connecting:
        return "Connecting";
      case ConnectionStep.connected:
        return "Connected";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            // For Searching, Available Devices & Connecting, use white color
            color: (_step == ConnectionStep.searching ||
                    _step == ConnectionStep.deviceFound ||
                    _step == ConnectionStep.connecting)
                ? Colors.white
                : const Color(0xFF2D3142),
          ),
        ),
        centerTitle: true,
        backgroundColor: (_step == ConnectionStep.searching ||
                _step == ConnectionStep.deviceFound ||
                _step == ConnectionStep.connecting)
            ? const Color(0xFF0A3649)
            : Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: (_step == ConnectionStep.searching ||
                    _step == ConnectionStep.deviceFound ||
                    _step == ConnectionStep.connecting)
                ? Colors.white
                : const Color(0xFF2D3142),
            size: 20,
          ),
          onPressed: () {
            if (_step == ConnectionStep.idle ||
                _step == ConnectionStep.connected) {
              Navigator.of(context).pop();
            } else if (_step == ConnectionStep.deviceFound) {
              setState(() => _step = ConnectionStep.searching);
            } else if (_step == ConnectionStep.connecting) {
              setState(() => _step = ConnectionStep.deviceFound);
            } else {
              _searchTimer?.cancel();
              setState(() => _step = ConnectionStep.idle);
            }
          },
        ),
        actions: [
          if (_step == ConnectionStep.searching)
            IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.white),
              onPressed: () {
                // Show help dialog if needed
              },
            ),
        ],
      ),
      backgroundColor: (_step == ConnectionStep.searching ||
              _step == ConnectionStep.deviceFound ||
              _step == ConnectionStep.connecting)
          ? const Color(0xFF0A3649)
          : Colors.grey[100],
      body: SafeArea(child: _buildContent()),
    );
  }
}
