import 'package:tetris_domain/src/entities/entities.dart';
import 'package:tetris_domain/src/value_objects/value_objects.dart';

/// ライン消去結果を表すクラス
class LineClearResult {
  /// LineClearResultを生成
  const LineClearResult({
    required this.board,
    required this.linesCleared,
    required this.clearedLineIndices,
  });

  /// ライン消去なしの結果を生成
  factory LineClearResult.noClears(Board board) {
    return LineClearResult(
      board: board,
      linesCleared: LinesCleared.none,
      clearedLineIndices: const [],
    );
  }

  /// 消去後のボード
  final Board board;

  /// 消去されたライン数
  final LinesCleared linesCleared;

  /// 消去されたラインのインデックス（上から）
  final List<int> clearedLineIndices;
}

/// ライン消去サービスのインターフェース
///
/// 完成したラインの検出と消去を処理する。
/// 実装はInfrastructure層で提供される。
abstract class LineClearService {
  /// ボード上の完成したラインを検出して消去する
  ///
  /// [board] 現在のボード状態
  /// Returns: ライン消去結果
  LineClearResult clearLines(Board board);

  /// ボード上の完成したラインのインデックスを取得する
  ///
  /// [board] 現在のボード状態
  /// Returns: 完成したラインのインデックスリスト（上から順）
  List<int> getCompletedLineIndices(Board board);

  /// 指定したラインが完成しているかを判定する
  ///
  /// [board] 現在のボード状態
  /// [lineIndex] 判定するラインのインデックス（上から）
  /// Returns: ラインが完成している場合true
  bool isLineComplete(Board board, int lineIndex);
}
