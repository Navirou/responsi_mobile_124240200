import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/theme.dart';
import '../controllers/detail_controller.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final DetailController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(DetailController());
  }

  @override
  void dispose() {
    Get.delete<DetailController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.55),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            tooltip: 'Kembali',
            onPressed: () => Get.back(),
          ),
        ),
        title: const Text(
          'Detail',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.anime.value == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 16),
                Text(
                  'Memuat detail anime...',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty && controller.anime.value == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 54, color: AppColors.textMuted),
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.animeId != null) {
                        controller.fetchDetail(controller.animeId!);
                      }
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        final anime = controller.anime.value;
        if (anime == null) {
          return const Center(
            child: Text('Data tidak ditemukan.', style: TextStyle(color: AppColors.textSecondary)),
          );
        }

        final imageUrl = anime.bestCover;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Hero with Dark Gradient
              Stack(
                children: [
                  Container(
                    height: 380,
                    width: double.infinity,
                    color: AppColors.surface,
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            errorBuilder: (context, error, stackTrace) => const Center(
                              child: Icon(Icons.movie_creation_outlined, size: 64, color: AppColors.textMuted),
                            ),
                          )
                        : const Center(
                            child: Icon(Icons.movie_creation_outlined, size: 64, color: AppColors.textMuted),
                          ),
                  ),

                  // Gradient Overlays (top and bottom)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.65),
                            Colors.transparent,
                            AppColors.background.withValues(alpha: 0.8),
                            AppColors.background,
                          ],
                          stops: const [0.0, 0.35, 0.8, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Title and Meta Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      anime.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Rating & Age Rating & Episodes Row
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 18, color: AppColors.starGold),
                        const SizedBox(width: 4),
                        Text(
                          anime.displayRating,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (anime.ageRating != null) ...[
                          const SizedBox(width: 10),
                          const Text('•', style: TextStyle(color: AppColors.textMuted)),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              anime.ageRating!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                        if (anime.episodeCount != null) ...[
                          const SizedBox(width: 10),
                          const Text('•', style: TextStyle(color: AppColors.textMuted)),
                          const SizedBox(width: 10),
                          Text(
                            '${anime.episodeCount} Episode',
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Actions Row: [▶ Nonton] and [Favorite Heart Button]
                    Row(
                      children: [
                        // Watch Button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.snackbar(
                                'Nonton Skuy',
                                'Memulai pemutaran ${anime.name}...',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppColors.primary.withValues(alpha: 0.9),
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(16),
                                icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                              );
                            },
                            icon: const Icon(Icons.play_arrow_rounded, size: 22),
                            label: const Text(
                              'Nonton',
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
                        ),
                        const SizedBox(width: 12),

                        // Favorite Button
                        Obx(
                          () => InkWell(
                            onTap: () => controller.toggleFavorite(),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: controller.isFav.value
                                    ? AppColors.primary.withValues(alpha: 0.18)
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: controller.isFav.value
                                      ? AppColors.primary
                                      : AppColors.border,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  controller.isFav.value
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: controller.isFav.value
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Synopsis Section
                    const Text(
                      'Sinopsis',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      anime.cleanSummary,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFFC7C7C7),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
