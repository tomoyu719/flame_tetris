import 'package:test/test.dart';
import 'package:tetris_domain/tetris_domain.dart';

/// テスト用のLineClearService実装
class TestLineClearService implements LineClearService {
  @override
  LineClearResult clearLines(Board board) {
    final completedIndices = getCompletedLineIndices(board);

    if (completedIndices.isEmpty) {
      return LineClearResult.noClears(board);
    }

    final clearedBoard = board.clearLines(completedIndices);

    return LineClearResult(
      board: clearedBoard,
      linesCleared: LinesCleared(completedIndices.length),
      clearedLineIndices: completedIndices,
    );
  }

  @override
  List<int> getCompletedLineIndices(Board board) {
    return board.getCompletedLines();
  }

  @override
  bool isLineComplete(Board board, int lineIndex) {
    for (var x = 0; x < Board.defaultWidth; x++) {
      if (board.getCell(Position(x, lineIndex)) == null) {
        return false;
      }
    }
    return true;
  }
}

void main() {
  group('LineClearService', () {
    late LineClearService service;
    late Board emptyBoard;

    setUp(() {
      service = TestLineClearService();
      emptyBoard = Board.empty();
    });

    group('LineClearResult', () {
      test('ライン消去なしの結果を生成できる', () {
        final result = LineClearResult.noClears(emptyBoard);

        expect(result.board, equals(emptyBoard));
        expect(result.linesCleared.value, equals(0));
        expect(result.clearedLineIndices, isEmpty);
      });

      test('ライン消去ありの結果を生成できる', () {
        final result = LineClearResult(
          board: Board.empty(),
          linesCleared: LinesCleared(2),
          clearedLineIndices: const [18, 19],
        );

        expect(result.linesCleared.value, equals(2));
        expect(result.clearedLineIndices, equals([18, 19]));
      });
    });

    group('isLineComplete', () {
      test('空の行は完成していない', () {
        expect(service.isLineComplete(emptyBoard, 19), isFalse);
      });

      test('一部だけ埋まった行は完成していない', () {
        var board = emptyBoard;
        for (var x = 0; x < Board.defaultWidth - 1; x++) {
          board = board.setCell(Position(x, 19), TetrominoType.i);
        }

        expect(service.isLineComplete(board, 19), isFalse);
      });

      test('完全に埋まった行は完成している', () {
        var board = emptyBoard;
        for (var x = 0; x < Board.defaultWidth; x++) {
          board = board.setCell(Position(x, 19), TetrominoType.i);
        }

        expect(service.isLineComplete(board, 19), isTrue);
      });
    });

    group('getCompletedLineIndices', () {
      test('完成ラインがない場合は空リストを返す', () {
        expect(service.getCompletedLineIndices(emptyBoard), isEmpty);
      });

      test('1行完成している場合はそのインデックスを返す', () {
        var board = emptyBoard;
        for (var x = 0; x < Board.defaultWidth; x++) {
          board = board.setCell(Position(x, 19), TetrominoType.i);
        }

        final indices = service.getCompletedLineIndices(board);

        expect(indices, equals([19]));
      });

      test('複数行完成している場合はすべてのインデックスを返す', () {
        var board = emptyBoard;
        for (var x = 0; x < Board.defaultWidth; x++) {
          board = board.setCell(Position(x, 18), TetrominoType.i);
          board = board.setCell(Position(x, 19), TetrominoType.i);
        }

        final indices = service.getCompletedLineIndices(board);

        expect(indices, equals([18, 19]));
      });

      test('飛び飛びの完成行も検出する', () {
        var board = emptyBoard;
        for (var x = 0; x < Board.defaultWidth; x++) {
          board = board.setCell(Position(x, 15), TetrominoType.i);
          board = board.setCell(Position(x, 17), TetrominoType.i);
          board = board.setCell(Position(x, 19), TetrominoType.i);
        }

        final indices = service.getCompletedLineIndices(board);

        expect(indices, equals([15, 17, 19]));
      });
    });

    group('clearLines', () {
      test('完成ラインがない場合はボードは変わらない', () {
        final result = service.clearLines(emptyBoard);

        expect(result.board, equals(emptyBoard));
        expect(result.linesCleared.value, equals(0));
        expect(result.clearedLineIndices, isEmpty);
      });

      test('1行消去できる', () {
        var board = emptyBoard;
        // 最下段を埋める
        for (var x = 0; x < Board.defaultWidth; x++) {
          board = board.setCell(Position(x, 19), TetrominoType.i);
        }
        // その上にブロックを1つ置く
        board = board.setCell(const Position(5, 18), TetrominoType.t);

        final result = service.clearLines(board);

        expect(result.linesCleared.value, equals(1));
        expect(result.clearedLineIndices, equals([19]));
        // 上のブロックが落ちてきている
        expect(
          result.board.getCell(const Position(5, 19)),
          equals(TetrominoType.t),
        );
        expect(result.board.getCell(const Position(5, 18)), isNull);
      });

      test('2行同時消去できる（ダブル）', () {
        var board = emptyBoard;
        // 下2行を埋める
        for (var x = 0; x < Board.defaultWidth; x++) {
          board = board.setCell(Position(x, 18), TetrominoType.i);
          board = board.setCell(Position(x, 19), TetrominoType.i);
        }
        // その上にブロックを置く
        board = board.setCell(const Position(5, 17), TetrominoType.t);

        final result = service.clearLines(board);

        expect(result.linesCleared.value, equals(2));
        expect(result.clearedLineIndices, equals([18, 19]));
        // 上のブロックが2行分落ちてきている
        expect(
          result.board.getCell(const Position(5, 19)),
          equals(TetrominoType.t),
        );
      });

      test('3行同時消去できる（トリプル）', () {
        var board = emptyBoard;
        // 下3行を埋める
        for (var x = 0; x < Board.defaultWidth; x++) {
          board = board.setCell(Position(x, 17), TetrominoType.i);
          board = board.setCell(Position(x, 18), TetrominoType.i);
          board = board.setCell(Position(x, 19), TetrominoType.i);
        }

        final result = service.clearLines(board);

        expect(result.linesCleared.value, equals(3));
        expect(result.clearedLineIndices, equals([17, 18, 19]));
      });

      test('4行同時消去できる（テトリス）', () {
        var board = emptyBoard;
        // 下4行を埋める
        for (var x = 0; x < Board.defaultWidth; x++) {
          board = board.setCell(Position(x, 16), TetrominoType.i);
          board = board.setCell(Position(x, 17), TetrominoType.i);
          board = board.setCell(Position(x, 18), TetrominoType.i);
          board = board.setCell(Position(x, 19), TetrominoType.i);
        }

        final result = service.clearLines(board);

        expect(result.linesCleared.value, equals(4));
        expect(result.clearedLineIndices, equals([16, 17, 18, 19]));
      });

      test('飛び飛びの行を消去できる', () {
        var board = emptyBoard;
        // 15, 17, 19行を埋める
        for (var x = 0; x < Board.defaultWidth; x++) {
          board = board.setCell(Position(x, 15), TetrominoType.i);
          board = board.setCell(Position(x, 17), TetrominoType.i);
          board = board.setCell(Position(x, 19), TetrominoType.i);
        }
        // 未完成行にブロックを置く
        board = board.setCell(const Position(3, 16), TetrominoType.t);
        board = board.setCell(const Position(7, 18), TetrominoType.s);

        final result = service.clearLines(board);

        expect(result.linesCleared.value, equals(3));
        // 16行と18行のブロックが落ちてきている
        expect(
          result.board.getCell(const Position(3, 18)),
          equals(TetrominoType.t),
        );
        expect(
          result.board.getCell(const Position(7, 19)),
          equals(TetrominoType.s),
        );
      });
    });
  });
}
