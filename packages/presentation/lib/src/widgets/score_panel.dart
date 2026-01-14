import 'package:flutter/material.dart';

/// スコアとレベルを表示するパネル
class ScorePanel extends StatelessWidget {
  /// ScorePanelを生成
  const ScorePanel({
    required this.score,
    required this.level,
    required this.linesCleared,
    super.key,
  });

  /// 現在のスコア
  final int score;

  /// 現在のレベル
  final int level;

  /// 消去したライン数
  final int linesCleared;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF4A4A6E),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatRow('SCORE', score.toString().padLeft(8, '0')),
          const SizedBox(height: 12),
          _buildStatRow('LEVEL', level.toString()),
          const SizedBox(height: 12),
          _buildStatRow('LINES', linesCleared.toString()),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8888AA),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}
