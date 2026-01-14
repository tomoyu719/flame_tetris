import 'package:test/test.dart';
import 'package:tetris_domain/tetris_domain.dart';

/// テスト用のCollisionService実装
class TestCollisionService implements CollisionService {
  @override
  bool isValidPosition(Tetromino tetromino, Board board) {
    // 簡易実装：ボードの範囲内かつ空のセルのみ
    final shapes = TetrominoShapes.getShape(tetromino.type, tetromino.rotation);
    for (final offset in shapes) {
      final x = tetromino.position.x + offset.x;
      final y = tetromino.position.y + offset.y;

      // 範囲外チェック
      if (x < 0 || x >= Board.defaultWidth || y >= Board.defaultHeight) {
        return false;
      }

      // 上側への飛び出しは許容（スポーン時）
      if (y < 0) continue;

      // 既存ブロックとの衝突チェック
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

void main() {
  group('CollisionService', () {
    late CollisionService service;
    late Board emptyBoard;

    setUp(() {
      service = TestCollisionService();
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
        // 10行目に横一列ブロックを配置
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
    });
  });
}
