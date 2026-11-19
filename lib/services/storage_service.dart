import 'package:hive_flutter/hive_flutter.dart';
import '../models/anime.dart';

class StorageService {
  static const String boxName = 'favorite_anime_box';
  static Box? _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(boxName);
  }

  static Box get box {
    if (_box == null || !_box!.isOpen) {
      throw Exception('Hive box not initialized. Call StorageService.init() first.');
    }
    return _box!;
  }

  static List<Anime> getFavorites() {
    try {
      final List<Anime> list = [];
      for (var key in box.keys) {
        final raw = box.get(key);
        if (raw != null && raw is Map) {
          list.add(Anime.fromJson(Map<dynamic, dynamic>.from(raw)));
        }
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  static bool isFavorite(int id) {
    return box.containsKey(id.toString());
  }

  static Future<void> addFavorite(Anime anime) async {
    await box.put(anime.id.toString(), anime.toJson());
  }

  static Future<void> removeFavorite(int id) async {
    await box.delete(id.toString());
  }

  static Future<bool> toggleFavorite(Anime anime) async {
    if (isFavorite(anime.id)) {
      await removeFavorite(anime.id);
      return false;
    } else {
      await addFavorite(anime);
      return true;
    }
  }
}
