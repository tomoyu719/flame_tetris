import 'package:tetris_domain/src/entities/high_score.dart';

/// スコアの永続化を担当するリポジトリのインターフェース
///
/// ハイスコアの保存・取得を抽象化し、
/// 実装詳細（SharedPreferences等）を隠蔽する。
abstract class ScoreRepository {
  /// ハイスコアを取得する
  ///
  /// 保存されたハイスコアがない場合は[HighScore.empty()]を返す。
  Future<HighScore> getHighScore();

  /// ハイスコアを保存する
  ///
  /// [highScore]: 保存するハイスコア
  /// 保存に成功した場合はtrueを返す。
  Future<bool> saveHighScore(HighScore highScore);

  /// ハイスコアをクリアする
  ///
  /// 保存されているハイスコアを削除する。
  /// 削除に成功した場合はtrueを返す。
  Future<bool> clearHighScore();

  /// 現在のスコアがハイスコアかどうかを判定する
  ///
  /// [score]: 判定するスコア
  /// 現在のスコアが保存されているハイスコアより高い場合はtrueを返す。
  Future<bool> isHighScore(int score);
}
