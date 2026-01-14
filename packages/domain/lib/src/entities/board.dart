import 'package:meta/meta.dart';

import '../enums/enums.dart';
import 'position.dart';

/// テトリスのゲームボードを表すイミュータブルなクラス
///
/// 10×20のグリッドで構成され、各セルにはテトリミノの種類（色）が格納される
/// 空のセルはnullで表現される
@immutable
class Board {
  /// 内部グリッドを直接指定してBoardを生成（プライベート）
  const Board._(this._grid);

  /// 空のボードを生成
  factory Board.empty() {
    final grid = List.generate(
      defaultHeight,
      (_) => List<TetrominoType?>.filled(defaultWidth, null),
    );
    return Board._(grid);
  }

  /// デフォルトの幅（列数）
  static const int defaultWidth = 10;

  /// デフォルトの高さ（行数）
  static const int defaultHeight = 20;

  /// バッファ高さ（見えない領域）
  static const int bufferHeight = 4;

  /// 内部グリッド（行→列の2次元リスト）
  final List<List<TetrominoType?>> _grid;

  /// ボードの幅
  int get width => defaultWidth;

  /// ボードの高さ
  int get height => defaultHeight;

  /// 指定位置のセルの値を取得
  ///
  /// 範囲外の場合はnullを返す
  TetrominoType? getCell(Position pos) {
    if (!isInBounds(pos)) return null;
    return _grid[pos.y][pos.x];
  }

  /// 指定位置にセルの値を設定した新しいBoardを返す
  Board setCell(Position pos, TetrominoType? type) {
    if (!isInBounds(pos)) return this;

    final newGrid = _copyGrid();
    newGrid[pos.y][pos.x] = type;
    return Board._(newGrid);
  }

  /// 座標がボード内にあるかどうかを判定
  bool isInBounds(Position pos) {
    return pos.x >= 0 && pos.x < width && pos.y >= 0 && pos.y < height;
  }

  /// 指定行が完全に埋まっているかを判定
  bool isLineFull(int y) {
    if (y < 0 || y >= height) return false;
    return _grid[y].every((cell) => cell != null);
  }

  /// 完全に埋まっている行のインデックスリストを取得
  List<int> getCompletedLines() {
    final lines = <int>[];
    for (var y = 0; y < height; y++) {
      if (isLineFull(y)) {
        lines.add(y);
      }
    }
    return lines;
  }

  /// 指定した行を消去し、上の行を落とす
  ///
  /// [lines]は消去する行のインデックス
  Board clearLines(List<int> lines) {
    if (lines.isEmpty) return this;

    final linesToClear = Set<int>.from(lines);
    final newGrid = <List<TetrominoType?>>[];

    // 消去対象でない行だけを残す
    for (var y = 0; y < height; y++) {
      if (!linesToClear.contains(y)) {
        newGrid.add(List<TetrominoType?>.from(_grid[y]));
      }
    }

    // 消去した行数分、上に空行を追加
    final clearedCount = lines.length;
    for (var i = 0; i < clearedCount; i++) {
      newGrid.insert(0, List<TetrominoType?>.filled(width, null));
    }

    return Board._(newGrid);
  }

  /// グリッドのディープコピーを作成
  List<List<TetrominoType?>> _copyGrid() {
    return _grid.map((row) => List<TetrominoType?>.from(row)).toList();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Board) return false;

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        if (_grid[y][x] != other._grid[y][x]) return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    var hash = 0;
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        hash = Object.hash(hash, _grid[y][x]);
      }
    }
    return hash;
  }

  @override
  String toString() {
    final buffer = StringBuffer('Board(\n');
    for (var y = 0; y < height; y++) {
      buffer.write('  ');
      for (var x = 0; x < width; x++) {
        final cell = _grid[y][x];
        buffer.write(cell == null ? '.' : cell.name[0].toUpperCase());
      }
      buffer.writeln();
    }
    buffer.write(')');
    return buffer.toString();
  }
}
