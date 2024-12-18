import 'package:flutter/material.dart';
import 'package:medical/utils/color_screen.dart';

class AdvantageTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const AdvantageTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: ScreenColor.color6),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: ScreenColor.color2),
            ),
          ),
        ],
      ),
    );
  }
}
