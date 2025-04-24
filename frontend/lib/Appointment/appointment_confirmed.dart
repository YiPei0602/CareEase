import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'doctor_profile.dart';
import 'package:intl/intl.dart';

class AppointmentConfirmedPage extends StatelessWidget {
  final Doctor doctor;
  final DateTime appointmentDate;
  final DateTime appointmentTime;

  const AppointmentConfirmedPage({
    Key? key,
    required this.doctor,
    required this.appointmentDate,
    required this.appointmentTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Success Animation
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Lottie.network(
                          'https://assets10.lottiefiles.com/packages/lf20_rc5d0f61.json',
                          repeat: false,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Success Message
                      const Text(
                        'Appointment Confirmed!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Your appointment has been successfully scheduled with ${doctor.name}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Appointment Details Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow(
                              icon: Icons.calendar_today,
                              title: 'Date',
                              value: DateFormat('EEE, d MMM yyyy').format(appointmentDate),
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              icon: Icons.access_time,
                              title: 'Time',
                              value: DateFormat('HH:mm').format(appointmentTime),
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              icon: Icons.local_hospital,
                              title: 'Hospital',
                              value: '${doctor.state} Hospital',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(12),
                      child: const Text(
                        'Go to Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      onPressed: () {
                        // Add calendar integration logic here
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to calendar'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      color: CupertinoColors.activeBlue,
                      borderRadius: BorderRadius.circular(12),
                      child: const Text(
                        'Add to Calendar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 