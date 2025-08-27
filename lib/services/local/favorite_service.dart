import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _key = "favorites";

  Future<void> saveFavorites(List<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, favorites);
  }

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<bool> isFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites =  prefs.getStringList(_key) ?? [];

    return favorites.contains(id);
  }


  Future<void> addFavorite(String id) async {
    final favorites = await getFavorites();
    if (!favorites.contains(id)) {
      favorites.add(id);
      await saveFavorites(favorites);
    }
  }

  Future<void> removeFavorite(String id) async {
    final favorites = await getFavorites();
    favorites.remove(id);
    await saveFavorites(favorites);
  }
}
