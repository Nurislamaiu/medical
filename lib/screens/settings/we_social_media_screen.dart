import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:medical/utils/size_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/color_screen.dart';

class WeSocialMedia extends StatefulWidget {
  @override
  _WeSocialMediaState createState() => _WeSocialMediaState();
}

class _WeSocialMediaState extends State<WeSocialMedia> {
  final List<SocialMedia> socialMediaList = [
    SocialMedia(
      name: 'Instagram',
      url: 'https://www.instagram.com',
      svgPath: 'assets/svg/instagram.svg',
    ),
    SocialMedia(
      name: 'Facebook',
      url: 'https://www.facebook.com',
      svgPath: 'assets/svg/facebook.svg',
    ),
    SocialMedia(
      name: 'Twitter',
      url: 'https://www.twitter.com',
      svgPath: 'assets/svg/twitter.svg',
    ),
    SocialMedia(
      name: 'LinkedIn',
      url: 'https://www.linkedin.com',
      svgPath: 'assets/svg/linkedIn.svg',
    ),
    SocialMedia(
      name: 'YouTube',
      url: 'https://www.youtube.com',
      svgPath: 'assets/svg/youtube.svg',
    ),
  ];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: Lottie.asset('assets/lottie/loading.json', height: ScreenSize(context).height * 0.2))
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
                          'Мы в социальных \nсетях',
                          style: TextStyle(
                            fontSize: 24,
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
                      'Вы можете нас найти тут',
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
                        itemCount: socialMediaList.length,
                        itemBuilder: (context, index) {
                final socialMedia = socialMediaList[index];
                return Container(
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [ScreenColor.background, Colors.white70],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ListTile(
                    splashColor: Colors.transparent,
                    leading: SvgPicture.asset(
                      socialMedia.svgPath,
                      width: 40,
                      height: 40,
                    ),
                    title: Text(socialMedia.name, style: TextStyle(fontSize: 18.0)),
                    trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey, size: 14,),
                    onTap: () => _launchURL(socialMedia.url),
                  ),
                );
                        },
                      ),
              ),
            ],
          ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class SocialMedia {
  final String name;
  final String url;
  final String svgPath;

  SocialMedia({required this.name, required this.url, required this.svgPath});
}
