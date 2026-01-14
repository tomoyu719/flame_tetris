import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:tetris_domain/tetris_domain.dart';

/// 1つのブロック（セル）を描画するコンポーネント
///
/// テトリミノを構成する最小単位。
/// テトリミノタイプに応じた色で描画される。
class BlockComponent extends RectangleComponent {
  /// BlockComponentを生成
  ///
  /// [type]: テトリミノタイプ（色を決定）
  /// [cellSize]: セルのサイズ（ピクセル）
  /// [isGhost]: ゴーストピースかどうか（半透明にする）
  BlockComponent({
    required TetrominoType type,
    required double cellSize,
    bool isGhost = false,
  }) : super(
          size: Vector2.all(cellSize - 2), // 1pxの隙間
          paint: Paint()
            ..color = _getColor(type).withValues(alpha: isGhost ? 0.3 : 1.0),
        ) {
    // 枠線用のペイント
    _borderPaint = Paint()
      ..color = _getBorderColor(type).withValues(alpha: isGhost ? 0.3 : 1.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // ハイライト用のペイント
    _highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: isGhost ? 0.1 : 0.3);
  }

  late final Paint _borderPaint;
  late final Paint _highlightPaint;

  @override
  void render(Canvas canvas) {
    // メインの塗りつぶし
    super.render(canvas);

    // 枠線
    canvas.drawRect(size.toRect(), _borderPaint);

    // 左上のハイライト（立体感）
    final highlightPath = Path()
      ..moveTo(0, size.y)
      ..lineTo(0, 0)
      ..lineTo(size.x, 0)
      ..lineTo(size.x - 4, 4)
      ..lineTo(4, 4)
      ..lineTo(4, size.y - 4)
      ..close();
    canvas.drawPath(highlightPath, _highlightPaint);
  }

  /// テトリミノタイプに応じた色を取得
  static Color _getColor(TetrominoType type) {
    return switch (type) {
      TetrominoType.i => const Color(0xFF00F0F0), // シアン
      TetrominoType.o => const Color(0xFFF0F000), // イエロー
      TetrominoType.t => const Color(0xFFA000F0), // パープル
      TetrominoType.s => const Color(0xFF00F000), // グリーン
      TetrominoType.z => const Color(0xFFF00000), // レッド
      TetrominoType.j => const Color(0xFF0000F0), // ブルー
      TetrominoType.l => const Color(0xFFF0A000), // オレンジ
    };
  }

  /// テトリミノタイプに応じた枠線色を取得
  static Color _getBorderColor(TetrominoType type) {
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

  /// テトリミノタイプから色を取得（外部から参照用）
  static Color getColorForType(TetrominoType type) => _getColor(type);
}
