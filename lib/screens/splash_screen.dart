import 'package:flutter/material.dart';
import '../utils/size_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize(context); // Создаем экземпляр утилиты

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/onboarding');
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          height: screenSize.percentHeight(25), // 15% от высоты экрана
        ),
      ),
    );
  }
}
