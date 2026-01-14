import 'package:tetris_domain/src/entities/entities.dart';
import 'package:tetris_domain/src/enums/enums.dart';

/// 衝突判定サービスのインターフェース
///
/// テトリミノとボード間の衝突判定を行う。
/// 実装はInfrastructure層で提供される。
abstract class CollisionService {
  /// テトリミノが現在の位置で有効かどうかを判定する
  ///
  /// [tetromino] 判定対象のテトリミノ
  /// [board] 現在のボード状態
  /// Returns: 配置可能な場合true、衝突または範囲外の場合false
  bool isValidPosition(Tetromino tetromino, Board board);

  /// テトリミノを指定方向に移動できるかを判定する
  ///
  /// [tetromino] 移動対象のテトリミノ
  /// [board] 現在のボード状態
  /// [direction] 移動方向
  /// Returns: 移動可能な場合true
  bool canMove(Tetromino tetromino, Board board, MoveDirection direction);

  /// テトリミノを指定方向に回転できるかを判定する
  ///
  /// [tetromino] 回転対象のテトリミノ
  /// [board] 現在のボード状態
  /// [direction] 回転方向
  /// Returns: 回転可能な場合true（ウォールキックなしの場合）
  bool canRotate(Tetromino tetromino, Board board, RotationDirection direction);

  /// テトリミノがロック可能な状態か（下に移動不可）を判定する
  ///
  /// [tetromino] 判定対象のテトリミノ
  /// [board] 現在のボード状態
  /// Returns: ロック可能な場合true
  bool canLock(Tetromino tetromino, Board board);

  /// ゴーストピースの位置（ハードドロップ先）を取得する
  ///
  /// [tetromino] 対象のテトリミノ
  /// [board] 現在のボード状態
  /// Returns: ハードドロップ後のテトリミノ
  Tetromino getGhostPosition(Tetromino tetromino, Board board);
}
