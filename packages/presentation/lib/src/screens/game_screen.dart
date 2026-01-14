import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tetris_domain/tetris_domain.dart';

import '../flame/tetris_game.dart';
import '../widgets/hold_panel.dart';
import '../widgets/mobile_controls.dart';
import '../widgets/next_panel.dart';
import '../widgets/score_panel.dart';

/// ゲームメイン画面
class GameScreen extends StatefulWidget {
  /// GameScreenを生成
  const GameScreen({
    required this.game,
    super.key,
  });

  /// テトリスゲームインスタンス
  final TetrisGame game;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameState? _gameState;

  @override
  void initState() {
    super.initState();
    _gameState = widget.game.state;
    widget.game.onStateChanged = _onStateChanged;
  }

  void _onStateChanged(GameState state) {
    setState(() {
      _gameState = state;
    });
  }

  @override
  void dispose() {
    widget.game.onStateChanged = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1F),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return _buildWideLayout(constraints);
            } else {
              return _buildNarrowLayout(constraints);
            }
          },
        ),
      ),
    );
  }

  /// 横長レイアウト（PC/タブレット）
  Widget _buildWideLayout(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 左パネル（HOLD + SCORE）
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HoldPanel(
                heldType: _gameState?.heldTetromino?.type,
                canHold: _gameState?.canHold ?? true,
              ),
              const SizedBox(height: 16),
              ScorePanel(
                score: _gameState?.score ?? 0,
                level: _gameState?.level ?? 1,
                linesCleared: _gameState?.linesCleared ?? 0,
              ),
            ],
          ),
        ),

        // ゲームボード
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: Board.defaultWidth / Board.defaultHeight,
              child: GameWidget(game: widget.game),
            ),
          ),
        ),

        // 右パネル（NEXT）
        Padding(
          padding: const EdgeInsets.all(16),
          child: NextPanel(
            nextQueue: _gameState?.nextQueue ?? [],
          ),
        ),
      ],
    );
  }

  /// 縦長レイアウト（モバイル）
  Widget _buildNarrowLayout(BoxConstraints constraints) {
    return Column(
      children: [
        // 上部パネル
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HoldPanel(
                heldType: _gameState?.heldTetromino?.type,
                canHold: _gameState?.canHold ?? true,
                cellSize: 12,
              ),
              ScorePanel(
                score: _gameState?.score ?? 0,
                level: _gameState?.level ?? 1,
                linesCleared: _gameState?.linesCleared ?? 0,
              ),
              NextPanel(
                nextQueue: (_gameState?.nextQueue ?? []).take(3).toList(),
                cellSize: 12,
              ),
            ],
          ),
        ),

        // ゲームボード
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: Board.defaultWidth / Board.defaultHeight,
              child: GameWidget(game: widget.game),
            ),
          ),
        ),

        // モバイルコントロール
        Padding(
          padding: const EdgeInsets.all(16),
          child: MobileControls(
            onMoveLeft: widget.game.moveLeft,
            onMoveRight: widget.game.moveRight,
            onSoftDrop: widget.game.softDrop,
            onHardDrop: widget.game.hardDrop,
            onRotateClockwise: widget.game.rotateClockwise,
            onRotateCounterClockwise: widget.game.rotateCounterClockwise,
            onHold: widget.game.hold,
            onPause: widget.game.togglePause,
          ),
        ),
      ],
    );
  }
}

/// ゲームオーバーオーバーレイ
class GameOverOverlay extends StatelessWidget {
  /// GameOverOverlayを生成
  const GameOverOverlay({
    required this.score,
    required this.onRestart,
    required this.onQuit,
    super.key,
  });

  /// 最終スコア
  final int score;

  /// リスタートコールバック
  final VoidCallback onRestart;

  /// 終了コールバック
  final VoidCallback onQuit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF4A4A6E),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'GAME OVER',
                style: TextStyle(
                  color: Color(0xFFFF4444),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'SCORE: ${score.toString().padLeft(8, '0')}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: onRestart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A6A4A),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('RETRY'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: onQuit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A4A4A),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('QUIT'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 一時停止オーバーレイ
class PauseOverlay extends StatelessWidget {
  /// PauseOverlayを生成
  const PauseOverlay({
    required this.onResume,
    required this.onQuit,
    super.key,
  });

  /// 再開コールバック
  final VoidCallback onResume;

  /// 終了コールバック
  final VoidCallback onQuit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF4A4A6E),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'PAUSED',
                style: TextStyle(
                  color: Color(0xFFFFFF44),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onResume,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A6A4A),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('RESUME'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onQuit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A4A4A),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('QUIT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
