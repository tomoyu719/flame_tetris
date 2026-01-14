import 'package:test/test.dart';
import 'package:tetris_domain/tetris_domain.dart';

/// テスト用のScoringService実装
class TestScoringService implements ScoringService {
  @override
  int calculateLineClearScore(LinesCleared linesCleared, Level level) {
    return linesCleared.baseScore * level.value;
  }

  @override
  int calculateSoftDropScore(int cellsDropped) {
    return cellsDropped; // 1セルにつき1点
  }

  @override
  int calculateHardDropScore(int cellsDropped) {
    return cellsDropped * 2; // 1セルにつき2点
  }
}

void main() {
  group('ScoringService', () {
    late ScoringService service;

    setUp(() {
      service = TestScoringService();
    });

    group('calculateLineClearScore', () {
      group('レベル1での計算', () {
        test('Single (1行) は100点', () {
          final linesCleared = LinesCleared(1);
          final level = Level(1);

          final score = service.calculateLineClearScore(linesCleared, level);

          expect(score, equals(100));
        });

        test('Double (2行) は300点', () {
          final linesCleared = LinesCleared(2);
          final level = Level(1);

          final score = service.calculateLineClearScore(linesCleared, level);

          expect(score, equals(300));
        });

        test('Triple (3行) は500点', () {
          final linesCleared = LinesCleared(3);
          final level = Level(1);

          final score = service.calculateLineClearScore(linesCleared, level);

          expect(score, equals(500));
        });

        test('Tetris (4行) は800点', () {
          final linesCleared = LinesCleared(4);
          final level = Level(1);

          final score = service.calculateLineClearScore(linesCleared, level);

          expect(score, equals(800));
        });

        test('0行は0点', () {
          final score = service.calculateLineClearScore(
            LinesCleared.none,
            Level(1),
          );

          expect(score, equals(0));
        });
      });

      group('レベル倍率の計算', () {
        test('レベル5でSingleは500点', () {
          final linesCleared = LinesCleared(1);
          final level = Level(5);

          final score = service.calculateLineClearScore(linesCleared, level);

          expect(score, equals(500));
        });

        test('レベル10でDoubleは3000点', () {
          final linesCleared = LinesCleared(2);
          final level = Level(10);

          final score = service.calculateLineClearScore(linesCleared, level);

          expect(score, equals(3000));
        });

        test('レベル15でTetrisは12000点', () {
          final linesCleared = LinesCleared(4);
          final level = Level.max;

          final score = service.calculateLineClearScore(linesCleared, level);

          expect(score, equals(12000));
        });
      });
    });

    group('calculateSoftDropScore', () {
      test('1セル落下で1点', () {
        expect(service.calculateSoftDropScore(1), equals(1));
      });

      test('10セル落下で10点', () {
        expect(service.calculateSoftDropScore(10), equals(10));
      });

      test('0セル落下で0点', () {
        expect(service.calculateSoftDropScore(0), equals(0));
      });
    });

    group('calculateHardDropScore', () {
      test('1セル落下で2点', () {
        expect(service.calculateHardDropScore(1), equals(2));
      });

      test('10セル落下で20点', () {
        expect(service.calculateHardDropScore(10), equals(20));
      });

      test('0セル落下で0点', () {
        expect(service.calculateHardDropScore(0), equals(0));
      });

      test('ソフトドロップの2倍のスコア', () {
        const cells = 15;
        final softDropScore = service.calculateSoftDropScore(cells);
        final hardDropScore = service.calculateHardDropScore(cells);

        expect(hardDropScore, equals(softDropScore * 2));
      });
    });
  });
}
