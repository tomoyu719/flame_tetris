import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tetris_application/tetris_application.dart';
import 'package:tetris_infrastructure/tetris_infrastructure.dart';

import '../flame/tetris_game.dart';

/// ゲームコントローラーを提供するProvider
///
/// GameControllerを生成し、必要なサービスを注入する。
final gameControllerProvider = Provider<GameController>((ref) {
  // サービスを生成
  final collisionService = CollisionServiceImpl();
  final rotationService = RotationServiceImpl(
    collisionService: collisionService,
  );
  final lineClearService = LineClearServiceImpl();
  final scoringService = ScoringServiceImpl();

  // テトリミノジェネレーター
  final generator = TetrominoGenerator(random: Random());

  // GameControllerを生成
  return GameController(
    generator: generator,
    collisionService: collisionService,
    rotationService: rotationService,
    lineClearService: lineClearService,
    scoringService: scoringService,
  );
});

/// TetrisGameを提供するProvider
///
/// 画面ごとに新しいゲームインスタンスを生成するため、
/// autoDisposeを使用する。
final tetrisGameProvider = Provider.autoDispose<TetrisGame>((ref) {
  final controller = ref.watch(gameControllerProvider);

  final game = TetrisGame(
    controller: controller,
    cellSize: 30.0,
    autoStart: true, // onLoad完了時に自動的にゲームを開始
  );

  return game;
});

/// ゲーム状態を監視するためのStateNotifier
class GameStateNotifier extends StateNotifier<GameStateData> {
  /// GameStateNotifierを生成
  GameStateNotifier() : super(const GameStateData());

  /// ゲーム状態を更新
  void updateState({
    int? score,
    int? level,
    int? linesCleared,
    bool? isPlaying,
    bool? isPaused,
    bool? isGameOver,
  }) {
    state = state.copyWith(
      score: score,
      level: level,
      linesCleared: linesCleared,
      isPlaying: isPlaying,
      isPaused: isPaused,
      isGameOver: isGameOver,
    );
  }

  /// 状態をリセット
  void reset() {
    state = const GameStateData();
  }
}

/// ゲーム状態データ（UIで使用）
class GameStateData {
  /// GameStateDataを生成
  const GameStateData({
    this.score = 0,
    this.level = 1,
    this.linesCleared = 0,
    this.isPlaying = false,
    this.isPaused = false,
    this.isGameOver = false,
  });

  /// スコア
  final int score;

  /// レベル
  final int level;

  /// 消去ライン数
  final int linesCleared;

  /// プレイ中かどうか
  final bool isPlaying;

  /// 一時停止中かどうか
  final bool isPaused;

  /// ゲームオーバーかどうか
  final bool isGameOver;

  /// コピーを作成
  GameStateData copyWith({
    int? score,
    int? level,
    int? linesCleared,
    bool? isPlaying,
    bool? isPaused,
    bool? isGameOver,
  }) {
    return GameStateData(
      score: score ?? this.score,
      level: level ?? this.level,
      linesCleared: linesCleared ?? this.linesCleared,
      isPlaying: isPlaying ?? this.isPlaying,
      isPaused: isPaused ?? this.isPaused,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }
}

/// ゲーム状態Provider
final gameStateProvider =
    StateNotifierProvider<GameStateNotifier, GameStateData>(
  (ref) => GameStateNotifier(),
);
