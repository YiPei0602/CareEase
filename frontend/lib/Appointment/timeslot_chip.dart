import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeslotChip extends StatelessWidget {
  const TimeslotChip({
    Key? key,
    required this.time,
    required this.onTap,
  }) : super(key: key);

  final DateTime time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = DateFormat('EEE d MMM • HH:mm').format(time);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: ActionChip(
        label: Text(label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        onPressed: onTap,
      ),
    );
  }
}
