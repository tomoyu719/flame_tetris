import 'package:test/test.dart';
import 'package:tetris_application/tetris_application.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('PauseGameUseCase', () {
    late PauseGameUseCase useCase;

    setUp(() {
      useCase = const PauseGameUseCase();
    });

    GameState createGameState({
      GameStatus status = GameStatus.playing,
    }) {
      return GameState(
        board: Board.empty(),
        currentTetromino: const Tetromino(
          type: TetrominoType.t,
          position: Position(4, 5),
          rotation: RotationState.spawn,
        ),
        heldTetromino: null,
        nextQueue: const [TetrominoType.i, TetrominoType.o, TetrominoType.s],
        score: 1000,
        level: 5,
        linesCleared: 42,
        status: status,
        canHold: true,
      );
    }

    group('pause', () {
      test('プレイ中から一時停止に変更できる', () {
        final state = createGameState(status: GameStatus.playing);

        final result = useCase.pause(state);

        expect(result.isSuccess, isTrue);
        expect(result.state!.status, equals(GameStatus.paused));
      });

      test('他の状態は保持される', () {
        final state = createGameState(status: GameStatus.playing);

        final result = useCase.pause(state);

        expect(result.state!.score, equals(1000));
        expect(result.state!.level, equals(5));
        expect(result.state!.linesCleared, equals(42));
      });

      test('すでに一時停止中の場合は失敗', () {
        final state = createGameState(status: GameStatus.paused);

        final result = useCase.pause(state);

        expect(result.isSuccess, isFalse);
        expect(result.failure, isA<InvalidOperationFailure>());
      });

      test('ゲームオーバー中は失敗', () {
        final state = createGameState(status: GameStatus.gameOver);

        final result = useCase.pause(state);

        expect(result.isSuccess, isFalse);
        expect(result.failure, isA<InvalidOperationFailure>());
      });
    });

    group('resume', () {
      test('一時停止からプレイ中に変更できる', () {
        final state = createGameState(status: GameStatus.paused);

        final result = useCase.resume(state);

        expect(result.isSuccess, isTrue);
        expect(result.state!.status, equals(GameStatus.playing));
      });

      test('プレイ中の場合は失敗', () {
        final state = createGameState(status: GameStatus.playing);

        final result = useCase.resume(state);

        expect(result.isSuccess, isFalse);
        expect(result.failure, isA<InvalidOperationFailure>());
      });

      test('ゲームオーバー中は失敗', () {
        final state = createGameState(status: GameStatus.gameOver);

        final result = useCase.resume(state);

        expect(result.isSuccess, isFalse);
        expect(result.failure, isA<InvalidOperationFailure>());
      });
    });

    group('toggle', () {
      test('プレイ中の場合は一時停止になる', () {
        final state = createGameState(status: GameStatus.playing);

        final result = useCase.toggle(state);

        expect(result.isSuccess, isTrue);
        expect(result.state!.status, equals(GameStatus.paused));
      });

      test('一時停止中の場合はプレイ中になる', () {
        final state = createGameState(status: GameStatus.paused);

        final result = useCase.toggle(state);

        expect(result.isSuccess, isTrue);
        expect(result.state!.status, equals(GameStatus.playing));
      });

      test('ゲームオーバー中は失敗', () {
        final state = createGameState(status: GameStatus.gameOver);

        final result = useCase.toggle(state);

        expect(result.isSuccess, isFalse);
        expect(result.failure, isA<InvalidOperationFailure>());
      });
    });
  });
}
