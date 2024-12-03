import 'package:flutter/material.dart';
import 'package:medical/utils/color_screen.dart';

class RequestHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('История заявок'),
        automaticallyImplyLeading: false,
        backgroundColor: ScreenColor.color6,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 10, // Пример: 10 заявок
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.assignment, color: ScreenColor.color6),
              title: Text('Заявка #${index + 1}'),
              subtitle: Text('Статус: Выполнено'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: ScreenColor.color2),
              onTap: () {
                // Логика для просмотра деталей заявки
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, '/patient/new-request');
      }),
    );
  }
}
