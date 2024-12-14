import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> fetchAndNotify() async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final userUid = user.uid;

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

    try {
      final bookingDate = DateFormat('dd.MM.yyyy').parse(date);
      final bookingTime = DateFormat('HH:mm').parse(time);
      final bookingDateTime = DateTime(
        bookingDate.year,
        bookingDate.month,
        bookingDate.day,
        bookingTime.hour,
        bookingTime.minute,
      );

      final now = DateTime.now();
      final difference = bookingDateTime.difference(now).inMinutes;

      if (difference == 60) {
        final title = 'Напоминание о записи';
        final body = 'У вас запись на услугу "$service" сегодня в $time.';

        await _saveNotificationLocally(title, body);
        log('Уведомление сохранено локально: $title, $body');
        _sendNotification(title, body);
      }
    } catch (e) {
      log('Ошибка при обработке записи: $e');
    }
  }
}

Future<void> _saveNotificationLocally(String title, String body) async {
  final prefs = await SharedPreferences.getInstance();
  final notificationsJson = prefs.getString('notifications');
  List<Map<String, dynamic>> currentNotifications = [];

  if (notificationsJson != null) {
    currentNotifications =
    List<Map<String, dynamic>>.from(jsonDecode(notificationsJson));
  }

  final newNotification = {
    'id': DateTime.now().toIso8601String(),
    'title': title,
    'body': body,
    'read': false,
    'timestamp': DateTime.now().toIso8601String()
  };

  currentNotifications.add(newNotification);
  await prefs.setString('notifications', jsonEncode(currentNotifications));
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
    body, // Текст уведомления
    platformChannelSpecifics,
  );
}
