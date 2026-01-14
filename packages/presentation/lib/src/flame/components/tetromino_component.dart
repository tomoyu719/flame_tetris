import 'package:flame/components.dart';
import 'package:tetris_domain/tetris_domain.dart';

import 'block_component.dart';

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
  })  : _tetromino = tetromino,
        _cellSize = cellSize,
        _isGhost = isGhost;

  final Tetromino _tetromino;
  final double _cellSize;
  final bool _isGhost;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _createBlocks();
  }

  /// ブロックを生成して配置
  void _createBlocks() {
    final shape = TetrominoShapes.getShape(_tetromino.type, _tetromino.rotation);

    for (final offset in shape) {
      final block = BlockComponent(
        type: _tetromino.type,
        cellSize: _cellSize,
        isGhost: _isGhost,
      )..position = Vector2(
          offset.x * _cellSize,
          offset.y * _cellSize,
        );
      add(block);
    }
  }

  /// テトリミノを更新する
  ///
  /// 新しいテトリミノでブロックを再配置する。
  void updateTetromino(Tetromino newTetromino) {
    // 古いブロックを削除
    removeAll(children.whereType<BlockComponent>());

    // 新しい形状でブロックを生成
    final shape = TetrominoShapes.getShape(newTetromino.type, newTetromino.rotation);

    for (final offset in shape) {
      final block = BlockComponent(
        type: newTetromino.type,
        cellSize: _cellSize,
        isGhost: _isGhost,
      )..position = Vector2(
          offset.x * _cellSize,
          offset.y * _cellSize,
        );
      add(block);
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
