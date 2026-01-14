import 'package:tetris_domain/tetris_domain.dart';

/// ライン消去サービスの実装
///
/// 完成したラインの検出と消去を処理する。
class LineClearServiceImpl implements LineClearService {
  @override
  LineClearResult clearLines(Board board) {
    final completedIndices = getCompletedLineIndices(board);

    if (completedIndices.isEmpty) {
      return LineClearResult.noClears(board);
    }

    final clearedBoard = board.clearLines(completedIndices);

    return LineClearResult(
      board: clearedBoard,
      linesCleared: LinesCleared(completedIndices.length),
      clearedLineIndices: completedIndices,
    );
  }

  @override
  List<int> getCompletedLineIndices(Board board) {
    return board.getCompletedLines();
  }

  @override
  bool isLineComplete(Board board, int lineIndex) {
    return board.isLineFull(lineIndex);
  }
}
