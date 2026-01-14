import 'package:tetris_domain/tetris_domain.dart';

/// CollisionServiceの実装
///
/// テトリミノとボード間の衝突判定を行う。
class CollisionServiceImpl implements CollisionService {
  @override
  bool isValidPosition(Tetromino tetromino, Board board) {
    final shapes = TetrominoShapes.getShape(tetromino.type, tetromino.rotation);

    for (final offset in shapes) {
      final x = tetromino.position.x + offset.x;
      final y = tetromino.position.y + offset.y;

      // 左右の範囲外チェック
      if (x < 0 || x >= Board.defaultWidth) {
        return false;
      }

      // 下端の範囲外チェック
      if (y >= Board.defaultHeight) {
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
