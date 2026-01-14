import 'package:tetris_domain/tetris_domain.dart';

/// 設定保存UseCase
///
/// リポジトリに設定を保存する。
class SaveSettingsUseCase {
  /// SaveSettingsUseCaseを生成
  const SaveSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  /// ゲーム設定を保存
  Future<bool> execute(GameSettings settings) async {
    return _repository.saveSettings(settings);
  }

  /// キーバインド設定を保存
  Future<bool> executeKeyBindings(KeyBindings bindings) async {
    return _repository.saveKeyBindings(bindings);
  }

  /// 設定をデフォルトにリセット
  Future<bool> executeReset() async {
    return _repository.resetToDefaults();
  }
}
