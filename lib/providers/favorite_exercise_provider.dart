import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// お気に入り種目を管理するプロバイダー
class FavoriteExerciseProvider with ChangeNotifier {
  static const String _favoritesKey = 'favorite_exercises';
  
  Set<String> _favoriteExerciseIds = {};
  bool _isLoaded = false;

  Set<String> get favoriteExerciseIds => _favoriteExerciseIds;
  bool get isLoaded => _isLoaded;

  FavoriteExerciseProvider() {
    _loadFavorites();
  }

  /// お気に入りをローカルストレージから読み込み
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList(_favoritesKey) ?? [];
      _favoriteExerciseIds = favorites.toSet();
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load favorites: $e');
      _isLoaded = true;
      notifyListeners();
    }
  }

  /// お気に入りをローカルストレージに保存
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, _favoriteExerciseIds.toList());
    } catch (e) {
      debugPrint('Failed to save favorites: $e');
    }
  }

  /// 種目がお気に入りかどうかを確認
  bool isFavorite(String exerciseId) {
    return _favoriteExerciseIds.contains(exerciseId);
  }

  /// お気に入りに追加
  Future<void> addFavorite(String exerciseId) async {
    if (_favoriteExerciseIds.add(exerciseId)) {
      notifyListeners();
      await _saveFavorites();
    }
  }

  /// お気に入りから削除
  Future<void> removeFavorite(String exerciseId) async {
    if (_favoriteExerciseIds.remove(exerciseId)) {
      notifyListeners();
      await _saveFavorites();
    }
  }

  /// お気に入りをトグル
  Future<void> toggleFavorite(String exerciseId) async {
    if (isFavorite(exerciseId)) {
      await removeFavorite(exerciseId);
    } else {
      await addFavorite(exerciseId);
    }
  }

  /// お気に入りの数を取得
  int get favoriteCount => _favoriteExerciseIds.length;

  /// お気に入りをすべてクリア
  Future<void> clearAllFavorites() async {
    _favoriteExerciseIds.clear();
    notifyListeners();
    await _saveFavorites();
  }
}
