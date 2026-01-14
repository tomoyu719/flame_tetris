import 'package:tetris_domain/tetris_domain.dart';

import 'usecase_result.dart';

/// ゲームティックの結果
class GameTickResult {
  const GameTickResult({
    required this.state,
    required this.linesCleared,
    required this.locked,
    required this.gameOver,
  });

  /// 更新後のゲーム状態
  final GameState state;

  /// 今回消去されたライン数
  final int linesCleared;

  /// テトリミノがロックされたかどうか
  final bool locked;

  /// ゲームオーバーになったかどうか
  final bool gameOver;
}

/// ゲームティック（自動落下+着地処理）を行うユースケース
///
/// 定期的に呼び出され、テトリミノの自動落下とロック処理を行う。
class GameTickUseCase {
  /// GameTickUseCaseを生成
  const GameTickUseCase({
    required this.collisionService,
    required this.lineClearService,
    required this.scoringService,
  });

  /// 衝突判定サービス
  final CollisionService collisionService;

  /// ライン消去サービス
  final LineClearService lineClearService;

  /// スコア計算サービス
  final ScoringService scoringService;

  /// ゲームティックを実行
  ///
  /// [state]: 現在のゲーム状態
  /// [getNextTetromino]: 次のテトリミノを取得するコールバック
  /// [forcelock]: 強制ロック（ハードドロップ後など）
  /// Returns: ティック結果
  UseCaseResult execute(
    GameState state,
    Tetromino Function() getNextTetromino, {
    bool forceLock = false,
  }) {
    // ゲームがプレイ中でなければ何もしない
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

    // ロック判定
    final shouldLock =
        forceLock || collisionService.canLock(currentTetromino, state.board);

    if (shouldLock) {
      return _lockTetromino(state, currentTetromino, getNextTetromino);
    } else {
      // 自動落下
      return _autoFall(state, currentTetromino);
    }
  }

  /// テトリミノをロックする
  UseCaseResult _lockTetromino(
    GameState state,
    Tetromino tetromino,
    Tetromino Function() getNextTetromino,
  ) {
    // テトリミノをボードに配置
    var board = state.board;
    final shapes = TetrominoShapes.getShape(tetromino.type, tetromino.rotation);

    for (final offset in shapes) {
      final x = tetromino.position.x + offset.x;
      final y = tetromino.position.y + offset.y;

      if (y >= 0 && y < Board.defaultHeight && x >= 0 && x < Board.defaultWidth) {
        board = board.setCell(Position(x, y), tetromino.type);
      }
    }

    // ライン消去
    final clearResult = lineClearService.clearLines(board);
    board = clearResult.board;

    // スコア計算
    final level = Level(state.level.clamp(1, 15));
    final lineScore = scoringService.calculateLineClearScore(
      clearResult.linesCleared,
      level,
    );

    // レベルアップ判定（10ライン消去ごとにレベルアップ）
    final newTotalLines = state.linesCleared + clearResult.linesCleared.value;
    final newLevel = (newTotalLines ~/ 10 + 1).clamp(1, 15);

    // 次のテトリミノを取得
    final nextTetromino = getNextTetromino();

    // 新しいテトリミノをスポーン
    final spawned = Tetromino.spawn(
      state.nextQueue.isNotEmpty ? state.nextQueue.first : nextTetromino.type,
    );

    // NEXTキューを更新
    final newNextQueue = [
      ...state.nextQueue.skip(1),
      nextTetromino.type,
    ];

    // ゲームオーバー判定（スポーン位置が無効な場合）
    final isGameOver = !collisionService.isValidPosition(spawned, board);

    return UseCaseResult.success(
      state.copyWith(
        board: board,
        currentTetromino: isGameOver ? null : spawned,
        nextQueue: newNextQueue,
        score: state.score + lineScore,
        level: newLevel,
        linesCleared: newTotalLines,
        status: isGameOver ? GameStatus.gameOver : GameStatus.playing,
        canHold: true, // ロック後はホールド可能に戻る
      ),
    );
  }

  /// 自動落下
  UseCaseResult _autoFall(GameState state, Tetromino tetromino) {
    if (collisionService.canMove(tetromino, state.board, MoveDirection.down)) {
      final fallen = tetromino.move(MoveDirection.down);
      return UseCaseResult.success(
        state.copyWith(currentTetromino: fallen),
      );
    } else {
      // 落下できない場合は現状維持（次のティックでロックされる）
      return UseCaseResult.success(state);
    }
  }
}
