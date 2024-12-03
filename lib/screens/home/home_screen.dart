import 'package:flutter/material.dart';
import 'package:medical/110n/app_localizations.dart';
import 'package:medical/screens/home/widgets/home_action_button.dart';
import 'package:medical/screens/home/widgets/home_advantage_tile.dart';
import 'package:medical/utils/color_screen.dart';
import 'package:medical/utils/size_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Индекс текущей вкладки

  // Список экранов для навигации
  final List<Widget> _screens = [
    HomeContent(), // Ваш Home Screen
    ServicesScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Отображение текущего экрана
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Обновляем индекс выбранной вкладки
          });
        },
        backgroundColor: ScreenColor.white,
        selectedItemColor: ScreenColor.color6,
        unselectedItemColor: ScreenColor.color2,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_outlined),
            label: 'Заявки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Уведомления',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}

// Содержимое вкладки Home
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ScreenColor.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Баннер
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ScreenColor.color6,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ScreenColor.color6.withOpacity(0.5),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('your_health'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ScreenColor.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ScreenColor.white,
                        foregroundColor: ScreenColor.color6,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // Действие для кнопки
                      },
                      child: Text(AppLocalizations.of(context)
                          .translate('submit_application')),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenSize(context).height * 0.05),
              // Кнопки быстрого действия
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ActionButton(
                      icon: Icons.medical_services,
                      label: AppLocalizations.of(context).translate('services'),
                      color: ScreenColor.color6,
                      onTap: () {
                        Navigator.pushNamed(context, '/service');
                      },
                    ),
                    ActionButton(
                      icon: Icons.chat,
                      label: AppLocalizations.of(context)
                          .translate('consultation'),
                      color: ScreenColor.color6,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              SizedBox(height: ScreenSize(context).height * 0.05),
              // Преимущества сервиса
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('why_choose_us'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ScreenColor.color1,
                      ),
                    ),
                    SizedBox(height: 10),
                    AdvantageTile(
                      icon: Icons.verified,
                      text: AppLocalizations.of(context)
                          .translate('qualified_specialists'),
                    ),
                    AdvantageTile(
                      icon: Icons.shield,
                      text: AppLocalizations.of(context)
                          .translate('sterility_and_safety'),
                    ),
                    AdvantageTile(
                      icon: Icons.access_time,
                      text: AppLocalizations.of(context)
                          .translate('availability'),
                    ),
                    AdvantageTile(
                      icon: Icons.delivery_dining,
                      text: AppLocalizations.of(context)
                          .translate('fast_delivery'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Заглушка для экрана "Услуги"
class ServicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Услуги', style: TextStyle(fontSize: 24)));
  }
}

// Заглушка для экрана "Уведомления"
class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Уведомления', style: TextStyle(fontSize: 24)));
  }
}

// Заглушка для экрана "Профиль"
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Профиль', style: TextStyle(fontSize: 24)));
  }
}
