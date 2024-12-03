import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical/110n/app_localizations.dart';
import 'package:medical/screens/home/widgets/home_action_button.dart';
import 'package:medical/screens/home/widgets/home_advantage_tile.dart';
import 'package:medical/utils/color_screen.dart';
import 'package:medical/utils/size_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

Future<void> signOutUser() async {
  try {
    await FirebaseAuth.instance.signOut();
    print('Пользователь вышел из системы');
  } catch (e) {
    print('Ошибка при выходе: $e');
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Баннер
              Container(
                width: double.infinity,
                height: ScreenSize(context).height * 0.25,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ScreenColor.color6, ScreenColor.color6.withOpacity(0.2)],
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('your_health'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ScreenColor.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ScreenColor.white,
                        foregroundColor: ScreenColor.color6,
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        await signOutUser();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(AppLocalizations.of(context)
                          .translate('submit_application')),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenSize(context).height * 0.05),
              // Кнопки быстрого действия
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ActionButton(
                      icon: Icons.medical_services,
                      label: AppLocalizations.of(context).translate('services'),
                      color: ScreenColor.color6,
                      onTap: () {
                        Navigator.pushNamed(context, '/service');
                      },
                    ),
                    ActionButton(
                      icon: Icons.chat,
                      label: AppLocalizations.of(context)
                          .translate('consultation'),
                      color: ScreenColor.color6,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              SizedBox(height: ScreenSize(context).height * 0.05),
              // Преимущества сервиса
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('why_choose_us'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ScreenColor.color1,
                      ),
                    ),
                    SizedBox(height: 10),
                    AdvantageTile(
                      icon: Icons.verified,
                      text: AppLocalizations.of(context)
                          .translate('qualified_specialists'),
                    ),
                    AdvantageTile(
                      icon: Icons.shield,
                      text: AppLocalizations.of(context)
                          .translate('sterility_and_safety'),
                    ),
                    AdvantageTile(
                      icon: Icons.access_time,
                      text: AppLocalizations.of(context)
                          .translate('availability'),
                    ),
                    AdvantageTile(
                      icon: Icons.delivery_dining,
                      text: AppLocalizations.of(context)
                          .translate('fast_delivery'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
