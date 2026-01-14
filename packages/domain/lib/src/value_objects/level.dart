/// ゲームレベルを表すValue Object
///
/// レベルは1〜15の範囲で、レベルが上がるとテトリミノの落下速度が速くなる
class Level {
  /// 指定した値でLevelを生成
  ///
  /// [value]は1〜15の範囲でなければならない
  /// 範囲外の場合は[ArgumentError]をスロー
  Level(this.value) {
    if (value < minValue || value > maxValue) {
      throw ArgumentError.value(
        value,
        'value',
        'Level must be between $minValue and $maxValue',
      );
    }
  }

  /// 最小レベル
  static const int minValue = 1;

  /// 最大レベル
  static const int maxValue = 15;

  /// 初期レベル（レベル1）
  static final Level initial = Level(1);

  /// 最大レベル（レベル15）
  static final Level max = Level(15);

  /// レベルの値
  final int value;

  /// レベルに応じたドロップ間隔（ミリ秒）
  ///
  /// レベル1: 1000ms → レベル15: 100ms
  /// 線形補間で計算
  int get dropIntervalMs {
    // レベル1で1000ms、レベル15で100ms
    // (15 - level) / 14 * 900 + 100
    const maxInterval = 1000;
    const minInterval = 100;
    const intervalRange = maxInterval - minInterval; // 900

    final normalizedLevel = (maxValue - value) / (maxValue - minValue);
    return (normalizedLevel * intervalRange + minInterval).round();
  }

  /// レベルを1上げた新しいLevelを返す
  ///
  /// 最大レベルの場合は同じ値を返す
  Level increment() {
    if (value >= maxValue) return this;
    return Level(value + 1);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Level && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Level($value)';
}
