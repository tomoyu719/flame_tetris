import 'package:tetris_domain/tetris_domain.dart';

/// SRS（Super Rotation System）に基づく回転サービスの実装
///
/// テトリミノの回転とウォールキックを処理する。
class RotationServiceImpl implements RotationService {
  /// RotationServiceImplを生成
  ///
  /// [collisionService]: 衝突判定サービス
  const RotationServiceImpl({required this.collisionService});

  /// 衝突判定サービス
  final CollisionService collisionService;

  @override
  RotationResult rotate(
    Tetromino tetromino,
    Board board,
    RotationDirection direction,
  ) {
    final rotated = tetromino.rotate(direction);

    // 基本回転を試す
    if (collisionService.isValidPosition(rotated, board)) {
      return RotationResult(
        tetromino: rotated,
        success: true,
      );
    }

    // ウォールキックを試す
    final kickOffsets = SrsKickData.getKickOffsets(
      tetromino.type,
      tetromino.rotation,
      rotated.rotation,
    );

    for (var i = 0; i < kickOffsets.length; i++) {
      final kicked = rotated.copyWith(
        position: rotated.position + kickOffsets[i],
      );

      if (collisionService.isValidPosition(kicked, board)) {
        return RotationResult(
          tetromino: kicked,
          success: true,
          kickIndex: i + 1,
        );
      }
    }

    return RotationResult.failed(tetromino);
  }

  @override
  RotationResult rotateWithoutKick(
    Tetromino tetromino,
    Board board,
    RotationDirection direction,
  ) {
    final rotated = tetromino.rotate(direction);

    if (collisionService.isValidPosition(rotated, board)) {
      return RotationResult(
        tetromino: rotated,
        success: true,
      );
    }

    return RotationResult.failed(tetromino);
  }
}
