import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tetris_domain/tetris_domain.dart';

/// [ScoreRepository]のSharedPreferencesを使用した実装
///
/// ハイスコアをJSON形式でSharedPreferencesに保存する。
class ScoreRepositoryImpl implements ScoreRepository {
  /// SharedPreferencesのキー
  static const String _highScoreKey = 'high_score';

  @override
  Future<HighScore> getHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_highScoreKey);

      if (jsonString == null) {
        return HighScore.empty();
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return HighScore.fromJson(json);
    } catch (e) {
      // JSONのパースに失敗した場合は空のハイスコアを返す
      return HighScore.empty();
    }
  }

  @override
  Future<bool> saveHighScore(HighScore highScore) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(highScore.toJson());
      return prefs.setString(_highScoreKey, jsonString);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> clearHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.remove(_highScoreKey);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isHighScore(int score) async {
    if (score <= 0) {
      return false;
    }

    final currentHighScore = await getHighScore();
    return score > currentHighScore.score;
  }
}
