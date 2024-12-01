import 'package:flutter/material.dart';
import 'package:medical/screens/on_boarding/widgets/on_boarding_dot_indicator.dart';
import 'package:medical/screens/on_boarding/widgets/on_boarding_next_button.dart';
import 'package:medical/screens/on_boarding/widgets/on_boarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Добро пожаловать",
      "description": "Приложение для медицинских услуг на дому.",
      "image": "assets/on_boarding/onboarding1.svg"
    },
    {
      "title": "Удобный заказ",
      "description": "Оформляйте заявки всего за несколько кликов.",
      "image": "assets/on_boarding/onboarding2.svg"
    },
    {
      "title": "Качественный сервис",
      "description": "Наша команда гарантирует профессиональный подход.",
      "image": "assets/on_boarding/onboarding3.svg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: Text(
              "Пропустить",
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
          ),
        ],
      ),
    );
  }
}
