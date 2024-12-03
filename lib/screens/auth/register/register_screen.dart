import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart'; // Import Lottie
import 'package:medical/utils/color_screen.dart';
import 'package:medical/110n/app_localizations.dart';

import '../../../utils/size_screen.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _register() async {
    try {
      setState(() {
        _isLoading = true;
      });

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        Navigator.pushReplacementNamed(
          context,
          '/user-info',
          arguments: {
            'userId': user.uid,
          },
        );
      }
    } catch (e) {
      // Обработка ошибок
      Get.snackbar('Ошибка', 'Не удалось зарегистрировать пользователя');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColor.white,
      appBar: AppBar(
        backgroundColor: ScreenColor.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/logo.png',
                      height: ScreenSize(context).width * 0.4),
                  SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context).translate('register'),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: ScreenColor.color2,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate('register_description'),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 16,
                      color: ScreenColor.color2,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: _emailController,
                    label: AppLocalizations.of(context).translate('email'),
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _passwordController,
                    label: AppLocalizations.of(context).translate('password'),
                    icon: Icons.lock,
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: AppLocalizations.of(context).translate('register'),
                    onPressed: _register,
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Center(
                child: Lottie.asset(
                  'assets/lottie/loading.json',
                  // Add the path to your Lottie file
                  width: 100,
                  height: 100,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
