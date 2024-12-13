import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:medical/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../utils/color_screen.dart';
import '../../utils/size_screen.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  Set<int> readNotifications = {};
  Set<String> processedMessageIds = {};
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _initializeFirebase();
    _handleInitialMessage();
    _initializeLocalNotifications();
    Timer.periodic(Duration(minutes: 1), (Timer t) => _fetchAndNotify());
  }

  void _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _sendNotification(String title, String body) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    const AndroidNotificationDetails(
      'service_notifications', // Уникальный ID канала
      'Уведомления о записи',
      importance: Importance.high,
      priority: Priority.high,
    );
    NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // ID уведомления
      title, // Заголовок уведомления
      body,  // Текст уведомления
      platformChannelSpecifics,
    );
  }

  Future<void> _fetchAndNotify() async {
    // Получение текущего пользователя
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userUid = user.uid;

    // Чтение данных из Firestore
    final userRequests = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('requests')
        .get();
    log('requests');

    for (var request in userRequests.docs) {
      final data = request.data();
      final service = data['service'] ?? 'Услуга';
      final date = data['date'] ?? ''; // Формат "dd.MM.yyyy"
      final time = data['time'] ?? ''; // Формат "HH:mm"

      if (date.isEmpty || time.isEmpty) continue;

      // Парсинг даты и времени записи
      try {
        final bookingDate = DateFormat('dd.MM.yyyy').parse(date); // Преобразуем дату
        final bookingTime = DateFormat('HH:mm').parse(time); // Преобразуем время

        // Комбинируем дату и время
        final bookingDateTime = DateTime(
          bookingDate.year,
          bookingDate.month,
          bookingDate.day,
          bookingTime.hour,
          bookingTime.minute,
        );

        final now = DateTime.now();

        // Проверяем, осталось ли ровно 1 час до записи
        final difference = bookingDateTime.difference(now).inMinutes;
        if (difference == 60) {
          final title = 'Напоминание о записи';
          final body = 'У вас запись на услугу "$service" сегодня в $time.';

          // Отправка уведомления
          log('Запись на $title, $body');
          await _sendNotification(title, body);
        }
      } catch (e) {
        print('Ошибка при обработке записи: $e');
      }
    }
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request notification permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // Подписка на топик
      await messaging.subscribeToTopic('global');
      print('Подписано на топик global');

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _saveNotificationIfNew(message);
      });

      // Handle background and terminated messages
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _saveNotificationIfNew(message);
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> _handleInitialMessage() async {
    // Handle message when the app is opened from a terminated state
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _saveNotificationIfNew(initialMessage);
    }
  }

  void _saveNotificationIfNew(RemoteMessage message) async {
    final messageId = message.messageId;

    if (messageId != null && !processedMessageIds.contains(messageId)) {
      processedMessageIds.add(messageId);

      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getString('notifications');
      List<Map<String, dynamic>> currentNotifications = [];

      if (notificationsJson != null) {
        currentNotifications =
            List<Map<String, dynamic>>.from(jsonDecode(notificationsJson));
      }

      // Проверяем, есть ли уведомление с таким же messageId
      if (!currentNotifications.any((n) => n['id'] == messageId)) {
        currentNotifications.add({
          'id': messageId, // Уникальный идентификатор уведомления
          'title': message.notification?.title ??
              message.data['title'] ??
              'Без заголовка',
          'body': message.notification?.body ??
              message.data['body'] ??
              'Без содержания',
          'read': false,
        });

        await prefs.setString(
            'notifications', jsonEncode(currentNotifications));

        if (mounted) {
          setState(() {
            notifications = currentNotifications;
          });
        }
      }
    }
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getString('notifications');
    if (notificationsJson != null) {
      setState(() {
        notifications =
            List<Map<String, dynamic>>.from(jsonDecode(notificationsJson));
      });
      // Обновляем список прочитанных уведомлений
      for (var i = 0; i < notifications.length; i++) {
        if (notifications[i]['read'] == true) {
          readNotifications.add(i);
        }
      }
    }
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = jsonEncode(notifications);
    await prefs.setString('notifications', notificationsJson);
  }

  Future<void> _clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications');
    setState(() {
      notifications.clear();
      readNotifications.clear();
      processedMessageIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Уведомление',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ScreenColor.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Iconsax.trash),
                      onPressed: () {
                        _clearNotifications();
                      },
                    ),
                  ],
                ),
                const Text(
                  'Входящие уведомлений',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ScreenColor.white,
                  ),
                ),
              ],
            ),
          ),
          notifications.isEmpty
              ? Expanded(child: Center(child: Text('Уведомлений нет')))
              : Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      final isRead = readNotifications.contains(index);
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            colors: [ScreenColor.background, Colors.white70],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            splashColor: Colors.transparent,
                            title: Text(notification['title']!),
                            subtitle: Text(notification['body']!),
                            trailing: isRead
                                ? null
                                : const Icon(
                                    Icons.circle,
                                    color: ScreenColor.color6,
                                    size: 12.0,
                                  ),
                            onTap: () {
                              setState(() {
                                readNotifications.add(index);
                                notifications[index]['read'] =
                                    true; // Обновляем статус "прочитано"
                              });
                              _saveNotifications();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
