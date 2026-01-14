import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme.dart';

/// テーマ設定状態管理用Notifier
class ThemeNotifier extends StateNotifier<TetrisThemeMode> {
  /// ThemeNotifierを生成
  ThemeNotifier() : super(TetrisThemeMode.dark);

  /// テーマモードを設定
  void setThemeMode(TetrisThemeMode mode) {
    state = mode;
  }

  /// ダークモードに切り替え
  void setDark() => state = TetrisThemeMode.dark;

  /// ライトモードに切り替え
  void setLight() => state = TetrisThemeMode.light;

  /// システム設定に従う
  void setSystem() => state = TetrisThemeMode.system;

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
final themeProvider =
    StateNotifierProvider<ThemeNotifier, TetrisThemeMode>((ref) {
  return ThemeNotifier();
});
