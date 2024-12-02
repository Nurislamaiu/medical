import 'package:flutter/material.dart';

import '../../../utils/color_screen.dart';

class NextButton extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onNext;
  final String buttonText;

  const NextButton({required this.isLastPage, required this.onNext, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: InkWell(
        onTap: onNext,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: ScreenColor.color2,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            alignment: Alignment.center,
            height: 50,
            width: double.infinity,
            child: Text(
                buttonText,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ScreenColor.white)
            ),
          ),
        ),
      ),
    );
  }
}
