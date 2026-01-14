import 'package:flutter_test/flutter_test.dart';
import 'package:tetris_application/tetris_application.dart';
import 'package:tetris_domain/tetris_domain.dart';

import '../mocks/mock_score_repository.dart';

void main() {
  late SaveHighScoreUseCase useCase;
  late MockScoreRepository mockRepository;

  setUp(() {
    mockRepository = MockScoreRepository();
    useCase = SaveHighScoreUseCase(repository: mockRepository);
  });

  group('SaveHighScoreUseCase', () {
    test('ハイスコアを保存する', () async {
      final highScore = HighScore(
        score: 15000,
        level: 10,
        linesCleared: 60,
        achievedAt: DateTime(2026, 2, 20),
      );

      final result = await useCase.execute(highScore);

      expect(result, isTrue);
      expect(mockRepository.savedHighScore?.score, equals(15000));
    });

    test('GameStateからハイスコアを作成して保存する', () async {
      final gameState = GameState.initial().copyWith(
        score: 20000,
        level: 12,
        linesCleared: 80,
      );

      final result = await useCase.executeFromGameState(gameState);

      expect(result, isTrue);
      expect(mockRepository.savedHighScore?.score, equals(20000));
      expect(mockRepository.savedHighScore?.level, equals(12));
      expect(mockRepository.savedHighScore?.linesCleared, equals(80));
    });

    test('保存に失敗した場合はfalseを返す', () async {
      mockRepository.shouldFail = true;
      final highScore = HighScore(
        score: 5000,
        level: 5,
        linesCleared: 20,
        achievedAt: DateTime.now(),
      );

      final result = await useCase.execute(highScore);

      expect(result, isFalse);
    });
  });
}
