import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1F),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ゲームオーバータイトル
              const Text(
                'GAME OVER',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  letterSpacing: 4,
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
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'NEW HIGH SCORE!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.star, color: Colors.amber, size: 24),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              const SizedBox(height: 20),

              // スコア詳細
              _ScoreDetail(label: 'SCORE', value: score.toString()),
              const SizedBox(height: 12),
              _ScoreDetail(label: 'LEVEL', value: level.toString()),
              const SizedBox(height: 12),
              _ScoreDetail(label: 'LINES', value: linesCleared.toString()),

              const SizedBox(height: 60),

              // ボタン
              _ActionButton(
                label: 'RETRY',
                icon: Icons.replay,
                color: Colors.cyan,
                onPressed: () => context.goToGame(),
              ),
              const SizedBox(height: 16),
              _ActionButton(
                label: 'TITLE',
                icon: Icons.home,
                color: Colors.grey,
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
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
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
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
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
