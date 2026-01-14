import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:tetris_domain/tetris_domain.dart';

import 'block_component.dart';
import 'line_clear_effect.dart';
import 'tetromino_component.dart';

/// ゲームボードを描画するコンポーネント
///
/// - 固定されたブロック
/// - 現在のテトリミノ
/// - ゴーストピース
/// - グリッド線
/// - アニメーションエフェクト
class BoardComponent extends PositionComponent {
  /// BoardComponentを生成
  ///
  /// [cellSize]: セルのサイズ（ピクセル）
  /// [boardWidth]: ボードの幅（セル数）
  /// [boardHeight]: ボードの高さ（セル数）
  BoardComponent({
    required double cellSize,
    int boardWidth = Board.defaultWidth,
    int boardHeight = Board.defaultHeight,
  })  : _cellSize = cellSize,
        _boardWidth = boardWidth,
        _boardHeight = boardHeight,
        super(
          size: Vector2(
            cellSize * boardWidth,
            cellSize * boardHeight,
          ),
        );

  final double _cellSize;
  final int _boardWidth;
  final int _boardHeight;

  // 固定ブロックのコンポーネントマップ（位置 -> BlockComponent）
  final Map<Position, BlockComponent> _fixedBlocks = {};

  // 現在のテトリミノコンポーネント
  TetrominoComponent? _currentTetrominoComponent;

  // ゴーストコンポーネント
  GhostTetrominoComponent? _ghostComponent;

  // ゴースト位置キャッシュ
  int? _cachedGhostY;
  int? _lastTetrominoX;
  RotationState? _lastTetrominoRotation;
  TetrominoType? _lastTetrominoType;
  int? _lastBoardHash;

  // 前回の状態（エフェクト検知用）
  int _previousLevel = 1;
  List<int> _previousClearedLines = const [];

  // 背景ペイント
  late final Paint _backgroundPaint;
  late final Paint _gridPaint;
  late final Paint _borderPaint;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _backgroundPaint = Paint()..color = const Color(0xFF1A1A2E);

    _gridPaint = Paint()
      ..color = const Color(0xFF2A2A4E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    _borderPaint = Paint()
      ..color = const Color(0xFF4A4A6E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
  }

  @override
  void render(Canvas canvas) {
    // 背景
    canvas.drawRect(size.toRect(), _backgroundPaint);

    // グリッド線
    _drawGrid(canvas);

    // 枠線
    canvas.drawRect(size.toRect(), _borderPaint);

    super.render(canvas);
  }

  /// グリッド線を描画
  void _drawGrid(Canvas canvas) {
    // 縦線
    for (var x = 1; x < _boardWidth; x++) {
      canvas.drawLine(
        Offset(x * _cellSize, 0),
        Offset(x * _cellSize, size.y),
        _gridPaint,
      );
    }

    // 横線
    for (var y = 1; y < _boardHeight; y++) {
      canvas.drawLine(
        Offset(0, y * _cellSize),
        Offset(size.x, y * _cellSize),
        _gridPaint,
      );
    }
  }

  /// ゲーム状態を更新
  void updateGameState(GameState state) {
    // ライン消去エフェクトをチェック
    _checkLineClearEffect(state);

    // レベルアップエフェクトをチェック
    _checkLevelUpEffect(state);

    _updateFixedBlocks(state.board);
    _updateCurrentTetromino(state.currentTetromino);
    _updateGhost(state.currentTetromino, state.board);
  }

  /// ライン消去エフェクトをチェック
  void _checkLineClearEffect(GameState state) {
    final clearedLines = state.lastClearedLines;

    // 新しいライン消去がある場合
    if (clearedLines.isNotEmpty &&
        !_listEquals(clearedLines, _previousClearedLines)) {
      final isTetris = clearedLines.length >= 4;

      final effect = LineClearEffect(
        lineIndices: clearedLines,
        cellSize: _cellSize,
        boardWidth: _boardWidth,
        isTetris: isTetris,
      );
      add(effect);

      _previousClearedLines = clearedLines;
    } else if (clearedLines.isEmpty) {
      _previousClearedLines = const [];
    }
  }

  /// レベルアップエフェクトをチェック
  void _checkLevelUpEffect(GameState state) {
    if (state.level > _previousLevel) {
      final effect = LevelUpEffect(
        level: state.level,
        boardWidth: size.x,
        boardHeight: size.y,
      );
      add(effect);
    }
    _previousLevel = state.level;
  }

  /// 固定ブロックを更新
  void _updateFixedBlocks(Board board) {
    // 変更があった位置のみ更新
    final currentPositions = <Position>{};

    for (var y = 0; y < _boardHeight; y++) {
      for (var x = 0; x < _boardWidth; x++) {
        final pos = Position(x, y);
        final cell = board.getCell(pos);

        if (cell != null) {
          currentPositions.add(pos);

          // 既存のブロックがない場合は追加
          if (!_fixedBlocks.containsKey(pos)) {
            final block = BlockComponent(
              type: cell,
              cellSize: _cellSize,
            )..position = Vector2(
                x * _cellSize + 1, // 1px のオフセット
                y * _cellSize + 1,
              );
            _fixedBlocks[pos] = block;
            add(block);
          }
        }
      }
    }

    // 不要になったブロックを削除
    final toRemove = <Position>[];
    for (final pos in _fixedBlocks.keys) {
      if (!currentPositions.contains(pos)) {
        toRemove.add(pos);
      }
    }
    for (final pos in toRemove) {
      final block = _fixedBlocks.remove(pos);
      block?.removeFromParent();
    }
  }

  /// 現在のテトリミノを更新
  void _updateCurrentTetromino(Tetromino? tetromino) {
    if (tetromino == null) {
      _currentTetrominoComponent?.removeFromParent();
      _currentTetrominoComponent = null;
      return;
    }

    if (_currentTetrominoComponent == null) {
      _currentTetrominoComponent = TetrominoComponent(
        tetromino: tetromino,
        cellSize: _cellSize,
      )..position = Vector2(
          tetromino.position.x * _cellSize + 1,
          tetromino.position.y * _cellSize + 1,
        );
      add(_currentTetrominoComponent!);
    } else {
      _currentTetrominoComponent!
        ..position = Vector2(
          tetromino.position.x * _cellSize + 1,
          tetromino.position.y * _cellSize + 1,
        )
        ..updateTetromino(tetromino);
    }
  }

  /// ゴーストピースを更新
  void _updateGhost(Tetromino? tetromino, Board board) {
    if (tetromino == null) {
      _ghostComponent?.removeFromParent();
      _ghostComponent = null;
      _invalidateGhostCache();
      return;
    }

    // ゴースト位置を計算（キャッシュ利用）
    final ghostY = _calculateGhostY(tetromino, board);

    // 現在位置と同じならゴーストは不要
    if (ghostY == tetromino.position.y) {
      _ghostComponent?.removeFromParent();
      _ghostComponent = null;
      return;
    }

    final ghostTetromino = Tetromino(
      type: tetromino.type,
      position: Position(tetromino.position.x, ghostY),
      rotation: tetromino.rotation,
    );

    if (_ghostComponent == null) {
      _ghostComponent = GhostTetrominoComponent(
        tetromino: ghostTetromino,
        cellSize: _cellSize,
      )..position = Vector2(
          ghostTetromino.position.x * _cellSize + 1,
          ghostTetromino.position.y * _cellSize + 1,
        );
      add(_ghostComponent!);
    } else {
      _ghostComponent!
        ..position = Vector2(
          ghostTetromino.position.x * _cellSize + 1,
          ghostTetromino.position.y * _cellSize + 1,
        )
        ..updateTetromino(ghostTetromino);
    }
  }

  /// ゴースト位置を計算（キャッシュ利用）
  ///
  /// テトリミノのx座標、回転、またはボード状態が変わった時のみ再計算
  int _calculateGhostY(Tetromino tetromino, Board board) {
    // ボードのハッシュを簡易計算（固定ブロック数で代用）
    final boardHash = _fixedBlocks.length;

    // キャッシュが有効かチェック
    final cacheValid = _cachedGhostY != null &&
        _lastTetrominoX == tetromino.position.x &&
        _lastTetrominoRotation == tetromino.rotation &&
        _lastTetrominoType == tetromino.type &&
        _lastBoardHash == boardHash;

    if (cacheValid) {
      return _cachedGhostY!;
    }

    // ゴースト位置を計算（最下部まで落下した位置）
    var ghostY = tetromino.position.y;
    final shape = TetrominoShapes.getShape(tetromino.type, tetromino.rotation);

    outer:
    while (true) {
      ghostY++;
      for (final offset in shape) {
        final x = tetromino.position.x + offset.x;
        final y = ghostY + offset.y;

        // 底に達した
        if (y >= _boardHeight) {
          ghostY--;
          break outer;
        }

        // 他のブロックと衝突
        if (y >= 0 && board.getCell(Position(x, y)) != null) {
          ghostY--;
          break outer;
        }
      }
    }

    // キャッシュを更新
    _cachedGhostY = ghostY;
    _lastTetrominoX = tetromino.position.x;
    _lastTetrominoRotation = tetromino.rotation;
    _lastTetrominoType = tetromino.type;
    _lastBoardHash = boardHash;

    return ghostY;
  }

  /// ゴーストキャッシュを無効化
  void _invalidateGhostCache() {
    _cachedGhostY = null;
    _lastTetrominoX = null;
    _lastTetrominoRotation = null;
    _lastTetrominoType = null;
    _lastBoardHash = null;
  }

  /// ボードをクリア（ゲームリスタート時）
  void clear() {
    for (final block in _fixedBlocks.values) {
      block.removeFromParent();
    }
    _fixedBlocks.clear();

    _currentTetrominoComponent?.removeFromParent();
    _currentTetrominoComponent = null;

    _ghostComponent?.removeFromParent();
    _ghostComponent = null;

    _invalidateGhostCache();

    _previousLevel = 1;
    _previousClearedLines = const [];
  }
}

/// リストの等価性を比較
bool _listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
