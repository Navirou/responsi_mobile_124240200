import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/theme.dart';
import 'home_page.dart';
import 'favorite_page.dart';
import 'profile_page.dart';

class MainNavController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}

class MainNavPage extends StatelessWidget {
  const MainNavPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MainNavController controller = Get.put(MainNavController());

    final List<Widget> pages = const [
      HomePage(),
      FavoritePage(),
      ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.border, width: 0.8),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            backgroundColor: AppColors.surface,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textMuted,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline_rounded),
                activeIcon: Icon(Icons.favorite_rounded),
                label: 'Favorit',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
