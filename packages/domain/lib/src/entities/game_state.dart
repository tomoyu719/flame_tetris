import 'package:meta/meta.dart';

import '../enums/enums.dart';
import 'board.dart';
import 'tetromino.dart';

/// ゲーム全体の状態を表すイミュータブルなクラス
///
/// ボード、現在のテトリミノ、ホールド、NEXT、スコア、レベル等を保持
@immutable
class GameState {
  /// 全フィールドを指定してGameStateを生成
  const GameState({
    required this.board,
    required this.currentTetromino,
    required this.heldTetromino,
    required this.nextQueue,
    required this.score,
    required this.level,
    required this.linesCleared,
    required this.status,
    required this.canHold,
  });

  /// 初期状態のGameStateを生成
  factory GameState.initial() {
    return GameState(
      board: Board.empty(),
      currentTetromino: null,
      heldTetromino: null,
      nextQueue: const [],
      score: 0,
      level: 1,
      linesCleared: 0,
      status: GameStatus.ready,
      canHold: true,
    );
  }

  /// ゲームボード
  final Board board;

  /// 現在操作中のテトリミノ
  final Tetromino? currentTetromino;

  /// ホールド中のテトリミノ
  final Tetromino? heldTetromino;

  /// 次に来るテトリミノのキュー（最大3個表示）
  final List<TetrominoType> nextQueue;

  /// 現在のスコア
  final int score;

  /// 現在のレベル（1〜15）
  final int level;

  /// 消去したライン数の累計
  final int linesCleared;

  /// ゲームの状態
  final GameStatus status;

  /// ホールドが可能かどうか（1ターン1回の制限）
  final bool canHold;

  /// ゲームオーバーかどうか
  bool get isGameOver => status == GameStatus.gameOver;

  /// プレイ中かどうか
  bool get isPlaying => status == GameStatus.playing;

  /// 一時停止中かどうか
  bool get isPaused => status == GameStatus.paused;

  /// 指定されたフィールドのみを変更した新しいGameStateを返す
  GameState copyWith({
    Board? board,
    Tetromino? currentTetromino,
    Tetromino? heldTetromino,
    List<TetrominoType>? nextQueue,
    int? score,
    int? level,
    int? linesCleared,
    GameStatus? status,
    bool? canHold,
    // nullを明示的に設定するためのフラグ
    bool clearCurrentTetromino = false,
    bool clearHeldTetromino = false,
  }) {
    return GameState(
      board: board ?? this.board,
      currentTetromino: clearCurrentTetromino
          ? null
          : (currentTetromino ?? this.currentTetromino),
      heldTetromino: clearHeldTetromino
          ? null
          : (heldTetromino ?? this.heldTetromino),
      nextQueue: nextQueue ?? this.nextQueue,
      score: score ?? this.score,
      level: level ?? this.level,
      linesCleared: linesCleared ?? this.linesCleared,
      status: status ?? this.status,
      canHold: canHold ?? this.canHold,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GameState) return false;

    return other.board == board &&
        other.currentTetromino == currentTetromino &&
        other.heldTetromino == heldTetromino &&
        _listEquals(other.nextQueue, nextQueue) &&
        other.score == score &&
        other.level == level &&
        other.linesCleared == linesCleared &&
        other.status == status &&
        other.canHold == canHold;
  }

  @override
  int get hashCode => Object.hash(
        board,
        currentTetromino,
        heldTetromino,
        Object.hashAll(nextQueue),
        score,
        level,
        linesCleared,
        status,
        canHold,
      );

  @override
  String toString() =>
      'GameState(score: $score, level: $level, status: $status)';
}

/// リストの等価性を比較するヘルパー関数
bool _listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
