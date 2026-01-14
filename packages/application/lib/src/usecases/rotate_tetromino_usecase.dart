import 'package:tetris_application/src/usecases/usecase_result.dart';
import 'package:tetris_domain/tetris_domain.dart';

/// テトリミノを回転するユースケース
///
/// 現在のテトリミノをSRSに基づいて回転する。
/// ウォールキックを含めて回転できない場合はRotationFailureを返す。
class RotateTetrominoUseCase {
  /// RotateTetrominoUseCaseを生成
  const RotateTetrominoUseCase({required this.rotationService});

  /// 回転サービス
  final RotationService rotationService;

  /// テトリミノを回転する
  ///
  /// [state]: 現在のゲーム状態
  /// [direction]: 回転方向
  /// Returns: 回転結果
  UseCaseResult execute(GameState state, RotationDirection direction) {
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

    // 回転を試みる
    final result = rotationService.rotate(
      currentTetromino,
      state.board,
      direction,
    );

    if (!result.success) {
      return UseCaseResult.failure(
        const RotationFailure(message: '回転できません'),
      );
    }

    return UseCaseResult.success(
      state.copyWith(currentTetromino: result.tetromino),
    );
  }
}
