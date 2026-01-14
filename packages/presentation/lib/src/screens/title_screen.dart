import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/tetris_l10n.dart';
import '../router/app_router.dart';
import '../widgets/high_score_dialog.dart';

/// タイトル画面
///
/// ゲーム開始、設定、ハイスコア表示へのナビゲーションを提供する。
class TitleScreen extends ConsumerWidget {
  /// TitleScreenを生成
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // タイトルロゴ
              _TitleLogo(l10n: l10n),
              const SizedBox(height: 60),

              // メニューボタン
              _MenuButton(
                label: l10n.menuStart,
                onPressed: () => context.goToGame(),
              ),
              const SizedBox(height: 20),

              _MenuButton(
                label: l10n.menuHighScore,
                onPressed: () => _showHighScoreDialog(context),
              ),
              const SizedBox(height: 20),

              _MenuButton(
                label: l10n.menuSettings,
                onPressed: () => context.goToSettings(),
              ),

              const SizedBox(height: 80),

              // クレジット
              Text(
                l10n.copyright,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHighScoreDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => const HighScoreDialog(),
    );
  }
}

/// タイトルロゴ
class _TitleLogo extends StatelessWidget {
  const _TitleLogo({required this.l10n});

  final TetrisL10n l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // テトリスブロック風のアイコン
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBlock(Colors.cyan),
            _buildBlock(Colors.cyan),
            _buildBlock(Colors.cyan),
            _buildBlock(Colors.cyan),
          ],
        ),
        const SizedBox(height: 20),
        // タイトルテキスト
        Builder(
          builder: (context) {
            final theme = Theme.of(context);
            return ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                  theme.colorScheme.tertiary,
                ],
              ).createShader(bounds),
              child: Text(
                l10n.titleTetris,
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 32,
                  letterSpacing: 4,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Builder(
          builder: (context) {
            return Text(
              l10n.titleSubtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 8,
                    letterSpacing: 2,
                  ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBlock(Color color) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

/// メニューボタン
class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: theme.colorScheme.onSurface,
          side: BorderSide(color: theme.colorScheme.primary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
