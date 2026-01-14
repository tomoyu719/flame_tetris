import 'package:flame_audio/flame_audio.dart';
import 'package:tetris_domain/tetris_domain.dart';

/// AudioServiceのflame_audio実装
///
/// flame_audioを使用してゲームの効果音とBGMを再生する。
class AudioServiceImpl implements AudioService {
  /// AudioServiceImplを生成
  AudioServiceImpl();

  double _soundEffectVolume = 1.0;
  double _bgmVolume = 0.5;
  bool _isMuted = false;
  bool _isBgmPlaying = false;
  BgmType? _currentBgmType;

  /// 効果音ファイルのマッピング
  static const Map<GameSoundEffect, String> _soundEffectFiles = {
    GameSoundEffect.move: 'se/move.wav',
    GameSoundEffect.rotate: 'se/rotate.wav',
    GameSoundEffect.drop: 'se/drop.wav',
    GameSoundEffect.land: 'se/land.wav',
    GameSoundEffect.clear: 'se/clear.wav',
    GameSoundEffect.tetris: 'se/tetris.wav',
    GameSoundEffect.levelUp: 'se/levelup.wav',
    GameSoundEffect.gameOver: 'se/gameover.wav',
    GameSoundEffect.hold: 'se/hold.wav',
  };

  /// BGMファイルのマッピング
  static const Map<BgmType, String> _bgmFiles = {
    BgmType.title: 'bgm/title.wav',
    BgmType.gameLv1: 'bgm/game_lv1.wav',
    BgmType.gameLv2: 'bgm/game_lv2.wav',
    BgmType.gameLv3: 'bgm/game_lv3.wav',
    BgmType.gameOver: 'bgm/gameover.wav',
  };

  @override
  void playSoundEffect(GameSoundEffect effect) {
    if (_isMuted) return;

    final file = _soundEffectFiles[effect];
    if (file != null) {
      FlameAudio.play(file, volume: _soundEffectVolume);
    }
  }

  @override
  void playBgm([BgmType type = BgmType.gameLv1]) {
    if (_isMuted) return;

    // 同じBGMが既に再生中なら何もしない
    if (_isBgmPlaying && _currentBgmType == type) return;

    // 現在のBGMを停止
    if (_isBgmPlaying) {
      FlameAudio.bgm.stop();
    }

    final file = _bgmFiles[type];
    if (file != null) {
      FlameAudio.bgm.play(file, volume: _bgmVolume);
      _isBgmPlaying = true;
      _currentBgmType = type;
    }
  }

  @override
  void playGameBgmForLevel(int level) {
    final bgmType = _getBgmTypeForLevel(level);
    playBgm(bgmType);
  }

  /// レベルに応じたBGMタイプを取得
  BgmType _getBgmTypeForLevel(int level) {
    if (level <= 5) {
      return BgmType.gameLv1;
    } else if (level <= 10) {
      return BgmType.gameLv2;
    } else {
      return BgmType.gameLv3;
    }
  }

  @override
  void stopBgm() {
    _isBgmPlaying = false;
    _currentBgmType = null;
    FlameAudio.bgm.stop();
  }

  @override
  void pauseBgm() {
    if (_isBgmPlaying) {
      FlameAudio.bgm.pause();
    }
  }

  @override
  void resumeBgm() {
    if (_isBgmPlaying && !_isMuted) {
      FlameAudio.bgm.resume();
    }
  }

  @override
  void setSoundEffectVolume(double volume) {
    _soundEffectVolume = volume.clamp(0.0, 1.0);
  }

  @override
  void setBgmVolume(double volume) {
    _bgmVolume = volume.clamp(0.0, 1.0);
    // BGM再生中なら音量を更新
    // FlameAudio.bgm は直接音量変更できないため、
    // 次回再生時に反映される
  }

  @override
  double get soundEffectVolume => _soundEffectVolume;

  @override
  double get bgmVolume => _bgmVolume;

  @override
  void mute() {
    _isMuted = true;
    if (_isBgmPlaying) {
      FlameAudio.bgm.pause();
    }
  }

  @override
  void unmute() {
    _isMuted = false;
    if (_isBgmPlaying) {
      FlameAudio.bgm.resume();
    }
  }

  @override
  bool get isMuted => _isMuted;

  @override
  void dispose() {
    FlameAudio.bgm.stop();
    FlameAudio.bgm.dispose();
  }
}
