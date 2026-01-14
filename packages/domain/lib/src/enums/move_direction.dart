/// テトリミノの移動方向を表す列挙型
enum MoveDirection {
  /// 左に移動
  left(-1, 0),

  /// 右に移動
  right(1, 0),

  /// 下に移動（ソフトドロップ）
  down(0, 1);

  const MoveDirection(this.dx, this.dy);

  /// X軸方向の移動量（左: -1, 右: +1, 下: 0）
  final int dx;

  /// Y軸方向の移動量（左: 0, 右: 0, 下: +1）
  final int dy;
}
