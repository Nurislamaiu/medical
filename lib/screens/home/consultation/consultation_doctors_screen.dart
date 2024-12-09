import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/color_screen.dart';
import '../../../utils/size_screen.dart';

class DoctorDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Получаем переданные аргументы из предыдущей страницы
    final Map<String, dynamic> doctorData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: ScreenSize(context).height * 0.30,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ScreenColor.color6,
                    ScreenColor.color6.withOpacity(0.2),
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
                        'Профиль доктора',
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
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  const Text(
                    'Пожалуйста, не звоните поздно вечером',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ScreenColor.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  /// Карточка Доктора
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [ScreenColor.background, Colors.white70],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Имя: ${doctorData['name'] ?? 'Не указано'}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ScreenColor.color6,
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.medical_information_outlined,
                                  color: ScreenColor.color6),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Специализация: ${doctorData['specialization'] ?? 'Не указано'}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[800]),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Iconsax.clock, color: ScreenColor.color6),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Опыт: ${doctorData['experience'] ?? 'Не указано'}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[800]),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.phone, color: ScreenColor.color6),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Номер: ${doctorData['doctorId'] ?? 'Не указан'}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/book-consultation',
                                  arguments: {'doctorId': doctorData['doctorId']},
                                );
                              },
                              label: Text(
                                'Записаться на консультацию',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 24),
                                backgroundColor: ScreenColor.color6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  // Новый блок для информации о записи
                  FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('doctors')
                        .doc(doctorData['doctorId'])
                        .collection('appointments')
                        .limit(1)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Lottie.asset(
                            'assets/lottie/loading.json',
                            width: 150,
                            height: 150,
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Text('Запись не найдена');
                      }

                      final document = snapshot.data!.docs.first;
                      final appointmentData = document.data() as Map<String, dynamic>;

                      return SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [ScreenColor.background, Colors.white70],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ваша запись:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Дата: ${appointmentData['date'] ?? 'Не указана'}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () async {
                                  // Открываем диалог для выбора новой даты
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                    builder: (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          datePickerTheme: DatePickerThemeData(
                                            backgroundColor: ScreenColor.white,
                                            headerBackgroundColor: ScreenColor.color6,
                                            todayBackgroundColor:
                                            MaterialStateProperty.all(ScreenColor.color6),
                                            headerHelpStyle:
                                            const TextStyle(color: Colors.white),
                                            headerForegroundColor: Colors.white,
                                            dayStyle: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                            cancelButtonStyle: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(
                                                  Colors.transparent),
                                              foregroundColor: MaterialStateProperty.all(
                                                  ScreenColor.color6),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                    side: const BorderSide(
                                                        color: ScreenColor.color6),
                                                  )),
                                              padding: MaterialStateProperty.all(
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20, vertical: 10)),
                                            ),
                                            confirmButtonStyle: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(
                                                  ScreenColor.color6),
                                              foregroundColor:
                                              MaterialStateProperty.all(Colors.white),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  )),
                                              padding: MaterialStateProperty.all(
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20, vertical: 10)),
                                              elevation: MaterialStateProperty.all(5),
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );

                                  if (picked != null) {
                                    // Обновляем запись в Firestore
                                    await FirebaseFirestore.instance
                                        .collection('doctors')
                                        .doc(doctorData['doctorId'])
                                        .collection('appointments')
                                        .doc(document.id)
                                        .update({'date': picked.toLocal().toString().split(' ')[0]});

                                    // Показываем уведомление
                                    Get.snackbar('Успешно', 'Дата записи обновлена.');
                                  }
                                },
                                icon: Icon(Iconsax.edit),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
