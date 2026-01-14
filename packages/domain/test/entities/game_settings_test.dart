import 'package:test/test.dart';
import 'package:tetris_domain/tetris_domain.dart';

void main() {
  group('GameSettings', () {
    group('コンストラクタ', () {
      test('デフォルト値で生成できる', () {
        final settings = GameSettings();

        expect(settings.soundEffectVolume, 1.0);
        expect(settings.bgmVolume, 0.5);
        expect(settings.showGhost, true);
        expect(settings.isMuted, false);
      });

      test('カスタム値で生成できる', () {
        final settings = GameSettings(
          soundEffectVolume: 0.8,
          bgmVolume: 0.3,
          showGhost: false,
          isMuted: true,
        );

        expect(settings.soundEffectVolume, 0.8);
        expect(settings.bgmVolume, 0.3);
        expect(settings.showGhost, false);
        expect(settings.isMuted, true);
      });

      test('音量は0.0-1.0の範囲にクランプされる', () {
        final settingsLow = GameSettings(
          soundEffectVolume: -0.5,
          bgmVolume: -1,
        );
        expect(settingsLow.soundEffectVolume, 0.0);
        expect(settingsLow.bgmVolume, 0.0);

        final settingsHigh = GameSettings(
          soundEffectVolume: 1.5,
          bgmVolume: 2,
        );
        expect(settingsHigh.soundEffectVolume, 1.0);
        expect(settingsHigh.bgmVolume, 1.0);
      });
    });

    group('copyWith', () {
      test('soundEffectVolumeのみ変更できる', () {
        final original = GameSettings();
        final modified = original.copyWith(soundEffectVolume: 0.5);

        expect(modified.soundEffectVolume, 0.5);
        expect(modified.bgmVolume, original.bgmVolume);
        expect(modified.showGhost, original.showGhost);
        expect(modified.isMuted, original.isMuted);
      });

      test('bgmVolumeのみ変更できる', () {
        final original = GameSettings();
        final modified = original.copyWith(bgmVolume: 0.7);

        expect(modified.bgmVolume, 0.7);
        expect(modified.soundEffectVolume, original.soundEffectVolume);
      });

      test('showGhostのみ変更できる', () {
        final original = GameSettings();
        final modified = original.copyWith(showGhost: false);

        expect(modified.showGhost, false);
        expect(modified.soundEffectVolume, original.soundEffectVolume);
      });

      test('isMutedのみ変更できる', () {
        final original = GameSettings();
        final modified = original.copyWith(isMuted: true);

        expect(modified.isMuted, true);
        expect(modified.soundEffectVolume, original.soundEffectVolume);
      });

      test('複数の値を同時に変更できる', () {
        final original = GameSettings();
        final modified = original.copyWith(
          soundEffectVolume: 0.3,
          bgmVolume: 0.4,
          showGhost: false,
          isMuted: true,
        );

        expect(modified.soundEffectVolume, 0.3);
        expect(modified.bgmVolume, 0.4);
        expect(modified.showGhost, false);
        expect(modified.isMuted, true);
      });

      test('copyWithでも音量はクランプされる', () {
        final original = GameSettings();
        final modified = original.copyWith(
          soundEffectVolume: 1.5,
          bgmVolume: -0.5,
        );

        expect(modified.soundEffectVolume, 1.0);
        expect(modified.bgmVolume, 0.0);
      });
    });

    group('JSON変換', () {
      test('toJsonで正しくシリアライズできる', () {
        final settings = GameSettings(
          soundEffectVolume: 0.8,
          bgmVolume: 0.6,
          showGhost: false,
          isMuted: true,
        );

        final json = settings.toJson();

        expect(json['soundEffectVolume'], 0.8);
        expect(json['bgmVolume'], 0.6);
        expect(json['showGhost'], false);
        expect(json['isMuted'], true);
      });

      test('fromJsonで正しくデシリアライズできる', () {
        final json = {
          'soundEffectVolume': 0.7,
          'bgmVolume': 0.4,
          'showGhost': false,
          'isMuted': true,
        };

        final settings = GameSettings.fromJson(json);

        expect(settings.soundEffectVolume, 0.7);
        expect(settings.bgmVolume, 0.4);
        expect(settings.showGhost, false);
        expect(settings.isMuted, true);
      });

      test('fromJsonでキーが欠けている場合はデフォルト値を使用', () {
        final json = <String, dynamic>{};

        final settings = GameSettings.fromJson(json);

        expect(settings.soundEffectVolume, 1.0);
        expect(settings.bgmVolume, 0.5);
        expect(settings.showGhost, true);
        expect(settings.isMuted, false);
      });

      test('toJson→fromJsonで往復できる', () {
        final original = GameSettings(
          soundEffectVolume: 0.9,
          bgmVolume: 0.2,
          showGhost: false,
          isMuted: true,
        );

        final restored = GameSettings.fromJson(original.toJson());

        expect(restored.soundEffectVolume, original.soundEffectVolume);
        expect(restored.bgmVolume, original.bgmVolume);
        expect(restored.showGhost, original.showGhost);
        expect(restored.isMuted, original.isMuted);
      });
    });

    group('等価性', () {
      test('同じ値のGameSettingsは等しい', () {
        final settings1 = GameSettings(
          soundEffectVolume: 0.5,
          bgmVolume: 0.3,
        );
        final settings2 = GameSettings(
          soundEffectVolume: 0.5,
          bgmVolume: 0.3,
        );

        expect(settings1, equals(settings2));
        expect(settings1.hashCode, equals(settings2.hashCode));
      });

      test('異なる値のGameSettingsは等しくない', () {
        final settings1 = GameSettings(soundEffectVolume: 0.5);
        final settings2 = GameSettings(soundEffectVolume: 0.6);

        expect(settings1, isNot(equals(settings2)));
      });
    });
  });
}
