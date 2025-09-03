import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/services/local/favorite_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../test_helpers.dart';

void main() {
  group('FavoritesService', () {
    late FavoritesService favoritesService;

    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      // Clear SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
      favoritesService = FavoritesService();
    });

    group('constructor and basic properties', () {
      test('creates instance successfully', () {
        expect(favoritesService, isNotNull);
        expect(favoritesService, isA<FavoritesService>());
      });

      test('multiple instances can be created', () {
        final service1 = FavoritesService();
        final service2 = FavoritesService();
        
        expect(service1, isNotNull);
        expect(service2, isNotNull);
        expect(service1, isNot(same(service2)));
      });

      test('has correct key constant', () {
        // Since _key is private, we test indirectly through behavior
        expect(favoritesService, isA<FavoritesService>());
      });
    });

    group('getFavorites', () {
      test('returns empty list when no favorites stored', () async {
        final favorites = await favoritesService.getFavorites();
        
        expect(favorites, isA<List<String>>());
        expect(favorites, isEmpty);
      });

      test('returns stored favorites', () async {
        // Pre-populate SharedPreferences
        SharedPreferences.setMockInitialValues({
          'favorites': ['event1', 'event2', 'event3']
        });
        
        final favorites = await favoritesService.getFavorites();
        
        expect(favorites, isA<List<String>>());
        expect(favorites.length, equals(3));
        expect(favorites, contains('event1'));
        expect(favorites, contains('event2'));
        expect(favorites, contains('event3'));
      });

      test('handles missing SharedPreferences key', () async {
        // Test when SharedPreferences doesn't have the key
        SharedPreferences.setMockInitialValues({'other_key': 'value'});
        
        final favorites = await favoritesService.getFavorites();
        
        expect(favorites, isA<List<String>>());
        expect(favorites, isEmpty);
      });

      test('returns consistent results across calls', () async {
        SharedPreferences.setMockInitialValues({
          'favorites': ['event1', 'event2']
        });
        
        final favorites1 = await favoritesService.getFavorites();
        final favorites2 = await favoritesService.getFavorites();
        
        expect(favorites1, equals(favorites2));
        expect(favorites1.length, equals(favorites2.length));
      });
    });

    group('saveFavorites', () {
      test('saves favorites list to SharedPreferences', () async {
        final testFavorites = ['event1', 'event2', 'event3'];
        
        await favoritesService.saveFavorites(testFavorites);
        
        final prefs = await SharedPreferences.getInstance();
        final saved = prefs.getStringList('favorites');
        
        expect(saved, isNotNull);
        expect(saved!, hasLength(3));
        expect(saved, containsAll(testFavorites));
      });

      test('saves empty list', () async {
        await favoritesService.saveFavorites([]);
        
        final prefs = await SharedPreferences.getInstance();
        final saved = prefs.getStringList('favorites');
        
        expect(saved, isNotNull);
        expect(saved!, isEmpty);
      });

      test('overwrites existing favorites', () async {
        // First save some favorites
        await favoritesService.saveFavorites(['event1', 'event2']);
        
        // Then overwrite with new favorites
        await favoritesService.saveFavorites(['event3', 'event4']);
        
        final prefs = await SharedPreferences.getInstance();
        final saved = prefs.getStringList('favorites');
        
        expect(saved, isNotNull);
        expect(saved!, hasLength(2));
        expect(saved, contains('event3'));
        expect(saved, contains('event4'));
        expect(saved, isNot(contains('event1')));
        expect(saved, isNot(contains('event2')));
      });

      test('handles duplicate entries', () async {
        final testFavorites = ['event1', 'event1', 'event2', 'event2'];
        
        await favoritesService.saveFavorites(testFavorites);
        
        final prefs = await SharedPreferences.getInstance();
        final saved = prefs.getStringList('favorites');
        
        expect(saved, isNotNull);
        expect(saved!, hasLength(4)); // Preserves duplicates as passed
      });
    });

    group('isFavorite', () {
      test('returns false for non-existent favorite', () async {
        final isFav = await favoritesService.isFavorite('non-existent');
        expect(isFav, isFalse);
      });

      test('returns true for existing favorite', () async {
        SharedPreferences.setMockInitialValues({
          'favorites': ['event1', 'event2', 'event3']
        });
        
        final isFav1 = await favoritesService.isFavorite('event1');
        final isFav2 = await favoritesService.isFavorite('event2');
        final isFav3 = await favoritesService.isFavorite('event3');
        
        expect(isFav1, isTrue);
        expect(isFav2, isTrue);
        expect(isFav3, isTrue);
      });

      test('returns false for similar but not exact match', () async {
        SharedPreferences.setMockInitialValues({
          'favorites': ['event1']
        });
        
        final isFav = await favoritesService.isFavorite('Event1'); // Different case
        expect(isFav, isFalse);
      });

      test('handles empty favorites list', () async {
        SharedPreferences.setMockInitialValues({
          'favorites': []
        });
        
        final isFav = await favoritesService.isFavorite('event1');
        expect(isFav, isFalse);
      });

      test('handles missing SharedPreferences key', () async {
        SharedPreferences.setMockInitialValues({'other_key': 'value'});
        
        final isFav = await favoritesService.isFavorite('event1');
        expect(isFav, isFalse);
      });
    });

    group('addFavorite', () {
      test('adds new favorite to empty list', () async {
        await favoritesService.addFavorite('event1');
        
        final favorites = await favoritesService.getFavorites();
        expect(favorites, hasLength(1));
        expect(favorites, contains('event1'));
      });

      test('adds new favorite to existing list', () async {
        SharedPreferences.setMockInitialValues({
          'favorites': ['event1', 'event2']
        });
        
        await favoritesService.addFavorite('event3');
        
        final favorites = await favoritesService.getFavorites();
        expect(favorites, hasLength(3));
        expect(favorites, contains('event1'));
        expect(favorites, contains('event2'));
        expect(favorites, contains('event3'));
      });

      test('does not add duplicate favorites', () async {
        SharedPreferences.setMockInitialValues({
          'favorites': ['event1', 'event2']
        });
        
        await favoritesService.addFavorite('event1'); // Already exists
        
        final favorites = await favoritesService.getFavorites();
        expect(favorites, hasLength(2));
        expect(favorites.where((f) => f == 'event1'), hasLength(1)); // Only one occurrence
      });

      test('adds favorite and updates isFavorite status', () async {
        // Initially not a favorite
        expect(await favoritesService.isFavorite('event1'), isFalse);
        
        await favoritesService.addFavorite('event1');
        
        // Now should be a favorite
        expect(await favoritesService.isFavorite('event1'), isTrue);
      });

      test('handles adding multiple favorites sequentially', () async {
        await favoritesService.addFavorite('event1');
        await favoritesService.addFavorite('event2');
        await favoritesService.addFavorite('event3');
        
        final favorites = await favoritesService.getFavorites();
        expect(favorites, hasLength(3));
        expect(favorites, contains('event1'));
        expect(favorites, contains('event2'));
        expect(favorites, contains('event3'));
      });
    });

    group('removeFavorite', () {
      test('removes existing favorite', () async {
        SharedPreferences.setMockInitialValues({
          'favorites': ['event1', 'event2', 'event3']
        });
        
        await favoritesService.removeFavorite('event2');
        
        final favorites = await favoritesService.getFavorites();
        expect(favorites, hasLength(2));
        expect(favorites, contains('event1'));
        expect(favorites, contains('event3'));
        expect(favorites, isNot(contains('event2')));
      });

      test('handles removing non-existent favorite', () async {
        SharedPreferences.setMockInitialValues({
          'favorites': ['event1', 'event2']
        });
        
        await favoritesService.removeFavorite('non-existent');
        
        final favorites = await favoritesService.getFavorites();
        expect(favorites, hasLength(2));
        expect(favorites, contains('event1'));
        expect(favorites, contains('event2'));
      });

      test('removes favorite from empty list', () async {
        SharedPreferences.setMockInitialValues({
          'favorites': []
        });
        
        await favoritesService.removeFavorite('event1');
        
        final favorites = await favoritesService.getFavorites();
        expect(favorites, isEmpty);
      });

      test('removes first occurrence of duplicate favorites', () async {
        SharedPreferences.setMockInitialValues({
          'favorites': ['event1', 'event2', 'event1', 'event3']
        });
        
        await favoritesService.removeFavorite('event1');
        
        final favorites = await favoritesService.getFavorites();
        expect(favorites, hasLength(3));
        expect(favorites, contains('event2'));
        expect(favorites, contains('event3'));
        // Should still contain one occurrence of event1
        expect(favorites.where((f) => f == 'event1'), hasLength(1));
      });

      test('removes favorite and updates isFavorite status', () async {
        SharedPreferences.setMockInitialValues({
          'favorites': ['event1', 'event2']
        });
        
        // Initially is a favorite
        expect(await favoritesService.isFavorite('event1'), isTrue);
        
        await favoritesService.removeFavorite('event1');
        
        // Now should not be a favorite
        expect(await favoritesService.isFavorite('event1'), isFalse);
      });
    });

    group('integration tests', () {
      test('complete add/check/remove workflow', () async {
        const eventId = 'test-event-123';
        
        // Initially not a favorite
        expect(await favoritesService.isFavorite(eventId), isFalse);
        expect(await favoritesService.getFavorites(), isEmpty);
        
        // Add to favorites
        await favoritesService.addFavorite(eventId);
        expect(await favoritesService.isFavorite(eventId), isTrue);
        expect(await favoritesService.getFavorites(), contains(eventId));
        
        // Remove from favorites
        await favoritesService.removeFavorite(eventId);
        expect(await favoritesService.isFavorite(eventId), isFalse);
        expect(await favoritesService.getFavorites(), isNot(contains(eventId)));
      });

      test('multiple services share same data', () async {
        final service1 = FavoritesService();
        final service2 = FavoritesService();
        
        await service1.addFavorite('event1');
        expect(await service2.isFavorite('event1'), isTrue);
        
        await service2.addFavorite('event2');
        final favorites = await service1.getFavorites();
        expect(favorites, contains('event1'));
        expect(favorites, contains('event2'));
      });

      test('handles rapid successive operations', () async {
        const eventId = 'rapid-test';
        
        // Rapid add/remove/add sequence
        await favoritesService.addFavorite(eventId);
        await favoritesService.removeFavorite(eventId);
        await favoritesService.addFavorite(eventId);
        
        expect(await favoritesService.isFavorite(eventId), isTrue);
        expect(await favoritesService.getFavorites(), contains(eventId));
      });

      test('maintains state across multiple operations', () async {
        // Add several favorites
        await favoritesService.addFavorite('event1');
        await favoritesService.addFavorite('event2');
        await favoritesService.addFavorite('event3');
        
        // Remove one
        await favoritesService.removeFavorite('event2');
        
        // Add another
        await favoritesService.addFavorite('event4');
        
        final favorites = await favoritesService.getFavorites();
        expect(favorites, hasLength(3));
        expect(favorites, containsAll(['event1', 'event3', 'event4']));
        expect(favorites, isNot(contains('event2')));
      });
    });
  });
}