import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:lottie/lottie.dart';
import 'package:medical/nav_bar.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _gender = 'Не выбран';
  bool _isLoading = false;

  final phoneFormatter = MaskTextInputFormatter(
    mask: '+7 ### ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  void _registerAndSaveUserInfo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Register user
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Save user info to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': _nameController.text,
          'age': _ageController.text,
          'address': _addressController.text,
          'phone': _phoneController.text,
          'gender': _gender,
          'email': _emailController.text,
        });

        Get.snackbar(
          AppLocalizations.of(context).translate('success'),
          AppLocalizations.of(context).translate('user_created_successfully'),
        );

        // Navigate to main screen
        // Replace with your desired screen
        Get.offAll(() => NavBarScreen());
      } catch (e) {
        Get.snackbar(
          AppLocalizations.of(context).translate('error'),
          AppLocalizations.of(context).translate('error_creating_user'),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColor.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/logo.png',
                              height: ScreenSize(context).width * 0.4),
                          SizedBox(height: 20),
                          Text(
                            AppLocalizations.of(context).translate('register'),
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
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          CustomTextField(
                            controller: _emailController,
                            label:
                                AppLocalizations.of(context).translate('email'),
                            icon: Icons.email,
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            controller: _passwordController,
                            label: AppLocalizations.of(context)
                                .translate('password'),
                            icon: Icons.lock,
                            obscureText: true,
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            controller: _nameController,
                            label:
                                AppLocalizations.of(context).translate('name'),
                            icon: Icons.person,
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            controller: _ageController,
                            label:
                                AppLocalizations.of(context).translate('age'),
                            icon: Icons.calendar_today,
                            type: TextInputType.number,
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            controller: _addressController,
                            label: AppLocalizations.of(context)
                                .translate('address'),
                            icon: Icons.location_on,
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            controller: _phoneController,
                            label:
                                AppLocalizations.of(context).translate('phone'),
                            icon: Icons.phone,
                            inputFormatters: [phoneFormatter],
                          ),
                          SizedBox(height: 20),
                          _buildGenderSelection(),
                        ],
                      ),
                      SizedBox(height: 40),
                      CustomButton(
                        text:
                            AppLocalizations.of(context).translate('register'),
                        onPressed: _registerAndSaveUserInfo,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close))),
            if (_isLoading)
              Positioned.fill(
                child: Center(
                  child: Lottie.asset('assets/lottie/loading.json',
                      width: 100, height: 100),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ScreenColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: ScreenColor.color4.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.accessibility, color: ScreenColor.color6),
          const SizedBox(width: 10),
          Text(AppLocalizations.of(context).translate('paul'),
              style: TextStyle(color: ScreenColor.color2)),
          const SizedBox(width: 10),
          DropdownButton<String>(
            value: _gender,
            borderRadius: BorderRadius.circular(10),
            dropdownColor: Colors.white,
            onChanged: (String? newValue) {
              setState(() {
                _gender = newValue!;
              });
            },
            items: <String>['Не выбран', 'Мужчина', 'Женщина']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                    style: const TextStyle(color: ScreenColor.color2)),
              );
            }).toList(),
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: ScreenColor.color2),
          ),
        ],
      ),
    );
  }
}
