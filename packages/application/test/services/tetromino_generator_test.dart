import 'dart:math';

import 'package:test/test.dart';
import 'package:tetris_application/tetris_application.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('TetrominoGenerator', () {
    group('7-bagアルゴリズム', () {
      test('7個取り出すと全種類が1回ずつ出現する', () {
        final generator = TetrominoGenerator(random: Random(42));
        final types = <TetrominoType>[];

        for (var i = 0; i < 7; i++) {
          types.add(generator.next());
        }

        // 全7種類が含まれていることを確認
        expect(types.toSet().length, equals(7));
        for (final type in TetrominoType.values) {
          expect(types.contains(type), isTrue);
        }
      });

      test('14個取り出すと各種類が2回ずつ出現する', () {
        final generator = TetrominoGenerator(random: Random(42));
        final typeCounts = <TetrominoType, int>{};

        for (var i = 0; i < 14; i++) {
          final type = generator.next();
          typeCounts[type] = (typeCounts[type] ?? 0) + 1;
        }

        // 各種類が2回ずつ
        for (final type in TetrominoType.values) {
          expect(typeCounts[type], equals(2));
        }
      });

      test('同じシードで同じ順序が生成される', () {
        final generator1 = TetrominoGenerator(random: Random(123));
        final generator2 = TetrominoGenerator(random: Random(123));

        for (var i = 0; i < 21; i++) {
          expect(generator1.next(), equals(generator2.next()));
        }
      });

      test('異なるシードで異なる順序が生成される', () {
        final generator1 = TetrominoGenerator(random: Random(1));
        final generator2 = TetrominoGenerator(random: Random(2));

        final sequence1 = List.generate(7, (_) => generator1.next());
        final sequence2 = List.generate(7, (_) => generator2.next());

        // 異なる順序であることを確認（極めて稀に一致する可能性はあるが無視）
        expect(sequence1, isNot(equals(sequence2)));
      });
    });

    group('peek', () {
      test('次のピースをプレビューできる', () {
        final generator = TetrominoGenerator(random: Random(42));

        final peeked = generator.peek();
        final next = generator.next();

        expect(peeked, equals(next));
      });

      test('複数回peekしても同じ値を返す', () {
        final generator = TetrominoGenerator(random: Random(42));

        final peek1 = generator.peek();
        final peek2 = generator.peek();
        final peek3 = generator.peek();

        expect(peek1, equals(peek2));
        expect(peek2, equals(peek3));
      });

      test('peekは状態を変更しない', () {
        final generator = TetrominoGenerator(random: Random(42));

        generator.peek();
        generator.peek();
        final next1 = generator.next();

        final generator2 = TetrominoGenerator(random: Random(42));
        final next2 = generator2.next();

        expect(next1, equals(next2));
      });
    });

    group('peekMultiple', () {
      test('複数のピースをプレビューできる', () {
        final generator = TetrominoGenerator(random: Random(42));

        final previews = generator.peekMultiple(3);

        expect(previews.length, equals(3));

        // 実際に取り出して確認
        for (final preview in previews) {
          expect(generator.next(), equals(preview));
        }
      });

      test('7個以上のプレビューも可能', () {
        final generator = TetrominoGenerator(random: Random(42));

        final previews = generator.peekMultiple(10);

        expect(previews.length, equals(10));
      });

      test('peekMultipleは状態を変更しない', () {
        final generator = TetrominoGenerator(random: Random(42));

        generator.peekMultiple(5);
        generator.peekMultiple(3);

        final generator2 = TetrominoGenerator(random: Random(42));

        for (var i = 0; i < 5; i++) {
          expect(generator.next(), equals(generator2.next()));
        }
      });
    });

    group('reset', () {
      test('リセットすると新しいバッグから開始する', () {
        final generator = TetrominoGenerator(random: Random(42));

        // いくつか取り出す
        for (var i = 0; i < 5; i++) {
          generator.next();
        }

        // リセット
        generator.reset();

        // 7個取り出すと全種類が出現する
        final types = <TetrominoType>{};
        for (var i = 0; i < 7; i++) {
          types.add(generator.next());
        }

        expect(types.length, equals(7));
      });
    });

    group('NEXTキュー用', () {
      test('3個のNEXTプレビューが取得できる', () {
        final generator = TetrominoGenerator(random: Random(42));

        final nextQueue = generator.peekMultiple(3);

        expect(nextQueue.length, equals(3));
      });

      test('ピースを取り出した後もNEXTが維持される', () {
        final generator = TetrominoGenerator(random: Random(42));

        final initialNext = generator.peekMultiple(3);
        generator.next(); // 1つ取り出す
        final afterNext = generator.peekMultiple(3);

        // 最初のNEXTの2,3番目が、取り出し後の1,2番目になる
        expect(afterNext[0], equals(initialNext[1]));
        expect(afterNext[1], equals(initialNext[2]));
      });
    });
  });
}
