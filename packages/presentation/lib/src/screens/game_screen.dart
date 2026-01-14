import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tetris_domain/tetris_domain.dart';

import '../flame/tetris_game.dart';
import '../widgets/hold_panel.dart';
import '../widgets/mobile_controls.dart';
import '../widgets/next_panel.dart';
import '../widgets/responsive_layout.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final deviceType = ResponsiveLayout.getDeviceType(constraints.maxWidth);

            switch (deviceType) {
              case DeviceType.mobile:
                return _buildMobileLayout(constraints);
              case DeviceType.tablet:
                return _buildTabletLayout(constraints);
              case DeviceType.desktop:
                return _buildDesktopLayout(constraints);
            }
          },
        ),
      ),
    );
  }

  /// モバイルレイアウト（縦長）
  Widget _buildMobileLayout(BoxConstraints constraints) {
    return Column(
      children: [
        // 上部パネル（横並び）
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

  /// タブレットレイアウト（中間サイズ）
  Widget _buildTabletLayout(BoxConstraints constraints) {
    // タブレットでは横長レイアウトだが、パネルサイズを調整
    final panelWidth = constraints.maxWidth * 0.2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 左パネル
        SizedBox(
          width: panelWidth.clamp(100, 160),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HoldPanel(
                  heldType: _gameState?.heldTetromino?.type,
                  canHold: _gameState?.canHold ?? true,
                  cellSize: 16,
                ),
                const SizedBox(height: 12),
                ScorePanel(
                  score: _gameState?.score ?? 0,
                  level: _gameState?.level ?? 1,
                  linesCleared: _gameState?.linesCleared ?? 0,
                ),
              ],
            ),
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

        // 右パネル
        SizedBox(
          width: panelWidth.clamp(100, 160),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: NextPanel(
              nextQueue: _gameState?.nextQueue ?? [],
              cellSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  /// デスクトップレイアウト（横長）
  Widget _buildDesktopLayout(BoxConstraints constraints) {
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
    final theme = Theme.of(context);

    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'GAME OVER',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.error,
                  fontSize: 24,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'SCORE: ${score.toString().padLeft(8, '0')}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
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
                      backgroundColor:
                          theme.colorScheme.primary.withValues(alpha: 0.2),
                      foregroundColor: theme.colorScheme.primary,
                      side: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
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
                      backgroundColor:
                          theme.colorScheme.error.withValues(alpha: 0.2),
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(
                        color: theme.colorScheme.error,
                        width: 2,
                      ),
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
