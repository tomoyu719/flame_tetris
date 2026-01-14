import 'package:tetris_domain/tetris_domain.dart';

import 'usecase_result.dart';

/// ソフトドロップを実行するユースケース
///
/// テトリミノを1マス下に移動し、スコアを加算する。
class SoftDropUseCase {
  /// SoftDropUseCaseを生成
  const SoftDropUseCase({
    required this.collisionService,
    required this.scoringService,
  });

  /// 衝突判定サービス
  final CollisionService collisionService;

  /// スコア計算サービス
  final ScoringService scoringService;

  /// ソフトドロップを実行
  ///
  /// [state]: 現在のゲーム状態
  /// Returns: ドロップ結果
  UseCaseResult execute(GameState state) {
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

    // 下に移動できなければ失敗
    if (!collisionService.canMove(
      currentTetromino,
      state.board,
      MoveDirection.down,
    )) {
      return UseCaseResult.failure(
        const MoveFailure(message: 'これ以上下に移動できません'),
      );
    }

    // 移動とスコア加算
    final movedTetromino = currentTetromino.move(MoveDirection.down);
    final dropScore = scoringService.calculateSoftDropScore(1);

    return UseCaseResult.success(
      state.copyWith(
        currentTetromino: movedTetromino,
        score: state.score + dropScore,
      ),
    );
  }
}
