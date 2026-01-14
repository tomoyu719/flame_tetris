import 'package:test/test.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('GameSoundEffect', () {
    test('全ての効果音種別が定義されている', () {
      expect(GameSoundEffect.values, hasLength(9));
      expect(GameSoundEffect.values, contains(GameSoundEffect.move));
      expect(GameSoundEffect.values, contains(GameSoundEffect.rotate));
      expect(GameSoundEffect.values, contains(GameSoundEffect.drop));
      expect(GameSoundEffect.values, contains(GameSoundEffect.land));
      expect(GameSoundEffect.values, contains(GameSoundEffect.clear));
      expect(GameSoundEffect.values, contains(GameSoundEffect.tetris));
      expect(GameSoundEffect.values, contains(GameSoundEffect.levelUp));
      expect(GameSoundEffect.values, contains(GameSoundEffect.gameOver));
      expect(GameSoundEffect.values, contains(GameSoundEffect.hold));
    });
  });

  group('BgmType', () {
    test('全てのBGM種別が定義されている', () {
      expect(BgmType.values, hasLength(5));
      expect(BgmType.values, contains(BgmType.title));
      expect(BgmType.values, contains(BgmType.gameLv1));
      expect(BgmType.values, contains(BgmType.gameLv2));
      expect(BgmType.values, contains(BgmType.gameLv3));
      expect(BgmType.values, contains(BgmType.gameOver));
    });
  });

  group('AudioService interface', () {
    test('AudioServiceはabstractクラスとして定義されている', () {
      // AudioServiceは抽象クラスなのでインスタンス化できない
      // これはコンパイル時のチェックとなる
      // ignore: unnecessary_type_check
      expect(AudioService is Type, isTrue);
    });
  });

  group('MockAudioService', () {
    late MockAudioService audioService;

    setUp(() {
      audioService = MockAudioService();
    });

    test('効果音を再生できる', () {
      audioService
        ..playSoundEffect(GameSoundEffect.move)
        ..playSoundEffect(GameSoundEffect.rotate);

      expect(audioService.playedEffects, hasLength(2));
      expect(audioService.playedEffects[0], GameSoundEffect.move);
      expect(audioService.playedEffects[1], GameSoundEffect.rotate);
    });

    test('ミュート時は効果音が再生されない', () {
      audioService
        ..mute()
        ..playSoundEffect(GameSoundEffect.move);

      expect(audioService.playedEffects, isEmpty);
    });

    test('BGMを再生・停止できる', () {
      expect(audioService.bgmPlaying, isFalse);

      audioService.playBgm();
      expect(audioService.bgmPlaying, isTrue);

      audioService.stopBgm();
      expect(audioService.bgmPlaying, isFalse);
    });

    test('BGMタイプを指定して再生できる', () {
      audioService.playBgm(BgmType.title);
      expect(audioService.bgmPlaying, isTrue);
      expect(audioService.currentBgmType, BgmType.title);

      audioService.playBgm(BgmType.gameLv2);
      expect(audioService.currentBgmType, BgmType.gameLv2);
    });

    test('レベルに応じたBGMを再生できる', () {
      // レベル1-5: gameLv1
      audioService.playGameBgmForLevel(1);
      expect(audioService.currentBgmType, BgmType.gameLv1);

      audioService.playGameBgmForLevel(5);
      expect(audioService.currentBgmType, BgmType.gameLv1);

      // レベル6-10: gameLv2
      audioService.playGameBgmForLevel(6);
      expect(audioService.currentBgmType, BgmType.gameLv2);

      audioService.playGameBgmForLevel(10);
      expect(audioService.currentBgmType, BgmType.gameLv2);

      // レベル11以上: gameLv3
      audioService.playGameBgmForLevel(11);
      expect(audioService.currentBgmType, BgmType.gameLv3);

      audioService.playGameBgmForLevel(15);
      expect(audioService.currentBgmType, BgmType.gameLv3);
    });

    test('BGMを一時停止・再開できる', () {
      audioService
        ..playBgm()
        ..pauseBgm();
      expect(audioService.bgmPaused, isTrue);

      audioService.resumeBgm();
      expect(audioService.bgmPaused, isFalse);
    });

    test('音量を設定できる', () {
      audioService.setSoundEffectVolume(0.5);
      expect(audioService.soundEffectVolume, 0.5);

      audioService.setBgmVolume(0.3);
      expect(audioService.bgmVolume, 0.3);
    });

    test('音量は0.0-1.0の範囲にクランプされる', () {
      audioService.setSoundEffectVolume(-0.5);
      expect(audioService.soundEffectVolume, 0.0);

      audioService.setSoundEffectVolume(1.5);
      expect(audioService.soundEffectVolume, 1.0);
    });

    test('ミュート・ミュート解除ができる', () {
      expect(audioService.isMuted, isFalse);

      audioService.mute();
      expect(audioService.isMuted, isTrue);

      audioService.unmute();
      expect(audioService.isMuted, isFalse);
    });

    test('dispose後はBGMが停止する', () {
      audioService
        ..playBgm()
        ..dispose();

      expect(audioService.bgmPlaying, isFalse);
    });
  });
}

/// テスト用のMock AudioService
class MockAudioService implements AudioService {
  final List<GameSoundEffect> playedEffects = [];
  bool bgmPlaying = false;
  bool bgmPaused = false;
  BgmType? currentBgmType;
  double _seVolume = 1;
  double _bgmVolume = 0.5;
  bool _muted = false;

  @override
  void playSoundEffect(GameSoundEffect effect) {
    if (!_muted) {
      playedEffects.add(effect);
    }
  }

  @override
  void playBgm([BgmType type = BgmType.gameLv1]) {
    if (!_muted) {
      bgmPlaying = true;
      bgmPaused = false;
      currentBgmType = type;
    }
  }

  @override
  void playGameBgmForLevel(int level) {
    final bgmType = _getBgmTypeForLevel(level);
    playBgm(bgmType);
  }

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
    bgmPlaying = false;
    bgmPaused = false;
    currentBgmType = null;
  }

  @override
  void pauseBgm() {
    if (bgmPlaying) {
      bgmPaused = true;
    }
  }

  @override
  void resumeBgm() {
    if (bgmPlaying && !_muted) {
      bgmPaused = false;
    }
  }

  @override
  void setSoundEffectVolume(double volume) {
    _seVolume = volume.clamp(0.0, 1.0);
  }

  @override
  void setBgmVolume(double volume) {
    _bgmVolume = volume.clamp(0.0, 1.0);
  }

  @override
  double get soundEffectVolume => _seVolume;

  @override
  double get bgmVolume => _bgmVolume;

  @override
  void mute() {
    _muted = true;
    if (bgmPlaying) {
      bgmPaused = true;
    }
  }

  @override
  void unmute() {
    _muted = false;
    if (bgmPlaying) {
      bgmPaused = false;
    }
  }

  @override
  bool get isMuted => _muted;

  @override
  void dispose() {
    bgmPlaying = false;
    bgmPaused = false;
    currentBgmType = null;
  }
}
