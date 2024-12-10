import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medical/110n/app_localizations.dart';
import 'package:medical/utils/color_screen.dart';
import 'package:medical/widgets/custom_text_field.dart';
import 'package:get/get.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _gender = 'Не выбран'; // Пол
  late String userId;

  // Маска для телефона +7 ### ### ## ##
  final phoneFormatter = MaskTextInputFormatter(
    mask: '+7 ### ### ## ##',
    filter: { "#": RegExp(r'[0-9]') },
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      userId = user.uid;
    } else {
      Get.snackbar(
        AppLocalizations.of(context).translate('error'),
        AppLocalizations.of(context).translate('user_not_authenticated'),
      );
      Navigator.pushReplacementNamed(context, '/register');
    }
  }


  /// Save user info to firebase
  void _saveUserInfo() async {
    // Получаем данные из текстовых полей
    String name = _nameController.text;
    String age = _ageController.text;
    String address = _addressController.text;
    String phone = _phoneController.text;
    String gender = _gender;

    if (name.isEmpty || age.isEmpty || address.isEmpty || phone.isEmpty || gender == 'Не выбран') {
      Get.snackbar(
        AppLocalizations.of(context).translate('error'),
        AppLocalizations.of(context).translate('all_fields_required'),
      );
      return; // Если хотя бы одно поле пустое, выходим из метода
    }

    // Валидация телефона
    if (phone.isEmpty || phone.length != 16 || !phone.startsWith('+7')) {
      Get.snackbar(
        AppLocalizations.of(context).translate('error'),
        AppLocalizations.of(context).translate('invalid_phone_number'),
      );
      return;
    }

    try {
      // Получаем текущего пользователя
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Обновляем данные пользователя в Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'age': age,
          'address': address,
          'phone': phone,
          'gender': gender,
          'email': user.email ?? 'No Email', // Добавляем email
        });

        // Переход на главный экран
        Navigator.pushReplacementNamed(context, '/nav-bar');
      } else {
        Get.snackbar(
          AppLocalizations.of(context).translate('error'),
          AppLocalizations.of(context).translate('user_not_authenticated'),
        );
      }
    } catch (e) {
      Get.snackbar(
        AppLocalizations.of(context).translate('error'),
        AppLocalizations.of(context).translate('error_info_screen'),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColor.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).translate('enter_data_title'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ScreenColor.color1,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate('enter_data_sub_title'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ScreenColor.color2,
                    ),
                  ),
                  SizedBox(height: 40),

                  // Форма ввода данных
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _nameController,
                          label: AppLocalizations.of(context).translate('name'),
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate('please_enter_name');
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: _ageController,
                          label: AppLocalizations.of(context).translate('age'),
                          icon: Icons.calendar_today,
                          type: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate('please_enter_age');
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: _addressController,
                          label:
                          AppLocalizations.of(context).translate('address'),
                          icon: Icons.location_on,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate('please_enter_address');
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: _phoneController,
                          label:
                          AppLocalizations.of(context).translate('phone'),
                          icon: Icons.phone,
                          type: TextInputType.phone,
                          inputFormatters: [phoneFormatter], // Маска ввода
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate('please_enter_phone');
                            } else if (value.length != 16 || !value.startsWith('+7')) {
                              return AppLocalizations.of(context)
                                  .translate('invalid_phone_number');
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        // Выбор пола
                        _buildGenderSelection(),
                        SizedBox(height: 40),

                        // Кнопка "Далее"
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
            items: <String>[
              'Не выбран',
              AppLocalizations.of(context).translate('men'),
              AppLocalizations.of(context).translate('women')
            ].map<DropdownMenuItem<String>>((String value) {
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

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _saveUserInfo();
        }
      },
      child: Text(AppLocalizations.of(context).translate('next'),
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 55),
        backgroundColor: ScreenColor.color6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadowColor: ScreenColor.color4.withOpacity(0.4),
        elevation: 5,
      ),
    );
  }
}