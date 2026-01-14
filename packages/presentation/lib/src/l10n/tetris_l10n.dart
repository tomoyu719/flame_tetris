import 'package:flutter/widgets.dart';

/// テトリスゲームのローカライズ文字列
///
/// InheritedWidgetを通じてウィジェットツリーに提供される。
/// main.dartでTetrisL10nProviderを使ってAppLocalizationsの値を注入する。
class TetrisL10n {
  /// TetrisL10nを生成
  const TetrisL10n({
    this.appTitle = 'Flame Tetris',
    this.titleTetris = 'TETRIS',
    this.titleSubtitle = 'FLAME EDITION',
    this.menuStart = 'START',
    this.menuHighScore = 'HIGH SCORE',
    this.menuSettings = 'SETTINGS',
    this.copyright = '© 2026 Flame Tetris',
    this.labelScore = 'SCORE',
    this.labelLevel = 'LEVEL',
    this.labelLines = 'LINES',
    this.labelNext = 'NEXT',
    this.labelHold = 'HOLD',
    this.gameOver = 'GAME OVER',
    this.newHighScore = 'NEW HIGH SCORE!',
    this.buttonRetry = 'RETRY',
    this.buttonTitle = 'TITLE',
    this.paused = 'PAUSED',
    this.buttonResume = 'RESUME',
    this.buttonQuit = 'QUIT',
    this.settingsTitle = 'SETTINGS',
    this.settingsAudio = 'Audio',
    this.settingsBgmVolume = 'BGM Volume',
    this.settingsSeVolume = 'SE Volume',
    this.settingsMuteAll = 'Mute All',
    this.settingsGameplay = 'Gameplay',
    this.settingsGhostPiece = 'Ghost Piece',
    this.settingsResetDefaults = 'RESET TO DEFAULTS',
    this.settingsVersion = 'Version 1.0.0',
    this.dialogResetTitle = 'Reset Settings?',
    this.dialogResetContent =
        'This will reset all settings to their default values.',
    this.dialogCancel = 'CANCEL',
    this.dialogReset = 'RESET',
    this.snackbarSettingsReset = 'Settings reset to defaults',
    this.errorLoadSettings = 'Failed to load settings',
    this.highScoreDialogTitle = 'HIGH SCORE',
    this.highScoreNoRecord = 'No high score yet',
    this.highScoreDate = 'Date',
    this.buttonClose = 'CLOSE',
    this.pauseHint = 'Press ESC or P to resume',
    this.highScorePlayPrompt = 'Play a game to set your first record.',
    this.settingsAppearance = 'Appearance',
    this.settingsTheme = 'Theme',
    this.settingsThemeDark = 'Dark',
    this.settingsThemeLight = 'Light',
    this.settingsThemeSystem = 'System',
    this.settingsLanguage = 'Language',
    this.settingsLanguageEnglish = 'English',
    this.settingsLanguageJapanese = 'Japanese',
  });

  /// アプリタイトル
  final String appTitle;

  /// タイトル：TETRIS
  final String titleTetris;

  /// タイトル：サブタイトル
  final String titleSubtitle;

  /// メニュー：スタート
  final String menuStart;

  /// メニュー：ハイスコア
  final String menuHighScore;

  /// メニュー：設定
  final String menuSettings;

  /// コピーライト
  final String copyright;

  /// ラベル：スコア
  final String labelScore;

  /// ラベル：レベル
  final String labelLevel;

  /// ラベル：ライン
  final String labelLines;

  /// ラベル：次
  final String labelNext;

  /// ラベル：ホールド
  final String labelHold;

  /// ゲームオーバー
  final String gameOver;

  /// 新記録
  final String newHighScore;

  /// ボタン：リトライ
  final String buttonRetry;

  /// ボタン：タイトル
  final String buttonTitle;

  /// 一時停止
  final String paused;

  /// ボタン：再開
  final String buttonResume;

  /// ボタン：終了
  final String buttonQuit;

  /// 設定タイトル
  final String settingsTitle;

  /// 設定：オーディオ
  final String settingsAudio;

  /// 設定：BGM音量
  final String settingsBgmVolume;

  /// 設定：効果音音量
  final String settingsSeVolume;

  /// 設定：ミュート
  final String settingsMuteAll;

  /// 設定：ゲームプレイ
  final String settingsGameplay;

  /// 設定：ゴーストピース
  final String settingsGhostPiece;

  /// 設定：デフォルトにリセット
  final String settingsResetDefaults;

  /// 設定：バージョン
  final String settingsVersion;

  /// ダイアログ：リセット確認タイトル
  final String dialogResetTitle;

  /// ダイアログ：リセット確認内容
  final String dialogResetContent;

  /// ダイアログ：キャンセル
  final String dialogCancel;

  /// ダイアログ：リセット
  final String dialogReset;

  /// スナックバー：設定リセット
  final String snackbarSettingsReset;

  /// エラー：設定読み込み失敗
  final String errorLoadSettings;

  /// ハイスコアダイアログタイトル
  final String highScoreDialogTitle;

  /// ハイスコア：記録なし
  final String highScoreNoRecord;

  /// ハイスコア：日付
  final String highScoreDate;

  /// ボタン：閉じる
  final String buttonClose;

  /// 一時停止ヒント
  final String pauseHint;

  /// ハイスコア：プレイ促進
  final String highScorePlayPrompt;

  /// 設定：外観
  final String settingsAppearance;

  /// 設定：テーマ
  final String settingsTheme;

  /// 設定：ダークテーマ
  final String settingsThemeDark;

  /// 設定：ライトテーマ
  final String settingsThemeLight;

  /// 設定：システムテーマ
  final String settingsThemeSystem;

  /// 設定：言語
  final String settingsLanguage;

  /// 設定：英語
  final String settingsLanguageEnglish;

  /// 設定：日本語
  final String settingsLanguageJapanese;
}

/// TetrisL10nをウィジェットツリーに提供するInheritedWidget
class TetrisL10nProvider extends InheritedWidget {
  /// TetrisL10nProviderを生成
  const TetrisL10nProvider({
    required this.l10n,
    required super.child,
    super.key,
  });

  /// ローカライズ文字列
  final TetrisL10n l10n;

  /// BuildContextからTetrisL10nを取得
  static TetrisL10n of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<TetrisL10nProvider>();
    return provider?.l10n ?? const TetrisL10n();
  }

  @override
  bool updateShouldNotify(TetrisL10nProvider oldWidget) {
    return l10n != oldWidget.l10n;
  }
}

/// BuildContextからローカライズ文字列を取得する拡張
extension TetrisL10nExtension on BuildContext {
  /// ローカライズ文字列を取得
  TetrisL10n get l10n => TetrisL10nProvider.of(this);
}
