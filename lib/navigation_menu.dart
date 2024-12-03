import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medical/screens/home/home_screen.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Obx(
        () => CrystalNavigationBar(
          backgroundColor: Colors.grey.withOpacity(0.5),
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.white,
          indicatorColor: Colors.transparent,
          splashColor: Colors.transparent,
          items: [
            CrystalNavigationBarItem(icon: Iconsax.home),
            CrystalNavigationBarItem(icon: Iconsax.task),
            CrystalNavigationBarItem(
                icon: Iconsax.additem, selectedColor: Colors.blue),
            CrystalNavigationBarItem(icon: Iconsax.user),
            CrystalNavigationBarItem(icon: Iconsax.setting),
          ],
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => controller.selectedIndex.value = index,
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    HomeScreen(),
    Container(
      color: Colors.red,
    ),
    Container(
      color: Colors.lightBlue,
    ),
    Container(
      color: Colors.yellow,
    ),
    Container(
      color: Colors.orangeAccent,
    ),
  ];
}
