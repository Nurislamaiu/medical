import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:medical/screens/patient/request_edit_screen.dart';

import '../../utils/color_screen.dart';
import '../../utils/size_screen.dart';

class RequestHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Если пользователь не авторизован, можем вернуть экран входа
      return const Scaffold(
        body: Center(
          child: Text('Пожалуйста, авторизуйтесь'),
        ),
      );
    }

    final requestsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('requests');

    return Scaffold(
      backgroundColor: ScreenColor.white,
      body: Column(
          children: [
            Container(
              width: double.infinity,
              height: ScreenSize(context).height * 0.30,
              padding: EdgeInsets.all(20),
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
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ScreenColor.color6.withOpacity(0.5),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Ваши заявки на ближайшие дни',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ScreenColor.white,
                    ),
                  ),
                  Text(
                    'Не болейте :)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ScreenColor.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenSize(context).height * 0.025),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: requestsRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Lottie.asset(
                      'assets/lottie/loading.json',
                      width: 100,
                      height: 100,
                    ));
                  }

                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Ошибка при загрузке данных',
                            style: TextStyle(fontSize: 18, color: Colors.red)));
                  }

                  final requests = snapshot.data?.docs ?? [];

                  if (requests.isEmpty) {
                    print('Нет заявок для этого пользователя');
                    return const Center(
                        child: Text('Нет заявок',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)));
                  }

                  requests.forEach((request) {
                    print('Заявка: ${request.data()}');
                  });

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request =
                      requests[index].data() as Map<String, dynamic>;
                      final service = request['service'];
                      final date = request['date'];
                      final time = request['time'];
                      final status = request['status'];

                      // Цвет для статуса
                      Color statusColor;
                      String statusText;

                      switch (status) {
                        case 'Выполнено':
                          statusColor = Colors.green;
                          statusText = 'Выполнено';
                          break;
                        case 'Ожидает':
                          statusColor = Colors.orange;
                          statusText = 'Ожидает';
                          break;
                        case 'Отменено':
                          statusColor = Colors.red;
                          statusText = 'Отменено';
                          break;
                        default:
                          statusColor = Colors.grey;
                          statusText = 'Неизвестно';
                      }

                      return GestureDetector(
                        onTap: () {
                          // Логика для редактирования заявки
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditRequestScreen(requestId: requests[index].id),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                            gradient: const LinearGradient(
                              colors: [ScreenColor.background, Colors.white70],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Основной контент карточки
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                title: Text(
                                  'Заявка ${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Услуга: $service', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                      SizedBox(height: 6),
                                      Text('Дата: $date | Время: $time', style: const TextStyle(fontSize: 12, color: Colors.black45)),
                                    ],
                                  ),
                                ),
                              ),
                              // Статус в правом верхнем углу
                              Positioned(
                                right: 5,
                                top: 5,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    statusText,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ScreenColor.color6,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(context, '/patient/new-request');
        },
      ),
    );
  }
}
