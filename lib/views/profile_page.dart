import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/theme.dart';
import '../controllers/auth_controller.dart';
import '../controllers/favorite_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final FavoriteController favController = Get.find<FavoriteController>();

    // Ensure username is fresh
    authController.loadCurrentUsername();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              // Avatar
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_rounded,
                      size: 60,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Username Display from SharedPreferences
              Obx(
                () => Text(
                  authController.currentUsername.value.isNotEmpty
                      ? authController.currentUsername.value
                      : '124240200',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Ahmad Santosa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),

              // Favorite count from Hive (Reactive via FavoriteController)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.6),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Anime Favorit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () => Text(
                        '${favController.favorites.length} anime',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              const SizedBox(height: 32),

              // Logout Button
              ElevatedButton.icon(
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Konfirmasi Logout',
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    middleText: 'Apakah kamu yakin ingin keluar dari aplikasi?',
                    middleTextStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    backgroundColor: AppColors.surfaceElevated,
                    radius: 12,
                    textCancel: 'Batal',
                    cancelTextColor: AppColors.textSecondary,
                    textConfirm: 'Keluar',
                    confirmTextColor: Colors.white,
                    buttonColor: AppColors.primary,
                    onConfirm: () {
                      Get.back();
                      authController.logout();
                    },
                  );
                },
                icon: const Icon(Icons.logout_rounded, size: 20),
                label: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
