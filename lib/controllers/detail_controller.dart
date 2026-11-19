import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/anime.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'favorite_controller.dart';

class DetailController extends GetxController {
  final Rx<Anime?> anime = Rx<Anime?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isFav = false.obs;

  int? animeId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is int) {
      animeId = args;
      isFav.value = StorageService.isFavorite(args);
      fetchDetail(args);
    } else if (args is Anime) {
      anime.value = args;
      animeId = args.id;
      isFav.value = StorageService.isFavorite(args.id);
      fetchDetail(args.id);
    }
  }

  Future<void> fetchDetail(int id) async {
    isLoading.value = anime.value == null;
    errorMessage.value = '';
    try {
      final detail = await ApiService.fetchAnimeDetail(id);
      anime.value = detail;
      isFav.value = StorageService.isFavorite(id);
    } catch (e) {
      if (anime.value == null) {
        errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite() async {
    final current = anime.value;
    if (current == null) return;

    final newState = await StorageService.toggleFavorite(current);
    isFav.value = newState;

    if (Get.isRegistered<FavoriteController>()) {
      Get.find<FavoriteController>().loadFavorites();
    }

    Get.snackbar(
      newState ? 'Ditambahkan ke Favorit' : 'Dihapus dari Favorit',
      newState
          ? '${current.name} berhasil disimpan di daftar favorit.'
          : '${current.name} telah dihapus dari daftar favorit.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: newState ? Colors.green.shade800 : Colors.grey.shade900,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      icon: Icon(
        newState ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: newState ? Colors.redAccent : Colors.white70,
      ),
    );
  }
}
