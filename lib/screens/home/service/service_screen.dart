import 'package:flutter/material.dart';
import 'package:medical/utils/color_screen.dart';
import '../../../utils/size_screen.dart';

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
                        'Наши услуги!',
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
                    'Выберите услугу или проконсультируйтесь со специалистом.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ScreenColor.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: services.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [ScreenColor.background, Colors.white70],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.medical_information_outlined,
                          color: ScreenColor.color6),
                      title: Text(
                        service['title']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ScreenColor.color1,
                        ),
                      ),
                      subtitle: Text(
                        service['description']!,
                        style:
                            TextStyle(fontSize: 12, color: ScreenColor.color2),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
    );
  }
}
