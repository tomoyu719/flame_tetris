import 'package:tetris_domain/tetris_domain.dart';

import 'usecase_result.dart';

/// テトリミノをホールドするユースケース
///
/// 現在のテトリミノをホールドし、ホールド中のテトリミノがあれば入れ替える。
/// 1ターンに1回のみホールド可能。
class HoldTetrominoUseCase {
  /// HoldTetrominoUseCaseを生成
  const HoldTetrominoUseCase();

  /// テトリミノをホールド
  ///
  /// [state]: 現在のゲーム状態
  /// [getNextTetromino]: 次のテトリミノを取得するコールバック
  /// Returns: ホールド結果
  UseCaseResult execute(
    GameState state,
    Tetromino Function() getNextTetromino,
  ) {
    // ゲームがプレイ中でなければ失敗
    if (state.status != GameStatus.playing) {
      return UseCaseResult.failure(
        const InvalidOperationFailure(message: 'ゲームがプレイ中ではありません'),
      );
    }

    // 現在のテトリミノがなければ失敗
    final currentTetromino = state.currentTetromino;
    if (currentTetromino == null) {
      return UseCaseResult.failure(
        const InvalidOperationFailure(message: 'テトリミノがありません'),
      );
    }

    // ホールド可能かチェック（1ターン1回制限）
    if (!state.canHold) {
      return UseCaseResult.failure(
        const HoldFailure(message: 'ホールドは1ターンに1回のみです'),
      );
    }

    final heldTetromino = state.heldTetromino;

    if (heldTetromino == null) {
      // ホールドが空の場合：現在のテトリミノをホールドし、次のテトリミノを取得
      final nextTetromino = getNextTetromino();
      return UseCaseResult.success(
        state.copyWith(
          currentTetromino: nextTetromino,
          heldTetromino: Tetromino.spawn(currentTetromino.type),
          canHold: false,
        ),
      );
    } else {
      // ホールドにテトリミノがある場合：入れ替え
      return UseCaseResult.success(
        state.copyWith(
          currentTetromino: Tetromino.spawn(heldTetromino.type),
          heldTetromino: Tetromino.spawn(currentTetromino.type),
          canHold: false,
        ),
      );
    }
  }
}
