import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tetris_domain/tetris_domain.dart';

import '../l10n/tetris_l10n.dart';
import '../providers/settings_provider.dart';
import '../router/app_router.dart';
import '../widgets/toggle_setting.dart';
import '../widgets/volume_slider.dart';

/// 設定画面
///
/// BGM/SE音量、ゴースト表示、ハイスコアリセットなどの設定を提供する。
class SettingsScreen extends ConsumerWidget {
  /// SettingsScreenを生成
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(gameSettingsProvider);
    final l10n = context.l10n;

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => context.goToTitle(),
        ),
        title: Text(
          l10n.settingsTitle,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 16,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: settingsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.cyan),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                l10n.errorLoadSettings,
                style: TextStyle(color: Colors.grey[400]),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(gameSettingsProvider.notifier).resetToDefaults(),
                child: Text(l10n.settingsResetDefaults),
              ),
            ],
          ),
        ),
        data: (settings) => _SettingsContent(settings: settings, l10n: l10n),
      ),
    );
  }
}

/// 設定コンテンツ
class _SettingsContent extends ConsumerWidget {
  const _SettingsContent({required this.settings, required this.l10n});

  final GameSettings settings;
  final TetrisL10n l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // オーディオセクション
        _buildSectionHeader(context, l10n.settingsAudio),
        const SizedBox(height: 16),

        VolumeSlider(
          label: l10n.settingsBgmVolume,
          value: settings.bgmVolume,
          onChanged: (value) {
            ref.read(gameSettingsProvider.notifier).updateBgmVolume(value);
          },
        ),

        VolumeSlider(
          label: l10n.settingsSeVolume,
          value: settings.soundEffectVolume,
          onChanged: (value) {
            ref
                .read(gameSettingsProvider.notifier)
                .updateSoundEffectVolume(value);
          },
        ),

        ToggleSetting(
          label: l10n.settingsMuteAll,
          value: settings.isMuted,
          onChanged: (value) {
            ref.read(gameSettingsProvider.notifier).updateIsMuted(value);
          },
        ),

        const SizedBox(height: 32),

        // ゲームプレイセクション
        _buildSectionHeader(context, l10n.settingsGameplay),
        const SizedBox(height: 16),

        ToggleSetting(
          label: l10n.settingsGhostPiece,
          value: settings.showGhost,
          onChanged: (value) {
            ref.read(gameSettingsProvider.notifier).updateShowGhost(value);
          },
        ),

        const SizedBox(height: 48),

        // リセットボタン
        _buildResetButton(context, ref),

        const SizedBox(height: 24),

        // バージョン情報
        Center(
          child: Text(
            l10n.settingsVersion,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 8,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildResetButton(BuildContext context, WidgetRef ref) {
    return Center(
      child: SizedBox(
        width: 200,
        child: OutlinedButton(
          onPressed: () => _showResetConfirmDialog(context, ref),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(
            l10n.settingsResetDefaults,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  void _showResetConfirmDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.dialogResetTitle,
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 12),
        ),
        content: Text(
          l10n.dialogResetContent,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 10),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.dialogCancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(gameSettingsProvider.notifier).resetToDefaults();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.snackbarSettingsReset),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.dialogReset),
          ),
        ],
      ),
    );
  }
}
