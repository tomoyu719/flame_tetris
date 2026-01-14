import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tetris_domain/tetris_domain.dart';
import 'package:tetris_infrastructure/tetris_infrastructure.dart';

void main() {
  late ScoreRepositoryImpl repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = ScoreRepositoryImpl();
  });

  group('ScoreRepositoryImpl', () {
    group('getHighScore', () {
      test('保存されていない場合は空のハイスコアを返す', () async {
        final result = await repository.getHighScore();

        expect(result.score, equals(0));
        expect(result.level, equals(1));
        expect(result.linesCleared, equals(0));
      });

      test('保存されたハイスコアを取得できる', () async {
        final highScore = HighScore(
          score: 10000,
          level: 8,
          linesCleared: 45,
          achievedAt: DateTime(2026, 1, 15, 10, 30, 0),
        );

        // 先に保存
        SharedPreferences.setMockInitialValues({
          'high_score': jsonEncode(highScore.toJson()),
        });
        repository = ScoreRepositoryImpl();

        final result = await repository.getHighScore();

        expect(result.score, equals(10000));
        expect(result.level, equals(8));
        expect(result.linesCleared, equals(45));
      });

      test('不正なJSONの場合は空のハイスコアを返す', () async {
        SharedPreferences.setMockInitialValues({
          'high_score': 'invalid json',
        });
        repository = ScoreRepositoryImpl();

        final result = await repository.getHighScore();

        expect(result.score, equals(0));
      });
    });

    group('saveHighScore', () {
      test('ハイスコアを保存できる', () async {
        final highScore = HighScore(
          score: 15000,
          level: 10,
          linesCleared: 60,
          achievedAt: DateTime(2026, 2, 20, 14, 0, 0),
        );

        final result = await repository.saveHighScore(highScore);

        expect(result, isTrue);

        // 保存されたことを確認
        final saved = await repository.getHighScore();
        expect(saved.score, equals(15000));
        expect(saved.level, equals(10));
        expect(saved.linesCleared, equals(60));
      });

      test('既存のハイスコアを上書きできる', () async {
        final first = HighScore(
          score: 5000,
          level: 5,
          linesCleared: 20,
          achievedAt: DateTime(2026, 1, 1),
        );
        final second = HighScore(
          score: 20000,
          level: 12,
          linesCleared: 80,
          achievedAt: DateTime(2026, 1, 15),
        );

        await repository.saveHighScore(first);
        await repository.saveHighScore(second);

        final result = await repository.getHighScore();
        expect(result.score, equals(20000));
      });
    });

    group('clearHighScore', () {
      test('ハイスコアをクリアできる', () async {
        final highScore = HighScore(
          score: 10000,
          level: 8,
          linesCleared: 45,
          achievedAt: DateTime.now(),
        );

        await repository.saveHighScore(highScore);
        final cleared = await repository.clearHighScore();

        expect(cleared, isTrue);

        final result = await repository.getHighScore();
        expect(result.score, equals(0));
      });

      test('保存されていない状態でクリアしてもtrueを返す', () async {
        final result = await repository.clearHighScore();

        expect(result, isTrue);
      });
    });

    group('isHighScore', () {
      test('保存されていない場合、0より大きいスコアはハイスコア', () async {
        final result = await repository.isHighScore(100);

        expect(result, isTrue);
      });

      test('保存されていない場合、0はハイスコアではない', () async {
        final result = await repository.isHighScore(0);

        expect(result, isFalse);
      });

      test('保存されたスコアより高ければハイスコア', () async {
        final existing = HighScore(
          score: 5000,
          level: 5,
          linesCleared: 20,
          achievedAt: DateTime.now(),
        );
        await repository.saveHighScore(existing);

        expect(await repository.isHighScore(6000), isTrue);
        expect(await repository.isHighScore(10000), isTrue);
      });

      test('保存されたスコア以下はハイスコアではない', () async {
        final existing = HighScore(
          score: 5000,
          level: 5,
          linesCleared: 20,
          achievedAt: DateTime.now(),
        );
        await repository.saveHighScore(existing);

        expect(await repository.isHighScore(5000), isFalse);
        expect(await repository.isHighScore(4999), isFalse);
        expect(await repository.isHighScore(0), isFalse);
      });
    });
  });
}
