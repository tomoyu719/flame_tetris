import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tetris_presentation/src/theme/app_theme.dart';

/// テーマ設定状態管理用Notifier
class ThemeNotifier extends StateNotifier<TetrisThemeMode> {
  /// ThemeNotifierを生成
  ThemeNotifier() : super(TetrisThemeMode.dark);

  /// テーマをトグル（dark <-> light）
  void toggle() {
    if (state == TetrisThemeMode.dark) {
      state = TetrisThemeMode.light;
    } else {
      state = TetrisThemeMode.dark;
    }
  }
}

/// テーマモードProvider
final themeProvider = StateNotifierProvider<ThemeNotifier, TetrisThemeMode>((
  ref,
) {
  return ThemeNotifier();
});
