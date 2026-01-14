import 'package:tetris_domain/tetris_domain.dart';

/// ハイスコアを取得するユースケース
///
/// リポジトリからハイスコアを取得する。
class GetHighScoreUseCase {
  /// GetHighScoreUseCaseを生成
  ///
  /// [repository]: スコアリポジトリ
  const GetHighScoreUseCase({
    required ScoreRepository repository,
  }) : _repository = repository;

  final ScoreRepository _repository;

  /// ハイスコアを取得する
  ///
  /// ハイスコアが保存されていない場合は空のハイスコアを返す。
  Future<HighScore> execute() {
    return _repository.getHighScore();
  }
}
