import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tetris_domain/tetris_domain.dart';
import 'package:tetris_infrastructure/tetris_infrastructure.dart';

/// SettingsRepository Provider
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl();
});

/// GameSettings状態管理用Notifier
class GameSettingsNotifier extends StateNotifier<AsyncValue<GameSettings>> {
  /// GameSettingsNotifierを生成
  GameSettingsNotifier(this._repository) : super(const AsyncValue.loading()) {
    unawaited(_loadSettings());
  }

  final SettingsRepository _repository;

  Future<void> _loadSettings() async {
    state = const AsyncValue.loading();
    try {
      final settings = await _repository.getSettings();
      state = AsyncValue.data(settings);
    } on Object catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 設定を更新
  Future<void> updateSettings(GameSettings settings) async {
    await _repository.saveSettings(settings);
    state = AsyncValue.data(settings);
  }

  /// BGM音量を更新
  Future<void> updateBgmVolume(double volume) async {
    final current = state.valueOrNull ?? GameSettings();
    final updated = current.copyWith(bgmVolume: volume);
    await updateSettings(updated);
  }

  /// SE音量を更新
  Future<void> updateSoundEffectVolume(double volume) async {
    final current = state.valueOrNull ?? GameSettings();
    final updated = current.copyWith(soundEffectVolume: volume);
    await updateSettings(updated);
  }

  /// ゴースト表示を更新
  Future<void> updateShowGhost({required bool show}) async {
    final current = state.valueOrNull ?? GameSettings();
    final updated = current.copyWith(showGhost: show);
    await updateSettings(updated);
  }

  /// ミュート状態を更新
  Future<void> updateIsMuted({required bool muted}) async {
    final current = state.valueOrNull ?? GameSettings();
    final updated = current.copyWith(isMuted: muted);
    await updateSettings(updated);
  }

  /// 設定をデフォルトにリセット
  Future<void> resetToDefaults() async {
    await _repository.resetToDefaults();
    await _loadSettings();
  }
}

/// GameSettings Provider
final gameSettingsProvider =
    StateNotifierProvider<GameSettingsNotifier, AsyncValue<GameSettings>>(
      (ref) {
        final repository = ref.watch(settingsRepositoryProvider);
        return GameSettingsNotifier(repository);
      },
    );
