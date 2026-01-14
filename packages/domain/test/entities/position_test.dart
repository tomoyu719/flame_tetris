import 'package:test/test.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('Position', () {
    group('コンストラクタ', () {
      test('x, y座標を指定して生成できる', () {
        const position = Position(3, 5);

        expect(position.x, equals(3));
        expect(position.y, equals(5));
      });

      test('負の座標も許容する', () {
        const position = Position(-1, -2);

        expect(position.x, equals(-1));
        expect(position.y, equals(-2));
      });
    });

    group('演算子', () {
      test('+ 演算子で2つのPositionを加算できる', () {
        const p1 = Position(1, 2);
        const p2 = Position(3, 4);

        final result = p1 + p2;

        expect(result.x, equals(4));
        expect(result.y, equals(6));
      });

      test('- 演算子で2つのPositionを減算できる', () {
        const p1 = Position(5, 7);
        const p2 = Position(2, 3);

        final result = p1 - p2;

        expect(result.x, equals(3));
        expect(result.y, equals(4));
      });
    });

    group('等価性', () {
      test('同じ座標のPositionは等しい', () {
        const p1 = Position(3, 5);
        const p2 = Position(3, 5);

        expect(p1, equals(p2));
        expect(p1.hashCode, equals(p2.hashCode));
      });

      test('異なる座標のPositionは等しくない', () {
        const p1 = Position(3, 5);
        const p2 = Position(3, 6);

        expect(p1, isNot(equals(p2)));
      });
    });

    group('copyWith', () {
      test('xのみ変更できる', () {
        const original = Position(1, 2);

        final result = original.copyWith(x: 5);

        expect(result.x, equals(5));
        expect(result.y, equals(2));
      });

      test('yのみ変更できる', () {
        const original = Position(1, 2);

        final result = original.copyWith(y: 10);

        expect(result.x, equals(1));
        expect(result.y, equals(10));
      });

      test('x, y両方変更できる', () {
        const original = Position(1, 2);

        final result = original.copyWith(x: 5, y: 10);

        expect(result.x, equals(5));
        expect(result.y, equals(10));
      });

      test('引数なしで同じ値のPositionを返す', () {
        const original = Position(1, 2);

        final result = original.copyWith();

        expect(result, equals(original));
      });
    });

    group('toString', () {
      test('座標を文字列で表現できる', () {
        const position = Position(3, 5);

        expect(position.toString(), equals('Position(3, 5)'));
      });
    });
  });
}
