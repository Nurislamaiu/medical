import 'package:flutter/material.dart';
import 'package:medical/screens/auth/register/info_screen.dart';
import 'package:medical/screens/service/service_screen.dart';

import '../screens/auth/login/login_screen.dart';
import '../screens/auth/register/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/on_boarding/on_boarding_screen.dart';
import '../screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String userInfo = '/user-info';
  static const String home = '/home';
  static const String service = '/service';

  // Пути для пациента
  static const String newRequest = '/patient/new-request';
  static const String requestHistory = '/patient/request-history';

  // Пути для медсестры
  static const String activeRequests = '/nurse/active-requests';
  static const String completedRequests = '/nurse/completed-requests';

  // Пути для администратора
  static const String manageUsers = '/admin/manage-users';
  static const String manageServices = '/admin/manage-services';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => SplashScreen(),
      onboarding: (context) => OnboardingScreen(),
      login: (context) => LoginScreen(),
      register: (context) => RegisterScreen(),
      userInfo: (context) => UserInfoScreen(),
      home: (context) => HomeScreen(),
      service: (context) => ServiceScreen(),
      //
      // // Маршруты для пациента
      // newRequest: (context) => NewRequestScreen(),
      // requestHistory: (context) => RequestHistoryScreen(),
      //
      // // Маршруты для медсестры
      // activeRequests: (context) => ActiveRequestsScreen(),
      // completedRequests: (context) => CompletedRequestsScreen(),
      //
      // // Маршруты для администратора
      // manageUsers: (context) => ManageUsersScreen(),
      // manageServices: (context) => ManageServicesScreen(),
    };
  }
}
