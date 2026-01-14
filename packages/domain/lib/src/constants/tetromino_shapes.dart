import 'package:tetris_domain/src/entities/position.dart';
import 'package:tetris_domain/src/enums/enums.dart';

/// 各テトリミノの形状データ（回転状態ごとの相対座標）
///
/// 座標は左上を原点として、各ブロックの相対位置を定義
/// SRS（Super Rotation System）に基づく形状
abstract final class TetrominoShapes {
  /// テトリミノの形状を取得
  ///
  /// [type]: テトリミノの種類
  /// [rotation]: 回転状態
  /// 戻り値: 相対座標のリスト（4要素）
  static List<Position> getShape(TetrominoType type, RotationState rotation) {
    return _shapes[type]![rotation]!;
  }

  static final Map<TetrominoType, Map<RotationState, List<Position>>> _shapes =
      {
        TetrominoType.i: _iShapes,
        TetrominoType.o: _oShapes,
        TetrominoType.t: _tShapes,
        TetrominoType.s: _sShapes,
        TetrominoType.z: _zShapes,
        TetrominoType.j: _jShapes,
        TetrominoType.l: _lShapes,
      };

  // I-テトリミノ (水色) - 4x1 棒状
  //
  // spawn:      clockwise:   inverted:    counterClockwise:
  // ....        ..#.         ....         .#..
  // ####        ..#.         ....         .#..
  // ....        ..#.         ####         .#..
  // ....        ..#.         ....         .#..
  static final Map<RotationState, List<Position>> _iShapes = {
    RotationState.spawn: const [
      Position(0, 1),
      Position(1, 1),
      Position(2, 1),
      Position(3, 1),
    ],
    RotationState.clockwise: const [
      Position(2, 0),
      Position(2, 1),
      Position(2, 2),
      Position(2, 3),
    ],
    RotationState.inverted: const [
      Position(0, 2),
      Position(1, 2),
      Position(2, 2),
      Position(3, 2),
    ],
    RotationState.counterClockwise: const [
      Position(1, 0),
      Position(1, 1),
      Position(1, 2),
      Position(1, 3),
    ],
  };

  // O-テトリミノ (黄色) - 2x2 正方形
  // 回転しても形状は変わらない
  //
  // .##.
  // .##.
  static final Map<RotationState, List<Position>> _oShapes = {
    RotationState.spawn: const [
      Position(1, 0),
      Position(2, 0),
      Position(1, 1),
      Position(2, 1),
    ],
    RotationState.clockwise: const [
      Position(1, 0),
      Position(2, 0),
      Position(1, 1),
      Position(2, 1),
    ],
    RotationState.inverted: const [
      Position(1, 0),
      Position(2, 0),
      Position(1, 1),
      Position(2, 1),
    ],
    RotationState.counterClockwise: const [
      Position(1, 0),
      Position(2, 0),
      Position(1, 1),
      Position(2, 1),
    ],
  };

  // T-テトリミノ (紫) - T字型
  //
  // spawn:      clockwise:   inverted:    counterClockwise:
  // .#.         .#.          ...          .#.
  // ###         .##          ###          ##.
  // ...         .#.          .#.          .#.
  static final Map<RotationState, List<Position>> _tShapes = {
    RotationState.spawn: const [
      Position(1, 0),
      Position(0, 1),
      Position(1, 1),
      Position(2, 1),
    ],
    RotationState.clockwise: const [
      Position(1, 0),
      Position(1, 1),
      Position(2, 1),
      Position(1, 2),
    ],
    RotationState.inverted: const [
      Position(0, 1),
      Position(1, 1),
      Position(2, 1),
      Position(1, 2),
    ],
    RotationState.counterClockwise: const [
      Position(1, 0),
      Position(0, 1),
      Position(1, 1),
      Position(1, 2),
    ],
  };

  // S-テトリミノ (緑) - S字型
  //
  // spawn:      clockwise:   inverted:    counterClockwise:
  // .##         .#.          ...          #..
  // ##.         .##          .##          ##.
  // ...         ..#          ##.          .#.
  static final Map<RotationState, List<Position>> _sShapes = {
    RotationState.spawn: const [
      Position(1, 0),
      Position(2, 0),
      Position(0, 1),
      Position(1, 1),
    ],
    RotationState.clockwise: const [
      Position(1, 0),
      Position(1, 1),
      Position(2, 1),
      Position(2, 2),
    ],
    RotationState.inverted: const [
      Position(1, 1),
      Position(2, 1),
      Position(0, 2),
      Position(1, 2),
    ],
    RotationState.counterClockwise: const [
      Position(0, 0),
      Position(0, 1),
      Position(1, 1),
      Position(1, 2),
    ],
  };

  // Z-テトリミノ (赤) - Z字型
  //
  // spawn:      clockwise:   inverted:    counterClockwise:
  // ##.         ..#          ...          .#.
  // .##         .##          ##.          ##.
  // ...         .#.          .##          #..
  static final Map<RotationState, List<Position>> _zShapes = {
    RotationState.spawn: const [
      Position(0, 0),
      Position(1, 0),
      Position(1, 1),
      Position(2, 1),
    ],
    RotationState.clockwise: const [
      Position(2, 0),
      Position(1, 1),
      Position(2, 1),
      Position(1, 2),
    ],
    RotationState.inverted: const [
      Position(0, 1),
      Position(1, 1),
      Position(1, 2),
      Position(2, 2),
    ],
    RotationState.counterClockwise: const [
      Position(1, 0),
      Position(0, 1),
      Position(1, 1),
      Position(0, 2),
    ],
  };

  // J-テトリミノ (青) - J字型
  //
  // spawn:      clockwise:   inverted:    counterClockwise:
  // #..         .##          ...          .#.
  // ###         .#.          ###          .#.
  // ...         .#.          ..#          ##.
  static final Map<RotationState, List<Position>> _jShapes = {
    RotationState.spawn: const [
      Position(0, 0),
      Position(0, 1),
      Position(1, 1),
      Position(2, 1),
    ],
    RotationState.clockwise: const [
      Position(1, 0),
      Position(2, 0),
      Position(1, 1),
      Position(1, 2),
    ],
    RotationState.inverted: const [
      Position(0, 1),
      Position(1, 1),
      Position(2, 1),
      Position(2, 2),
    ],
    RotationState.counterClockwise: const [
      Position(1, 0),
      Position(1, 1),
      Position(0, 2),
      Position(1, 2),
    ],
  };

  // L-テトリミノ (オレンジ) - L字型
  //
  // spawn:      clockwise:   inverted:    counterClockwise:
  // ..#         .#.          ...          ##.
  // ###         .#.          ###          .#.
  // ...         .##          #..          .#.
  static final Map<RotationState, List<Position>> _lShapes = {
    RotationState.spawn: const [
      Position(2, 0),
      Position(0, 1),
      Position(1, 1),
      Position(2, 1),
    ],
    RotationState.clockwise: const [
      Position(1, 0),
      Position(1, 1),
      Position(1, 2),
      Position(2, 2),
    ],
    RotationState.inverted: const [
      Position(0, 1),
      Position(1, 1),
      Position(2, 1),
      Position(0, 2),
    ],
    RotationState.counterClockwise: const [
      Position(0, 0),
      Position(1, 0),
      Position(1, 1),
      Position(1, 2),
    ],
  };
}
