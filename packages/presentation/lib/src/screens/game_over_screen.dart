import 'package:flutter/material.dart';

import '../l10n/tetris_l10n.dart';
import '../router/app_router.dart';

/// ゲームオーバー画面
///
/// 最終スコア、レベル、消去ライン数を表示し、
/// リトライまたはタイトルへの遷移を提供する。
class GameOverScreen extends StatelessWidget {
  /// GameOverScreenを生成
  const GameOverScreen({
    required this.score,
    required this.level,
    required this.linesCleared,
    this.isNewHighScore = false,
    super.key,
  });

  /// 最終スコア
  final int score;

  /// 到達レベル
  final int level;

  /// 消去ライン数
  final int linesCleared;

  /// 新記録かどうか
  final bool isNewHighScore;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ゲームオーバータイトル
              Text(
                l10n.gameOver,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: 24,
                  color: theme.colorScheme.error,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 20),

              // 新記録表示
              if (isNewHighScore) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        l10n.newHighScore,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontSize: 10,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              const SizedBox(height: 20),

              // スコア詳細
              _ScoreDetail(label: l10n.labelScore, value: score.toString()),
              const SizedBox(height: 12),
              _ScoreDetail(label: l10n.labelLevel, value: level.toString()),
              const SizedBox(height: 12),
              _ScoreDetail(
                label: l10n.labelLines,
                value: linesCleared.toString(),
              ),

              const SizedBox(height: 60),

              // ボタン
              _ActionButton(
                label: l10n.buttonRetry,
                icon: Icons.replay,
                color: theme.colorScheme.primary,
                onPressed: () => context.goToGame(),
              ),
              const SizedBox(height: 16),
              _ActionButton(
                label: l10n.buttonTitle,
                icon: Icons.home,
                color: theme.colorScheme.outline,
                onPressed: () => context.goToTitle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// スコア詳細表示
class _ScoreDetail extends StatelessWidget {
  const _ScoreDetail({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 10),
          ),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

/// アクションボタン
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.2),
          foregroundColor: color,
          side: BorderSide(color: color, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
