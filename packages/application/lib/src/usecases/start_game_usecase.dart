import 'package:tetris_domain/tetris_domain.dart';

/// ゲーム開始のユースケース
///
/// 新しいゲームを開始し、初期状態を生成する。
class StartGameUseCase {
  /// StartGameUseCaseを生成
  const StartGameUseCase();

  /// ゲームを開始する
  ///
  /// [getNextTetromino]: 次のテトリミノを取得するコールバック
  /// [nextQueueSize]: NEXTキューのサイズ（デフォルト3）
  /// Returns: 初期ゲーム状態
  GameState execute(
    TetrominoType Function() getNextTetromino, {
    int nextQueueSize = 3,
  }) {
    // NEXTキューを生成
    final nextQueue = <TetrominoType>[];
    for (var i = 0; i < nextQueueSize; i++) {
      nextQueue.add(getNextTetromino());
    }

    // 最初のテトリミノを取得
    final firstTetromino = Tetromino.spawn(getNextTetromino());

    return GameState(
      board: Board.empty(),
      currentTetromino: firstTetromino,
      heldTetromino: null,
      nextQueue: nextQueue,
      score: 0,
      level: 1,
      linesCleared: 0,
      status: GameStatus.playing,
      canHold: true,
    );
  }
}
