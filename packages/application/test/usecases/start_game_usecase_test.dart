import 'package:test/test.dart';
import 'package:tetris_application/tetris_application.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('StartGameUseCase', () {
    late StartGameUseCase useCase;
    var nextTetrominoIndex = 0;
    final tetrominoSequence = [
      TetrominoType.t,
      TetrominoType.i,
      TetrominoType.o,
      TetrominoType.s,
      TetrominoType.z,
    ];

    TetrominoType getNextTetromino() {
      final index = nextTetrominoIndex % tetrominoSequence.length;
      final type = tetrominoSequence[index];
      nextTetrominoIndex++;
      return type;
    }

    setUp(() {
      useCase = const StartGameUseCase();
      nextTetrominoIndex = 0;
    });

    group('ゲーム初期化', () {
      test('初期状態が正しく設定される', () {
        final state = useCase.execute(getNextTetromino);

        expect(state.status, equals(GameStatus.playing));
        expect(state.score, equals(0));
        expect(state.level, equals(1));
        expect(state.linesCleared, equals(0));
        expect(state.canHold, isTrue);
        expect(state.heldTetromino, isNull);
        expect(state.board, equals(Board.empty()));
      });

      test('最初のテトリミノが設定される', () {
        final state = useCase.execute(getNextTetromino);

        expect(state.currentTetromino, isNotNull);
        // sequence: T, I, O, S, Z - 4番目(index 3)のS がcurrentになる
        // nextQueue: [T, I, O] (3個)、currentは4番目
        expect(state.currentTetromino!.type, equals(TetrominoType.s));
      });

      test('NEXTキューがデフォルト3個で生成される', () {
        final state = useCase.execute(getNextTetromino);

        expect(state.nextQueue.length, equals(3));
        expect(state.nextQueue[0], equals(TetrominoType.t));
        expect(state.nextQueue[1], equals(TetrominoType.i));
        expect(state.nextQueue[2], equals(TetrominoType.o));
      });

      test('NEXTキューサイズをカスタマイズできる', () {
        final state = useCase.execute(getNextTetromino, nextQueueSize: 5);

        expect(state.nextQueue.length, equals(5));
      });

      test('テトリミノはスポーン位置に配置される', () {
        final state = useCase.execute(getNextTetromino);

        expect(state.currentTetromino!.rotation, equals(RotationState.spawn));
        // スポーン位置は Tetromino.spawn で決まる
      });
    });

    group('シーケンス確認', () {
      test('連続でゲーム開始すると異なるシーケンスが使用される', () {
        final state1 = useCase.execute(getNextTetromino);
        final state2 = useCase.execute(getNextTetromino);

        // state1: nextQueue [T, I, O], current: S
        // state2: nextQueue [Z, T, I], current: O
        expect(state1.nextQueue, isNot(equals(state2.nextQueue)));
      });
    });
  });
}
