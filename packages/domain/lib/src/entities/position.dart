import 'package:meta/meta.dart';

/// ゲームボード上の座標を表すイミュータブルなクラス
///
/// テトリミノやブロックの位置を表現するために使用
/// x座標は左から右（0から始まる）、y座標は上から下（0から始まる）
@immutable
class Position {
  /// 指定された座標でPositionを生成
  const Position(this.x, this.y);

  /// X座標（水平方向、左から右）
  final int x;

  /// Y座標（垂直方向、上から下）
  final int y;

  /// 2つのPositionを加算して新しいPositionを返す
  Position operator +(Position other) {
    return Position(x + other.x, y + other.y);
  }

  /// 2つのPositionを減算して新しいPositionを返す
  Position operator -(Position other) {
    return Position(x - other.x, y - other.y);
  }

  /// 指定されたフィールドのみを変更した新しいPositionを返す
  Position copyWith({int? x, int? y}) {
    return Position(x ?? this.x, y ?? this.y);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Position && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Position($x, $y)';
}
