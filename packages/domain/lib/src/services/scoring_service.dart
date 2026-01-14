import 'package:tetris_domain/src/value_objects/value_objects.dart';

/// スコア計算サービスのインターフェース
///
/// テトリスのスコア計算ロジックを提供する。
/// 実装はInfrastructure層で提供される。
abstract class ScoringService {
  /// ライン消去時のスコアを計算する
  ///
  /// スコア計算式: baseScore × level
  /// - Single (1行): 100 × level
  /// - Double (2行): 300 × level
  /// - Triple (3行): 500 × level
  /// - Tetris (4行): 800 × level
  ///
  /// [linesCleared] 消去されたライン数
  /// [level] 現在のレベル
  /// Returns: 獲得スコア
  int calculateLineClearScore(LinesCleared linesCleared, Level level);

  /// ソフトドロップのスコアを計算する
  ///
  /// [cellsDropped] 落下したセル数
  /// Returns: 獲得スコア（1セルにつき1点）
  int calculateSoftDropScore(int cellsDropped);

  /// ハードドロップのスコアを計算する
  ///
  /// [cellsDropped] 落下したセル数
  /// Returns: 獲得スコア（1セルにつき2点）
  int calculateHardDropScore(int cellsDropped);
}
