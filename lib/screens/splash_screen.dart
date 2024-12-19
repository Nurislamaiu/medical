import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/app_routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2));
    FirebaseAuth.instance.authStateChanges().listen((User? currentUser) async {
      if (currentUser != null) {
        // Проверяем, существует ли пользователь в Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          Get.offNamed(AppRoutes.navBar); // Пользователь существует, идем на NavBar
        } else {
          // Если пользователя нет в Firestore, разлогиниваем
          await FirebaseAuth.instance.signOut();
          Get.offNamed(AppRoutes.onboarding); // Отправляем на Onboarding
        }
      } else {
        Get.offNamed(AppRoutes.onboarding); // Пользователь не авторизован
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                SizedBox(height: 30),
                Text(
                  'Добро пожаловать \nОжидайте, мы проверяем данные...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
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
}
