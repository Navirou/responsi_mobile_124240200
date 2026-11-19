import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants/theme.dart';
import 'controllers/auth_controller.dart';
import 'controllers/favorite_controller.dart';
import 'services/auth_service.dart';
import 'services/storage_service.dart';
import 'views/login_page.dart';
import 'views/main_nav_page.dart';
import 'views/detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi penyimpanan lokal Hive untuk data favorit
  await StorageService.init();

  // Cek status login dari SharedPreferences
  final bool loggedIn = await AuthService.isLoggedIn();

  runApp(MyApp(isLoggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Keripikroll',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController(), permanent: true);
        Get.put(FavoriteController(), permanent: true);
      }),
      initialRoute: isLoggedIn ? '/main' : '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/main',
          page: () => const MainNavPage(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/detail',
          page: () => const DetailPage(),
          transition: Transition.rightToLeft,
        ),
      ],
    );
  }
}
