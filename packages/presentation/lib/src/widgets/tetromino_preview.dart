import 'package:flutter/material.dart';
import 'package:tetris_domain/tetris_domain.dart';

/// テトリミノのプレビューを描画するウィジェット
///
/// NEXT表示やHOLD表示で使用する。
class TetrominoPreview extends StatelessWidget {
  /// TetrominoPreviewを生成
  const TetrominoPreview({
    required this.type,
    this.cellSize = 20.0,
    super.key,
  });

  /// テトリミノタイプ
  final TetrominoType? type;

  /// セルサイズ
  final double cellSize;

  @override
  Widget build(BuildContext context) {
    if (type == null) {
      return SizedBox(
        width: cellSize * 4,
        height: cellSize * 2,
      );
    }

    return CustomPaint(
      size: Size(cellSize * 4, cellSize * 2),
      painter: _TetrominoPainter(
        type: type!,
        cellSize: cellSize,
      ),
    );
  }
}

class _TetrominoPainter extends CustomPainter {
  _TetrominoPainter({
    required this.type,
    required this.cellSize,
  });

  final TetrominoType type;
  final double cellSize;

  @override
  void paint(Canvas canvas, Size size) {
    final shape = TetrominoShapes.getShape(type, RotationState.spawn);
    final color = _getColor(type);
    final borderColor = _getBorderColor(type);

    // テトリミノを中央に配置するためのオフセットを計算
    final minX = shape.map((p) => p.x).reduce((a, b) => a < b ? a : b);
    final maxX = shape.map((p) => p.x).reduce((a, b) => a > b ? a : b);
    final minY = shape.map((p) => p.y).reduce((a, b) => a < b ? a : b);
    final maxY = shape.map((p) => p.y).reduce((a, b) => a > b ? a : b);

    final tetrominoWidth = (maxX - minX + 1) * cellSize;
    final tetrominoHeight = (maxY - minY + 1) * cellSize;

    final offsetX = (size.width - tetrominoWidth) / 2 - minX * cellSize;
    final offsetY = (size.height - tetrominoHeight) / 2 - minY * cellSize;

    final fillPaint = Paint()..color = color;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final pos in shape) {
      final rect = Rect.fromLTWH(
        offsetX + pos.x * cellSize + 1,
        offsetY + pos.y * cellSize + 1,
        cellSize - 2,
        cellSize - 2,
      );

      canvas.drawRect(rect, fillPaint);
      canvas.drawRect(rect, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TetrominoPainter oldDelegate) {
    return oldDelegate.type != type || oldDelegate.cellSize != cellSize;
  }

  Color _getColor(TetrominoType type) {
    return switch (type) {
      TetrominoType.i => const Color(0xFF00F0F0),
      TetrominoType.o => const Color(0xFFF0F000),
      TetrominoType.t => const Color(0xFFA000F0),
      TetrominoType.s => const Color(0xFF00F000),
      TetrominoType.z => const Color(0xFFF00000),
      TetrominoType.j => const Color(0xFF0000F0),
      TetrominoType.l => const Color(0xFFF0A000),
    };
  }

  Color _getBorderColor(TetrominoType type) {
    return switch (type) {
      TetrominoType.i => const Color(0xFF009999),
      TetrominoType.o => const Color(0xFF999900),
      TetrominoType.t => const Color(0xFF600099),
      TetrominoType.s => const Color(0xFF009900),
      TetrominoType.z => const Color(0xFF990000),
      TetrominoType.j => const Color(0xFF000099),
      TetrominoType.l => const Color(0xFF996000),
    };
  }
}
