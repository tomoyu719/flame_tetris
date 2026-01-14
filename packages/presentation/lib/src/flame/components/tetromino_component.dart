import 'dart:async';

import 'package:flame/components.dart';
import 'package:tetris_domain/tetris_domain.dart';

import 'package:tetris_presentation/src/flame/components/block_component.dart';

/// テトリミノを描画するコンポーネント
///
/// 4つのBlockComponentで構成される。
/// テトリミノの形状と回転状態に応じてブロックを配置する。
class TetrominoComponent extends PositionComponent {
  /// TetrominoComponentを生成
  ///
  /// [tetromino]: 描画するテトリミノ
  /// [cellSize]: セルのサイズ（ピクセル）
  /// [isGhost]: ゴーストピースかどうか
  TetrominoComponent({
    required Tetromino tetromino,
    required double cellSize,
    bool isGhost = false,
  }) : _tetromino = tetromino,
       _cellSize = cellSize,
       _isGhost = isGhost;

  Tetromino _tetromino;
  final double _cellSize;
  final bool _isGhost;

  /// ブロックのプール（再利用用）
  final List<BlockComponent> _blockPool = [];

  /// 前回のテトリミノタイプ（型変更検知用）
  TetrominoType? _lastType;

  /// 前回の回転状態
  RotationState? _lastRotation;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _createBlocks();
  }

  /// ブロックを生成して配置
  void _createBlocks() {
    final shape = TetrominoShapes.getShape(
      _tetromino.type,
      _tetromino.rotation,
    );

    for (var i = 0; i < shape.length; i++) {
      final offset = shape[i];
      final block =
          BlockComponent(
              type: _tetromino.type,
              cellSize: _cellSize,
              isGhost: _isGhost,
            )
            ..position = Vector2(
              offset.x * _cellSize,
              offset.y * _cellSize,
            );
      _blockPool.add(block);
      // Flame's add() returns FutureOr<void>, fire-and-forget is intentional.
      // ignore: discarded_futures
      add(block);
    }

    _lastType = _tetromino.type;
    _lastRotation = _tetromino.rotation;
  }

  /// テトリミノを更新する
  ///
  /// 新しいテトリミノでブロックを再配置する。
  /// 可能な限りブロックを再利用してパフォーマンスを向上。
  void updateTetromino(Tetromino newTetromino) {
    _tetromino = newTetromino;

    final shape = TetrominoShapes.getShape(
      newTetromino.type,
      newTetromino.rotation,
    );

    // タイプまたは回転が変わった場合のみブロックを更新
    final needsBlockUpdate =
        _lastType != newTetromino.type ||
        _lastRotation != newTetromino.rotation;

    if (!needsBlockUpdate) {
      return; // 位置のみの変更は親コンポーネントの位置更新で対応済み
    }

    // タイプが変わった場合はブロックを再生成
    if (_lastType != newTetromino.type) {
      _recreateBlocksForNewType(newTetromino, shape);
    } else {
      // 回転のみ変わった場合は位置を更新
      _updateBlockPositions(shape);
    }

    _lastType = newTetromino.type;
    _lastRotation = newTetromino.rotation;
  }

  /// 新しいタイプ用にブロックを再生成
  void _recreateBlocksForNewType(
    Tetromino newTetromino,
    List<Position> shape,
  ) {
    // 既存のブロックを削除
    for (final block in _blockPool) {
      block.removeFromParent();
    }
    _blockPool.clear();

    // 新しいブロックを生成
    for (final offset in shape) {
      final block =
          BlockComponent(
              type: newTetromino.type,
              cellSize: _cellSize,
              isGhost: _isGhost,
            )
            ..position = Vector2(
              offset.x * _cellSize,
              offset.y * _cellSize,
            );
      _blockPool.add(block);
      // Flame's add() returns FutureOr<void>, fire-and-forget is intentional.
      // ignore: discarded_futures
      add(block);
    }
  }

  /// ブロック位置を更新（回転変更時）
  void _updateBlockPositions(List<Position> shape) {
    // プール内のブロック数と新しい形状のブロック数は常に同じ（テトリミノは常に4ブロック）
    for (var i = 0; i < shape.length && i < _blockPool.length; i++) {
      final offset = shape[i];
      _blockPool[i].position = Vector2(
        offset.x * _cellSize,
        offset.y * _cellSize,
      );
    }
  }
}

/// ゴーストピース用のテトリミノコンポーネント
class GhostTetrominoComponent extends TetrominoComponent {
  /// GhostTetrominoComponentを生成
  GhostTetrominoComponent({
    required super.tetromino,
    required super.cellSize,
  }) : super(isGhost: true);
}
