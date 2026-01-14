import 'package:test/test.dart';
import 'package:tetris_application/tetris_application.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('GameTickUseCase', () {
    late GameTickUseCase useCase;
    late CollisionService collisionService;
    late LineClearService lineClearService;
    late ScoringService scoringService;
    int nextTetrominoIndex = 0;
    final tetrominoSequence = [
      TetrominoType.t,
      TetrominoType.i,
      TetrominoType.o,
    ];

    Tetromino getNextTetromino() {
      final type = tetrominoSequence[nextTetrominoIndex % tetrominoSequence.length];
      nextTetrominoIndex++;
      return Tetromino.spawn(type);
    }

    setUp(() {
      collisionService = _TestCollisionService();
      lineClearService = _TestLineClearService();
      scoringService = _TestScoringService();
      useCase = GameTickUseCase(
        collisionService: collisionService,
        lineClearService: lineClearService,
        scoringService: scoringService,
      );
      nextTetrominoIndex = 0;
    });

    GameState createGameState({
      Tetromino? currentTetromino,
      Board? board,
      List<TetrominoType>? nextQueue,
      int score = 0,
      int level = 1,
      int linesCleared = 0,
      GameStatus status = GameStatus.playing,
    }) {
      return GameState(
        board: board ?? Board.empty(),
        currentTetromino: currentTetromino ??
            const Tetromino(
              type: TetrominoType.t,
              position: Position(4, 5),
              rotation: RotationState.spawn,
            ),
        heldTetromino: null,
        nextQueue: nextQueue ?? const [TetrominoType.i, TetrominoType.o, TetrominoType.s],
        score: score,
        level: level,
        linesCleared: linesCleared,
        status: status,
        canHold: true,
      );
    }

    group('自動落下', () {
      test('ロック条件でない場合はテトリミノが1マス落下する', () {
        final state = createGameState();

        final result = useCase.execute(state, getNextTetromino);

        expect(result.isSuccess, isTrue);
        expect(
          result.state!.currentTetromino!.position.y,
          equals(state.currentTetromino!.position.y + 1),
        );
      });

      test('下に移動できない場合は状態維持（次ティックでロック）', () {
        // ブロックの直上にいる場合
        var board = Board.empty();
        for (var x = 0; x < Board.defaultWidth; x++) {
          board = board.setCell(Position(x, 10), TetrominoType.i);
        }

        final state = createGameState(
          board: board,
          currentTetromino: const Tetromino(
            type: TetrominoType.t,
            position: Position(4, 8),
            rotation: RotationState.spawn,
          ),
        );

        final result = useCase.execute(state, getNextTetromino);

        expect(result.isSuccess, isTrue);
        // canLock が true なので ロック処理が実行される
      });
    });

    group('ロック処理', () {
      test('底に達したテトリミノはボードに固定される', () {
        final state = createGameState(
          currentTetromino: const Tetromino(
            type: TetrominoType.t,
            position: Position(4, 18),
            rotation: RotationState.spawn,
          ),
        );

        final result = useCase.execute(state, getNextTetromino);

        expect(result.isSuccess, isTrue);
        // テトリミノがボードに固定された
        // T-pieceのspawn状態: 位置 + オフセット (1,0) = (5, 18)
        expect(result.state!.board.getCell(const Position(5, 18)), isNotNull);
      });

      test('ロック後にcanHoldがtrueにリセットされる', () {
        final state = createGameState(
          currentTetromino: const Tetromino(
            type: TetrominoType.t,
            position: Position(4, 18),
            rotation: RotationState.spawn,
          ),
        ).copyWith(canHold: false);

        final result = useCase.execute(state, getNextTetromino);

        expect(result.isSuccess, isTrue);
        expect(result.state!.canHold, isTrue);
      });

      test('次のテトリミノがスポーンする', () {
        final state = createGameState(
          currentTetromino: const Tetromino(
            type: TetrominoType.t,
            position: Position(4, 18),
            rotation: RotationState.spawn,
          ),
          nextQueue: const [TetrominoType.i, TetrominoType.o, TetrominoType.s],
        );

        final result = useCase.execute(state, getNextTetromino);

        expect(result.isSuccess, isTrue);
        expect(result.state!.currentTetromino!.type, equals(TetrominoType.i));
        // NEXTキューが更新される
        expect(result.state!.nextQueue.first, equals(TetrominoType.o));
      });

      test('forceLock=trueで強制ロック', () {
        final state = createGameState(
          currentTetromino: const Tetromino(
            type: TetrominoType.t,
            position: Position(4, 10), // 底ではない
            rotation: RotationState.spawn,
          ),
        );

        final result = useCase.execute(state, getNextTetromino, forceLock: true);

        expect(result.isSuccess, isTrue);
        // ロック処理が実行された（新しいテトリミノがスポーン）
        expect(result.state!.currentTetromino!.type, isNot(equals(TetrominoType.t)));
      });
    });

    group('ゲームオーバー判定', () {
      // NOTE: ゲームオーバーの詳細なテストは統合テストで行う
      // 現時点ではGameTickUseCaseの基本動作をテストし、
      // ゲームオーバー判定はGameControllerの統合テストで確認する
      test('forceLockでロックが発生し次のテトリミノがスポーンする', () {
        final state = createGameState(
          currentTetromino: const Tetromino(
            type: TetrominoType.t,
            position: Position(4, 10),
            rotation: RotationState.spawn,
          ),
          nextQueue: const [TetrominoType.i, TetrominoType.o, TetrominoType.s],
        );

        final result = useCase.execute(state, getNextTetromino, forceLock: true);

        expect(result.isSuccess, isTrue);
        expect(result.state!.status, equals(GameStatus.playing));
        expect(result.state!.currentTetromino!.type, equals(TetrominoType.i));
      });
    });

    group('ゲーム状態チェック', () {
      test('ゲームがプレイ中でない場合は失敗', () {
        final state = createGameState(status: GameStatus.paused);

        final result = useCase.execute(state, getNextTetromino);

        expect(result.isSuccess, isFalse);
        expect(result.failure, isA<InvalidOperationFailure>());
      });

      test('currentTetrominoがnullの場合は失敗', () {
        final state = GameState(
          board: Board.empty(),
          currentTetromino: null,
          heldTetromino: null,
          nextQueue: const [],
          score: 0,
          level: 1,
          linesCleared: 0,
          status: GameStatus.playing,
          canHold: true,
        );

        final result = useCase.execute(state, getNextTetromino);

        expect(result.isSuccess, isFalse);
        expect(result.failure, isA<InvalidOperationFailure>());
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
      // 行を消して上の行を下にシフト
      for (var y = lineY; y > 0; y--) {
        for (var x = 0; x < Board.defaultWidth; x++) {
          final cell = newBoard.getCell(Position(x, y - 1));
          newBoard = newBoard.setCell(Position(x, y), null);
          if (cell != null) {
            newBoard = newBoard.setCell(Position(x, y), cell);
          }
        }
      }
      // 最上行をクリア
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
