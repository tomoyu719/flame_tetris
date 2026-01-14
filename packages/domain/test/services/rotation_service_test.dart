import 'package:test/test.dart';
import 'package:tetris_domain/tetris_domain.dart';

/// テスト用のRotationService実装（SRS準拠）
class TestRotationService implements RotationService {
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

  @override
  RotationResult rotate(
    Tetromino tetromino,
    Board board,
    RotationDirection direction,
  ) {
    final rotated = tetromino.rotate(direction);

    // 基本回転を試す
    if (_isValidPosition(rotated, board)) {
      return RotationResult(
        tetromino: rotated,
        success: true,
        kickIndex: 0,
      );
    }

    // ウォールキックを試す
    final kickOffsets = SrsKickData.getKickOffsets(
      tetromino.type,
      tetromino.rotation,
      rotated.rotation,
    );

    for (var i = 0; i < kickOffsets.length; i++) {
      final kicked = rotated.copyWith(
        position: rotated.position + kickOffsets[i],
      );

      if (_isValidPosition(kicked, board)) {
        return RotationResult(
          tetromino: kicked,
          success: true,
          kickIndex: i + 1,
        );
      }
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
        kickIndex: 0,
      );
    }

    return RotationResult.failed(tetromino);
  }
}

void main() {
  group('RotationService', () {
    late RotationService service;
    late Board emptyBoard;

    setUp(() {
      service = TestRotationService();
      emptyBoard = Board.empty();
    });

    group('RotationResult', () {
      test('成功時のRotationResultを生成できる', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 5),
          rotation: RotationState.clockwise,
        );

        const result = RotationResult(
          tetromino: tetromino,
          success: true,
          kickIndex: 0,
        );

        expect(result.success, isTrue);
        expect(result.tetromino, equals(tetromino));
        expect(result.kickIndex, equals(0));
      });

      test('失敗時のRotationResultを生成できる', () {
        const original = Tetromino(
          type: TetrominoType.t,
          position: Position(5, 5),
          rotation: RotationState.spawn,
        );

        final result = RotationResult.failed(original);

        expect(result.success, isFalse);
        expect(result.tetromino, equals(original));
        expect(result.kickIndex, equals(-1));
      });
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
        expect(result.tetromino.rotation, equals(RotationState.counterClockwise));
      });

      test('壁際でウォールキックが適用される', () {
        // 左壁際でI-pieceを回転
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

        // ウォールキックで成功するはず
        expect(result.success, isTrue);
        expect(result.kickIndex, greaterThan(0));
      });

      test('回転不可能な場合は失敗する', () {
        // ブロックで囲まれた状態を作成
        var board = emptyBoard;
        // 周囲をブロックで埋める
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
        // Oミノは回転しても同じ形状
        expect(result.tetromino.rotation, equals(RotationState.clockwise));
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
        // I-ミノを左壁際で縦向きから横向きに回転
        // counterClockwise状態は x=1 にブロックがある
        // x=-1 で回転すると x=0 に配置しようとする
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

        // I-pieceのcounterClockwise -> spawnでは左にはみ出すため回転できない
        expect(result.success, isFalse);
      });
    });
  });
}
