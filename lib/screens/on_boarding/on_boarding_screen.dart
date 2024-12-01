import 'package:flutter/material.dart';
import 'package:medical/screens/on_boarding/widgets/on_boarding_dot_indicator.dart';
import 'package:medical/screens/on_boarding/widgets/on_boarding_next_button.dart';
import 'package:medical/screens/on_boarding/widgets/on_boarding_page.dart';

import '../../110n/app_localizations.dart';
import '../../main.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Locale _selectedLocale = Locale('ru'); // Язык по умолчанию

  @override
  Widget build(BuildContext context) {
    // Локализованные данные для Onboarding
    final List<Map<String, String>> onboardingData = [
      {
        "title": AppLocalizations.of(context).translate('title1'),
        "description": AppLocalizations.of(context).translate('description1'),
        "image": "assets/on_boarding/onboarding1.svg"
      },
      {
        "title": AppLocalizations.of(context).translate('title2'),
        "description": AppLocalizations.of(context).translate('description2'),
        "image": "assets/on_boarding/onboarding2.svg"
      },
      {
        "title": AppLocalizations.of(context).translate('title3'),
        "description": AppLocalizations.of(context).translate('description3'),
        "image": "assets/on_boarding/onboarding3.svg"
      },
    ];

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: DropdownButton<Locale>(
            value: _selectedLocale,
            underline: SizedBox(width: 20),
            icon: Icon(Icons.language, color: Colors.blue),
            onChanged: (Locale? newLocale) {
              if (newLocale != null) {
                setState(() {
                  _selectedLocale = newLocale;
                  MyApp.setLocale(context, newLocale);
                });
              }
            },
            items: [
              DropdownMenuItem(
                value: Locale('en'),
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: Locale('ru'),
                child: Text('Русский'),
              ),
              DropdownMenuItem(
                value: Locale('kk'),
                child: Text('Қазақша'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text(
                AppLocalizations.of(context).translate('skip'),
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) => OnboardingPage(
                  title: onboardingData[index]['title']!,
                  description: onboardingData[index]['description']!,
                  image: onboardingData[index]['image']!,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                    (index) => OnBoardingDotIndicator(
                  isActive: index == _currentPage,
                ),
              ),
            ),
            SizedBox(height: 20),
            NextButton(
              isLastPage: _currentPage == onboardingData.length - 1,
              onNext: () {
                if (_currentPage == onboardingData.length - 1) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
              buttonText: _currentPage == onboardingData.length - 1
                  ? AppLocalizations.of(context).translate('start')
                  : AppLocalizations.of(context).translate('next'),
            ),
          ],
        ),
      ),
    );
  }
}
