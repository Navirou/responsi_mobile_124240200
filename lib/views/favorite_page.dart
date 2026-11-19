import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/theme.dart';
import '../controllers/favorite_controller.dart';
import '../models/anime.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController controller = Get.find<FavoriteController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Daftar Favorit',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.favorites.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceElevated,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      size: 40,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum Ada Favorit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tambahkan anime yang kamu sukai dari halaman Beranda atau Detail.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => controller.loadFavorites(),
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: controller.favorites.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final Anime anime = controller.favorites[index];

              return InkWell(
                onTap: () async {
                  await Get.toNamed('/detail', arguments: anime);
                  controller.loadFavorites();
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      // Thumbnail Poster
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 58,
                          height: 80,
                          color: AppColors.surfaceElevated,
                          child: anime.posterUrl != null
                              ? Image.network(
                                  anime.posterUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Center(
                                    child: Icon(Icons.movie_rounded, color: AppColors.textMuted),
                                  ),
                                )
                              : const Center(
                                  child: Icon(Icons.movie_rounded, color: AppColors.textMuted),
                                ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Title & Rating
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              anime.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 16, color: AppColors.starGold),
                                const SizedBox(width: 4),
                                Text(
                                  anime.displayRating,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                if (anime.ageRating != null) ...[
                                  const SizedBox(width: 8),
                                  const Text('•', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      anime.ageRating!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Delete Button
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                        tooltip: 'Hapus dari Favorit',
                        onPressed: () => controller.removeFavorite(anime),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
