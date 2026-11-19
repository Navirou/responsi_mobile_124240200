import 'package:get/get.dart';
import '../models/anime.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  final RxList<Anime> animeList = <Anime>[].obs;
  final RxList<Anime> filteredAnime = <Anime>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAnime();
  }

  Future<void> fetchAnime() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await ApiService.fetchAnime();
      animeList.assignAll(result);
      filterAnime(searchQuery.value);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void filterAnime(String query) {
    searchQuery.value = query;
    if (query.trim().isEmpty) {
      filteredAnime.assignAll(animeList);
    } else {
      final q = query.toLowerCase();
      filteredAnime.assignAll(
        animeList.where((item) => item.name.toLowerCase().contains(q)).toList(),
      );
    }
  }
}
