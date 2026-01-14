import 'package:test/test.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('Tetromino', () {
    group('コンストラクタ', () {
      test('type, position, rotationを指定して生成できる', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(4, 0),
          rotation: RotationState.spawn,
        );

        expect(tetromino.type, equals(TetrominoType.t));
        expect(tetromino.position, equals(const Position(4, 0)));
        expect(tetromino.rotation, equals(RotationState.spawn));
      });

      test('spawn()で初期位置に生成できる', () {
        final tetromino = Tetromino.spawn(TetrominoType.i);

        expect(tetromino.type, equals(TetrominoType.i));
        expect(tetromino.position, equals(const Position(3, 0)));
        expect(tetromino.rotation, equals(RotationState.spawn));
      });
    });

    group('move', () {
      test('左に移動できる', () {
        const original = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 3),
          rotation: RotationState.spawn,
        );

        final moved = original.move(MoveDirection.left);

        expect(moved.position, equals(const Position(4, 3)));
        expect(moved.type, equals(original.type));
        expect(moved.rotation, equals(original.rotation));
      });

      test('右に移動できる', () {
        const original = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 3),
          rotation: RotationState.spawn,
        );

        final moved = original.move(MoveDirection.right);

        expect(moved.position, equals(const Position(6, 3)));
      });

      test('下に移動できる', () {
        const original = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 3),
          rotation: RotationState.spawn,
        );

        final moved = original.move(MoveDirection.down);

        expect(moved.position, equals(const Position(5, 4)));
      });
    });

    group('rotate', () {
      test('時計回りに回転できる', () {
        const original = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 3),
          rotation: RotationState.spawn,
        );

        final rotated = original.rotate(RotationDirection.clockwise);

        expect(rotated.rotation, equals(RotationState.clockwise));
        expect(rotated.position, equals(original.position));
        expect(rotated.type, equals(original.type));
      });

      test('反時計回りに回転できる', () {
        const original = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 3),
          rotation: RotationState.spawn,
        );

        final rotated = original.rotate(RotationDirection.counterClockwise);

        expect(rotated.rotation, equals(RotationState.counterClockwise));
      });
    });

    group('copyWith', () {
      test('positionのみ変更できる', () {
        const original = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 3),
          rotation: RotationState.spawn,
        );

        final result = original.copyWith(position: const Position(2, 5));

        expect(result.position, equals(const Position(2, 5)));
        expect(result.type, equals(original.type));
        expect(result.rotation, equals(original.rotation));
      });

      test('rotationのみ変更できる', () {
        const original = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 3),
          rotation: RotationState.spawn,
        );

        final result = original.copyWith(rotation: RotationState.inverted);

        expect(result.rotation, equals(RotationState.inverted));
        expect(result.position, equals(original.position));
      });
    });

    group('等価性', () {
      test('同じ値のTetrominoは等しい', () {
        const t1 = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 3),
          rotation: RotationState.spawn,
        );
        const t2 = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 3),
          rotation: RotationState.spawn,
        );

        expect(t1, equals(t2));
        expect(t1.hashCode, equals(t2.hashCode));
      });

      test('異なる値のTetrominoは等しくない', () {
        const t1 = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 3),
          rotation: RotationState.spawn,
        );
        const t2 = Tetromino(
          type: TetrominoType.i,
          position: Position(5, 3),
          rotation: RotationState.spawn,
        );

        expect(t1, isNot(equals(t2)));
      });
    });
  });
}
