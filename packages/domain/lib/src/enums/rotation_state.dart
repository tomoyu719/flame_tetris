/// テトリミノの回転状態を表す列挙型
///
/// SRS（Super Rotation System）に基づく4つの回転状態を定義
/// 時計回りに0° → 90° → 180° → 270°と遷移する
enum RotationState {
  /// 初期状態（0°）- スポーン時の向き
  spawn,

  /// 時計回りに90°回転した状態
  clockwise,

  /// 180°回転した状態（上下反転）
  inverted,

  /// 反時計回りに90°回転した状態（= 時計回りに270°）
  counterClockwise;

  /// 時計回りに回転した後の状態を取得
  RotationState rotateClockwise() {
    return RotationState.values[(index + 1) % 4];
  }

  /// 反時計回りに回転した後の状態を取得
  RotationState rotateCounterClockwise() {
    return RotationState.values[(index + 3) % 4];
  }
}
