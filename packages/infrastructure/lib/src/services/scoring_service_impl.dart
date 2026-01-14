import 'package:tetris_domain/tetris_domain.dart';

/// スコア計算サービスの実装
///
/// テトリスのスコア計算ロジックを提供する。
class ScoringServiceImpl implements ScoringService {
  @override
  int calculateLineClearScore(LinesCleared linesCleared, Level level) {
    return linesCleared.baseScore * level.value;
  }

  @override
  int calculateSoftDropScore(int cellsDropped) {
    return cellsDropped;
  }

  @override
  int calculateHardDropScore(int cellsDropped) {
    return cellsDropped * 2;
  }
}
