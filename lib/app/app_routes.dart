import 'package:flutter/material.dart';
import 'package:medical/nav_bar.dart';
import 'package:medical/screens/auth/register/info_screen.dart';
import '../screens/auth/login/login_screen.dart';
import '../screens/auth/on_boarding/on_boarding_screen.dart';
import '../screens/auth/register/register_screen.dart';
import '../screens/home/consultation/consultation_book_screen.dart';
import '../screens/home/consultation/consultation_doctors_screen.dart';
import '../screens/home/consultation/consultation_knowledge_base_screen.dart';
import '../screens/home/consultation/consultation_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/service/service_screen.dart';
import '../screens/patient/request_history_screen.dart';
import '../screens/patient/request_new_screen.dart';
import '../screens/profile/user_edit_screen.dart';
import '../screens/profile/user_profile_screen.dart';
import '../screens/profile/user_settings_screen.dart';
import '../screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String userInfo = '/user-info';
  static const String navBar = '/nav-bar';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String profileEdit = '/profile-edit';
  static const String service = '/service';
  static const String consultation = '/consultation';
  static const String doctorDetails = '/doctor-details';
  static const String bookConsultation = '/book-consultation';
  static const String knowledgeBase = '/knowledge-base';

  // Пути для пациента
  static const String requestNew = '/patient/new-request';
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
      navBar: (context) => NavBarScreen(),
      home: (context) => HomeScreen(),
      profile: (context) => ProfileScreen(),
      settings: (context) => UserSettingsScreen(),
      profileEdit: (context) => EditProfileScreen(),
      service: (context) => ServiceScreen(),
      consultation: (context) => ConsultationScreen(),
      doctorDetails: (context) => DoctorDetailsScreen(),
      bookConsultation: (context) => BookConsultationScreen(),
      knowledgeBase: (context) => ConsultationKnowledgeBaseScreen(),
      //
      // // Маршруты для пациента
      requestNew: (context) => RequestNewScreen(),
      requestHistory: (context) => RequestHistoryScreen(),
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
