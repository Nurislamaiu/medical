import 'package:flutter/material.dart';
import 'package:medical/screens/splash_screen.dart';
import 'app/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medical Services App',
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
