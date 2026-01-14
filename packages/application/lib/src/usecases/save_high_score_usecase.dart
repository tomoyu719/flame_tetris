import 'package:tetris_domain/tetris_domain.dart';

/// ハイスコアを保存するユースケース
///
/// リポジトリにハイスコアを保存する。
class SaveHighScoreUseCase {
  /// SaveHighScoreUseCaseを生成
  ///
  /// [repository]: スコアリポジトリ
  const SaveHighScoreUseCase({
    required ScoreRepository repository,
  }) : _repository = repository;

  final ScoreRepository _repository;

  /// ハイスコアを保存する
  ///
  /// [highScore]: 保存するハイスコア
  /// 保存に成功した場合はtrueを返す。
  Future<bool> execute(HighScore highScore) {
    return _repository.saveHighScore(highScore);
  }

  /// GameStateからハイスコアを作成して保存する
  ///
  /// [gameState]: ゲーム状態
  /// 保存に成功した場合はtrueを返す。
  Future<bool> executeFromGameState(GameState gameState) {
    final highScore = HighScore(
      score: gameState.score,
      level: gameState.level,
      linesCleared: gameState.linesCleared,
      achievedAt: DateTime.now(),
    );
    return execute(highScore);
  }
}
