import 'package:flutter/material.dart';

import '../l10n/tetris_l10n.dart';
import '../router/app_router.dart';

/// 一時停止オーバーレイ
///
/// ゲーム中に一時停止した際に表示するオーバーレイ。
/// 再開またはタイトルへの遷移を提供する。
class PauseOverlay extends StatelessWidget {
  /// PauseOverlayを生成
  const PauseOverlay({
    required this.onResume,
    super.key,
  });

  /// 再開時のコールバック
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 一時停止アイコン
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.pause,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),

              // タイトル
              Text(
                l10n.paused,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontSize: 20,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.pauseHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 8,
                ),
              ),

              const SizedBox(height: 32),

              // ボタン
              _PauseButton(
                label: l10n.buttonResume,
                icon: Icons.play_arrow,
                color: theme.colorScheme.primary,
                onPressed: onResume,
              ),
              const SizedBox(height: 12),
              _PauseButton(
                label: l10n.buttonQuit,
                icon: Icons.exit_to_app,
                color: theme.colorScheme.error,
                onPressed: () => context.goToTitle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 一時停止メニューボタン
class _PauseButton extends StatelessWidget {
  const _PauseButton({
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
      width: 180,
      height: 45,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
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
          side: BorderSide(color: color, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
