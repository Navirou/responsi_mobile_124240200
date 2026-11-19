import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/anime.dart';
import '../services/storage_service.dart';

class FavoriteController extends GetxController {
  final RxList<Anime> favorites = <Anime>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
    try {
      StorageService.box.watch().listen((_) {
        loadFavorites();
      });
    } catch (_) {}
  }

  void loadFavorites() {
    try {
      final list = StorageService.getFavorites();
      favorites.assignAll(list);
    } catch (_) {}
  }

  bool isFavorite(int id) {
    return favorites.any((item) => item.id == id);
  }

  Future<void> removeFavorite(Anime anime) async {
    await StorageService.removeFavorite(anime.id);
    favorites.removeWhere((item) => item.id == anime.id);

    Get.snackbar(
      'Dihapus',
      '${anime.name} dihapus dari daftar favorit.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey.shade900,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      mainButton: TextButton(
        onPressed: () async {
          await StorageService.addFavorite(anime);
          loadFavorites();
          if (Get.isSnackbarOpen) Get.back();
        },
        child: const Text('BATALKAN', style: TextStyle(color: Colors.amber)),
      ),
    );
  }
}
