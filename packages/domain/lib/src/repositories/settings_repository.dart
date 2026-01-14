import 'package:tetris_domain/tetris_domain.dart';

/// 設定のリポジトリインターフェース
///
/// ゲーム設定とキーバインド設定の永続化を担当する。
/// 実装はInfrastructure層で行う。
abstract class SettingsRepository {
  /// ゲーム設定を取得
  ///
  /// 保存されていない場合はデフォルト値を返す。
  Future<GameSettings> getSettings();

  /// ゲーム設定を保存
  ///
  /// 成功した場合はtrue、失敗した場合はfalseを返す。
  Future<bool> saveSettings(GameSettings settings);

  /// キーバインド設定を取得
  ///
  /// 保存されていない場合はデフォルト値を返す。
  Future<KeyBindings> getKeyBindings();

  /// キーバインド設定を保存
  ///
  /// 成功した場合はtrue、失敗した場合はfalseを返す。
  Future<bool> saveKeyBindings(KeyBindings bindings);

  /// 全ての設定をデフォルトにリセット
  ///
  /// 成功した場合はtrue、失敗した場合はfalseを返す。
  Future<bool> resetToDefaults();
}
