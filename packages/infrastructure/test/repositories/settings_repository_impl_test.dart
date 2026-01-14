import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tetris_domain/tetris_domain.dart';
import 'package:tetris_infrastructure/tetris_infrastructure.dart';

void main() {
  late SettingsRepositoryImpl repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = SettingsRepositoryImpl();
  });

  group('SettingsRepositoryImpl', () {
    group('getSettings', () {
      test('保存されていない場合はデフォルト設定を返す', () async {
        final result = await repository.getSettings();

        expect(result.soundEffectVolume, equals(1.0));
        expect(result.bgmVolume, equals(0.5));
        expect(result.showGhost, isTrue);
        expect(result.isMuted, isFalse);
      });

      test('保存された設定を取得できる', () async {
        final settings = GameSettings(
          soundEffectVolume: 0.7,
          bgmVolume: 0.3,
          showGhost: false,
          isMuted: true,
        );

        SharedPreferences.setMockInitialValues({
          'game_settings': jsonEncode(settings.toJson()),
        });
        repository = SettingsRepositoryImpl();

        final result = await repository.getSettings();

        expect(result.soundEffectVolume, equals(0.7));
        expect(result.bgmVolume, equals(0.3));
        expect(result.showGhost, isFalse);
        expect(result.isMuted, isTrue);
      });

      test('不正なJSONの場合はデフォルト設定を返す', () async {
        SharedPreferences.setMockInitialValues({
          'game_settings': 'invalid json',
        });
        repository = SettingsRepositoryImpl();

        final result = await repository.getSettings();

        expect(result.soundEffectVolume, equals(1.0));
        expect(result.bgmVolume, equals(0.5));
      });
    });

    group('saveSettings', () {
      test('設定を保存できる', () async {
        final settings = GameSettings(
          soundEffectVolume: 0.5,
          bgmVolume: 0.4,
          showGhost: false,
          isMuted: true,
        );

        final result = await repository.saveSettings(settings);

        expect(result, isTrue);

        final saved = await repository.getSettings();
        expect(saved.soundEffectVolume, equals(0.5));
        expect(saved.bgmVolume, equals(0.4));
        expect(saved.showGhost, isFalse);
        expect(saved.isMuted, isTrue);
      });

      test('既存の設定を上書きできる', () async {
        final first = GameSettings(soundEffectVolume: 0.3);
        final second = GameSettings(soundEffectVolume: 0.9);

        await repository.saveSettings(first);
        await repository.saveSettings(second);

        final result = await repository.getSettings();
        expect(result.soundEffectVolume, equals(0.9));
      });
    });

    group('getKeyBindings', () {
      test('保存されていない場合はデフォルトバインドを返す', () async {
        final result = await repository.getKeyBindings();

        expect(result.getKey(GameAction.moveLeft), equals('ArrowLeft'));
        expect(result.getKey(GameAction.moveRight), equals('ArrowRight'));
        expect(result.getKey(GameAction.hardDrop), equals('Space'));
      });

      test('保存されたバインドを取得できる', () async {
        final bindings = KeyBindings(
          bindings: {
            GameAction.moveLeft: 'KeyA',
            GameAction.moveRight: 'KeyD',
          },
        );

        SharedPreferences.setMockInitialValues({
          'key_bindings': jsonEncode(bindings.toJson()),
        });
        repository = SettingsRepositoryImpl();

        final result = await repository.getKeyBindings();

        expect(result.getKey(GameAction.moveLeft), equals('KeyA'));
        expect(result.getKey(GameAction.moveRight), equals('KeyD'));
      });

      test('不正なJSONの場合はデフォルトバインドを返す', () async {
        SharedPreferences.setMockInitialValues({
          'key_bindings': 'invalid json',
        });
        repository = SettingsRepositoryImpl();

        final result = await repository.getKeyBindings();

        expect(result.getKey(GameAction.moveLeft), equals('ArrowLeft'));
      });
    });

    group('saveKeyBindings', () {
      test('バインドを保存できる', () async {
        final bindings = KeyBindings(
          bindings: {
            GameAction.moveLeft: 'KeyA',
            GameAction.moveRight: 'KeyD',
            GameAction.softDrop: 'KeyS',
            GameAction.hardDrop: 'KeyW',
          },
        );

        final result = await repository.saveKeyBindings(bindings);

        expect(result, isTrue);

        final saved = await repository.getKeyBindings();
        expect(saved.getKey(GameAction.moveLeft), equals('KeyA'));
        expect(saved.getKey(GameAction.moveRight), equals('KeyD'));
        expect(saved.getKey(GameAction.softDrop), equals('KeyS'));
        expect(saved.getKey(GameAction.hardDrop), equals('KeyW'));
      });
    });

    group('resetToDefaults', () {
      test('全ての設定をデフォルトにリセットできる', () async {
        // 設定を保存
        await repository.saveSettings(
          GameSettings(soundEffectVolume: 0.1, bgmVolume: 0.1),
        );
        await repository.saveKeyBindings(
          KeyBindings(bindings: {GameAction.moveLeft: 'KeyA'}),
        );

        // リセット
        final result = await repository.resetToDefaults();
        expect(result, isTrue);

        // デフォルトに戻っていることを確認
        final settings = await repository.getSettings();
        expect(settings.soundEffectVolume, equals(1.0));
        expect(settings.bgmVolume, equals(0.5));

        final bindings = await repository.getKeyBindings();
        expect(bindings.getKey(GameAction.moveLeft), equals('ArrowLeft'));
      });
    });
  });
}
