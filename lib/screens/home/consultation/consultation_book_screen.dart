import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/color_screen.dart';
import '../../../utils/size_screen.dart';
class BookConsultationScreen extends StatefulWidget {
  @override
  _BookConsultationScreenState createState() => _BookConsultationScreenState();
}

class _BookConsultationScreenState extends State<BookConsultationScreen> {
  DateTime? selectedDate;
  TextEditingController dataController = TextEditingController();

  Future<void> saveAppointmentToFirestore(
      String doctorId, Map<String, dynamic> data) async {
    try {
      // Проверяем существование записи на указанную дату
      final QuerySnapshot existingAppointments = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .collection('appointments')
          .where('date', isEqualTo: data['date'])
          .get();

      if (existingAppointments.docs.isNotEmpty) {
        // Если запись существует, уведомляем пользователя
        Get.snackbar('Ошибка', 'Запись уже существует.');
        return;
      }

      // Если записи нет, создаем новую
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .collection('appointments')
          .add(data);

      Get.snackbar(
        'Успешно',
        'Вы записались на ${data['date']}',
      );
    } catch (e) {
      Get.snackbar('Ошибка', 'Не удалось сохранить данные: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    // Получаем `doctorId` из переданного аргумента
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String doctorId = arguments['doctorId'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
                      'Создайте заявку!',
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
                  'Укажите дату.',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  title: Text(
                    selectedDate == null
                        ? 'Выберите дату'
                        : 'Дата: ${selectedDate!.toLocal().toString().split(' ')[0]}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
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

                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: dataController,
                  decoration: InputDecoration(
                    labelText: 'Введите данные для обратной связи',
                    labelStyle:
                        TextStyle(fontSize: 12, color: ScreenColor.color6),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: ScreenColor.color6, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedDate == null) {
                        Get.snackbar('Ошибка', 'Выберите дату для записи.');
                        return;
                      }
                      if (dataController.text.isEmpty) {
                        Get.snackbar('Ошибка', 'Заполните поле данных.');
                        return;
                      }

                      final data = {
                        'date':
                            selectedDate!.toLocal().toString().split(' ')[0],
                        'contactInfo': dataController.text,
                        'timestamp': Timestamp.now(),
                      };

                      Navigator.pop(context);

                      saveAppointmentToFirestore(doctorId, data);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: ScreenColor.color6,
                    ),
                    child: const Text(
                      'Подтвердить запись',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
