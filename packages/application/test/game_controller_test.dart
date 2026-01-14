import 'dart:math';

import 'package:test/test.dart';
import 'package:tetris_application/tetris_application.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('GameController', () {
    late GameController controller;
    late TetrominoGenerator generator;
    late CollisionService collisionService;
    late RotationService rotationService;
    late LineClearService lineClearService;
    late ScoringService scoringService;

    setUp(() {
      // シード固定で再現性のあるテスト
      generator = TetrominoGenerator(random: Random(42));
      collisionService = _TestCollisionService();
      rotationService = _TestRotationService();
      lineClearService = _TestLineClearService();
      scoringService = _TestScoringService();
      controller = GameController(
        generator: generator,
        collisionService: collisionService,
        rotationService: rotationService,
        lineClearService: lineClearService,
        scoringService: scoringService,
      );
    });

    group('初期化', () {
      test('初期状態はnull', () {
        expect(controller.state, isNull);
      });

      test('isPlaying/isPaused/isGameOverは全てfalse', () {
        expect(controller.isPlaying, isFalse);
        expect(controller.isPaused, isFalse);
        expect(controller.isGameOver, isFalse);
      });
    });

    group('startGame', () {
      test('ゲームを開始できる', () {
        controller.startGame();

        expect(controller.state, isNotNull);
        expect(controller.state!.status, equals(GameStatus.playing));
        expect(controller.isPlaying, isTrue);
      });

      test('開始後はcurrentTetrominoが設定される', () {
        controller.startGame();

        expect(controller.state!.currentTetromino, isNotNull);
      });

      test('開始後はNEXTキューが3個設定される', () {
        controller.startGame();

        expect(controller.state!.nextQueue.length, equals(3));
      });

      test('NEXTキューサイズをカスタマイズできる', () {
        controller.startGame(nextQueueSize: 5);

        expect(controller.state!.nextQueue.length, equals(5));
      });

      test('スコアは0で開始', () {
        controller.startGame();

        expect(controller.state!.score, equals(0));
      });
    });

    group('move', () {
      setUp(() {
        controller.startGame();
      });

      test('左に移動できる', () {
        final initialX = controller.state!.currentTetromino!.position.x;

        final result = controller.move(MoveDirection.left);

        expect(result, isTrue);
        expect(
          controller.state!.currentTetromino!.position.x,
          equals(initialX - 1),
        );
      });

      test('右に移動できる', () {
        final initialX = controller.state!.currentTetromino!.position.x;

        final result = controller.move(MoveDirection.right);

        expect(result, isTrue);
        expect(
          controller.state!.currentTetromino!.position.x,
          equals(initialX + 1),
        );
      });

      test('下に移動できる', () {
        final initialY = controller.state!.currentTetromino!.position.y;

        final result = controller.move(MoveDirection.down);

        expect(result, isTrue);
        expect(
          controller.state!.currentTetromino!.position.y,
          equals(initialY + 1),
        );
      });

      test('ゲームが開始されていない場合は失敗', () {
        final freshController = GameController(
          generator: generator,
          collisionService: collisionService,
          rotationService: rotationService,
          lineClearService: lineClearService,
          scoringService: scoringService,
        );

        final result = freshController.move(MoveDirection.left);

        expect(result, isFalse);
      });
    });

    group('rotate', () {
      setUp(() {
        controller.startGame();
      });

      test('時計回りに回転できる', () {
        final initialRotation = controller.state!.currentTetromino!.rotation;

        final result = controller.rotate(RotationDirection.clockwise);

        expect(result, isTrue);
        expect(
          controller.state!.currentTetromino!.rotation,
          isNot(equals(initialRotation)),
        );
      });

      test('反時計回りに回転できる', () {
        final initialRotation = controller.state!.currentTetromino!.rotation;

        final result = controller.rotate(RotationDirection.counterClockwise);

        expect(result, isTrue);
        expect(
          controller.state!.currentTetromino!.rotation,
          isNot(equals(initialRotation)),
        );
      });

      test('ゲームが開始されていない場合は失敗', () {
        final freshController = GameController(
          generator: generator,
          collisionService: collisionService,
          rotationService: rotationService,
          lineClearService: lineClearService,
          scoringService: scoringService,
        );

        final result = freshController.rotate(RotationDirection.clockwise);

        expect(result, isFalse);
      });
    });

    group('softDrop', () {
      setUp(() {
        controller.startGame();
      });

      test('ソフトドロップで1マス落下しスコアが増える', () {
        final initialY = controller.state!.currentTetromino!.position.y;
        final initialScore = controller.state!.score;

        final result = controller.softDrop();

        expect(result, isTrue);
        expect(
          controller.state!.currentTetromino!.position.y,
          equals(initialY + 1),
        );
        expect(controller.state!.score, equals(initialScore + 1));
      });

      test('ゲームが開始されていない場合は失敗', () {
        final freshController = GameController(
          generator: generator,
          collisionService: collisionService,
          rotationService: rotationService,
          lineClearService: lineClearService,
          scoringService: scoringService,
        );

        final result = freshController.softDrop();

        expect(result, isFalse);
      });
    });

    group('hardDrop', () {
      setUp(() {
        controller.startGame();
      });

      test('ハードドロップでテトリミノが即座に着地', () {
        final initialType = controller.state!.currentTetromino!.type;

        final result = controller.hardDrop();

        expect(result, isTrue);
        // 新しいテトリミノに変わっている（ロック処理が発生）
        expect(
          controller.state!.currentTetromino!.type,
          isNot(equals(initialType)),
        );
      });

      test('ハードドロップでスコアが増える', () {
        final initialScore = controller.state!.score;

        controller.hardDrop();

        expect(controller.state!.score, greaterThan(initialScore));
      });

      test('ゲームが開始されていない場合は失敗', () {
        final freshController = GameController(
          generator: generator,
          collisionService: collisionService,
          rotationService: rotationService,
          lineClearService: lineClearService,
          scoringService: scoringService,
        );

        final result = freshController.hardDrop();

        expect(result, isFalse);
      });
    });

    group('hold', () {
      setUp(() {
        controller.startGame();
      });

      test('ホールドでテトリミノを保持できる', () {
        final currentType = controller.state!.currentTetromino!.type;

        final result = controller.hold();

        expect(result, isTrue);
        expect(controller.state!.heldTetromino, isNotNull);
        expect(controller.state!.heldTetromino!.type, equals(currentType));
      });

      test('ホールド後はcanHoldがfalse', () {
        controller.hold();

        expect(controller.state!.canHold, isFalse);
      });

      test('連続ホールドは失敗', () {
        controller.hold();

        final result = controller.hold();

        expect(result, isFalse);
      });

      test('ゲームが開始されていない場合は失敗', () {
        final freshController = GameController(
          generator: generator,
          collisionService: collisionService,
          rotationService: rotationService,
          lineClearService: lineClearService,
          scoringService: scoringService,
        );

        final result = freshController.hold();

        expect(result, isFalse);
      });
    });

    group('pause/resume', () {
      setUp(() {
        controller.startGame();
      });

      test('一時停止できる', () {
        final result = controller.pause();

        expect(result, isTrue);
        expect(controller.isPaused, isTrue);
        expect(controller.isPlaying, isFalse);
      });

      test('再開できる', () {
        controller.pause();

        final result = controller.resume();

        expect(result, isTrue);
        expect(controller.isPlaying, isTrue);
        expect(controller.isPaused, isFalse);
      });

      test('toggleで一時停止/再開を切り替え', () {
        controller.togglePause();
        expect(controller.isPaused, isTrue);

        controller.togglePause();
        expect(controller.isPlaying, isTrue);
      });

      test('ゲームが開始されていない場合は失敗', () {
        final freshController = GameController(
          generator: generator,
          collisionService: collisionService,
          rotationService: rotationService,
          lineClearService: lineClearService,
          scoringService: scoringService,
        );

        expect(freshController.pause(), isFalse);
        expect(freshController.resume(), isFalse);
        expect(freshController.togglePause(), isFalse);
      });
    });

    group('tick', () {
      setUp(() {
        controller.startGame();
      });

      test('ティックでテトリミノが1マス落下', () {
        final initialY = controller.state!.currentTetromino!.position.y;

        final result = controller.tick();

        expect(result, isTrue);
        expect(
          controller.state!.currentTetromino!.position.y,
          equals(initialY + 1),
        );
      });

      test('一時停止中はティック無効', () {
        controller.pause();
        final stateBeforeTick = controller.state;

        final result = controller.tick();

        expect(result, isFalse);
        expect(controller.state, equals(stateBeforeTick));
      });

      test('ゲームが開始されていない場合は失敗', () {
        final freshController = GameController(
          generator: generator,
          collisionService: collisionService,
          rotationService: rotationService,
          lineClearService: lineClearService,
          scoringService: scoringService,
        );

        final result = freshController.tick();

        expect(result, isFalse);
      });
    });

    group('restart', () {
      test('ゲーム中からリスタートできる', () {
        controller.startGame();
        // 少し進める
        controller.move(MoveDirection.left);
        controller.softDrop();

        controller.restart();

        expect(controller.state!.score, equals(0));
        expect(controller.state!.status, equals(GameStatus.playing));
      });

      test('ゲームオーバー後にリスタートできる', () {
        controller.startGame();
        // 状態を直接変更してゲームオーバーにする（テスト用）
        controller.forceState(
          controller.state!.copyWith(status: GameStatus.gameOver),
        );
        expect(controller.isGameOver, isTrue);

        controller.restart();

        expect(controller.isPlaying, isTrue);
      });
    });

    group('ghostPosition', () {
      setUp(() {
        controller.startGame();
      });

      test('ゴースト位置を取得できる', () {
        final ghost = controller.ghostPosition;

        expect(ghost, isNotNull);
        expect(ghost!.type, equals(controller.state!.currentTetromino!.type));
        expect(
          ghost.position.y,
          greaterThanOrEqualTo(controller.state!.currentTetromino!.position.y),
        );
      });

      test('ゲームが開始されていない場合はnull', () {
        final freshController = GameController(
          generator: generator,
          collisionService: collisionService,
          rotationService: rotationService,
          lineClearService: lineClearService,
          scoringService: scoringService,
        );

        expect(freshController.ghostPosition, isNull);
      });
    });
  });
}

/// テスト用のCollisionService実装
class _TestCollisionService implements CollisionService {
  @override
  bool isValidPosition(Tetromino tetromino, Board board) {
    final shapes = TetrominoShapes.getShape(tetromino.type, tetromino.rotation);
    for (final offset in shapes) {
      final x = tetromino.position.x + offset.x;
      final y = tetromino.position.y + offset.y;
      if (x < 0 || x >= Board.defaultWidth || y >= Board.defaultHeight) {
        return false;
      }
      if (y < 0) continue;
      if (board.getCell(Position(x, y)) != null) {
        return false;
      }
    }
    return true;
  }

  @override
  bool canMove(Tetromino tetromino, Board board, MoveDirection direction) {
    final moved = tetromino.move(direction);
    return isValidPosition(moved, board);
  }

  @override
  bool canRotate(
    Tetromino tetromino,
    Board board,
    RotationDirection direction,
  ) {
    final rotated = tetromino.rotate(direction);
    return isValidPosition(rotated, board);
  }

  @override
  bool canLock(Tetromino tetromino, Board board) {
    return !canMove(tetromino, board, MoveDirection.down);
  }

  @override
  Tetromino getGhostPosition(Tetromino tetromino, Board board) {
    var ghost = tetromino;
    while (canMove(ghost, board, MoveDirection.down)) {
      ghost = ghost.move(MoveDirection.down);
    }
    return ghost;
  }
}

/// テスト用のRotationService実装
class _TestRotationService implements RotationService {
  @override
  RotationResult rotate(
    Tetromino tetromino,
    Board board,
    RotationDirection direction,
  ) {
    final rotated = tetromino.rotate(direction);

    if (_isValidPosition(rotated, board)) {
      return RotationResult(
        tetromino: rotated,
        success: true,
        kickIndex: 0,
      );
    }

    return RotationResult.failed(tetromino);
  }

  @override
  RotationResult rotateWithoutKick(
    Tetromino tetromino,
    Board board,
    RotationDirection direction,
  ) {
    return rotate(tetromino, board, direction);
  }

  bool _isValidPosition(Tetromino tetromino, Board board) {
    final shapes = TetrominoShapes.getShape(tetromino.type, tetromino.rotation);
    for (final offset in shapes) {
      final x = tetromino.position.x + offset.x;
      final y = tetromino.position.y + offset.y;
      if (x < 0 || x >= Board.defaultWidth || y >= Board.defaultHeight) {
        return false;
      }
      if (y < 0) continue;
      if (board.getCell(Position(x, y)) != null) {
        return false;
      }
    }
    return true;
  }
}

/// テスト用のLineClearService実装
class _TestLineClearService implements LineClearService {
  @override
  bool isLineComplete(Board board, int y) {
    for (var x = 0; x < Board.defaultWidth; x++) {
      if (board.getCell(Position(x, y)) == null) {
        return false;
      }
    }
    return true;
  }

  @override
  List<int> getCompletedLineIndices(Board board) {
    final indices = <int>[];
    for (var y = 0; y < Board.defaultHeight; y++) {
      if (isLineComplete(board, y)) {
        indices.add(y);
      }
    }
    return indices;
  }

  @override
  LineClearResult clearLines(Board board) {
    final completedLines = getCompletedLineIndices(board);
    if (completedLines.isEmpty) {
      return LineClearResult(
        board: board,
        linesCleared: LinesCleared.none,
        clearedLineIndices: const [],
      );
    }

    var newBoard = board;
    for (final lineY in completedLines.reversed) {
      for (var y = lineY; y > 0; y--) {
        for (var x = 0; x < Board.defaultWidth; x++) {
          final cell = newBoard.getCell(Position(x, y - 1));
          newBoard = newBoard.setCell(Position(x, y), null);
          if (cell != null) {
            newBoard = newBoard.setCell(Position(x, y), cell);
          }
        }
      }
      for (var x = 0; x < Board.defaultWidth; x++) {
        newBoard = newBoard.setCell(Position(x, 0), null);
      }
    }

    return LineClearResult(
      board: newBoard,
      linesCleared: LinesCleared(completedLines.length),
      clearedLineIndices: completedLines,
    );
  }
}

/// テスト用のScoringService実装
class _TestScoringService implements ScoringService {
  @override
  int calculateLineClearScore(LinesCleared linesCleared, Level level) {
    const baseScores = [0, 100, 300, 500, 800];
    return baseScores[linesCleared.value] * level.value;
  }

  @override
  int calculateSoftDropScore(int cells) => cells;

  @override
  int calculateHardDropScore(int cells) => cells * 2;
}
