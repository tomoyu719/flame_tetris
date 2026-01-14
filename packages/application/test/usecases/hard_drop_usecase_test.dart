import 'package:test/test.dart';
import 'package:tetris_application/tetris_application.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('HardDropUseCase', () {
    late HardDropUseCase useCase;
    late CollisionService collisionService;
    late ScoringService scoringService;

    setUp(() {
      collisionService = _TestCollisionService();
      scoringService = _TestScoringService();
      useCase = HardDropUseCase(
        collisionService: collisionService,
        scoringService: scoringService,
      );
    });

    GameState createGameState({
      Tetromino? currentTetromino,
      Board? board,
      int score = 0,
      GameStatus status = GameStatus.playing,
    }) {
      return GameState(
        board: board ?? Board.empty(),
        currentTetromino:
            currentTetromino ??
            const Tetromino(
              type: TetrominoType.t,
              position: Position(4, 5),
              rotation: RotationState.spawn,
            ),
        heldTetromino: null,
        nextQueue: const [TetrominoType.i, TetrominoType.o, TetrominoType.s],
        score: score,
        level: 1,
        linesCleared: 0,
        status: status,
        canHold: true,
      );
    }

    group('ハードドロップ成功', () {
      test('テトリミノが最下部に移動する', () {
        final state = createGameState();

        final result = useCase.execute(state);

        expect(result.isSuccess, isTrue);
        expect(result.state!.currentTetromino!.position.y, equals(18));
      });

      test('落下距離×2のスコアが加算される', () {
        final state = createGameState(
          score: 100,
          currentTetromino: const Tetromino(
            type: TetrominoType.t,
            position: Position(4, 0),
            rotation: RotationState.spawn,
          ),
        );

        final result = useCase.execute(state);

        // 0 → 18 = 18セル落下 × 2 = 36点
        expect(result.isSuccess, isTrue);
        expect(result.state!.score, equals(100 + 36));
      });

      test('すでに底にいる場合はスコア加算なし', () {
        final state = createGameState(
          score: 100,
          currentTetromino: const Tetromino(
            type: TetrominoType.t,
            position: Position(4, 18),
            rotation: RotationState.spawn,
          ),
        );

        final result = useCase.execute(state);

        expect(result.isSuccess, isTrue);
        expect(result.state!.score, equals(100));
        expect(result.state!.currentTetromino!.position.y, equals(18));
      });
    });

    group('障害物がある場合', () {
      test('障害物の直上で停止する', () {
        var board = Board.empty();
        for (var x = 0; x < Board.defaultWidth; x++) {
          board = board.setCell(Position(x, 15), TetrominoType.i);
        }

        final state = createGameState(
          board: board,
          currentTetromino: const Tetromino(
            type: TetrominoType.t,
            position: Position(4, 5),
            rotation: RotationState.spawn,
          ),
        );

        final result = useCase.execute(state);

        expect(result.isSuccess, isTrue);
        expect(result.state!.currentTetromino!.position.y, equals(13));
      });
    });

    group('ゲーム状態チェック', () {
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

        final result = useCase.execute(state);

        expect(result.isSuccess, isFalse);
        expect(result.failure, isA<InvalidOperationFailure>());
      });

      test('ゲームがプレイ中でない場合は失敗', () {
        final state = createGameState(status: GameStatus.paused);

        final result = useCase.execute(state);

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
