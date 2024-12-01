import 'package:flutter/material.dart';

class OnBoardingDotIndicator extends StatelessWidget {
  final bool isActive;

  const OnBoardingDotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      width: isActive ? 20 : 10,
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : LinearGradient(colors: [Colors.grey, Colors.grey]),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
