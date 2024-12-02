import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical/utils/color_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Получаем текущего авторизованного пользователя
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Главная', style: TextStyle(color: ScreenColor.white)),
          backgroundColor: ScreenColor.color1,
          centerTitle: true,
        ),
        body: Center(child: Text('Пользователь не найден, выполните вход.')),
      );
    }

    return Scaffold(
      backgroundColor: ScreenColor.background,
      appBar: AppBar(
        title: Text('Главная', style: TextStyle(color: ScreenColor.white)),
        backgroundColor: ScreenColor.color1,
        centerTitle: true,
        actions: [IconButton(onPressed: () async {
          await FirebaseAuth.instance.signOut();  // Выход из системы
          Navigator.pushReplacementNamed(context, '/login');  // Переход на экран входа
        }, icon: Icon(Icons.add))],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Ошибка загрузки данных'));
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text('Пользователь не найден в базе данных'));
              }

              // Получаем данные пользователя из Firestore
              var userData = snapshot.data!.data() as Map<String, dynamic>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Добро пожаловать, ${userData['name']}!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ScreenColor.color1,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildUserInfoCard(userData),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/user_info');
                    },
                    child: Text('Изменить данные'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ScreenColor.color1,
                      minimumSize: Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      shadowColor: ScreenColor.color4.withOpacity(0.4),
                      elevation: 5,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Виджет для отображения информации о пользователе
  Widget _buildUserInfoCard(Map<String, dynamic> userData) {
    return Card(
      color: ScreenColor.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfoRow('Имя:', userData['name']),
            _buildUserInfoRow('Возраст:', userData['age']),
            _buildUserInfoRow('Пол:', userData['gender']),
            _buildUserInfoRow('Адрес:', userData['address']),
            _buildUserInfoRow('Телефон:', userData['phone']),
          ],
        ),
      ),
    );
  }

  // Виджет для отображения строки с информацией
  Widget _buildUserInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ScreenColor.color1,
            ),
          ),
          Text(
            value ?? 'Не указан',
            style: TextStyle(
              fontSize: 16,
              color: ScreenColor.color2,
            ),
          ),
        ],
      ),
    );
  }
}
