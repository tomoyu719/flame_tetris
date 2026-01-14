import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/tetris_l10n.dart';
import '../router/app_router.dart';
import '../widgets/high_score_dialog.dart';
import '../widgets/responsive_layout.dart';

/// タイトル画面
///
/// ゲーム開始、設定、ハイスコア表示へのナビゲーションを提供する。
class TitleScreen extends ConsumerWidget {
  /// TitleScreenを生成
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final deviceType =
                ResponsiveLayout.getDeviceType(constraints.maxWidth);

            return Center(
              child: SingleChildScrollView(
                child: _TitleContent(
                  l10n: l10n,
                  deviceType: deviceType,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// タイトルコンテンツ
class _TitleContent extends StatelessWidget {
  const _TitleContent({
    required this.l10n,
    required this.deviceType,
  });

  final TetrisL10n l10n;
  final DeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveSpacing.large(deviceType);
    final extraLargeSpacing = ResponsiveSpacing.extraLarge(deviceType);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // タイトルロゴ
        _TitleLogo(l10n: l10n, deviceType: deviceType),
        SizedBox(height: extraLargeSpacing),

        // メニューボタン
        _MenuButton(
          label: l10n.menuStart,
          onPressed: () => context.goToGame(),
          deviceType: deviceType,
        ),
        SizedBox(height: spacing * 0.5),

        _MenuButton(
          label: l10n.menuHighScore,
          onPressed: () => _showHighScoreDialog(context),
          deviceType: deviceType,
        ),
        SizedBox(height: spacing * 0.5),

        _MenuButton(
          label: l10n.menuSettings,
          onPressed: () => context.goToSettings(),
          deviceType: deviceType,
        ),

        SizedBox(height: extraLargeSpacing),

        // クレジット
        Text(
          l10n.copyright,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: ResponsiveFontSize.caption(deviceType),
              ),
        ),
      ],
    );
  }

  void _showHighScoreDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => const HighScoreDialog(),
    );
  }
}

/// タイトルロゴ
class _TitleLogo extends StatelessWidget {
  const _TitleLogo({
    required this.l10n,
    required this.deviceType,
  });

  final TetrisL10n l10n;
  final DeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blockSize = _getBlockSize();
    final titleFontSize = ResponsiveFontSize.headlineLarge(deviceType);
    final subtitleFontSize = ResponsiveFontSize.caption(deviceType);

    return Column(
      children: [
        // テトリスブロック風のアイコン（Iピース）
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            4,
            (_) => _buildBlock(theme.colorScheme.primary, blockSize),
          ),
        ),
        SizedBox(height: ResponsiveSpacing.medium(deviceType)),
        // タイトルテキスト
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
              theme.colorScheme.tertiary,
            ],
          ).createShader(bounds),
          child: Text(
            l10n.titleTetris,
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: titleFontSize,
              letterSpacing: 4,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.titleSubtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: subtitleFontSize,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  double _getBlockSize() {
    switch (deviceType) {
      case DeviceType.mobile:
        return 20;
      case DeviceType.tablet:
        return 28;
      case DeviceType.desktop:
        return 32;
    }
  }

  Widget _buildBlock(Color color, double size) {
    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.all(size * 0.08),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.15),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: size * 0.25,
            spreadRadius: size * 0.04,
          ),
        ],
      ),
    );
  }
}

/// メニューボタン
class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.onPressed,
    required this.deviceType,
  });

  final String label;
  final VoidCallback onPressed;
  final DeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonWidth = _getButtonWidth();
    final buttonHeight = _getButtonHeight();
    final fontSize = ResponsiveFontSize.body(deviceType);

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: theme.colorScheme.onSurface,
          side: BorderSide(color: theme.colorScheme.primary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontSize: fontSize,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  double _getButtonWidth() {
    switch (deviceType) {
      case DeviceType.mobile:
        return 180;
      case DeviceType.tablet:
        return 220;
      case DeviceType.desktop:
        return 260;
    }
  }

  double _getButtonHeight() {
    switch (deviceType) {
      case DeviceType.mobile:
        return 44;
      case DeviceType.tablet:
        return 50;
      case DeviceType.desktop:
        return 56;
    }
  }
}
