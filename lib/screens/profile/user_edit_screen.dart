import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:medical/nav_bar.dart';

import '../../utils/color_screen.dart';
import '../../utils/size_screen.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? _gender;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _gender = null; // Or pre-fill with 'male', 'female', or 'other'
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _nameController.text = userData['name'] ?? '';
        _emailController.text = user.email ?? '';
        _addressController.text = userData['address'] ?? '';
        _ageController.text = userData['age']?.toString() ?? '';
        _phoneController.text = userData[''] ?? '';
        _gender = userData['gender'];
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'name': _nameController.text,
            'phone': _phoneController.text,
            'address': _addressController.text,
            'age': int.tryParse(_ageController.text),
            'gender': _gender,
          });

          if (_emailController.text != user.email) {
            await user.updateEmail(_emailController.text);
          }

          Get.snackbar('Успешно','Профиль обновлен');

          Get.offAll(NavBarScreen());
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    }
  }

  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+7 ### ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: ScreenSize(context).height * 0.30,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ScreenColor.color6,
                  ScreenColor.color6.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: ScreenColor.color6.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Редактируйте \nпрофиль',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ScreenColor.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
                const Text(
                  'Измените ваши данные и\nсохраните изменения.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ScreenColor.white,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Имя',
                          labelStyle: TextStyle(color: ScreenColor.color6,),
                          prefixIcon: Icon(Iconsax.user, color: ScreenColor.color6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: ScreenColor.color2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: ScreenColor.color2, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите имя';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Почта',
                          labelStyle: TextStyle(color: ScreenColor.color6,),
                          prefixIcon: Icon(Icons.email_outlined, color: ScreenColor.color6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: ScreenColor.color2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: ScreenColor.color2, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Введите корректный email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Адрес',
                          labelStyle: TextStyle(color: ScreenColor.color6,),
                          prefixIcon: Icon(Iconsax.location, color: ScreenColor.color6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: ScreenColor.color2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: ScreenColor.color2, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          labelText: 'Возраст',
                          labelStyle: TextStyle(color: ScreenColor.color6,),
                          prefixIcon: Icon(Iconsax.calendar_1, color: ScreenColor.color6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: ScreenColor.color2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: ScreenColor.color2, width: 2),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите возраст';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Возраст должен быть числом';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [_phoneMaskFormatter],
                        decoration: InputDecoration(
                          labelText: 'Номер телефона',
                          hintText: '+7 XXX XXX XX XX',
                          hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                          labelStyle: const TextStyle(color: ScreenColor.color6,),
                          prefixIcon: const Icon(Iconsax.user, color: ScreenColor.color6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: ScreenColor.color2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: ScreenColor.color2, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите номер телефона';
                          }
                          if (!_phoneMaskFormatter.isFill()) {
                            return 'Введите полный номер';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        borderRadius: BorderRadius.circular(15),
                        dropdownColor: Colors.white,
                        value: _gender, // This must match one and only one DropdownMenuItem's value
                        decoration: InputDecoration(
                          labelText: 'Пол',
                          labelStyle: TextStyle(color: ScreenColor.color6,),
                          prefixIcon: Icon(Iconsax.people, color: ScreenColor.color6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: ScreenColor.color2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: ScreenColor.color2, width: 2),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Мужской', // Unique value
                            child: Text('Мужской'),
                          ),
                          DropdownMenuItem(
                            value: 'Женский', // Unique value
                            child: Text('Женский'),
                          ),
                          DropdownMenuItem(
                            value: 'Другой', // Unique value
                            child: Text('Другой'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _gender = value; // Update state with the selected value
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Выберите пол';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _updateProfile,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: ScreenColor.color6,
                          ),
                          child: const Text('Сохранить', style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
