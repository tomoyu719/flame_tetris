import 'package:tetris_domain/tetris_domain.dart';

import 'usecase_result.dart';

/// テトリミノを移動するユースケース
///
/// 現在のテトリミノを指定方向に移動する。
/// 移動できない場合はMoveFailureを返す。
class MoveTetrominoUseCase {
  /// MoveTetrominoUseCaseを生成
  const MoveTetrominoUseCase({required this.collisionService});

  /// 衝突判定サービス
  final CollisionService collisionService;

  /// テトリミノを移動する
  ///
  /// [state]: 現在のゲーム状態
  /// [direction]: 移動方向
  /// Returns: 移動結果
  UseCaseResult execute(GameState state, MoveDirection direction) {
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

    // 移動可能かチェック
    if (!collisionService.canMove(currentTetromino, state.board, direction)) {
      return UseCaseResult.failure(
        const MoveFailure(message: '移動できません'),
      );
    }

    // 移動を実行
    final movedTetromino = currentTetromino.move(direction);

    return UseCaseResult.success(
      state.copyWith(currentTetromino: movedTetromino),
    );
  }
}
