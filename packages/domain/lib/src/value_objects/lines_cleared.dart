import 'package:meta/meta.dart';

/// 一度に消去したライン数を表すValue Object
///
/// 0〜4の範囲で、消去したライン数に応じた基本スコアを持つ
@immutable
class LinesCleared {
  /// 指定した値でLinesClearedを生成
  ///
  /// [value]は0〜4の範囲でなければならない
  LinesCleared(this.value) {
    if (value < 0 || value > maxValue) {
      throw ArgumentError.value(
        value,
        'value',
        'LinesCleared must be between 0 and $maxValue',
      );
    }
  }

  /// 最大ライン数（Tetris）
  static const int maxValue = 4;

  /// 0ライン消去（消去なし）
  static final LinesCleared none = LinesCleared(0);

  /// 消去したライン数
  final int value;

  /// Single（1ライン消去）かどうか
  bool get isSingle => value == 1;

  /// Double（2ライン消去）かどうか
  bool get isDouble => value == 2;

  /// Triple（3ライン消去）かどうか
  bool get isTriple => value == 3;

  /// Tetris（4ライン消去）かどうか
  bool get isTetris => value == 4;

  /// 基本スコア
  ///
  /// - 0ライン: 0点
  /// - Single: 100点
  /// - Double: 300点
  /// - Triple: 500点
  /// - Tetris: 800点
  int get baseScore {
    return switch (value) {
      0 => 0,
      1 => 100,
      2 => 300,
      3 => 500,
      4 => 800,
      _ => 0,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LinesCleared && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'LinesCleared($value)';
}
