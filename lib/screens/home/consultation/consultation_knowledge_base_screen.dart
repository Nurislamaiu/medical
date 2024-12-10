import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/color_screen.dart';
import '../../../utils/size_screen.dart';

class ConsultationKnowledgeBaseScreen extends StatelessWidget {
  const ConsultationKnowledgeBaseScreen({Key? key}) : super(key: key);

  void _showSupportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Свяжитесь с нами',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Wrap GridView.builder with Expanded
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return SupportButton(index: index);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final faqs = [
      FAQItem(
        question: "Как работает приложение MedCall?",
        answer:
        "Приложение MedCall позволяет вызвать врача или медицинскую сестру (брата) на дом для предоставления медицинских услуг. Вы выбираете услугу, указываете адрес и время, а наш специалист приедет к вам.",
      ),
      FAQItem(
        question: "Какие услуги можно заказать через приложение?",
        answer:
        "Мы предоставляем следующие услуги на дому:\n- Внутримышечные инъекции\n- Внутривенные инъекции\n- Капельницы\n- Перевязки\n- Установка мочевого катетера и стомы\n- Клизмы\n- Снятие алкогольной интоксикации",
      ),
      FAQItem(
        question: "Как быстро приедет медицинский работник?",
        answer:
        "Срок прибытия зависит от вашего местоположения и загруженности специалистов. Обычно медицинский работник приезжает в течение 1-2 часов после подтверждения заказа.",
      ),
      FAQItem(
        question: "Можно ли записаться заранее?",
        answer: "Да, вы можете указать удобное для вас время и дату визита.",
      ),
      FAQItem(
        question: "Безопасно ли это?",
        answer:
        "Все наши специалисты имеют медицинское образование, опыт работы и лицензии, подтверждающие их квалификацию.",
      ),
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(

        onPressed: () => _showSupportBottomSheet(context),
        backgroundColor: ScreenColor.color6,
        child: const Icon(Icons.support_agent, color: Colors.white),
      ),
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
                      'Часто задаваемые \nвопросы (FAQ)',
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
                  'Найдите ответы на популярные вопросы.',
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
              itemCount: faqs.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                final faq = faqs[index];
                return FAQWidget(faq: faq);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

class FAQWidget extends StatefulWidget {
  final FAQItem faq;

  const FAQWidget({Key? key, required this.faq}) : super(key: key);

  @override
  State<FAQWidget> createState() => _FAQWidgetState();
}

class _FAQWidgetState extends State<FAQWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [ScreenColor.background, Colors.white70],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: InkWell(
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: ExpansionTile(
            dense: false,
            maintainState: false,
            title: Text(
              widget.faq.question,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            trailing: Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: ScreenColor.color6,
            ),
            childrenPadding: EdgeInsets.zero,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [ScreenColor.background, Colors.white70],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  widget.faq.answer,
                  style: const TextStyle(fontSize: 14.0, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SupportButton extends StatelessWidget {
  final int index;

  const SupportButton({Key? key, required this.index}) : super(key: key);

  void _openApp(BuildContext context) async {
    String url;

    switch (index) {
      case 0:
        url = 'https://t.me/NurislamAiu';  // Ссылка для Telegram
        break;
      case 1:
        url = 'https://wa.me/77473193061'; // Ссылка для WhatsApp
        break;
      case 2:
        url = 'tel:+77473193061';  // Для звонка
        break;
      case 3:
        url = 'mailto:example@example.com';  // Для почты
        break;
      default:
        url = 'https://www.example.com'; // Для прочих случаев
    }

    // Проверка на возможность открытия URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar('Ошибка', 'Не удалось открыть приложение');
    }
  }


  @override
  Widget build(BuildContext context) {
    IconData icon;
    String label;
    Color? color;

    switch (index) {
      case 0:
        icon = Icons.telegram;
        label = 'Telegram';
        color = Colors.blue;
        break;
      case 1:
        icon = Icons.phone;
        label = 'WhatsApp';
        color = Colors.green;
        break;
      case 2:
        icon = Icons.phone;
        label = 'Позвонить';
        color = Colors.grey;
        break;
      case 3:
        icon = Icons.email;
        label = 'Написать';
        color = Colors.orangeAccent;
        break;
      default:
        icon = Icons.help;
        label = 'Помощь';
    }

    return GestureDetector(
      onTap: () {
        _openApp(context);  // Вызываем метод для открытия приложения
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

