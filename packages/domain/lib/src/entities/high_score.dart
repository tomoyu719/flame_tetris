import 'package:meta/meta.dart';

/// ハイスコアを表すエンティティ
///
/// ゲーム終了時のスコア、レベル、消去ライン数、達成日時を保持する。
@immutable
class HighScore {
  /// HighScoreを生成
  ///
  /// [score]: スコア（0以上）
  /// [level]: 到達レベル（1以上）
  /// [linesCleared]: 消去ライン数（0以上）
  /// [achievedAt]: 達成日時
  HighScore({
    required this.score,
    required this.level,
    required this.linesCleared,
    required this.achievedAt,
  })  : assert(score >= 0, 'スコアは0以上である必要があります'),
        assert(level >= 1, 'レベルは1以上である必要があります'),
        assert(linesCleared >= 0, 'ライン数は0以上である必要があります');

  /// 空のハイスコアを生成
  ///
  /// 初期状態やハイスコアが存在しない場合に使用する。
  factory HighScore.empty() {
    return HighScore(
      score: 0,
      level: 1,
      linesCleared: 0,
      achievedAt: DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  /// JSONからHighScoreを生成
  factory HighScore.fromJson(Map<String, dynamic> json) {
    return HighScore(
      score: json['score'] as int,
      level: json['level'] as int,
      linesCleared: json['linesCleared'] as int,
      achievedAt: DateTime.parse(json['achievedAt'] as String),
    );
  }

  /// スコア
  final int score;

  /// 到達レベル
  final int level;

  /// 消去ライン数
  final int linesCleared;

  /// 達成日時
  final DateTime achievedAt;

  /// このスコアが[other]より高いかどうか
  bool isHigherThan(HighScore other) {
    return score > other.score;
  }

  /// 一部のフィールドを変更したコピーを作成
  HighScore copyWith({
    int? score,
    int? level,
    int? linesCleared,
    DateTime? achievedAt,
  }) {
    return HighScore(
      score: score ?? this.score,
      level: level ?? this.level,
      linesCleared: linesCleared ?? this.linesCleared,
      achievedAt: achievedAt ?? this.achievedAt,
    );
  }

  /// JSON形式に変換
  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'level': level,
      'linesCleared': linesCleared,
      'achievedAt': achievedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HighScore &&
        other.score == score &&
        other.level == level &&
        other.linesCleared == linesCleared &&
        other.achievedAt == achievedAt;
  }

  @override
  int get hashCode {
    return Object.hash(score, level, linesCleared, achievedAt);
  }

  @override
  String toString() {
    return 'HighScore(score: $score, level: $level, '
        'linesCleared: $linesCleared, achievedAt: $achievedAt)';
  }
}
