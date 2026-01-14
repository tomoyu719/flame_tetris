import 'package:flutter/material.dart';
import 'package:tetris_domain/tetris_domain.dart';

import 'tetromino_preview.dart';

/// NEXTテトリミノを表示するパネル
class NextPanel extends StatelessWidget {
  /// NextPanelを生成
  const NextPanel({
    required this.nextQueue,
    this.cellSize = 16.0,
    super.key,
  });

  /// NEXTキュー（表示するテトリミノタイプのリスト）
  final List<TetrominoType> nextQueue;

  /// セルサイズ
  final double cellSize;

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'NEXT',
            style: TextStyle(
              color: Color(0xFF8888AA),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          ...nextQueue.map(
            (type) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TetrominoPreview(
                type: type,
                cellSize: cellSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
