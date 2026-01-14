import 'package:test/test.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('LinesCleared', () {
    group('コンストラクタ', () {
      test('有効な値（0〜4）で生成できる', () {
        for (var i = 0; i <= 4; i++) {
          final lines = LinesCleared(i);
          expect(lines.value, equals(i));
        }
      });

      test('負の値はエラー', () {
        expect(() => LinesCleared(-1), throwsArgumentError);
      });

      test('5以上の値はエラー', () {
        expect(() => LinesCleared(5), throwsArgumentError);
      });
    });

    group('none', () {
      test('0ライン消去を表す', () {
        final lines = LinesCleared.none;
        expect(lines.value, equals(0));
      });
    });

    group('isSingle / isDouble / isTriple / isTetris', () {
      test('1ラインはSingle', () {
        final lines = LinesCleared(1);
        expect(lines.isSingle, isTrue);
        expect(lines.isDouble, isFalse);
        expect(lines.isTriple, isFalse);
        expect(lines.isTetris, isFalse);
      });

      test('2ラインはDouble', () {
        final lines = LinesCleared(2);
        expect(lines.isSingle, isFalse);
        expect(lines.isDouble, isTrue);
        expect(lines.isTriple, isFalse);
        expect(lines.isTetris, isFalse);
      });

      test('3ラインはTriple', () {
        final lines = LinesCleared(3);
        expect(lines.isSingle, isFalse);
        expect(lines.isDouble, isFalse);
        expect(lines.isTriple, isTrue);
        expect(lines.isTetris, isFalse);
      });

      test('4ラインはTetris', () {
        final lines = LinesCleared(4);
        expect(lines.isSingle, isFalse);
        expect(lines.isDouble, isFalse);
        expect(lines.isTriple, isFalse);
        expect(lines.isTetris, isTrue);
      });
    });

    group('baseScore', () {
      test('0ラインは0点', () {
        expect(LinesCleared.none.baseScore, equals(0));
      });

      test('Single（1ライン）は100点', () {
        expect(LinesCleared(1).baseScore, equals(100));
      });

      test('Double（2ライン）は300点', () {
        expect(LinesCleared(2).baseScore, equals(300));
      });

      test('Triple（3ライン）は500点', () {
        expect(LinesCleared(3).baseScore, equals(500));
      });

      test('Tetris（4ライン）は800点', () {
        expect(LinesCleared(4).baseScore, equals(800));
      });
    });

    group('等価性', () {
      test('同じ値のLinesClearedは等しい', () {
        final lines1 = LinesCleared(2);
        final lines2 = LinesCleared(2);

        expect(lines1, equals(lines2));
        expect(lines1.hashCode, equals(lines2.hashCode));
      });

      test('異なる値のLinesClearedは等しくない', () {
        final lines1 = LinesCleared(2);
        final lines2 = LinesCleared(3);

        expect(lines1, isNot(equals(lines2)));
      });
    });
  });
}
