import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/color_screen.dart';
import '../../utils/size_screen.dart';

Future<void> signOutUser() async {
  try {
    await FirebaseAuth.instance.signOut();
    print('Пользователь вышел из системы');
  } catch (e) {
    print('Ошибка при выходе: $e');
  }
}

class UserSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  ScreenColor.color6.withOpacity(0.2)
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
                      'Настройка',
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
                        icon: const Icon(Icons.close, color: Colors.white))
                  ],
                ),
                const Text(
                  'Вы можете \nнастроить параметры.',
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
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                _buildCard(
                  context,
                  icon: Iconsax.edit,
                  title: "Редактирование профиля",
                  onTap: () {
                    // Логика для открытия страницы редактирования профиля
                    Navigator.pushNamed(context, '/profile-edit');
                  },
                ),
                _buildCard(
                  context,
                  icon: Iconsax.people,
                  title: "Пользовательское соглашение",
                  onTap: () {
                    // Логика для открытия страницы пользовательского соглашения
                  },
                ),
                _buildCard(
                  context,
                  icon: Iconsax.shield,
                  title: "Политика конфиденциальности",
                  onTap: () {
                    // Логика для открытия страницы политики конфиденциальности
                  },
                ),
                _buildCard(
                  context,
                  icon: Iconsax.share,
                  title: "Мы в социальных сетях",
                  onTap: () {
                    // Логика для открытия страницы социальных сетей
                  },
                ),
                _buildCard(
                  context,
                  icon: Iconsax.info_circle,
                  title: "О команде",
                  onTap: () {
                    // Логика для открытия страницы "О команде"
                  },
                ),
                _buildCard(
                  context,
                  icon: Icons.exit_to_app,
                  title: "Выйти",
                  onTap: () async {
                    // Логика для открытия страницы "О команде"
                    await signOutUser();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [ScreenColor.background, Colors.white70],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: ScreenColor.color6,
                child: Icon(icon, color: Colors.white,),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
