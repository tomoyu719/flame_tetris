import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tetris_domain/tetris_domain.dart';
import 'package:tetris_infrastructure/tetris_infrastructure.dart';
import 'package:tetris_presentation/src/l10n/tetris_l10n.dart';

/// ハイスコアリポジトリProvider
final _scoreRepositoryProvider = Provider<ScoreRepository>((ref) {
  return ScoreRepositoryImpl();
});

/// ハイスコア取得Provider
final _highScoreProvider = FutureProvider<HighScore>((ref) async {
  final repository = ref.watch(_scoreRepositoryProvider);
  return repository.getHighScore();
});

/// ハイスコアダイアログ
///
/// 保存されているハイスコアを表示するダイアログ。
class HighScoreDialog extends ConsumerWidget {
  /// HighScoreDialogを生成
  const HighScoreDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highScoreAsync = ref.watch(_highScoreProvider);
    final l10n = context.l10n;

    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.amber.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ヘッダー
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  color: Colors.amber[400],
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.highScoreDialogTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.emoji_events,
                  color: Colors.amber[400],
                  size: 32,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // スコア表示
            highScoreAsync.when(
              loading: () => const CircularProgressIndicator(
                color: Colors.cyan,
              ),
              error: (error, stack) => Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red),
              ),
              data: (highScore) => _HighScoreContent(
                highScore: highScore,
                l10n: l10n,
              ),
            ),

            const SizedBox(height: 24),

            // 閉じるボタン
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.2,
                  ),
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  l10n.buttonClose,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ハイスコアコンテンツ
class _HighScoreContent extends StatelessWidget {
  const _HighScoreContent({required this.highScore, required this.l10n});

  final HighScore highScore;
  final TetrisL10n l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (highScore.score == 0) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              Icons.sports_esports,
              size: 40,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.highScoreNoRecord,
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 10),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.highScorePlayPrompt,
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 8),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.withValues(alpha: 0.1),
            Colors.orange.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // スコア
          Text(
            highScore.score.toString(),
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: 28,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 16),

          // 詳細
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _DetailItem(
                icon: Icons.trending_up,
                label: l10n.labelLevel,
                value: highScore.level.toString(),
              ),
              _DetailItem(
                icon: Icons.clear_all,
                label: l10n.labelLines,
                value: highScore.linesCleared.toString(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 達成日時
          Text(
            _formatDate(highScore.achievedAt),
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 8),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    if (date.millisecondsSinceEpoch == 0) {
      return '';
    }
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$year/$month/$day $hour:$minute';
  }
}

/// 詳細アイテム
class _DetailItem extends StatelessWidget {
  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.outline, size: 18),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 8),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 14),
        ),
      ],
    );
  }
}
