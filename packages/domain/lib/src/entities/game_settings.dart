import 'package:meta/meta.dart';

/// ゲーム設定を表すエンティティ
///
/// 音量設定、ゴースト表示、ミュート状態などを保持する。
/// イミュータブルで、変更はcopyWithを使用する。
@immutable
class GameSettings {
  /// GameSettingsを生成
  ///
  /// 音量は0.0-1.0の範囲にクランプされる。
  GameSettings({
    double soundEffectVolume = 1.0,
    double bgmVolume = 0.5,
    this.showGhost = true,
    this.isMuted = false,
  })  : soundEffectVolume = soundEffectVolume.clamp(0.0, 1.0),
        bgmVolume = bgmVolume.clamp(0.0, 1.0);

  /// JSONからGameSettingsを生成
  factory GameSettings.fromJson(Map<String, dynamic> json) {
    return GameSettings(
      soundEffectVolume: (json['soundEffectVolume'] as num?)?.toDouble() ?? 1.0,
      bgmVolume: (json['bgmVolume'] as num?)?.toDouble() ?? 0.5,
      showGhost: json['showGhost'] as bool? ?? true,
      isMuted: json['isMuted'] as bool? ?? false,
    );
  }

  /// 効果音の音量（0.0-1.0）
  final double soundEffectVolume;

  /// BGMの音量（0.0-1.0）
  final double bgmVolume;

  /// ゴーストピースを表示するか
  final bool showGhost;

  /// ミュート状態か
  final bool isMuted;

  /// 指定したフィールドを変更した新しいGameSettingsを返す
  GameSettings copyWith({
    double? soundEffectVolume,
    double? bgmVolume,
    bool? showGhost,
    bool? isMuted,
  }) {
    return GameSettings(
      soundEffectVolume: soundEffectVolume ?? this.soundEffectVolume,
      bgmVolume: bgmVolume ?? this.bgmVolume,
      showGhost: showGhost ?? this.showGhost,
      isMuted: isMuted ?? this.isMuted,
    );
  }

  /// JSONに変換
  Map<String, dynamic> toJson() {
    return {
      'soundEffectVolume': soundEffectVolume,
      'bgmVolume': bgmVolume,
      'showGhost': showGhost,
      'isMuted': isMuted,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameSettings &&
        other.soundEffectVolume == soundEffectVolume &&
        other.bgmVolume == bgmVolume &&
        other.showGhost == showGhost &&
        other.isMuted == isMuted;
  }

  @override
  int get hashCode {
    return Object.hash(soundEffectVolume, bgmVolume, showGhost, isMuted);
  }

  @override
  String toString() {
    return 'GameSettings('
        'soundEffectVolume: $soundEffectVolume, '
        'bgmVolume: $bgmVolume, '
        'showGhost: $showGhost, '
        'isMuted: $isMuted)';
  }
}
