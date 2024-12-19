import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '110n/app_localizations.dart';
import 'app/app_routes.dart';
import 'firebase_service.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  List<Map<String, dynamic>> notifications = [];
  final notificationsJson = prefs.getString('notifications');

  if (notificationsJson != null) {
    notifications = List<Map<String, dynamic>>.from(jsonDecode(notificationsJson));
  }

  // Проверка уникальности сообщения
  final messageId = message.messageId;
  if (messageId != null && notifications.any((n) => n['id'] == messageId)) {
    return; // Уведомление уже сохранено
  }

  // Проверяем наличие данных (title и body)
  final title = message.notification?.title ?? message.data['title'];
  final body = message.notification?.body ?? message.data['body'];
  if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
    return; // Игнорируем пустые уведомления
  }

  notifications.add({
    'id': messageId, // Уникальный идентификатор
    'title': title ?? 'Без заголовка',
    'body': body ?? 'Без содержания',
    'read': false,
  });

  await prefs.setString('notifications', jsonEncode(notifications));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Получение токена
  String? token = await messaging.getToken();
  log(token!);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('ru');

  @override
  void initState() {
    super.initState();
    // Проверяем текущий статус пользователя
    initializeLocalNotifications();
    Timer.periodic(Duration(minutes: 1), (Timer t) => fetchAndNotify());
  }


  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    Get.updateLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
        Locale('kk'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
