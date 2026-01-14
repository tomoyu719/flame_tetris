import 'package:test/test.dart';
import 'package:tetris_application/tetris_application.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('MoveTetrominoUseCase', () {
    late MoveTetrominoUseCase useCase;
    late CollisionService collisionService;

    setUp(() {
      collisionService = _TestCollisionService();
      useCase = MoveTetrominoUseCase(collisionService: collisionService);
    });

    GameState createGameState({
      Tetromino? currentTetromino,
      Board? board,
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
        score: 0,
        level: 1,
        linesCleared: 0,
        status: GameStatus.playing,
        canHold: true,
      );
    }

    group('左移動', () {
      test('左に移動できる', () {
        final state = createGameState();

        final result = useCase.execute(state, MoveDirection.left);

        expect(result.isSuccess, isTrue);
        expect(
          result.state!.currentTetromino!.position.x,
          equals(state.currentTetromino!.position.x - 1),
        );
      });

      test('左壁では移動できない', () {
        final state = createGameState(
          currentTetromino: const Tetromino(
            type: TetrominoType.t,
            position: Position(0, 5),
            rotation: RotationState.spawn,
          ),
        );

        final result = useCase.execute(state, MoveDirection.left);

        expect(result.isSuccess, isFalse);
        expect(result.failure, isA<MoveFailure>());
      });
    });

    group('右移動', () {
      test('右に移動できる', () {
        final state = createGameState();

        final result = useCase.execute(state, MoveDirection.right);

        expect(result.isSuccess, isTrue);
        expect(
          result.state!.currentTetromino!.position.x,
          equals(state.currentTetromino!.position.x + 1),
        );
      });

      test('右壁では移動できない', () {
        final state = createGameState(
          currentTetromino: const Tetromino(
            type: TetrominoType.t,
            position: Position(7, 5),
            rotation: RotationState.spawn,
          ),
        );

        final result = useCase.execute(state, MoveDirection.right);

        expect(result.isSuccess, isFalse);
        expect(result.failure, isA<MoveFailure>());
      });
    });

    group('下移動', () {
      test('下に移動できる', () {
        final state = createGameState();

        final result = useCase.execute(state, MoveDirection.down);

        expect(result.isSuccess, isTrue);
        expect(
          result.state!.currentTetromino!.position.y,
          equals(state.currentTetromino!.position.y + 1),
        );
      });

      test('底では移動できない', () {
        final state = createGameState(
          currentTetromino: const Tetromino(
            type: TetrominoType.t,
            position: Position(4, 18),
            rotation: RotationState.spawn,
          ),
        );

        final result = useCase.execute(state, MoveDirection.down);

        expect(result.isSuccess, isFalse);
        expect(result.failure, isA<MoveFailure>());
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

        final result = useCase.execute(state, MoveDirection.left);

        expect(result.isSuccess, isFalse);
        expect(result.failure, isA<InvalidOperationFailure>());
      });

      test('ゲームがプレイ中でない場合は失敗', () {
        final state = createGameState().copyWith(status: GameStatus.paused);

        final result = useCase.execute(state, MoveDirection.left);

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
