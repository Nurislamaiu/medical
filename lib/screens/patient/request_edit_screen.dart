import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:medical/utils/color_screen.dart';
import 'package:medical/utils/size_screen.dart';

class EditRequestScreen extends StatefulWidget {
  final String requestId;

  const EditRequestScreen({Key? key, required this.requestId})
      : super(key: key);

  @override
  _EditRequestScreenState createState() => _EditRequestScreenState();
}

class _EditRequestScreenState extends State<EditRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  String _status = 'Ожидает';
  String _service = '';

  // Список услуг для Dropdown
  final List<String> _services = [
    'Внутримышечные инъекции',
    'Внутривенные инъекции',
    'Капельницы',
    'Перевязки',
    'Установка мочевого катетера и стомы',
    'Клизмы',
    'Снятие алкогольной интоксикации'
  ];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _timeController = TextEditingController();

    _loadRequestData();
  }

  // Метод для загрузки данных заявки
  void _loadRequestData() async {
    final requestRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('requests')
        .doc(widget.requestId);

    final requestSnapshot = await requestRef.get();
    if (requestSnapshot.exists) {
      final requestData = requestSnapshot.data() as Map<String, dynamic>;
      _dateController.text = requestData['date'] ?? '';
      _timeController.text = requestData['time'] ?? '';
      setState(() {
        _service = requestData['service'] ?? _services[0];
        _isLoading = false;
      });
    }
  }

  // Метод для обновления заявки в Firestore
  void _updateRequest() async {
    if (_formKey.currentState!.validate()) {
      final requestRef = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('requests')
          .doc(widget.requestId);

      await requestRef.update({
        'service': _service,
        'date': _dateController.text,
        'time': _timeController.text,
        'status': _status,
      });

      Navigator.pop(context);
    }
  }

  // Метод для удаления заявки из Firestore
  void _deleteRequest() async {
    final requestRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('requests')
        .doc(widget.requestId);

    try {
      // Ожидание 3 секунды перед удалением
      Navigator.pop(context);
      await Future.delayed(const Duration(seconds: 1));
      await requestRef.delete();
      Get.snackbar('Отлично', 'Заявка успешно удалена');
    } catch (e) {
      Get.snackbar('Ошибка', 'При удалении заявки');
    }
  }


  // Метод для выбора даты
  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      barrierColor: Colors.black.withOpacity(0.8),
      // Полупрозрачный фон
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: ScreenColor.white,
              // Цвет фона всего окна
              headerBackgroundColor: ScreenColor.color6,
              // Цвет фона заголовка
              todayBackgroundColor:
                  MaterialStateProperty.all(ScreenColor.color6),
              headerHelpStyle: TextStyle(color: Colors.white),
              headerForegroundColor: Colors.white,

              dayStyle: TextStyle(
                // Цвет текста для всех дней
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              cancelButtonStyle: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                // Прозрачный фон
                foregroundColor: MaterialStateProperty.all(ScreenColor.color6),
                // Цвет текста
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: ScreenColor.color6),
                )),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
              ),
              confirmButtonStyle: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(ScreenColor.color6),
                // Цвет фона
                foregroundColor: MaterialStateProperty.all(Colors.white),
                // Белый текст
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                elevation: MaterialStateProperty.all(5), // Легкая тень
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }

  }

  // Метод для выбора времени
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay currentTime = TimeOfDay.now();
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
      barrierColor: Colors.black.withOpacity(0.8), // Полупрозрачный фон
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            timePickerTheme: TimePickerThemeData(
              hourMinuteTextColor: Colors.white,
              // Цвет текста для часов и минут
              dialBackgroundColor: ScreenColor.color6,
              // Цвет фона циферблата
              entryModeIconColor: ScreenColor.color2,
              // Цвет иконки выбора формата времени
              backgroundColor: ScreenColor.white,
              // Цвет фона всего окна
              dialHandColor: Colors.black,
              hourMinuteColor: ScreenColor.color6,
              helpTextStyle: TextStyle(color: Colors.black),
              timeSelectorSeparatorColor:
                  MaterialStateProperty.all(Colors.black),
              dialTextColor: Colors.white,
              cancelButtonStyle: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(ScreenColor.color2),
              ),
              confirmButtonStyle: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(ScreenColor.color2),
              ),
              hourMinuteShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Округленные края для времени
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      setState(() {
        final String formattedTime = selectedTime.hour.toString().padLeft(2, '0') +
            ':' +
            selectedTime.minute.toString().padLeft(2, '0'); // Формат HH:mm
        _timeController.text = formattedTime;
      });
    }

  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColor.white,
      body: Column(
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
                        'Редактирование \nзаявки',
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
                    'Пожалуйста, заполните все поля',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ScreenColor.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenSize(context).height * 0.025),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: Lottie.asset(
                        'assets/lottie/loading.json', // Путь к Lottie анимации
                        width: 100,
                        height: 100,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            // Поле для выбора услуги (Dropdown)
                            DropdownButtonFormField<String>(
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                              value: _service.isEmpty ? _services[0] : _service,
                              items: _services
                                  .map((service) => DropdownMenuItem<String>(
                                        value: service,
                                        child: Text(service),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _service = value!;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Услуга',
                                labelStyle: TextStyle(color: ScreenColor.color6),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: ScreenColor.color6, width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Пожалуйста, выберите услугу';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),

                            // Поле для выбора даты
                            TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              // Делаем поле доступным только для чтения
                              onTap: () => _selectDate(context),
                              decoration: InputDecoration(
                                labelText: 'Дата',
                                labelStyle: TextStyle(color: ScreenColor.color6),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: ScreenColor.color6, width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Пожалуйста, выберите дату';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),

                            // Поле для выбора времени
                            TextFormField(
                              controller: _timeController,
                              readOnly: true,
                              // Делаем поле доступным только для чтения
                              onTap: () => _selectTime(context),
                              decoration: InputDecoration(
                                labelText: 'Время',
                                labelStyle: TextStyle(color: ScreenColor.color6),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: ScreenColor.color6, width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Пожалуйста, выберите время';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),

                            // Кнопка для обновления заявки
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _deleteRequest,
                                    child: const Text(
                                      'Удалить заявку',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      minimumSize: Size(double.infinity, 50),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _updateRequest,
                                    child: Text(
                                      'Обновить заявку',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      backgroundColor: ScreenColor.color6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      minimumSize: Size(double.infinity, 50),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
    );
  }
}
