import 'package:test/test.dart';
import 'package:tetris_application/tetris_application.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('HoldTetrominoUseCase', () {
    late HoldTetrominoUseCase useCase;
    int nextTetrominoIndex = 0;
    final nextTetrominoTypes = [
      TetrominoType.i,
      TetrominoType.o,
      TetrominoType.s,
    ];

    Tetromino getNextTetromino() {
      final type = nextTetrominoTypes[nextTetrominoIndex % nextTetrominoTypes.length];
      nextTetrominoIndex++;
      return Tetromino.spawn(type);
    }

    setUp(() {
      useCase = const HoldTetrominoUseCase();
      nextTetrominoIndex = 0;
    });

    GameState createGameState({
      Tetromino? currentTetromino,
      Tetromino? heldTetromino,
      bool canHold = true,
      GameStatus status = GameStatus.playing,
    }) {
      return GameState(
        board: Board.empty(),
        currentTetromino: currentTetromino ??
            const Tetromino(
              type: TetrominoType.t,
              position: Position(4, 5),
              rotation: RotationState.spawn,
            ),
        heldTetromino: heldTetromino,
        nextQueue: const [TetrominoType.i, TetrominoType.o, TetrominoType.s],
        score: 0,
        level: 1,
        linesCleared: 0,
        status: status,
        canHold: canHold,
      );
    }

    group('初回ホールド', () {
      test('ホールドが空の場合は現在のテトリミノをホールドし次のテトリミノを取得', () {
        final state = createGameState();

        final result = useCase.execute(state, getNextTetromino);

        expect(result.isSuccess, isTrue);
        expect(result.state!.heldTetromino!.type, equals(TetrominoType.t));
        expect(result.state!.currentTetromino!.type, equals(TetrominoType.i));
        expect(result.state!.canHold, isFalse);
      });

      test('ホールドされたテトリミノはスポーン状態にリセットされる', () {
        final state = createGameState(
          currentTetromino: const Tetromino(
            type: TetrominoType.t,
            position: Position(8, 10),
            rotation: RotationState.clockwise,
          ),
        );

        final result = useCase.execute(state, getNextTetromino);

        expect(result.isSuccess, isTrue);
        expect(result.state!.heldTetromino!.rotation, equals(RotationState.spawn));
      });
    });

    group('交換ホールド', () {
      test('ホールドにテトリミノがある場合は入れ替わる', () {
        final state = createGameState(
          currentTetromino: const Tetromino(
            type: TetrominoType.t,
            position: Position(4, 5),
            rotation: RotationState.spawn,
          ),
          heldTetromino: const Tetromino(
            type: TetrominoType.i,
            position: Position(3, 0),
            rotation: RotationState.spawn,
          ),
        );

        final result = useCase.execute(state, getNextTetromino);

        expect(result.isSuccess, isTrue);
        expect(result.state!.currentTetromino!.type, equals(TetrominoType.i));
        expect(result.state!.heldTetromino!.type, equals(TetrominoType.t));
        expect(result.state!.canHold, isFalse);
      });

      test('交換時は両方ともスポーン状態にリセットされる', () {
        final state = createGameState(
          currentTetromino: const Tetromino(
            type: TetrominoType.t,
            position: Position(8, 10),
            rotation: RotationState.clockwise,
          ),
          heldTetromino: const Tetromino(
            type: TetrominoType.i,
            position: Position(2, 5),
            rotation: RotationState.inverted,
          ),
        );

        final result = useCase.execute(state, getNextTetromino);

        expect(result.isSuccess, isTrue);
        expect(
          result.state!.currentTetromino!.rotation,
          equals(RotationState.spawn),
        );
        expect(
          result.state!.heldTetromino!.rotation,
          equals(RotationState.spawn),
        );
      });
    });

    group('ホールド制限', () {
      test('canHoldがfalseの場合は失敗', () {
        final state = createGameState(canHold: false);

        final result = useCase.execute(state, getNextTetromino);

        expect(result.isSuccess, isFalse);
        expect(result.failure, isA<HoldFailure>());
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

        final result = useCase.execute(state, getNextTetromino);

        expect(result.isSuccess, isFalse);
        expect(result.failure, isA<InvalidOperationFailure>());
      });

      test('ゲームがプレイ中でない場合は失敗', () {
        final state = createGameState(status: GameStatus.paused);

        final result = useCase.execute(state, getNextTetromino);

        expect(result.isSuccess, isFalse);
        expect(result.failure, isA<InvalidOperationFailure>());
      });
    });
  });
}
