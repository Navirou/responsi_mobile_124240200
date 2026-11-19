class Anime {
  final int id;
  final String name;
  final String? posterUrl;
  final String? coverUrl;
  final String? ageRating;
  final double? averageRating;
  final int? episodeCount;
  final String synopsis;

  Anime({
    required this.id,
    required this.name,
    this.posterUrl,
    this.coverUrl,
    this.ageRating,
    this.averageRating,
    this.episodeCount,
    required this.synopsis,
  });

  factory Anime.fromJson(Map<dynamic, dynamic> json) {
    final attrs = json['attributes'] is Map
        ? json['attributes'] as Map<dynamic, dynamic>
        : json;

    String title = 'Unknown Anime';
    if (attrs['titles'] is Map) {
      final titles = attrs['titles'] as Map;
      title = (titles['en_jp'] ?? titles['en'] ?? titles['ja_jp'])?.toString() ??
          title;
    }
    if (title == 'Unknown Anime') {
      title = (attrs['canonicalTitle'] ?? attrs['name'] ?? 'Unknown Anime')
          .toString();
    }

    String? poster;
    if (attrs['posterImage'] is Map) {
      final img = attrs['posterImage'] as Map;
      poster = (img['small'] ?? img['medium'] ?? img['tiny'])?.toString();
    } else {
      poster = attrs['posterUrl']?.toString();
    }

    String? cover;
    if (attrs['coverImage'] is Map) {
      final img = attrs['coverImage'] as Map;
      cover = (img['small'] ?? img['large'] ?? img['tiny'])?.toString();
    } else {
      cover = attrs['coverUrl']?.toString();
    }

    double? rating;
    final rawRating = attrs['averageRating'];
    if (rawRating is num) {
      rating = rawRating.toDouble();
    } else if (rawRating != null) {
      rating = double.tryParse(rawRating.toString());
    }

    int? episodes;
    final rawEpisodes = attrs['episodeCount'];
    if (rawEpisodes is num) {
      episodes = rawEpisodes.toInt();
    } else if (rawEpisodes != null) {
      episodes = int.tryParse(rawEpisodes.toString());
    }

    return Anime(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: title,
      posterUrl: poster,
      coverUrl: cover,
      ageRating: attrs['ageRating']?.toString(),
      averageRating: rating,
      episodeCount: episodes,
      synopsis: (attrs['synopsis'] ?? attrs['summary'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'posterUrl': posterUrl,
      'coverUrl': coverUrl,
      'ageRating': ageRating,
      'averageRating': averageRating,
      'episodeCount': episodeCount,
      'synopsis': synopsis,
    };
  }

  String get cleanSummary {
    if (synopsis.isEmpty) return 'Sinopsis tidak tersedia.';
    final exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    final cleaned = synopsis.replaceAll(exp, '').trim();
    return cleaned.isEmpty ? 'Sinopsis tidak tersedia.' : cleaned;
  }

  String get displayRating {
    if (averageRating == null) return 'N/A';
    return averageRating!.toStringAsFixed(1);
  }

  String? get bestCover => coverUrl ?? posterUrl;
}
