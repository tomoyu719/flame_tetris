import 'package:test/test.dart';
import 'package:tetris_application/tetris_application.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('RotateTetrominoUseCase', () {
    late RotateTetrominoUseCase useCase;
    late RotationService rotationService;

    setUp(() {
      rotationService = _TestRotationService();
      useCase = RotateTetrominoUseCase(rotationService: rotationService);
    });

    GameState createGameState({
      Tetromino? currentTetromino,
      Board? board,
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
        score: 0,
        level: 1,
        linesCleared: 0,
        status: status,
        canHold: true,
      );
    }

    group('時計回り回転', () {
      test('空のボードで回転できる', () {
        final state = createGameState();

        final result = useCase.execute(state, RotationDirection.clockwise);

        expect(result.isSuccess, isTrue);
        expect(
          result.state!.currentTetromino!.rotation,
          equals(RotationState.clockwise),
        );
      });

      test('4回回転で元に戻る', () {
        var state = createGameState();

        for (var i = 0; i < 4; i++) {
          final result = useCase.execute(state, RotationDirection.clockwise);
          expect(result.isSuccess, isTrue);
          state = result.state!;
        }

        expect(
          state.currentTetromino!.rotation,
          equals(RotationState.spawn),
        );
      });
    });

    group('反時計回り回転', () {
      test('空のボードで回転できる', () {
        final state = createGameState();

        final result = useCase.execute(
          state,
          RotationDirection.counterClockwise,
        );

        expect(result.isSuccess, isTrue);
        expect(
          result.state!.currentTetromino!.rotation,
          equals(RotationState.counterClockwise),
        );
      });
    });

    group('回転失敗', () {
      test('回転不可能な状況では失敗', () {
        // 壁に囲まれた状況を作成
        var board = Board.empty();
        for (var y = 4; y <= 7; y++) {
          board = board.setCell(Position(3, y), TetrominoType.i);
          board = board.setCell(Position(6, y), TetrominoType.i);
        }
        for (var x = 3; x <= 6; x++) {
          board = board.setCell(Position(x, 4), TetrominoType.i);
          board = board.setCell(Position(x, 7), TetrominoType.i);
        }

        final state = createGameState(
          board: board,
          currentTetromino: const Tetromino(
            type: TetrominoType.t,
            position: Position(4, 5),
            rotation: RotationState.spawn,
          ),
        );

        final result = useCase.execute(state, RotationDirection.clockwise);

        expect(result.isSuccess, isFalse);
        expect(result.failure, isA<RotationFailure>());
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

        final result = useCase.execute(state, RotationDirection.clockwise);

        expect(result.isSuccess, isFalse);
        expect(result.failure, isA<InvalidOperationFailure>());
      });

      test('ゲームがプレイ中でない場合は失敗', () {
        final state = createGameState(status: GameStatus.paused);

        final result = useCase.execute(state, RotationDirection.clockwise);

        expect(result.isSuccess, isFalse);
        expect(result.failure, isA<InvalidOperationFailure>());
      });
    });
  });
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

    // 簡易的な衝突判定
    if (_isValidPosition(rotated, board)) {
      return RotationResult(
        tetromino: rotated,
        success: true,
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
    final rotated = tetromino.rotate(direction);

    if (_isValidPosition(rotated, board)) {
      return RotationResult(
        tetromino: rotated,
        success: true,
      );
    }

    return RotationResult.failed(tetromino);
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
