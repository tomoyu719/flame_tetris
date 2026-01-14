import 'package:meta/meta.dart';
import 'package:tetris_domain/src/entities/position.dart';
import 'package:tetris_domain/src/enums/enums.dart';

/// SRS（Super Rotation System）の壁蹴りデータ
///
/// 回転が壁や他のブロックと衝突した際のオフセット候補を定義
/// 5つのテストポジションを順番に試し、有効な位置が見つかれば回転成功
abstract final class SrsKickData {
  /// 壁蹴りオフセットを取得
  ///
  /// [type]: テトリミノの種類（IとO以外は共通）
  /// [from]: 回転前の状態
  /// [to]: 回転後の状態
  /// 戻り値: 試行するオフセットのリスト（5要素）
  static List<Position> getKickOffsets(
    TetrominoType type,
    RotationState from,
    RotationState to,
  ) {
    // O-テトリミノは回転しても形状が変わらないので壁蹴り不要
    if (type == TetrominoType.o) {
      return const [Position(0, 0)];
    }

    // I-テトリミノは専用のテーブルを使用
    if (type == TetrominoType.i) {
      return _iKickData[_KickKey(from, to)] ?? const [Position(0, 0)];
    }

    // その他（J, L, S, T, Z）は共通のテーブルを使用
    return _jlstzKickData[_KickKey(from, to)] ?? const [Position(0, 0)];
  }

  // JLSTZ共通の壁蹴りデータ
  static final Map<_KickKey, List<Position>> _jlstzKickData = {
    // 0 -> R (spawn -> clockwise)
    const _KickKey(RotationState.spawn, RotationState.clockwise): const [
      Position(0, 0),
      Position(-1, 0),
      Position(-1, -1),
      Position(0, 2),
      Position(-1, 2),
    ],
    // R -> 0 (clockwise -> spawn)
    const _KickKey(RotationState.clockwise, RotationState.spawn): const [
      Position(0, 0),
      Position(1, 0),
      Position(1, 1),
      Position(0, -2),
      Position(1, -2),
    ],
    // R -> 2 (clockwise -> inverted)
    const _KickKey(RotationState.clockwise, RotationState.inverted): const [
      Position(0, 0),
      Position(1, 0),
      Position(1, 1),
      Position(0, -2),
      Position(1, -2),
    ],
    // 2 -> R (inverted -> clockwise)
    const _KickKey(RotationState.inverted, RotationState.clockwise): const [
      Position(0, 0),
      Position(-1, 0),
      Position(-1, -1),
      Position(0, 2),
      Position(-1, 2),
    ],
    // 2 -> L (inverted -> counterClockwise)
    const _KickKey(
      RotationState.inverted,
      RotationState.counterClockwise,
    ): const [
      Position(0, 0),
      Position(1, 0),
      Position(1, -1),
      Position(0, 2),
      Position(1, 2),
    ],
    // L -> 2 (counterClockwise -> inverted)
    const _KickKey(
      RotationState.counterClockwise,
      RotationState.inverted,
    ): const [
      Position(0, 0),
      Position(-1, 0),
      Position(-1, 1),
      Position(0, -2),
      Position(-1, -2),
    ],
    // L -> 0 (counterClockwise -> spawn)
    const _KickKey(RotationState.counterClockwise, RotationState.spawn): const [
      Position(0, 0),
      Position(-1, 0),
      Position(-1, 1),
      Position(0, -2),
      Position(-1, -2),
    ],
    // 0 -> L (spawn -> counterClockwise)
    const _KickKey(RotationState.spawn, RotationState.counterClockwise): const [
      Position(0, 0),
      Position(1, 0),
      Position(1, -1),
      Position(0, 2),
      Position(1, 2),
    ],
  };

  // I-テトリミノ専用の壁蹴りデータ
  static final Map<_KickKey, List<Position>> _iKickData = {
    // 0 -> R
    const _KickKey(RotationState.spawn, RotationState.clockwise): const [
      Position(0, 0),
      Position(-2, 0),
      Position(1, 0),
      Position(-2, 1),
      Position(1, -2),
    ],
    // R -> 0
    const _KickKey(RotationState.clockwise, RotationState.spawn): const [
      Position(0, 0),
      Position(2, 0),
      Position(-1, 0),
      Position(2, -1),
      Position(-1, 2),
    ],
    // R -> 2
    const _KickKey(RotationState.clockwise, RotationState.inverted): const [
      Position(0, 0),
      Position(-1, 0),
      Position(2, 0),
      Position(-1, -2),
      Position(2, 1),
    ],
    // 2 -> R
    const _KickKey(RotationState.inverted, RotationState.clockwise): const [
      Position(0, 0),
      Position(1, 0),
      Position(-2, 0),
      Position(1, 2),
      Position(-2, -1),
    ],
    // 2 -> L
    const _KickKey(
      RotationState.inverted,
      RotationState.counterClockwise,
    ): const [
      Position(0, 0),
      Position(2, 0),
      Position(-1, 0),
      Position(2, -1),
      Position(-1, 2),
    ],
    // L -> 2
    const _KickKey(
      RotationState.counterClockwise,
      RotationState.inverted,
    ): const [
      Position(0, 0),
      Position(-2, 0),
      Position(1, 0),
      Position(-2, 1),
      Position(1, -2),
    ],
    // L -> 0
    const _KickKey(RotationState.counterClockwise, RotationState.spawn): const [
      Position(0, 0),
      Position(1, 0),
      Position(-2, 0),
      Position(1, 2),
      Position(-2, -1),
    ],
    // 0 -> L
    const _KickKey(RotationState.spawn, RotationState.counterClockwise): const [
      Position(0, 0),
      Position(-1, 0),
      Position(2, 0),
      Position(-1, -2),
      Position(2, 1),
    ],
  };
}

/// 壁蹴りテーブルのキー
@immutable
class _KickKey {
  const _KickKey(this.from, this.to);
  final RotationState from;
  final RotationState to;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _KickKey && other.from == from && other.to == to;
  }

  @override
  int get hashCode => Object.hash(from, to);
}
