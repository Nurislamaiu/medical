import 'package:flutter/material.dart';
import 'package:medical/utils/color_screen.dart';

class ServiceScreen extends StatelessWidget {
  final List<Map<String, String>> services = [
    {
      'title': 'Внутримышечные инъекции',
      'description': 'Стоимость: от 3000 тг',
    },
    {
      'title': 'Внутривенные инъекции',
      'description': 'Стоимость: от 4000 тг',
    },
    {
      'title': 'Капельницы',
      'description': 'Стоимость: от 5000 тг',
    },
    {
      'title': 'Перевязки',
      'description': 'Стоимость: от 6000 тг',
    },
    {
      'title': 'Установка мочевого катетера и стом',
      'description': 'Стоимость: от 10 000 тг',
    },
    {
      'title': 'Клизмы',
      'description': 'Стоимость: от 15 000 тг',
    },
    {
      'title': 'Снятие алкогольной интоксикации',
      'description': 'Стоимость: от 20 000 тг',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Услуги'),
        backgroundColor: ScreenColor.color6,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: services.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final service = services[index];
          return ListTile(
            leading: Icon(Icons.medical_services, color: ScreenColor.color6),
            title: Text(
              service['title']!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ScreenColor.color1,
              ),
            ),
            subtitle: Text(
              service['description']!,
              style: TextStyle(fontSize: 14, color: ScreenColor.color2),
            ),
            onTap: () {
              // Можно добавить переход на детальный экран услуги
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${service['title']} выбрано'),
                  backgroundColor: ScreenColor.color6,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
