import 'package:flutter/material.dart';
import 'package:tetris_domain/tetris_domain.dart';

import 'package:tetris_presentation/src/widgets/tetromino_preview.dart';

/// HOLDテトリミノを表示するパネル
class HoldPanel extends StatelessWidget {
  /// HoldPanelを生成
  const HoldPanel({
    required this.heldType,
    this.canHold = true,
    this.cellSize = 16.0,
    super.key,
  });

  /// ホールド中のテトリミノタイプ（null = 空）
  final TetrominoType? heldType;

  /// ホールド可能かどうか
  final bool canHold;

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
          color: canHold ? const Color(0xFF4A4A6E) : const Color(0xFF6A3A3A),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'HOLD',
            style: TextStyle(
              color: canHold
                  ? const Color(0xFF8888AA)
                  : const Color(0xFF886666),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Opacity(
            opacity: canHold ? 1.0 : 0.5,
            child: TetrominoPreview(
              type: heldType,
              cellSize: cellSize,
            ),
          ),
        ],
      ),
    );
  }
}
