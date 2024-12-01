import 'package:flutter/material.dart';

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
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple], // Цвета градиента
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30), // Скруглённые углы
          ),
          child: Container(
            alignment: Alignment.center,
            height: 50,
            width: double.infinity,
            child: Text(
                buttonText,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
          ),
        ),
      ),
    );
  }
}
