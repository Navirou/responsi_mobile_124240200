import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final TextEditingController usernameController = TextEditingController(text: '124240200');
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxString currentUsername = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUsername();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> loadCurrentUsername() async {
    currentUsername.value = await AuthService.getUsername();
  }

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Username dan Password wajib diisi!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.85),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
      return;
    }

    isLoading.value = true;
    try {
      final success = await AuthService.login(username, password);
      if (success) {
        currentUsername.value = username;
        passwordController.clear();
        Get.snackbar(
          'Berhasil Masuk',
          'Selamat datang, $username!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.85),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        );
        Get.offAllNamed('/main');
      } else {
        Get.snackbar(
          'Login Gagal',
          'Username atau Password salah! (Username=[NIM], Password=123)',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withValues(alpha: 0.85),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat login: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.85),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    currentUsername.value = '';
    passwordController.clear();
    Get.offAllNamed('/login');
    Get.snackbar(
      'Logout Berhasil',
      'Anda telah keluar dari aplikasi.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey[800],
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
