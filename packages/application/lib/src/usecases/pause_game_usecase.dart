import 'package:tetris_application/src/usecases/usecase_result.dart';
import 'package:tetris_domain/tetris_domain.dart';

/// ゲームの一時停止/再開を行うユースケース
class PauseGameUseCase {
  /// PauseGameUseCaseを生成
  const PauseGameUseCase();

  /// ゲームを一時停止する
  ///
  /// [state]: 現在のゲーム状態
  /// Returns: 一時停止後の状態
  UseCaseResult pause(GameState state) {
    if (state.status != GameStatus.playing) {
      return UseCaseResult.failure(
        const InvalidOperationFailure(message: 'ゲームがプレイ中ではありません'),
      );
    }

    return UseCaseResult.success(
      state.copyWith(status: GameStatus.paused),
    );
  }

  /// ゲームを再開する
  ///
  /// [state]: 現在のゲーム状態
  /// Returns: 再開後の状態
  UseCaseResult resume(GameState state) {
    if (state.status != GameStatus.paused) {
      return UseCaseResult.failure(
        const InvalidOperationFailure(message: 'ゲームが一時停止中ではありません'),
      );
    }

    return UseCaseResult.success(
      state.copyWith(status: GameStatus.playing),
    );
  }

  /// 一時停止と再開をトグルする
  ///
  /// [state]: 現在のゲーム状態
  /// Returns: トグル後の状態
  UseCaseResult toggle(GameState state) {
    if (state.status == GameStatus.playing) {
      return pause(state);
    } else if (state.status == GameStatus.paused) {
      return resume(state);
    } else {
      return UseCaseResult.failure(
        const InvalidOperationFailure(message: 'この状態では一時停止を切り替えられません'),
      );
    }
  }
}
