import 'package:flutter_test/flutter_test.dart';
import 'package:tetris_application/tetris_application.dart';
import 'package:tetris_domain/tetris_domain.dart';

import '../mocks/mock_score_repository.dart';

void main() {
  late GetHighScoreUseCase useCase;
  late MockScoreRepository mockRepository;

  setUp(() {
    mockRepository = MockScoreRepository();
    useCase = GetHighScoreUseCase(repository: mockRepository);
  });

  group('GetHighScoreUseCase', () {
    test('リポジトリからハイスコアを取得する', () async {
      final expectedScore = HighScore(
        score: 10000,
        level: 8,
        linesCleared: 45,
        achievedAt: DateTime(2026, 1, 15),
      );
      mockRepository.setHighScore(expectedScore);

      final result = await useCase.execute();

      expect(result.score, equals(10000));
      expect(result.level, equals(8));
      expect(result.linesCleared, equals(45));
    });

    test('ハイスコアがない場合は空のスコアを返す', () async {
      // デフォルトは空
      final result = await useCase.execute();

      expect(result.score, equals(0));
      expect(result.level, equals(1));
    });
  });
}
