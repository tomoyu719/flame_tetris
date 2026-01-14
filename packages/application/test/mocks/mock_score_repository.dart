import 'package:tetris_domain/tetris_domain.dart';

/// テスト用のScoreRepositoryモック
class MockScoreRepository implements ScoreRepository {
  HighScore? _highScore;
  HighScore? savedHighScore;
  bool shouldFail = false;

  void setHighScore(HighScore score) {
    _highScore = score;
  }

  @override
  Future<HighScore> getHighScore() async {
    return _highScore ?? HighScore.empty();
  }

  @override
  Future<bool> saveHighScore(HighScore highScore) async {
    if (shouldFail) {
      return false;
    }
    savedHighScore = highScore;
    _highScore = highScore;
    return true;
  }

  @override
  Future<bool> clearHighScore() async {
    if (shouldFail) {
      return false;
    }
    _highScore = null;
    savedHighScore = null;
    return true;
  }

  @override
  Future<bool> isHighScore(int score) async {
    final current = _highScore ?? HighScore.empty();
    return score > current.score;
  }
}
