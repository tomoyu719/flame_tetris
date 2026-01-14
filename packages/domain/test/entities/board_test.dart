import 'package:test/test.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('Board', () {
    group('コンストラクタ', () {
      test('empty()で空のボードを生成できる', () {
        final board = Board.empty();

        expect(board.width, equals(Board.defaultWidth));
        expect(board.height, equals(Board.defaultHeight));
      });

      test('全セルがnull（空）で初期化される', () {
        final board = Board.empty();

        for (var y = 0; y < board.height; y++) {
          for (var x = 0; x < board.width; x++) {
            expect(board.getCell(Position(x, y)), isNull);
          }
        }
      });
    });

    group('定数', () {
      test('デフォルト幅は10', () {
        expect(Board.defaultWidth, equals(10));
      });

      test('デフォルト高さは20', () {
        expect(Board.defaultHeight, equals(20));
      });

      test('バッファ高さは4', () {
        expect(Board.bufferHeight, equals(4));
      });
    });

    group('getCell / setCell', () {
      test('セルに値を設定して取得できる', () {
        final board = Board.empty();
        const pos = Position(3, 5);

        final newBoard = board.setCell(pos, TetrominoType.t);

        expect(newBoard.getCell(pos), equals(TetrominoType.t));
      });

      test('元のボードは変更されない（イミュータブル）', () {
        final board = Board.empty();
        const pos = Position(3, 5);

        final newBoard = board.setCell(pos, TetrominoType.t);

        expect(board.getCell(pos), isNull);
        expect(newBoard.getCell(pos), equals(TetrominoType.t));
      });

      test('範囲外のセルを取得するとnullを返す', () {
        final board = Board.empty();

        expect(board.getCell(const Position(-1, 0)), isNull);
        expect(board.getCell(const Position(0, -1)), isNull);
        expect(board.getCell(const Position(10, 0)), isNull);
        expect(board.getCell(const Position(0, 20)), isNull);
      });
    });

    group('isInBounds', () {
      test('ボード内の座標はtrue', () {
        final board = Board.empty();

        expect(board.isInBounds(const Position(0, 0)), isTrue);
        expect(board.isInBounds(const Position(9, 19)), isTrue);
        expect(board.isInBounds(const Position(5, 10)), isTrue);
      });

      test('ボード外の座標はfalse', () {
        final board = Board.empty();

        expect(board.isInBounds(const Position(-1, 0)), isFalse);
        expect(board.isInBounds(const Position(0, -1)), isFalse);
        expect(board.isInBounds(const Position(10, 0)), isFalse);
        expect(board.isInBounds(const Position(0, 20)), isFalse);
      });
    });

    group('isLineFull', () {
      test('空のラインはfalse', () {
        final board = Board.empty();

        expect(board.isLineFull(5), isFalse);
      });

      test('一部が埋まったラインはfalse', () {
        var board = Board.empty();
        for (var x = 0; x < 5; x++) {
          board = board.setCell(Position(x, 5), TetrominoType.t);
        }

        expect(board.isLineFull(5), isFalse);
      });

      test('完全に埋まったラインはtrue', () {
        var board = Board.empty();
        for (var x = 0; x < Board.defaultWidth; x++) {
          board = board.setCell(Position(x, 5), TetrominoType.t);
        }

        expect(board.isLineFull(5), isTrue);
      });
    });

    group('getCompletedLines', () {
      test('揃ったラインがなければ空リストを返す', () {
        final board = Board.empty();

        expect(board.getCompletedLines(), isEmpty);
      });

      test('揃ったラインのインデックスをリストで返す', () {
        var board = Board.empty();
        // 5行目と10行目を埋める
        for (var x = 0; x < Board.defaultWidth; x++) {
          board = board.setCell(Position(x, 5), TetrominoType.t);
          board = board.setCell(Position(x, 10), TetrominoType.i);
        }

        final lines = board.getCompletedLines();

        expect(lines, containsAll([5, 10]));
        expect(lines.length, equals(2));
      });
    });

    group('clearLines', () {
      test('指定したラインを消去し上のラインが落ちてくる', () {
        var board = Board.empty();
        // 18行目にブロックを配置
        board = board.setCell(const Position(3, 18), TetrominoType.j);
        // 19行目（最下段）を完全に埋める
        for (var x = 0; x < Board.defaultWidth; x++) {
          board = board.setCell(Position(x, 19), TetrominoType.t);
        }

        final clearedBoard = board.clearLines([19]);

        // 18行目のブロックが19行目に落ちている
        expect(clearedBoard.getCell(const Position(3, 19)), equals(TetrominoType.j));
        // 18行目は空になっている
        expect(clearedBoard.getCell(const Position(3, 18)), isNull);
      });

      test('複数ラインを同時に消去できる', () {
        var board = Board.empty();
        // 17行目にブロックを配置
        board = board.setCell(const Position(5, 17), TetrominoType.l);
        // 18行目と19行目を完全に埋める
        for (var x = 0; x < Board.defaultWidth; x++) {
          board = board.setCell(Position(x, 18), TetrominoType.t);
          board = board.setCell(Position(x, 19), TetrominoType.i);
        }

        final clearedBoard = board.clearLines([18, 19]);

        // 17行目のブロックが19行目に落ちている（2行分）
        expect(clearedBoard.getCell(const Position(5, 19)), equals(TetrominoType.l));
        expect(clearedBoard.getCell(const Position(5, 17)), isNull);
        expect(clearedBoard.getCell(const Position(5, 18)), isNull);
      });
    });

    group('等価性', () {
      test('同じ状態のBoardは等しい', () {
        var board1 = Board.empty();
        var board2 = Board.empty();

        board1 = board1.setCell(const Position(3, 5), TetrominoType.t);
        board2 = board2.setCell(const Position(3, 5), TetrominoType.t);

        expect(board1, equals(board2));
      });

      test('異なる状態のBoardは等しくない', () {
        var board1 = Board.empty();
        var board2 = Board.empty();

        board1 = board1.setCell(const Position(3, 5), TetrominoType.t);
        board2 = board2.setCell(const Position(3, 5), TetrominoType.i);

        expect(board1, isNot(equals(board2)));
      });
    });
  });
}
