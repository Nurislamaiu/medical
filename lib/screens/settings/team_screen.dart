import 'package:flutter/material.dart';

import '../../utils/color_screen.dart';
import '../../utils/size_screen.dart';

class TeamScreen extends StatelessWidget {
  final List<TeamMember> teamMembers = [
    TeamMember(
      name: 'Ильясов Нурислам',
      role: 'Flutter Программист',
      description: 'Специализируется на разработке кросс-платформенных мобильных приложений с использованием Flutter.',
      imagePath: 'https://yt3.googleusercontent.com/REq4rTSQRwbsLk1v3PfreNf8creu9lhpox9R86w9BcExM1LEolkPFphZuIbwh_JYCi8B-ENQMSI=s900-c-k-c0x00ffffff-no-rj',
    ),
    TeamMember(
      name: 'Бейбытулы Мади',
      role: 'UI/UX Дизайнер',
      description: 'Создает пользовательские интерфейсы и обеспечивает пользовательский опыт.',
      imagePath: 'https://i.pinimg.com/736x/fb/0b/23/fb0b235e26d05fffbdd45ba968cc7810.jpg',
    ),
    TeamMember(
      name: 'Нурлибай Жандос',
      role: 'Тестировщик',
      description: 'Гарантирует качество и функциональность благодаря тщательному тестированию.',
      imagePath: 'https://yt3.googleusercontent.com/zgIXXOCf6RJMGmybO3Gwv3h4AXvJR9-50nHnxfjpfNA-B-EYnfkIA1qq7UwDF7ZYAoXJds4a=s900-c-k-c0x00ffffff-no-rj',
    ),
    TeamMember(
      name: 'Кызайымбек Ай-Керим',
      role: 'SEO Специалист',
      description: 'Защищает презентацию и поддерживает команду в соответствии со стратегическими целями',
      imagePath: 'https://i.pinimg.com/736x/f6/44/90/f64490f15839d070dd31b6bbb91ca2c6.jpg',
    ),
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
                      'О команде',
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
                  'Все информация о команде.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ScreenColor.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: teamMembers.length,
              itemBuilder: (context, index) {
                final member = teamMembers[index];
                return Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [ScreenColor.background, Colors.white70],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(member.imagePath),
                      radius: 30,
                    ),
                    title: Text(member.name, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(member.role, style: TextStyle(fontSize: 16.0, color: Colors.grey[700])),
                        SizedBox(height: 4.0),
                        Text(member.description, style: TextStyle(fontSize: 12.0, color: Colors.grey[600])),
                      ],
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

class TeamMember {
  final String name;
  final String role;
  final String description;
  final String imagePath;

  TeamMember({required this.name, required this.role, required this.description, required this.imagePath});
}
