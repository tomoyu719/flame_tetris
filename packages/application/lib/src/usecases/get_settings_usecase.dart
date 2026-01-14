import 'package:tetris_domain/tetris_domain.dart';

/// 設定取得UseCase
///
/// リポジトリから設定を取得する。
class GetSettingsUseCase {
  /// GetSettingsUseCaseを生成
  const GetSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  /// ゲーム設定を取得
  Future<GameSettings> execute() async {
    return _repository.getSettings();
  }

  /// キーバインド設定を取得
  Future<KeyBindings> executeKeyBindings() async {
    return _repository.getKeyBindings();
  }
}
