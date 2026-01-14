import 'package:tetris_application/src/usecases/usecase_result.dart';
import 'package:tetris_domain/tetris_domain.dart';

/// ハードドロップの結果
class HardDropResult {
  /// HardDropResultを生成
  const HardDropResult({
    required this.state,
    required this.cellsDropped,
  });

  /// ドロップ後のゲーム状態
  final GameState state;

  /// 落下したセル数
  final int cellsDropped;
}

/// ハードドロップを実行するユースケース
///
/// テトリミノを即座に最下部まで落下させ、スコアを加算する。
/// 落下後のロック処理は別途GameTickUseCaseで行う。
class HardDropUseCase {
  /// HardDropUseCaseを生成
  const HardDropUseCase({
    required this.collisionService,
    required this.scoringService,
  });

  /// 衝突判定サービス
  final CollisionService collisionService;

  /// スコア計算サービス
  final ScoringService scoringService;

  /// ハードドロップを実行
  ///
  /// [state]: 現在のゲーム状態
  /// Returns: ドロップ結果（成功時はHardDropResultを含む）
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

    // ゴースト位置（最下部）を取得
    final ghostPosition = collisionService.getGhostPosition(
      currentTetromino,
      state.board,
    );

    // 落下したセル数を計算
    final cellsDropped = ghostPosition.position.y - currentTetromino.position.y;

    // スコア加算
    final dropScore = scoringService.calculateHardDropScore(cellsDropped);

    return UseCaseResult.success(
      state.copyWith(
        currentTetromino: ghostPosition,
        score: state.score + dropScore,
      ),
    );
  }
}
