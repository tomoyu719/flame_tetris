import 'dart:async' as async;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris_application/tetris_application.dart';
import 'package:tetris_domain/tetris_domain.dart';

import 'package:tetris_presentation/src/flame/components/board_component.dart';

/// テトリスゲームのメインクラス
///
/// FlameGameを継承し、ゲームループと描画を管理する。
class TetrisGame extends FlameGame with KeyboardEvents {
  /// TetrisGameを生成
  ///
  /// [controller]: ゲームコントローラー
  /// [cellSize]: セルのサイズ（ピクセル）
  /// [autoStart]: onLoad完了時に自動的にゲームを開始するか
  /// [audioService]: オーディオサービス（オプション）
  TetrisGame({
    required GameController controller,
    this.cellSize = 30.0,
    this.autoStart = false,
    AudioService? audioService,
  }) : _controller = controller,
       _audioService = audioService;

  final GameController _controller;
  final AudioService? _audioService;

  /// セルのサイズ（ピクセル）
  final double cellSize;

  /// onLoad完了時に自動的にゲームを開始するか
  final bool autoStart;

  /// ボードコンポーネント
  BoardComponent? _boardComponent;

  /// ゲームティック用タイマー
  async.Timer? _tickTimer;

  /// 現在のティック間隔（ミリ秒）
  int _currentTickInterval = 1000;

  /// 前回のレベル（レベルアップ検知用）
  int _previousLevel = 1;

  /// 前回の消去ライン数（ライン消去検知用）
  int _previousLinesCleared = 0;

  /// ゲーム状態変更時のコールバック
  void Function(GameState state)? onStateChanged;

  /// ゲームの準備ができたかどうか
  bool _isReady = false;

  /// ゲームの準備ができたかどうか
  bool get isReady => _isReady;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // ボードコンポーネントを作成
    final boardComponent = BoardComponent(cellSize: cellSize)
      ..position = Vector2(
        (size.x - cellSize * Board.defaultWidth) / 2,
        (size.y - cellSize * Board.defaultHeight) / 2,
      );
    _boardComponent = boardComponent;

    add(boardComponent);

    _isReady = true;

    // 自動開始が有効な場合はゲームを開始
    if (autoStart) {
      startGame();
    } else if (_controller.state != null) {
      // ゲームが既に開始されている場合は状態を反映
      boardComponent.updateGameState(_controller.state!);
      _startTickTimer();
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    // ボードを中央に配置
    final boardComponent = _boardComponent;
    if (boardComponent != null && children.contains(boardComponent)) {
      boardComponent.position = Vector2(
        (size.x - cellSize * Board.defaultWidth) / 2,
        (size.y - cellSize * Board.defaultHeight) / 2,
      );
    }
  }

  @override
  Color backgroundColor() => const Color(0xFF0F0F1F);

  /// ゲームを開始する
  void startGame() {
    _controller.startGame();
    _boardComponent?.clear();
    _previousLevel = 1;
    _previousLinesCleared = 0;
    _updateState();
    _startTickTimer();
  }

  /// ゲームをリスタートする
  void restartGame() {
    _stopTickTimer();
    _controller.restart();
    _boardComponent?.clear();
    _previousLevel = 1;
    _previousLinesCleared = 0;
    _updateState();
    _startTickTimer();
  }

  /// ゲームを一時停止する
  void pauseGame() {
    if (_controller.pause()) {
      _stopTickTimer();
      _updateState();
    }
  }

  /// ゲームを再開する
  void resumeGame() {
    if (_controller.resume()) {
      _startTickTimer();
      _updateState();
    }
  }

  /// 一時停止/再開をトグルする
  void togglePause() {
    if (_controller.isPlaying) {
      pauseGame();
    } else if (_controller.isPaused) {
      resumeGame();
    }
  }

  /// ティックタイマーを開始
  void _startTickTimer() {
    _stopTickTimer();

    _currentTickInterval = _getTickInterval(_controller.state?.level ?? 1);

    _tickTimer = async.Timer.periodic(
      Duration(milliseconds: _currentTickInterval),
      (_) => _onTick(),
    );
  }

  /// ティックタイマーを停止
  void _stopTickTimer() {
    _tickTimer?.cancel();
    _tickTimer = null;
  }

  /// ティック処理
  void _onTick() {
    if (!_controller.isPlaying) return;

    _controller.tick();

    // ライン消去とレベルアップの効果音を判定
    final state = _controller.state;
    if (state != null) {
      _checkAndPlaySoundEffects(state);
    }

    _updateState();

    // レベルに応じてティック間隔を更新
    final newInterval = _getTickInterval(_controller.state?.level ?? 1);
    if (newInterval != _currentTickInterval) {
      _startTickTimer();
    }

    // ゲームオーバーチェック
    if (_controller.isGameOver) {
      _audioService?.playSoundEffect(GameSoundEffect.gameOver);
      _stopTickTimer();
    }
  }

  /// ライン消去・レベルアップの効果音をチェックして再生
  void _checkAndPlaySoundEffects(GameState state) {
    // ライン消去をチェック
    final clearedLines = state.linesCleared - _previousLinesCleared;
    if (clearedLines > 0) {
      if (clearedLines >= 4) {
        // テトリス（4ライン以上消去）
        _audioService?.playSoundEffect(GameSoundEffect.tetris);
      } else {
        // 通常のライン消去
        _audioService?.playSoundEffect(GameSoundEffect.clear);
      }
      _previousLinesCleared = state.linesCleared;
    }

    // レベルアップをチェック
    if (state.level > _previousLevel) {
      _audioService?.playSoundEffect(GameSoundEffect.levelUp);
      _previousLevel = state.level;
    }
  }

  /// レベルに応じたティック間隔を取得（ミリ秒）
  int _getTickInterval(int level) {
    // レベルが上がるほど速くなる
    // レベル1: 1000ms, レベル15: 100ms
    const maxInterval = 1000;
    const minInterval = 100;
    const maxLevel = 15;

    final normalizedLevel = level.clamp(1, maxLevel);
    final ratio = (normalizedLevel - 1) / (maxLevel - 1);

    return (maxInterval - (maxInterval - minInterval) * ratio).round();
  }

  /// 状態を更新してUIに反映
  void _updateState() {
    if (_controller.state != null) {
      _boardComponent?.updateGameState(_controller.state!);
      onStateChanged?.call(_controller.state!);
    }
  }

  // ========== キーボード入力 ==========

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    // ゲームオーバー時は入力を無視
    if (_controller.isGameOver) {
      return KeyEventResult.ignored;
    }

    // 一時停止中はEscapeのみ受け付ける
    if (_controller.isPaused) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        resumeGame();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    // ゲーム中の入力処理
    final handled = _handleGameInput(event.logicalKey);

    if (handled) {
      _updateState();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  /// ゲーム中の入力を処理
  bool _handleGameInput(LogicalKeyboardKey key) {
    return switch (key) {
      LogicalKeyboardKey.arrowLeft => _handleMove(MoveDirection.left),
      LogicalKeyboardKey.arrowRight => _handleMove(MoveDirection.right),
      LogicalKeyboardKey.arrowDown => _handleSoftDrop(),
      LogicalKeyboardKey.arrowUp => _handleRotate(RotationDirection.clockwise),
      LogicalKeyboardKey.keyX => _handleRotate(RotationDirection.clockwise),
      LogicalKeyboardKey.keyZ => _handleRotate(
        RotationDirection.counterClockwise,
      ),
      LogicalKeyboardKey.space => _handleHardDrop(),
      LogicalKeyboardKey.keyC => _handleHold(),
      LogicalKeyboardKey.shift => _handleHold(),
      LogicalKeyboardKey.escape => _handlePause(),
      LogicalKeyboardKey.keyP => _handlePause(),
      _ => false,
    };
  }

  /// 移動処理
  bool _handleMove(MoveDirection direction) {
    final result = _controller.move(direction);
    if (result) {
      _audioService?.playSoundEffect(GameSoundEffect.move);
    }
    return result;
  }

  /// ソフトドロップ処理（内部）
  bool _handleSoftDrop() {
    return _controller.softDrop();
  }

  /// 回転処理
  bool _handleRotate(RotationDirection direction) {
    final result = _controller.rotate(direction);
    if (result) {
      _audioService?.playSoundEffect(GameSoundEffect.rotate);
    }
    return result;
  }

  /// ホールド処理
  bool _handleHold() {
    final result = _controller.hold();
    if (result) {
      _audioService?.playSoundEffect(GameSoundEffect.hold);
    }
    return result;
  }

  /// ハードドロップ処理
  bool _handleHardDrop() {
    final result = _controller.hardDrop();
    if (result) {
      _audioService?.playSoundEffect(GameSoundEffect.drop);
      if (_controller.isGameOver) {
        _audioService?.playSoundEffect(GameSoundEffect.gameOver);
        _stopTickTimer();
      }
    }
    return result;
  }

  /// 一時停止処理
  bool _handlePause() {
    pauseGame();
    return true;
  }

  // ========== 外部からの操作 ==========

  /// 左に移動
  void moveLeft() {
    if (_controller.move(MoveDirection.left)) {
      _audioService?.playSoundEffect(GameSoundEffect.move);
      _updateState();
    }
  }

  /// 右に移動
  void moveRight() {
    if (_controller.move(MoveDirection.right)) {
      _audioService?.playSoundEffect(GameSoundEffect.move);
      _updateState();
    }
  }

  /// ソフトドロップ
  void softDrop() {
    if (_controller.softDrop()) {
      _updateState();
    }
  }

  /// ハードドロップ
  void hardDrop() {
    if (_controller.hardDrop()) {
      _audioService?.playSoundEffect(GameSoundEffect.drop);
      _updateState();
      if (_controller.isGameOver) {
        _audioService?.playSoundEffect(GameSoundEffect.gameOver);
        _stopTickTimer();
      }
    }
  }

  /// 時計回りに回転
  void rotateClockwise() {
    if (_controller.rotate(RotationDirection.clockwise)) {
      _audioService?.playSoundEffect(GameSoundEffect.rotate);
      _updateState();
    }
  }

  /// 反時計回りに回転
  void rotateCounterClockwise() {
    if (_controller.rotate(RotationDirection.counterClockwise)) {
      _audioService?.playSoundEffect(GameSoundEffect.rotate);
      _updateState();
    }
  }

  /// ホールド
  void hold() {
    if (_controller.hold()) {
      _audioService?.playSoundEffect(GameSoundEffect.hold);
      _updateState();
    }
  }

  /// 現在のゲーム状態を取得
  GameState? get state => _controller.state;

  /// ゲームがプレイ中かどうか
  bool get isPlaying => _controller.isPlaying;

  /// ゲームが一時停止中かどうか
  bool get isPaused => _controller.isPaused;

  /// ゲームオーバーかどうか
  bool get isGameOver => _controller.isGameOver;

  @override
  void onRemove() {
    _stopTickTimer();
    super.onRemove();
  }
}
