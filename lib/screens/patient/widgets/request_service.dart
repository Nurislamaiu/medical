import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestService {
  final Map<String, String> _servicePrices = {
    'Внутримышечные инъекции': '3000 тг',
    'Внутривенные инъекции': '4000 тг',
    'Капельницы': '5000 тг',
    'Перевязки': '6000 тг',
    'Установка мочевого катетера и стом': '10000 тг',
    'Клизмы': '15000 тг',
    'Снятие алкогольной интоксикации': '20000 тг',
  };

  Future<void> createRequest(
      String? selectedService,
      DateTime? selectedDate,
      TimeOfDay? selectedTime) async {
    if (selectedService == null || selectedDate == null || selectedTime == null) {
      Get.snackbar('Ошибка', 'Заполните все поля');
      return;
    }

    String formattedDate = '${selectedDate.day}.${selectedDate.month}.${selectedDate.year}';
    String formattedTime = '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}';

    // Проверка на дублирование заявки
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRequestsRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('requests');

      // Проверяем, существует ли уже заявка с таким же сервисом, датой и временем
      final querySnapshot = await userRequestsRef
          .where('service', isEqualTo: selectedService)
          .where('date', isEqualTo: formattedDate)
          .where('time', isEqualTo: formattedTime)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Get.snackbar('Ошибка', 'Заявка на эту услугу в указанное время уже существует.');
        return;
      }

      // Если дубликатов нет, создаем новую заявку
      await userRequestsRef.add({
        'service': selectedService,
        'date': formattedDate,
        'time': formattedTime,
        'price': _servicePrices[selectedService],
      });

      Get.snackbar('Заявка создана', 'Ваша заявка на услугу $selectedService успешно создана.');
    }
  }
}
