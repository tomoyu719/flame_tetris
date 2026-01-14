import 'package:flutter_test/flutter_test.dart';
import 'package:tetris_domain/tetris_domain.dart';
import 'package:tetris_infrastructure/tetris_infrastructure.dart';

void main() {
  group('CollisionServiceImpl', () {
    late CollisionService service;
    late Board emptyBoard;

    setUp(() {
      service = CollisionServiceImpl();
      emptyBoard = Board.empty();
    });

    group('isValidPosition', () {
      test('空のボードで初期位置のテトリミノは有効', () {
        final tetromino = Tetromino.spawn(TetrominoType.t);

        expect(service.isValidPosition(tetromino, emptyBoard), isTrue);
      });

      test('左端を超える位置は無効', () {
        const tetromino = Tetromino(
          type: TetrominoType.i,
          position: Position(-2, 5),
          rotation: RotationState.spawn,
        );

        expect(service.isValidPosition(tetromino, emptyBoard), isFalse);
      });

      test('右端を超える位置は無効', () {
        const tetromino = Tetromino(
          type: TetrominoType.i,
          position: Position(8, 5),
          rotation: RotationState.spawn,
        );

        expect(service.isValidPosition(tetromino, emptyBoard), isFalse);
      });

      test('下端を超える位置は無効', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(4, 19),
          rotation: RotationState.spawn,
        );

        expect(service.isValidPosition(tetromino, emptyBoard), isFalse);
      });

      test('上側への飛び出しは許容（スポーン時）', () {
        const tetromino = Tetromino(
          type: TetrominoType.i,
          position: Position(3, -1),
          rotation: RotationState.spawn,
        );

        // I-pieceのspawn状態はy=1の位置にブロックがあるので、position.y=-1でもy=0にブロックが来る
        expect(service.isValidPosition(tetromino, emptyBoard), isTrue);
      });

      test('既存ブロックと重なる位置は無効', () {
        final board = emptyBoard.setCell(const Position(5, 5), TetrominoType.t);
        const tetromino = Tetromino(
          type: TetrominoType.o,
          position: Position(4, 4),
          rotation: RotationState.spawn,
        );

        expect(service.isValidPosition(tetromino, board), isFalse);
      });
    });

    group('canMove', () {
      test('空のボードで左に移動可能', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 5),
          rotation: RotationState.spawn,
        );

        expect(
          service.canMove(tetromino, emptyBoard, MoveDirection.left),
          isTrue,
        );
      });

      test('空のボードで右に移動可能', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 5),
          rotation: RotationState.spawn,
        );

        expect(
          service.canMove(tetromino, emptyBoard, MoveDirection.right),
          isTrue,
        );
      });

      test('空のボードで下に移動可能', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 5),
          rotation: RotationState.spawn,
        );

        expect(
          service.canMove(tetromino, emptyBoard, MoveDirection.down),
          isTrue,
        );
      });

      test('左端では左に移動不可', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(0, 5),
          rotation: RotationState.spawn,
        );

        expect(
          service.canMove(tetromino, emptyBoard, MoveDirection.left),
          isFalse,
        );
      });

      test('右端では右に移動不可', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(7, 5),
          rotation: RotationState.spawn,
        );

        expect(
          service.canMove(tetromino, emptyBoard, MoveDirection.right),
          isFalse,
        );
      });

      test('底では下に移動不可', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(4, 18),
          rotation: RotationState.spawn,
        );

        expect(
          service.canMove(tetromino, emptyBoard, MoveDirection.down),
          isFalse,
        );
      });

      test('他のブロックがある方向には移動不可', () {
        final board = emptyBoard.setCell(const Position(4, 6), TetrominoType.i);
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(4, 4),
          rotation: RotationState.spawn,
        );

        expect(
          service.canMove(tetromino, board, MoveDirection.down),
          isFalse,
        );
      });
    });

    group('canRotate', () {
      test('空のボード中央で回転可能', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 5),
          rotation: RotationState.spawn,
        );

        expect(
          service.canRotate(tetromino, emptyBoard, RotationDirection.clockwise),
          isTrue,
        );
      });

      test('Oミノは常に回転可能', () {
        const tetromino = Tetromino(
          type: TetrominoType.o,
          position: Position(0, 0),
          rotation: RotationState.spawn,
        );

        expect(
          service.canRotate(tetromino, emptyBoard, RotationDirection.clockwise),
          isTrue,
        );
      });
    });

    group('canLock', () {
      test('底に達したテトリミノはロック可能', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(4, 18),
          rotation: RotationState.spawn,
        );

        expect(service.canLock(tetromino, emptyBoard), isTrue);
      });

      test('底に達していないテトリミノはロック不可', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(4, 10),
          rotation: RotationState.spawn,
        );

        expect(service.canLock(tetromino, emptyBoard), isFalse);
      });

      test('他のブロックの上に達したテトリミノはロック可能', () {
        final board = emptyBoard.setCell(
          const Position(5, 10),
          TetrominoType.i,
        );
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(4, 8),
          rotation: RotationState.spawn,
        );

        expect(service.canLock(tetromino, board), isTrue);
      });
    });

    group('getGhostPosition', () {
      test('空のボードでゴースト位置は底', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(4, 0),
          rotation: RotationState.spawn,
        );

        final ghost = service.getGhostPosition(tetromino, emptyBoard);

        expect(ghost.position.y, equals(18));
        expect(ghost.position.x, equals(tetromino.position.x));
        expect(ghost.type, equals(tetromino.type));
        expect(ghost.rotation, equals(tetromino.rotation));
      });

      test('ブロックがある場合はその上がゴースト位置', () {
        var board = emptyBoard;
        for (var x = 0; x < Board.defaultWidth; x++) {
          board = board.setCell(Position(x, 15), TetrominoType.i);
        }

        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(4, 0),
          rotation: RotationState.spawn,
        );

        final ghost = service.getGhostPosition(tetromino, board);

        expect(ghost.position.y, equals(13));
      });

      test('すでに底にある場合は位置は変わらない', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(4, 18),
          rotation: RotationState.spawn,
        );

        final ghost = service.getGhostPosition(tetromino, emptyBoard);

        expect(ghost.position, equals(tetromino.position));
      });
    });
  });
}
