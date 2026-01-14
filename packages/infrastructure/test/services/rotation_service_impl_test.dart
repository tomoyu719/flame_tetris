import 'package:flutter_test/flutter_test.dart';
import 'package:tetris_domain/tetris_domain.dart';
import 'package:tetris_infrastructure/tetris_infrastructure.dart';

void main() {
  group('RotationServiceImpl', () {
    late RotationService service;
    late CollisionService collisionService;
    late Board emptyBoard;

    setUp(() {
      collisionService = CollisionServiceImpl();
      service = RotationServiceImpl(collisionService: collisionService);
      emptyBoard = Board.empty();
    });

    group('rotate', () {
      test('空のボード中央で時計回り回転が成功する', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 5),
          rotation: RotationState.spawn,
        );

        final result = service.rotate(
          tetromino,
          emptyBoard,
          RotationDirection.clockwise,
        );

        expect(result.success, isTrue);
        expect(result.tetromino.rotation, equals(RotationState.clockwise));
        expect(result.kickIndex, equals(0));
      });

      test('空のボード中央で反時計回り回転が成功する', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 5),
          rotation: RotationState.spawn,
        );

        final result = service.rotate(
          tetromino,
          emptyBoard,
          RotationDirection.counterClockwise,
        );

        expect(result.success, isTrue);
        expect(
          result.tetromino.rotation,
          equals(RotationState.counterClockwise),
        );
      });

      test('壁際でウォールキックが適用される（T-piece左壁）', () {
        // T-pieceを左壁際でclockwise状態に配置
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(-1, 5),
          rotation: RotationState.clockwise,
        );

        final result = service.rotate(
          tetromino,
          emptyBoard,
          RotationDirection.counterClockwise,
        );

        // ウォールキックで成功するはず
        expect(result.success, isTrue);
        expect(result.kickIndex, greaterThan(0));
      });

      test('I-pieceの壁際回転でウォールキックが適用される', () {
        // I-pieceを左壁際で縦向きに配置
        const tetromino = Tetromino(
          type: TetrominoType.i,
          position: Position(-1, 5),
          rotation: RotationState.clockwise,
        );

        final result = service.rotate(
          tetromino,
          emptyBoard,
          RotationDirection.counterClockwise,
        );

        expect(result.success, isTrue);
      });

      test('回転不可能な場合は失敗する', () {
        // ブロックで囲まれた状態を作成
        var board = emptyBoard;
        for (var y = 4; y <= 7; y++) {
          board = board.setCell(Position(3, y), TetrominoType.i);
          board = board.setCell(Position(7, y), TetrominoType.i);
        }
        for (var x = 3; x <= 7; x++) {
          board = board.setCell(Position(x, 4), TetrominoType.i);
          board = board.setCell(Position(x, 7), TetrominoType.i);
        }

        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(4, 5),
          rotation: RotationState.spawn,
        );

        final result = service.rotate(
          tetromino,
          board,
          RotationDirection.clockwise,
        );

        expect(result.success, isFalse);
        expect(result.tetromino, equals(tetromino));
      });

      test('Oミノは回転しても形状が変わらない', () {
        const tetromino = Tetromino(
          type: TetrominoType.o,
          position: Position(5, 5),
          rotation: RotationState.spawn,
        );

        final result = service.rotate(
          tetromino,
          emptyBoard,
          RotationDirection.clockwise,
        );

        expect(result.success, isTrue);
        expect(result.tetromino.rotation, equals(RotationState.clockwise));
      });

      test('4回回転すると元の状態に戻る', () {
        const original = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 5),
          rotation: RotationState.spawn,
        );

        var tetromino = original;
        for (var i = 0; i < 4; i++) {
          final result = service.rotate(
            tetromino,
            emptyBoard,
            RotationDirection.clockwise,
          );
          expect(result.success, isTrue);
          tetromino = result.tetromino;
        }

        expect(tetromino.rotation, equals(original.rotation));
      });
    });

    group('rotateWithoutKick', () {
      test('キックなしで回転可能な場合は成功', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 5),
          rotation: RotationState.spawn,
        );

        final result = service.rotateWithoutKick(
          tetromino,
          emptyBoard,
          RotationDirection.clockwise,
        );

        expect(result.success, isTrue);
        expect(result.kickIndex, equals(0));
      });

      test('キックが必要な場合は失敗', () {
        // I-ミノを左壁際で縦向きに配置
        const tetromino = Tetromino(
          type: TetrominoType.i,
          position: Position(-1, 5),
          rotation: RotationState.counterClockwise,
        );

        final result = service.rotateWithoutKick(
          tetromino,
          emptyBoard,
          RotationDirection.clockwise,
        );

        expect(result.success, isFalse);
      });
    });

    group('SRS壁蹴りテスト', () {
      test('底での壁蹴り回転成功', () {
        // 底で回転するケース
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(4, 17),
          rotation: RotationState.inverted,
        );

        final result = service.rotate(
          tetromino,
          emptyBoard,
          RotationDirection.clockwise,
        );

        // 回転成功を確認
        expect(result.success, isTrue);
      });

      test('右壁際でのウォールキック', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(8, 5),
          rotation: RotationState.counterClockwise,
        );

        final result = service.rotate(
          tetromino,
          emptyBoard,
          RotationDirection.clockwise,
        );

        expect(result.success, isTrue);
      });
    });
  });
}
