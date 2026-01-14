import 'package:tetris_domain/src/failures/failure.dart';

/// ゲーム関連の失敗を表すクラス
///
/// ゲームプレイ中に発生する可能性のある失敗を型で表現する。
sealed class GameFailure extends Failure {
  const GameFailure({super.message});
}

/// 衝突による失敗
///
/// テトリミノが他のブロックや壁と衝突した場合に発生
class CollisionFailure extends GameFailure {
  /// CollisionFailureを生成
  const CollisionFailure({super.message});
}

/// 回転失敗
///
/// ウォールキックを含めても回転できない場合に発生
class RotationFailure extends GameFailure {
  /// RotationFailureを生成
  const RotationFailure({super.message});
}

/// 移動失敗
///
/// 指定方向への移動が不可能な場合に発生
class MoveFailure extends GameFailure {
  /// MoveFailureを生成
  const MoveFailure({super.message});
}

/// ゲームオーバー
///
/// 新しいテトリミノをスポーンできない場合に発生
class GameOverFailure extends GameFailure {
  /// GameOverFailureを生成
  const GameOverFailure({super.message});
}

/// ホールド失敗
///
/// ホールドが許可されていない状態で実行しようとした場合に発生
/// （1ターンに1回のみホールド可能）
class HoldFailure extends GameFailure {
  /// HoldFailureを生成
  const HoldFailure({super.message});
}

/// 無効な操作
///
/// 現在のゲーム状態では許可されていない操作を行おうとした場合に発生
class InvalidOperationFailure extends GameFailure {
  /// InvalidOperationFailureを生成
  const InvalidOperationFailure({super.message});
}
