import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// ライン消去時のフラッシュエフェクトコンポーネント
///
/// 消去されたラインに白いフラッシュアニメーションを表示する。
class LineClearEffect extends PositionComponent {
  /// LineClearEffectを生成
  ///
  /// [lineIndices]: 消去されたラインのインデックス
  /// [cellSize]: セルサイズ
  /// [boardWidth]: ボードの幅（セル数）
  /// [isTetris]: テトリス（4ライン消去）かどうか
  LineClearEffect({
    required List<int> lineIndices,
    required double cellSize,
    required int boardWidth,
    bool isTetris = false,
  })  : _lineIndices = lineIndices,
        _cellSize = cellSize,
        _boardWidth = boardWidth,
        _isTetris = isTetris;

  final List<int> _lineIndices;
  final double _cellSize;
  final int _boardWidth;
  final bool _isTetris;

  /// エフェクト完了時のコールバック
  VoidCallback? onComplete;

  /// アニメーション持続時間
  static const Duration _animationDuration = Duration(milliseconds: 300);

  /// テトリス時の追加フラッシュ回数
  static const int _tetrisFlashCount = 3;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 各ラインにフラッシュエフェクトを追加
    for (final lineIndex in _lineIndices) {
      final lineFlash = _LineFlashComponent(
        lineIndex: lineIndex,
        cellSize: _cellSize,
        boardWidth: _boardWidth,
      );
      add(lineFlash);
    }

    // テトリス時は画面全体のフラッシュを追加
    if (_isTetris) {
      final screenFlash = _ScreenFlashComponent(
        width: _cellSize * _boardWidth,
        height: _cellSize * 20, // ボードの高さ
        flashCount: _tetrisFlashCount,
      );
      add(screenFlash);
    }

    // アニメーション完了後に自己削除
    add(
      TimerComponent(
        period: _animationDuration.inMilliseconds / 1000.0,
        removeOnFinish: true,
        onTick: () {
          onComplete?.call();
          removeFromParent();
        },
      ),
    );
  }
}

/// 1ラインのフラッシュコンポーネント
///
/// 手動でオパシティをアニメーションする（OpacityEffectを使わない）
class _LineFlashComponent extends PositionComponent {
  _LineFlashComponent({
    required this.lineIndex,
    required this.cellSize,
    required this.boardWidth,
  }) : super(
          position: Vector2(0, lineIndex * cellSize),
          size: Vector2(cellSize * boardWidth, cellSize),
        );

  final int lineIndex;
  final double cellSize;
  final int boardWidth;

  late final Paint _paint;
  double _opacity = 1.0;
  double _elapsed = 0.0;
  static const double _duration = 0.3;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _paint = Paint()..color = Colors.white;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    // フェードアウト：1.0 -> 0.0
    _opacity = (1.0 - (_elapsed / _duration)).clamp(0.0, 1.0);
  }

  @override
  void render(Canvas canvas) {
    _paint.color = Colors.white.withValues(alpha: _opacity);
    canvas.drawRect(size.toRect(), _paint);
  }
}

/// テトリス時の画面フラッシュコンポーネント
///
/// 手動でオパシティをアニメーションする
class _ScreenFlashComponent extends PositionComponent {
  _ScreenFlashComponent({
    required double width,
    required double height,
    required this.flashCount,
  }) : super(size: Vector2(width, height));

  final int flashCount;

  late final Paint _paint;
  double _opacity = 0.0;
  double _elapsed = 0.0;
  int _currentFlash = 0;
  bool _fadingIn = true;
  static const double _flashDuration = 0.05;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _paint = Paint()..color = Colors.white;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_currentFlash >= flashCount) return;

    _elapsed += dt;

    if (_fadingIn) {
      // フェードイン：0.0 -> 0.5
      _opacity = ((_elapsed / _flashDuration) * 0.5).clamp(0.0, 0.5);
      if (_elapsed >= _flashDuration) {
        _elapsed = 0.0;
        _fadingIn = false;
      }
    } else {
      // フェードアウト：0.5 -> 0.0
      _opacity = (0.5 - (_elapsed / _flashDuration) * 0.5).clamp(0.0, 0.5);
      if (_elapsed >= _flashDuration) {
        _elapsed = 0.0;
        _fadingIn = true;
        _currentFlash++;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    _paint.color = Colors.white.withValues(alpha: _opacity);
    canvas.drawRect(size.toRect(), _paint);
  }
}

/// レベルアップエフェクトコンポーネント
///
/// スケールアップしながらフェードアウトするテキストを表示
class LevelUpEffect extends PositionComponent {
  /// LevelUpEffectを生成
  ///
  /// [level]: 新しいレベル
  /// [boardWidth]: ボード幅（ピクセル）
  /// [boardHeight]: ボード高さ（ピクセル）
  LevelUpEffect({
    required int level,
    required double boardWidth,
    required double boardHeight,
  })  : _level = level,
        super(
          position: Vector2(boardWidth / 2, boardHeight / 2),
          anchor: Anchor.center,
        );

  final int _level;
  double _scale = 1.0;
  double _opacity = 1.0;
  double _elapsed = 0.0;

  static const double _duration = 0.8;
  static const double _fadeStartAt = 0.3;

  late final TextPaint _textPaint;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.yellow,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            color: Colors.black,
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    _elapsed += dt;

    // スケールアップ: 1.0 -> 1.5 over duration
    _scale = 1.0 + (_elapsed / _duration) * 0.5;

    // フェードアウト: 開始は _fadeStartAt 秒後
    if (_elapsed > _fadeStartAt) {
      final fadeElapsed = _elapsed - _fadeStartAt;
      final fadeDuration = _duration - _fadeStartAt;
      _opacity = (1.0 - fadeElapsed / fadeDuration).clamp(0.0, 1.0);
    }

    // 完了時に削除
    if (_elapsed >= _duration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final text = 'LEVEL $_level';

    // スケールと透明度を適用
    canvas.save();
    canvas.scale(_scale);

    // テキストの色を透明度付きで再作成
    final style = _textPaint.style.copyWith(
      color: Colors.yellow.withValues(alpha: _opacity),
      shadows: [
        Shadow(
          color: Colors.black.withValues(alpha: _opacity),
          offset: const Offset(2, 2),
          blurRadius: 4,
        ),
      ],
    );

    final paint = TextPaint(style: style);
    paint.render(
      canvas,
      text,
      Vector2.zero(),
      anchor: Anchor.center,
    );

    canvas.restore();
  }
}
