import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// テトリスゲームのテーマモード
enum TetrisThemeMode {
  /// ダークモード
  dark,

  /// ライトモード
  light,

  /// システム設定に従う
  system,
}

/// テトリスゲームのカラーパレット
class TetrisColors {
  const TetrisColors._();

  /// シアン（Iミノ）
  static const Color cyan = Color(0xFF00BCD4);

  /// パープル（Tミノ）
  static const Color purple = Color(0xFF9C27B0);

  /// オレンジ（Lミノ）
  static const Color orange = Color(0xFFFF9800);

  /// レッド（Zミノ）
  static const Color red = Color(0xFFF44336);

  /// グリーン（Sミノ）
  static const Color green = Color(0xFF4CAF50);

  /// アンバー（Oミノ）
  static const Color amber = Color(0xFFFFC107);

  /// ブルー（Jミノ）
  static const Color blue = Color(0xFF2196F3);

  /// ダークテーマの背景色
  static const Color darkBackground = Color(0xFF0F0F1F);

  /// ダークテーマのサーフェス色
  static const Color darkSurface = Color(0xFF1A1A2E);

  /// ダークテーマのカード色
  static const Color darkCard = Color(0xFF16213E);

  /// ライトテーマの背景色
  static const Color lightBackground = Color(0xFFF5F5F5);

  /// ライトテーマのサーフェス色
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// ライトテーマのカード色
  static const Color lightCard = Color(0xFFE0E0E0);
}

/// アプリケーションテーマ定義
class AppTheme {
  const AppTheme._();

  /// ダークテーマ
  static ThemeData get dark {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: TetrisColors.darkBackground,
      primaryColor: TetrisColors.cyan,
      colorScheme: const ColorScheme.dark(
        primary: TetrisColors.cyan,
        secondary: TetrisColors.purple,
        surface: TetrisColors.darkSurface,
        error: TetrisColors.red,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 4,
        ),
        iconTheme: IconThemeData(color: TetrisColors.cyan),
      ),
      cardTheme: CardThemeData(
        color: TetrisColors.darkCard,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: TetrisColors.cyan.withValues(alpha: 0.2),
          foregroundColor: TetrisColors.cyan,
          side: const BorderSide(color: TetrisColors.cyan, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: TetrisColors.cyan,
          side: const BorderSide(color: TetrisColors.cyan),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: TetrisColors.cyan,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: TetrisColors.cyan,
        inactiveTrackColor: Colors.grey[800],
        thumbColor: TetrisColors.cyan,
        overlayColor: TetrisColors.cyan.withValues(alpha: 0.2),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TetrisColors.cyan;
          }
          return Colors.grey[400];
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TetrisColors.cyan.withValues(alpha: 0.5);
          }
          return Colors.grey[800];
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: TetrisColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: TetrisColors.darkCard,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      iconTheme: const IconThemeData(
        color: TetrisColors.cyan,
      ),
      textTheme: _buildTextTheme(isDark: true),
    );
  }

  /// ライトテーマ
  static ThemeData get light {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: TetrisColors.lightBackground,
      primaryColor: TetrisColors.blue,
      colorScheme: const ColorScheme.light(
        primary: TetrisColors.blue,
        secondary: TetrisColors.purple,
        error: TetrisColors.red,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: TetrisColors.lightSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 4,
        ),
        iconTheme: IconThemeData(color: TetrisColors.blue),
      ),
      cardTheme: CardThemeData(
        color: TetrisColors.lightCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: TetrisColors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: TetrisColors.blue,
          side: const BorderSide(color: TetrisColors.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: TetrisColors.blue,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: TetrisColors.blue,
        inactiveTrackColor: Colors.grey[300],
        thumbColor: TetrisColors.blue,
        overlayColor: TetrisColors.blue.withValues(alpha: 0.2),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TetrisColors.blue;
          }
          return Colors.grey[400];
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TetrisColors.blue.withValues(alpha: 0.5);
          }
          return Colors.grey[300];
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: TetrisColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 16,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey[800],
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      iconTheme: const IconThemeData(
        color: TetrisColors.blue,
      ),
      textTheme: _buildTextTheme(isDark: false),
    );
  }

  /// ピクセルフォントを使用したTextThemeを構築
  static TextTheme _buildTextTheme({required bool isDark}) {
    final color = isDark ? Colors.white : Colors.black87;
    final colorSecondary = isDark ? Colors.white70 : Colors.black54;

    return TextTheme(
      displayLarge: GoogleFonts.pressStart2p(
        color: color,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.pressStart2p(
        color: color,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.pressStart2p(
        color: color,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.pressStart2p(
        color: color,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.pressStart2p(
        color: color,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.pressStart2p(
        color: color,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: GoogleFonts.pressStart2p(
        color: color,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.pressStart2p(color: color),
      bodyMedium: GoogleFonts.pressStart2p(color: colorSecondary),
      bodySmall: GoogleFonts.pressStart2p(color: colorSecondary),
      labelLarge: GoogleFonts.pressStart2p(
        color: color,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: GoogleFonts.pressStart2p(color: color),
      labelSmall: GoogleFonts.pressStart2p(color: colorSecondary),
    );
  }

  /// テーマモードからThemeModeを取得
  static ThemeMode toThemeMode(TetrisThemeMode mode) {
    switch (mode) {
      case TetrisThemeMode.dark:
        return ThemeMode.dark;
      case TetrisThemeMode.light:
        return ThemeMode.light;
      case TetrisThemeMode.system:
        return ThemeMode.system;
    }
  }
}
