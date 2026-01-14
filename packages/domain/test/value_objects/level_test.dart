import 'package:test/test.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('Level', () {
    group('コンストラクタ', () {
      test('有効な値（1〜15）で生成できる', () {
        final level = Level(1);
        expect(level.value, equals(1));

        final level15 = Level(15);
        expect(level15.value, equals(15));
      });

      test('0以下の値はエラー', () {
        expect(() => Level(0), throwsArgumentError);
        expect(() => Level(-1), throwsArgumentError);
      });

      test('16以上の値はエラー', () {
        expect(() => Level(16), throwsArgumentError);
        expect(() => Level(100), throwsArgumentError);
      });
    });

    group('initial', () {
      test('初期レベルは1', () {
        final level = Level.initial;
        expect(level.value, equals(1));
      });
    });

    group('max', () {
      test('最大レベルは15', () {
        final level = Level.max;
        expect(level.value, equals(15));
      });
    });

    group('dropInterval', () {
      test('レベル1は1000ms（1秒）', () {
        final level = Level(1);
        expect(level.dropIntervalMs, equals(1000));
      });

      test('レベル15は100ms（0.1秒）', () {
        final level = Level(15);
        expect(level.dropIntervalMs, equals(100));
      });

      test('レベルが上がるとドロップ間隔が短くなる', () {
        final level1 = Level(1);
        final level5 = Level(5);
        final level10 = Level(10);

        expect(level5.dropIntervalMs, lessThan(level1.dropIntervalMs));
        expect(level10.dropIntervalMs, lessThan(level5.dropIntervalMs));
      });
    });

    group('increment', () {
      test('レベルを1上げた新しいLevelを返す', () {
        final level = Level(5);
        final nextLevel = level.increment();

        expect(nextLevel.value, equals(6));
      });

      test('最大レベルでは増加しない', () {
        final level = Level.max;
        final nextLevel = level.increment();

        expect(nextLevel.value, equals(15));
      });
    });

    group('等価性', () {
      test('同じ値のLevelは等しい', () {
        final level1 = Level(5);
        final level2 = Level(5);

        expect(level1, equals(level2));
        expect(level1.hashCode, equals(level2.hashCode));
      });

      test('異なる値のLevelは等しくない', () {
        final level1 = Level(5);
        final level2 = Level(6);

        expect(level1, isNot(equals(level2)));
      });
    });
  });
}
