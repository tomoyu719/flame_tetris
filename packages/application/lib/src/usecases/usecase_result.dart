import 'package:tetris_domain/tetris_domain.dart';

/// UseCaseの実行結果を表すクラス
///
/// 成功時は[state]に新しいGameStateが、
/// 失敗時は[failure]にFailureが格納される。
class UseCaseResult {
  const UseCaseResult._({
    this.state,
    this.failure,
  });

  /// 成功結果を生成
  factory UseCaseResult.success(GameState state) {
    return UseCaseResult._(state: state);
  }

  /// 失敗結果を生成
  factory UseCaseResult.failure(Failure failure) {
    return UseCaseResult._(failure: failure);
  }

  /// 成功時の新しいゲーム状態
  final GameState? state;

  /// 失敗時のエラー情報
  final Failure? failure;

  /// 成功かどうか
  bool get isSuccess => state != null;

  /// 失敗かどうか
  bool get isFailure => failure != null;
}
