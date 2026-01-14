import 'package:test/test.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('GameState', () {
    group('コンストラクタ', () {
      test('initial()で初期状態を生成できる', () {
        final state = GameState.initial();

        expect(state.board, isA<Board>());
        expect(state.currentTetromino, isNull);
        expect(state.heldTetromino, isNull);
        expect(state.nextQueue, isEmpty);
        expect(state.score, equals(0));
        expect(state.level, equals(1));
        expect(state.linesCleared, equals(0));
        expect(state.status, equals(GameStatus.ready));
        expect(state.canHold, isTrue);
      });

      test('全てのフィールドを指定して生成できる', () {
        final board = Board.empty();
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(4, 5),
          rotation: RotationState.spawn,
        );

        final state = GameState(
          board: board,
          currentTetromino: tetromino,
          heldTetromino: null,
          nextQueue: [TetrominoType.i, TetrominoType.o, TetrominoType.s],
          score: 1000,
          level: 3,
          linesCleared: 25,
          status: GameStatus.playing,
          canHold: false,
        );

        expect(state.board, equals(board));
        expect(state.currentTetromino, equals(tetromino));
        expect(state.heldTetromino, isNull);
        expect(state.nextQueue, hasLength(3));
        expect(state.score, equals(1000));
        expect(state.level, equals(3));
        expect(state.linesCleared, equals(25));
        expect(state.status, equals(GameStatus.playing));
        expect(state.canHold, isFalse);
      });
    });

    group('copyWith', () {
      test('scoreのみ変更できる', () {
        final original = GameState.initial();

        final result = original.copyWith(score: 500);

        expect(result.score, equals(500));
        expect(result.level, equals(original.level));
        expect(result.status, equals(original.status));
      });

      test('statusのみ変更できる', () {
        final original = GameState.initial();

        final result = original.copyWith(status: GameStatus.playing);

        expect(result.status, equals(GameStatus.playing));
        expect(result.score, equals(original.score));
      });

      test('複数フィールドを同時に変更できる', () {
        final original = GameState.initial();

        final result = original.copyWith(
          score: 1000,
          level: 5,
          status: GameStatus.gameOver,
        );

        expect(result.score, equals(1000));
        expect(result.level, equals(5));
        expect(result.status, equals(GameStatus.gameOver));
      });

      test('currentTetrominoを変更できる', () {
        final original = GameState.initial();
        const newTetromino = Tetromino(
          type: TetrominoType.i,
          position: Position(3, 0),
          rotation: RotationState.spawn,
        );

        final result = original.copyWith(currentTetromino: newTetromino);

        expect(result.currentTetromino, equals(newTetromino));
      });

      test('nextQueueを変更できる', () {
        final original = GameState.initial();
        const newQueue = [TetrominoType.z, TetrominoType.j];

        final result = original.copyWith(nextQueue: newQueue);

        expect(result.nextQueue, equals(newQueue));
      });
    });

    group('isGameOver', () {
      test('statusがgameOverのときtrue', () {
        final state = GameState.initial().copyWith(status: GameStatus.gameOver);

        expect(state.isGameOver, isTrue);
      });

      test('statusがplayingのときfalse', () {
        final state = GameState.initial().copyWith(status: GameStatus.playing);

        expect(state.isGameOver, isFalse);
      });
    });

    group('isPlaying', () {
      test('statusがplayingのときtrue', () {
        final state = GameState.initial().copyWith(status: GameStatus.playing);

        expect(state.isPlaying, isTrue);
      });

      test('statusがpausedのときfalse', () {
        final state = GameState.initial().copyWith(status: GameStatus.paused);

        expect(state.isPlaying, isFalse);
      });
    });

    group('isPaused', () {
      test('statusがpausedのときtrue', () {
        final state = GameState.initial().copyWith(status: GameStatus.paused);

        expect(state.isPaused, isTrue);
      });

      test('statusがplayingのときfalse', () {
        final state = GameState.initial().copyWith(status: GameStatus.playing);

        expect(state.isPaused, isFalse);
      });
    });

    group('等価性', () {
      test('同じ状態のGameStateは等しい', () {
        final state1 = GameState.initial();
        final state2 = GameState.initial();

        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('異なる状態のGameStateは等しくない', () {
        final state1 = GameState.initial();
        final state2 = GameState.initial().copyWith(score: 100);

        expect(state1, isNot(equals(state2)));
      });
    });
  });
}
