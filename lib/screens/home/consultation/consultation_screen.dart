import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medical/utils/color_screen.dart';
import '../../../utils/size_screen.dart';
class ConsultationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: ScreenSize(context).height * 0.30,
                padding: const EdgeInsets.all(20),
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
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ScreenColor.color6.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
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
                          'Выберите вариант \nконсультации',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: ScreenColor.white,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close, color: Colors.white))
                      ],
                    ),
                    const Text(
                      'Выберите консультацию и \nукажите дату и время.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ScreenColor.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Доступные специалисты',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ScreenColor.color1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildDoctorList(context), // Загрузка списка врачей из Firebase
                    const SizedBox(height: 20),
                    const Text(
                      'Другие варианты',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ScreenColor.color1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildOptionCard(
                      context,
                      icon: Icons.book,
                      title: 'База знаний',
                      subtitle: 'Найдите ответы на популярные вопросы.',
                      onTap: () {
                        Navigator.pushNamed(context, '/knowledge-base');
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }

  /// Список докторов
  Widget _buildDoctorList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'Нет доступных специалистов.',
              style: TextStyle(color: ScreenColor.color1),
            ),
          );
        }
        final doctors = snapshot.data!.docs;
        return Column(
          children: doctors.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final doctorId = doc.id; // UID документа
            return _buildDoctorCard(
              context,
              id: doctorId,
              name: data['name'] ?? 'Неизвестный врач',
              specialization: data['specialization'] ?? 'Специализация не указана',
              experience: data['experience'] ?? 'Опыт не указан',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/doctor-details',
                  arguments: {...data, 'doctorId': doctorId},
                );
              },
            );
          }).toList(),
        );
      },
    );
  }



  /// Карточка для доктора
  Widget _buildDoctorCard(BuildContext context,
      {required String name,
        required String specialization,
        required String experience,
        required Function() onTap, required id}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [ScreenColor.background, Colors.white70],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: ScreenColor.color6.withOpacity(0.2),
                child: Icon(Icons.person, size: 30, color: ScreenColor.color6),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ScreenColor.color1,
                      ),
                    ),
                    Text(
                      'Специалист: $specialization',
                      style: TextStyle(
                        fontSize: 14,
                        color: ScreenColor.color1.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      'Опыт: $experience лет',
                      style: TextStyle(
                        fontSize: 12,
                        color: ScreenColor.color1.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  size: 16, color: ScreenColor.color1),
            ],
          ),
        ),
      ),
    );
  }

  /// Карточка для Другие опции
  Widget _buildOptionCard(BuildContext context,
      {required IconData icon,
        required String title,
        required String subtitle,
        required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [ScreenColor.background, Colors.white70],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ScreenColor.color1,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: ScreenColor.color1.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 16, color: ScreenColor.color1),
            ],
          ),
        ),
      ),
    );
  }
}
