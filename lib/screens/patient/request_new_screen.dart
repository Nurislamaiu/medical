import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medical/screens/patient/widgets/request_section.dart';
import 'package:medical/screens/patient/widgets/request_service.dart';
import 'package:medical/utils/color_screen.dart';
import 'package:medical/utils/size_screen.dart';

import '../../nav_bar.dart';

class RequestNewScreen extends StatefulWidget {
  @override
  _RequestNewScreenState createState() => _RequestNewScreenState();
}

class _RequestNewScreenState extends State<RequestNewScreen> {
  String? _selectedService;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final _services = <String>[
    'Внутримышечные инъекции',
    'Внутривенные инъекции',
    'Капельницы',
    'Перевязки',
    'Установка мочевого катетера и стом',
    'Клизмы',
    'Снятие алкогольной интоксикации',
  ];

  final Map<String, String> _servicePrices = {
    'Внутримышечные инъекции': '3000 тг',
    'Внутривенные инъекции': '4000 тг',
    'Капельницы': '5000 тг',
    'Перевязки': '6000 тг',
    'Установка мочевого катетера и стом': '10000 тг',
    'Клизмы': '15000 тг',
    'Снятие алкогольной интоксикации': '20000 тг',
  };

  final RequestService _requestService = RequestService();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScreenColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Баннер
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
                    'Выберите услугу и \nукажите дату и время.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ScreenColor.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenSize(context).height * 0.04),
            // Секция выбора услуги
            Column(
              children: [
                SectionWidget(
                  title: 'Выберите услугу',
                  icon: Icons.medical_information_outlined,
                  content: DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: ScreenColor.color6, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                    ),
                    value: _selectedService,
                    items: _services.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry,
                        child: Text(
                          entry,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedService = value;
                      });
                    },
                    hint: Text(
                      'Выберите услугу',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ),
                SizedBox(height: ScreenSize(context).height * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SectionWidget(
                        title: 'Выберите дату',
                        icon: Icons.calendar_today,
                        content: GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                textAlign: TextAlign.center,
                                _selectedDate == null
                                    ? ''
                                    : '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SectionWidget(
                        title: 'Выберите время',
                        icon: Icons.access_time,
                        content: GestureDetector(
                          onTap: () => _selectTime(context),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                textAlign: TextAlign.center,
                                _selectedTime == null
                                    ? ''
                                    : '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: ScreenSize(context).height * 0.05),

            // Отображение выбранной услуги и её цены
            Row(
              children: [
                if (_selectedService != null)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '$_selectedService\nЦена: ${_servicePrices[_selectedService]}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ScreenColor.color1,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedService == null ||
                            _selectedDate == null ||
                            _selectedTime == null) {
                          Get.snackbar('Пожалуйста', 'Заполните все поля');
                          return;
                        }
                        _requestService.createRequest(
                            _selectedService, _selectedDate, _selectedTime);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Создать заявку',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ScreenColor.color6,
                        padding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
