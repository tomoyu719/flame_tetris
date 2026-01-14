import 'package:meta/meta.dart';

import '../enums/enums.dart';
import 'position.dart';

/// テトリミノを表すイミュータブルなクラス
///
/// テトリミノの種類、位置、回転状態を保持する
/// 実際のセル座標はConstants（TetrominoShapes）で定義される
@immutable
class Tetromino {
  /// テトリミノを生成
  const Tetromino({
    required this.type,
    required this.position,
    required this.rotation,
  });

  /// 初期位置にテトリミノをスポーンさせる
  ///
  /// ボードの中央上部（x=3, y=0）に配置
  factory Tetromino.spawn(TetrominoType type) {
    return Tetromino(
      type: type,
      position: const Position(3, 0),
      rotation: RotationState.spawn,
    );
  }

  /// テトリミノの種類
  final TetrominoType type;

  /// ボード上の位置（左上基準）
  final Position position;

  /// 回転状態
  final RotationState rotation;

  /// 指定方向に移動した新しいTetrominoを返す
  Tetromino move(MoveDirection direction) {
    return copyWith(
      position: Position(
        position.x + direction.dx,
        position.y + direction.dy,
      ),
    );
  }

  /// 指定方向に回転した新しいTetrominoを返す
  Tetromino rotate(RotationDirection direction) {
    final newRotation = switch (direction) {
      RotationDirection.clockwise => rotation.rotateClockwise(),
      RotationDirection.counterClockwise => rotation.rotateCounterClockwise(),
    };
    return copyWith(rotation: newRotation);
  }

  /// 指定されたフィールドのみを変更した新しいTetrominoを返す
  Tetromino copyWith({
    TetrominoType? type,
    Position? position,
    RotationState? rotation,
  }) {
    return Tetromino(
      type: type ?? this.type,
      position: position ?? this.position,
      rotation: rotation ?? this.rotation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tetromino &&
        other.type == type &&
        other.position == position &&
        other.rotation == rotation;
  }

  @override
  int get hashCode => Object.hash(type, position, rotation);

  @override
  String toString() => 'Tetromino($type, $position, $rotation)';
}
