import 'package:flutter/material.dart';

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
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.cyan.withValues(alpha: 0.5),
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
                  color: Colors.cyan.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pause,
                  size: 48,
                  color: Colors.cyan,
                ),
              ),
              const SizedBox(height: 24),

              // タイトル
              const Text(
                'PAUSED',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Press ESC or P to resume',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),

              const SizedBox(height: 32),

              // ボタン
              _PauseButton(
                label: 'RESUME',
                icon: Icons.play_arrow,
                color: Colors.cyan,
                onPressed: onResume,
              ),
              const SizedBox(height: 12),
              _PauseButton(
                label: 'QUIT',
                icon: Icons.exit_to_app,
                color: Colors.red,
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
    return SizedBox(
      width: 180,
      height: 45,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
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
