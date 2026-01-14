import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1F),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // タイトルロゴ
              const _TitleLogo(),
              const SizedBox(height: 60),

              // メニューボタン
              _MenuButton(
                label: 'START',
                onPressed: () => context.goToGame(),
              ),
              const SizedBox(height: 20),

              _MenuButton(
                label: 'HIGH SCORE',
                onPressed: () => _showHighScoreDialog(context),
              ),
              const SizedBox(height: 20),

              _MenuButton(
                label: 'SETTINGS',
                onPressed: () {
                  // TODO: Phase 3で実装
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings coming soon!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),

              const SizedBox(height: 80),

              // クレジット
              Text(
                '© 2026 Flame Tetris',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
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
  const _TitleLogo();

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
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Colors.cyan,
              Colors.purple,
              Colors.orange,
            ],
          ).createShader(bounds),
          child: const Text(
            'TETRIS',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 8,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'FLAME EDITION',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildBlock(Color color) {
    return Container(
      width: 30,
      height: 30,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 8,
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
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.cyan, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
