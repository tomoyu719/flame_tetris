import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tetris_domain/tetris_domain.dart';
import 'package:tetris_infrastructure/tetris_infrastructure.dart';

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

    return Dialog(
      backgroundColor: const Color(0xFF1A1A2E),
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
                const Text(
                  'HIGH SCORE',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
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
              data: (highScore) => _HighScoreContent(highScore: highScore),
            ),

            const SizedBox(height: 24),

            // 閉じるボタン
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.withValues(alpha: 0.2),
                  foregroundColor: Colors.cyan,
                  side: const BorderSide(color: Colors.cyan, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'CLOSE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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
  const _HighScoreContent({required this.highScore});

  final HighScore highScore;

  @override
  Widget build(BuildContext context) {
    if (highScore.score == 0) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              Icons.sports_esports,
              size: 48,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 12),
            Text(
              'No high score yet!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Play a game to set your first record.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
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
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
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
                label: 'Level',
                value: highScore.level.toString(),
              ),
              _DetailItem(
                icon: Icons.clear_all,
                label: 'Lines',
                value: highScore.linesCleared.toString(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 達成日時
          Text(
            _formatDate(highScore.achievedAt),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    if (date.millisecondsSinceEpoch == 0) {
      return '';
    }
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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
    return Column(
      children: [
        Icon(icon, color: Colors.grey[400], size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
