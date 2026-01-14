import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tetris_domain/tetris_domain.dart';

import 'package:tetris_presentation/src/l10n/tetris_l10n.dart';
import 'package:tetris_presentation/src/providers/settings_provider.dart';
import 'package:tetris_presentation/src/router/app_router.dart';
import 'package:tetris_presentation/src/widgets/responsive_layout.dart';
import 'package:tetris_presentation/src/widgets/toggle_setting.dart';
import 'package:tetris_presentation/src/widgets/volume_slider.dart';

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
        loading: () => Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: theme.colorScheme.error,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.errorLoadSettings,
                style: theme.textTheme.bodyMedium,
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
        data: (settings) => LayoutBuilder(
          builder: (context, constraints) {
            final deviceType = ResponsiveLayout.getDeviceType(
              constraints.maxWidth,
            );
            return _SettingsContent(
              settings: settings,
              l10n: l10n,
              deviceType: deviceType,
            );
          },
        ),
      ),
    );
  }
}

/// 設定コンテンツ
class _SettingsContent extends ConsumerWidget {
  const _SettingsContent({
    required this.settings,
    required this.l10n,
    required this.deviceType,
  });

  final GameSettings settings;
  final TetrisL10n l10n;
  final DeviceType deviceType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = ResponsiveSpacing.medium(deviceType);
    final sectionSpacing = ResponsiveSpacing.large(deviceType);
    final maxContentWidth = _getMaxContentWidth();

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: ListView(
          padding: EdgeInsets.all(padding),
          children: [
            // オーディオセクション
            _buildSectionHeader(context, l10n.settingsAudio),
            SizedBox(height: padding * 0.5),

            VolumeSlider(
              label: l10n.settingsBgmVolume,
              value: settings.bgmVolume,
              onChanged: (value) {
                unawaited(
                  ref
                      .read(gameSettingsProvider.notifier)
                      .updateBgmVolume(value),
                );
              },
            ),

            VolumeSlider(
              label: l10n.settingsSeVolume,
              value: settings.soundEffectVolume,
              onChanged: (value) {
                unawaited(
                  ref
                      .read(gameSettingsProvider.notifier)
                      .updateSoundEffectVolume(value),
                );
              },
            ),

            ToggleSetting(
              label: l10n.settingsMuteAll,
              value: settings.isMuted,
              onChanged: (value) {
                unawaited(
                  ref
                      .read(gameSettingsProvider.notifier)
                      .updateIsMuted(muted: value),
                );
              },
            ),

            SizedBox(height: sectionSpacing),

            // ゲームプレイセクション
            _buildSectionHeader(context, l10n.settingsGameplay),
            SizedBox(height: padding * 0.5),

            ToggleSetting(
              label: l10n.settingsGhostPiece,
              value: settings.showGhost,
              onChanged: (value) {
                unawaited(
                  ref
                      .read(gameSettingsProvider.notifier)
                      .updateShowGhost(show: value),
                );
              },
            ),

            SizedBox(height: sectionSpacing * 1.5),

            // リセットボタン
            _buildResetButton(context, ref),

            SizedBox(height: padding),

            // バージョン情報
            Center(
              child: Text(
                l10n.settingsVersion,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: ResponsiveFontSize.caption(deviceType),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getMaxContentWidth() {
    switch (deviceType) {
      case DeviceType.mobile:
        return double.infinity;
      case DeviceType.tablet:
        return 500;
      case DeviceType.desktop:
        return 600;
    }
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    final fontSize = ResponsiveFontSize.body(deviceType);

    return Row(
      children: [
        Container(
          width: 4,
          height: fontSize + 4,
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
            fontSize: fontSize,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildResetButton(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final buttonWidth = _getResetButtonWidth();

    return Center(
      child: SizedBox(
        width: buttonWidth,
        child: OutlinedButton(
          onPressed: () => _showResetConfirmDialog(context, ref),
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
            side: BorderSide(color: theme.colorScheme.error),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(
            l10n.settingsResetDefaults,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontSize: ResponsiveFontSize.body(deviceType),
            ),
          ),
        ),
      ),
    );
  }

  double _getResetButtonWidth() {
    switch (deviceType) {
      case DeviceType.mobile:
        return 200;
      case DeviceType.tablet:
        return 240;
      case DeviceType.desktop:
        return 280;
    }
  }

  void _showResetConfirmDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    unawaited(
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
                unawaited(
                  ref.read(gameSettingsProvider.notifier).resetToDefaults(),
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.snackbarSettingsReset),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              child: Text(l10n.dialogReset),
            ),
          ],
        ),
      ),
    );
  }
}
