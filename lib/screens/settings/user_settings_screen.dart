import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

import '../../main.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: [
                _buildCard(
                  context,
                  icon: Icons.work_outline,
                  colorAvatar: Colors.white,
                  colorIcon: const Color(0xFFFFD700),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  title: "Хочу работать на эту компанию",
                  onTap: () async {},
                ),
                _buildCard(
                  context,
                  icon: Iconsax.edit,
                  gradient: const LinearGradient(
                    colors: [ScreenColor.background, Colors.white70],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  title: "Редактирование профиля",
                  onTap: () {
                    // Логика для открытия страницы редактирования профиля
                    Navigator.pushNamed(context, '/profile-edit');
                  },
                ),
                _buildCard(
                  context,
                  icon: Icons.language,
                  gradient: const LinearGradient(
                    colors: [ScreenColor.background, Colors.white70],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  title: "Язык",
                  onTap: () {
                    _showLanguageBottomSheet(context);
                  },
                ),
                _buildCard(
                  context,
                  icon: Iconsax.people,
                  gradient: const LinearGradient(
                    colors: [ScreenColor.background, Colors.white70],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  title: "Пользовательское соглашение",
                  onTap: () {
                    // Логика для открытия страницы пользовательского соглашения
                    Navigator.pushNamed(context, '/agreement');
                  },
                ),
                _buildCard(
                  context,
                  icon: Iconsax.shield,
                  gradient: const LinearGradient(
                    colors: [ScreenColor.background, Colors.white70],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  title: "Политика конфиденциальности",
                  onTap: () {
                    // Логика для открытия страницы политики конфиденциальности
                    Navigator.pushNamed(context, '/privacy-policy');
                  },
                ),
                _buildCard(
                  context,
                  icon: Iconsax.share,
                  gradient: const LinearGradient(
                    colors: [ScreenColor.background, Colors.white70],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  title: "Мы в социальных сетях",
                  onTap: () {
                    // Логика для открытия страницы социальных сетей
                    Navigator.pushNamed(context, '/we-social-media');
                  },
                ),
                _buildCard(
                  context,
                  icon: Iconsax.info_circle,
                  gradient: const LinearGradient(
                    colors: [ScreenColor.background, Colors.white70],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  title: "О команде",
                  onTap: () {
                    // Логика для открытия страницы "О команде"
                    Navigator.pushNamed(context, '/team');
                  },
                ),
                _buildCard(
                  context,
                  icon: Icons.exit_to_app,
                  gradient: const LinearGradient(
                    colors: [ScreenColor.background, Colors.white70],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
      Color? colorAvatar = ScreenColor.color6,
      Color? colorIcon = Colors.white,
      required Gradient? gradient,
      required String title,
      required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: gradient,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colorAvatar,
                child: Icon(
                  icon,
                  color: colorIcon,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final List<Map<String, dynamic>> languages = [
      {'locale': Locale('ru'), 'title': 'Русский'},
      {'locale': Locale('en'), 'title': 'English'},
      {'locale': Locale('kk'), 'title': 'Қазақша'},
    ];

    Locale currentLocale =
        Localizations.localeOf(context); // Получить текущий язык

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          height: ScreenSize(context).height * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Выберите язык",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: languages.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  itemBuilder: (context, index) {
                    final language = languages[index];
                    final isSelected = language['locale'] == currentLocale;

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [
                                  ScreenColor.background,
                                  Colors.white70
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : const LinearGradient(
                                colors: [ScreenColor.white, Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.language,
                            color:
                                isSelected ? ScreenColor.color6 : Colors.black),
                        title: Text(
                          language['title'],
                          style: TextStyle(
                            color:
                                isSelected ? ScreenColor.color6 : Colors.black,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context); // Закрыть BottomSheet
                          _changeLanguage(context, language['locale']);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _changeLanguage(BuildContext context, Locale locale) {
    MyApp.setLocale(context, locale);
    Get.snackbar('Успешно','Язык изменён на ${locale.languageCode.toUpperCase()}');
  }
}
