import '../entities/entities.dart';
import '../enums/enums.dart';

/// 回転結果を表すクラス
class RotationResult {
  /// 回転後のテトリミノ
  final Tetromino tetromino;

  /// 回転が成功したかどうか
  final bool success;

  /// 使用されたウォールキックのインデックス（0-4、キックなしは0）
  final int kickIndex;

  const RotationResult({
    required this.tetromino,
    required this.success,
    this.kickIndex = 0,
  });

  /// 回転失敗を表すファクトリ
  factory RotationResult.failed(Tetromino original) {
    return RotationResult(
      tetromino: original,
      success: false,
      kickIndex: -1,
    );
  }
}

/// SRS（Super Rotation System）に基づく回転サービスのインターフェース
///
/// テトリミノの回転とウォールキックを処理する。
/// 実装はInfrastructure層で提供される。
abstract class RotationService {
  /// テトリミノを回転させる（ウォールキック適用）
  ///
  /// SRSに基づき、以下の順序で回転を試みる：
  /// 1. 基本回転（キックなし）
  /// 2. ウォールキックテスト1-4
  ///
  /// [tetromino] 回転対象のテトリミノ
  /// [board] 現在のボード状態
  /// [direction] 回転方向
  /// Returns: 回転結果（成功/失敗と回転後のテトリミノ）
  RotationResult rotate(
    Tetromino tetromino,
    Board board,
    RotationDirection direction,
  );

  /// 基本回転のみを試みる（ウォールキックなし）
  ///
  /// [tetromino] 回転対象のテトリミノ
  /// [board] 現在のボード状態
  /// [direction] 回転方向
  /// Returns: 回転結果
  RotationResult rotateWithoutKick(
    Tetromino tetromino,
    Board board,
    RotationDirection direction,
  );
}
