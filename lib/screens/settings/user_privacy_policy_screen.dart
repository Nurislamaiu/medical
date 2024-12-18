import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../utils/color_screen.dart';
import '../../utils/size_screen.dart';

class UserPrivacyPolicyScreen extends StatefulWidget {
  @override
  _UserPrivacyPolicyScreenState createState() => _UserPrivacyPolicyScreenState();
}

class _UserPrivacyPolicyScreenState extends State<UserPrivacyPolicyScreen> {
  String userAgreement = "";

  @override
  void initState() {
    super.initState();
    _loadUserAgreement();
  }

  Future<void> _loadUserAgreement() async {
    final String agreementText = await rootBundle.loadString('assets/user_privacy_policy.txt');
    setState(() {
      userAgreement = agreementText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userAgreement.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
            children: [
              Container(
                width: double.infinity,
                height: ScreenSize(context).height * 0.30,
                padding: EdgeInsets.all(20),
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
                          'ПОЛИТИКА \nКОНФИДЕНЦИАЛЬНОСТИ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ScreenColor.white,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white,),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const Text(
                      'Прочитайте',
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
                child: SingleChildScrollView(
                        padding: EdgeInsets.all(16.0),
                        child: Text(userAgreement),
                      ),
              ),
            ],
          ),
    );
  }
}
