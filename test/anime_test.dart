import 'package:flutter_test/flutter_test.dart';
import 'package:latres/models/anime.dart';

void main() {
  test('Anime.fromJson parses Kitsu JSON:API payload', () {
    final json = {
      'id': '1',
      'type': 'anime',
      'attributes': {
        'titles': {'en_jp': 'Cowboy Bebop', 'en': 'Cowboy Bebop'},
        'canonicalTitle': 'Cowboy Bebop',
        'averageRating': '82.28',
        'ageRating': 'R',
        'episodeCount': 26,
        'synopsis': 'Space bounty hunters.',
        'posterImage': {'small': 'https://example.com/p.jpg'},
        'coverImage': {'small': 'https://example.com/c.jpg'},
      },
    };

    final anime = Anime.fromJson(json);

    expect(anime.id, 1);
    expect(anime.name, 'Cowboy Bebop');
    expect(anime.posterUrl, 'https://example.com/p.jpg');
    expect(anime.coverUrl, 'https://example.com/c.jpg');
    expect(anime.ageRating, 'R');
    expect(anime.averageRating, 82.28);
    expect(anime.episodeCount, 26);
    expect(anime.synopsis, 'Space bounty hunters.');
    expect(anime.displayRating, '82.3');
  });

  test('Anime.fromJson round-trips Hive flat map', () {
    final original = Anime(
      id: 5,
      name: 'Naruto',
      posterUrl: 'p.jpg',
      coverUrl: 'c.jpg',
      ageRating: 'PG',
      averageRating: 75.0,
      episodeCount: 220,
      synopsis: 'Ninja.',
    );

    final restored = Anime.fromJson(original.toJson());

    expect(restored.id, 5);
    expect(restored.name, 'Naruto');
    expect(restored.posterUrl, 'p.jpg');
    expect(restored.coverUrl, 'c.jpg');
    expect(restored.ageRating, 'PG');
    expect(restored.averageRating, 75.0);
    expect(restored.episodeCount, 220);
    expect(restored.synopsis, 'Ninja.');
  });
}
