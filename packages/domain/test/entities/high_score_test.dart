import 'package:flutter_test/flutter_test.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('HighScore', () {
    group('コンストラクタ', () {
      test('正常な値で生成できる', () {
        final now = DateTime.now();
        final highScore = HighScore(
          score: 10000,
          level: 5,
          linesCleared: 40,
          achievedAt: now,
        );

        expect(highScore.score, equals(10000));
        expect(highScore.level, equals(5));
        expect(highScore.linesCleared, equals(40));
        expect(highScore.achievedAt, equals(now));
      });

      test('スコア0で生成できる', () {
        final highScore = HighScore(
          score: 0,
          level: 1,
          linesCleared: 0,
          achievedAt: DateTime.now(),
        );

        expect(highScore.score, equals(0));
      });

      test('負のスコアはAssertionErrorを投げる', () {
        expect(
          () => HighScore(
            score: -1,
            level: 1,
            linesCleared: 0,
            achievedAt: DateTime.now(),
          ),
          throwsA(isA<AssertionError>()),
        );
      });

      test('レベル0以下はAssertionErrorを投げる', () {
        expect(
          () => HighScore(
            score: 100,
            level: 0,
            linesCleared: 0,
            achievedAt: DateTime.now(),
          ),
          throwsA(isA<AssertionError>()),
        );
      });

      test('負のラインクリア数はAssertionErrorを投げる', () {
        expect(
          () => HighScore(
            score: 100,
            level: 1,
            linesCleared: -1,
            achievedAt: DateTime.now(),
          ),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('empty', () {
      test('空のハイスコアを生成できる', () {
        final empty = HighScore.empty();

        expect(empty.score, equals(0));
        expect(empty.level, equals(1));
        expect(empty.linesCleared, equals(0));
      });
    });

    group('copyWith', () {
      test('スコアのみ変更できる', () {
        final original = HighScore(
          score: 1000,
          level: 3,
          linesCleared: 10,
          achievedAt: DateTime(2026, 1, 1),
        );

        final copied = original.copyWith(score: 2000);

        expect(copied.score, equals(2000));
        expect(copied.level, equals(3));
        expect(copied.linesCleared, equals(10));
        expect(copied.achievedAt, equals(DateTime(2026, 1, 1)));
      });

      test('すべてのフィールドを変更できる', () {
        final original = HighScore(
          score: 1000,
          level: 3,
          linesCleared: 10,
          achievedAt: DateTime(2026, 1, 1),
        );
        final newDate = DateTime(2026, 6, 15);

        final copied = original.copyWith(
          score: 5000,
          level: 10,
          linesCleared: 50,
          achievedAt: newDate,
        );

        expect(copied.score, equals(5000));
        expect(copied.level, equals(10));
        expect(copied.linesCleared, equals(50));
        expect(copied.achievedAt, equals(newDate));
      });
    });

    group('比較', () {
      test('スコアが高い方が大きい', () {
        final lower = HighScore(
          score: 1000,
          level: 5,
          linesCleared: 10,
          achievedAt: DateTime.now(),
        );
        final higher = HighScore(
          score: 2000,
          level: 3,
          linesCleared: 5,
          achievedAt: DateTime.now(),
        );

        expect(higher.score > lower.score, isTrue);
      });

      test('同じ値のHighScoreは等しい', () {
        final date = DateTime(2026, 1, 1, 12, 0, 0);
        final a = HighScore(
          score: 1000,
          level: 5,
          linesCleared: 10,
          achievedAt: date,
        );
        final b = HighScore(
          score: 1000,
          level: 5,
          linesCleared: 10,
          achievedAt: date,
        );

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('異なる値のHighScoreは等しくない', () {
        final date = DateTime(2026, 1, 1, 12, 0, 0);
        final a = HighScore(
          score: 1000,
          level: 5,
          linesCleared: 10,
          achievedAt: date,
        );
        final b = HighScore(
          score: 2000,
          level: 5,
          linesCleared: 10,
          achievedAt: date,
        );

        expect(a, isNot(equals(b)));
      });
    });

    group('isHigherThan', () {
      test('スコアが高ければtrueを返す', () {
        final lower = HighScore(
          score: 1000,
          level: 5,
          linesCleared: 10,
          achievedAt: DateTime.now(),
        );
        final higher = HighScore(
          score: 2000,
          level: 3,
          linesCleared: 5,
          achievedAt: DateTime.now(),
        );

        expect(higher.isHigherThan(lower), isTrue);
        expect(lower.isHigherThan(higher), isFalse);
      });

      test('同じスコアならfalseを返す', () {
        final a = HighScore(
          score: 1000,
          level: 5,
          linesCleared: 10,
          achievedAt: DateTime.now(),
        );
        final b = HighScore(
          score: 1000,
          level: 3,
          linesCleared: 5,
          achievedAt: DateTime.now(),
        );

        expect(a.isHigherThan(b), isFalse);
        expect(b.isHigherThan(a), isFalse);
      });
    });

    group('toJson / fromJson', () {
      test('JSON形式にシリアライズできる', () {
        final date = DateTime(2026, 1, 15, 10, 30, 0);
        final highScore = HighScore(
          score: 10000,
          level: 8,
          linesCleared: 45,
          achievedAt: date,
        );

        final json = highScore.toJson();

        expect(json['score'], equals(10000));
        expect(json['level'], equals(8));
        expect(json['linesCleared'], equals(45));
        expect(json['achievedAt'], equals(date.toIso8601String()));
      });

      test('JSONからデシリアライズできる', () {
        final json = {
          'score': 10000,
          'level': 8,
          'linesCleared': 45,
          'achievedAt': '2026-01-15T10:30:00.000',
        };

        final highScore = HighScore.fromJson(json);

        expect(highScore.score, equals(10000));
        expect(highScore.level, equals(8));
        expect(highScore.linesCleared, equals(45));
        expect(highScore.achievedAt, equals(DateTime(2026, 1, 15, 10, 30, 0)));
      });

      test('シリアライズ→デシリアライズで同じ値になる', () {
        final original = HighScore(
          score: 12345,
          level: 7,
          linesCleared: 30,
          achievedAt: DateTime(2026, 3, 20, 15, 45, 30),
        );

        final json = original.toJson();
        final restored = HighScore.fromJson(json);

        expect(restored, equals(original));
      });
    });
  });
}
