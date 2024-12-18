import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medical/screens/home/home_screen.dart';
import 'package:medical/screens/notification/notification_screen.dart';
import 'package:medical/screens/patient/request_history_screen.dart';
import 'package:medical/screens/profile/user_profile_screen.dart';
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
    NotificationScreen(),
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

class GeoToAddressExample extends StatefulWidget {
  @override
  _GeoToAddressExampleState createState() => _GeoToAddressExampleState();
}

class _GeoToAddressExampleState extends State<GeoToAddressExample> {
  String _location = 'Координаты не определены';
  String _address = 'Адрес не определен';

  // Получение текущей геолокации
  Future<void> _getLocationAndAddress() async {
    try {
      // Получаем текущие координаты
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _location =
        'Широта: ${position.latitude}, Долгота: ${position.longitude}';
      });

      // Преобразуем координаты в адрес
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _address =
          '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
        });
      } else {
        setState(() {
          _address = 'Адрес не найден';
        });
      }
    } catch (e) {
      setState(() {
        _address = 'Ошибка при определении адреса: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Координаты в адрес'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Координаты: $_location'),
            SizedBox(height: 10),
            Text('Адрес: $_address'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getLocationAndAddress,
              child: Text('Определить адрес'),
            ),
          ],
        ),
      ),
    );
  }
}


