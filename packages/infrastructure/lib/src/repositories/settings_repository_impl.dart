import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tetris_domain/tetris_domain.dart';

/// SettingsRepositoryのSharedPreferences実装
///
/// SharedPreferencesを使用して設定を永続化する。
class SettingsRepositoryImpl implements SettingsRepository {
  /// SharedPreferencesキー: ゲーム設定
  static const String _settingsKey = 'game_settings';

  /// SharedPreferencesキー: キーバインド
  static const String _keyBindingsKey = 'key_bindings';

  @override
  Future<GameSettings> getSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_settingsKey);

      if (jsonString == null) {
        return GameSettings();
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return GameSettings.fromJson(json);
    } catch (e) {
      // JSONパースエラーなどの場合はデフォルト値を返す
      return GameSettings();
    }
  }

  @override
  Future<bool> saveSettings(GameSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(settings.toJson());
      return prefs.setString(_settingsKey, jsonString);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<KeyBindings> getKeyBindings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyBindingsKey);

      if (jsonString == null) {
        return KeyBindings();
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return KeyBindings.fromJson(json);
    } catch (e) {
      // JSONパースエラーなどの場合はデフォルト値を返す
      return KeyBindings();
    }
  }

  @override
  Future<bool> saveKeyBindings(KeyBindings bindings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(bindings.toJson());
      return prefs.setString(_keyBindingsKey, jsonString);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> resetToDefaults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_settingsKey);
      await prefs.remove(_keyBindingsKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}
