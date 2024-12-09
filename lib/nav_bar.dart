import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medical/screens/home/home_screen.dart';
import 'package:medical/screens/patient/request_history_screen.dart';
import 'package:medical/utils/color_screen.dart';

class NavBarScreen extends StatefulWidget {
  @override
  _NavBarScreenState createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int _currentIndex = 0; // Индекс текущей вкладки

  // Список экранов для навигации
  final List<Widget> _screens = [
    HomeScreen(), // Ваш Home Screen
    RequestHistoryScreen(),
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
            icon: Icon(Iconsax.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.clock),
            label: 'Заявки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.notification),
            label: 'Уведомления',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.user),
            label: 'Профиль',
          ),
        ],
      ),
    );
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
