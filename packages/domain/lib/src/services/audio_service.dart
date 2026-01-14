/// ゲームオーディオのイベント種別
enum GameSoundEffect {
  /// テトロミノ移動
  move,

  /// テトロミノ回転
  rotate,

  /// ハードドロップ
  drop,

  /// テトロミノ着地（ロック）
  land,

  /// ライン消去（1-3ライン）
  clear,

  /// テトリス（4ライン消去）
  tetris,

  /// レベルアップ
  levelUp,

  /// ゲームオーバー
  gameOver,

  /// ホールド
  hold,
}

/// BGMの種別
enum BgmType {
  /// タイトル画面
  title,

  /// ゲームプレイ（レベル1-5）
  gameLv1,

  /// ゲームプレイ（レベル6-10）
  gameLv2,

  /// ゲームプレイ（レベル11以上）
  gameLv3,

  /// ゲームオーバー/エンディング
  gameOver,
}

/// オーディオサービスのインターフェース
///
/// ゲームの効果音・BGM再生を抽象化する。
/// Domain層はこのインターフェースに依存し、
/// 実装はInfrastructure層で行う。
abstract class AudioService {
  /// 効果音を再生
  void playSoundEffect(GameSoundEffect effect);

  /// 指定したBGMを再生開始
  void playBgm([BgmType type = BgmType.gameLv1]);

  /// レベルに応じたゲームBGMを再生
  ///
  /// レベル1-5: gameLv1, レベル6-10: gameLv2, レベル11以上: gameLv3
  void playGameBgmForLevel(int level);

  /// BGMを停止
  void stopBgm();

  /// BGMを一時停止
  void pauseBgm();

  /// BGMを再開
  void resumeBgm();

  /// 効果音の音量を設定（0.0-1.0）
  void setSoundEffectVolume(double volume);

  /// BGMの音量を設定（0.0-1.0）
  void setBgmVolume(double volume);

  /// 効果音の音量を取得
  double get soundEffectVolume;

  /// BGMの音量を取得
  double get bgmVolume;

  /// 全ての音声をミュート
  void mute();

  /// ミュートを解除
  void unmute();

  /// ミュート状態を取得
  bool get isMuted;

  /// リソースを解放
  void dispose();
}
