// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'フレイム テトリス';

  @override
  String get titleTetris => 'テトリス';

  @override
  String get titleSubtitle => 'フレイム エディション';

  @override
  String get menuStart => 'スタート';

  @override
  String get menuHighScore => 'ハイスコア';

  @override
  String get menuSettings => '設定';

  @override
  String get copyright => '© 2026 Flame Tetris';

  @override
  String get labelScore => 'スコア';

  @override
  String get labelLevel => 'レベル';

  @override
  String get labelLines => 'ライン';

  @override
  String get labelNext => '次';

  @override
  String get labelHold => 'ホールド';

  @override
  String get gameOver => 'ゲームオーバー';

  @override
  String get newHighScore => '新記録！';

  @override
  String get buttonRetry => 'リトライ';

  @override
  String get buttonTitle => 'タイトル';

  @override
  String get paused => '一時停止';

  @override
  String get buttonResume => '再開';

  @override
  String get buttonQuit => '終了';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsAudio => 'オーディオ';

  @override
  String get settingsBgmVolume => 'BGM音量';

  @override
  String get settingsSeVolume => '効果音音量';

  @override
  String get settingsMuteAll => 'すべてミュート';

  @override
  String get settingsGameplay => 'ゲームプレイ';

  @override
  String get settingsGhostPiece => 'ゴーストピース';

  @override
  String get settingsResetDefaults => '初期設定に戻す';

  @override
  String settingsVersion(String version) {
    return 'バージョン $version';
  }

  @override
  String get dialogResetTitle => '設定をリセット';

  @override
  String get dialogResetContent => 'すべての設定を初期値に戻します。';

  @override
  String get dialogCancel => 'キャンセル';

  @override
  String get dialogReset => 'リセット';

  @override
  String get snackbarSettingsReset => '設定を初期値に戻しました';

  @override
  String get errorLoadSettings => '設定の読み込みに失敗しました';

  @override
  String get highScoreDialogTitle => 'ハイスコア';

  @override
  String get highScoreNoRecord => '記録がありません';

  @override
  String get highScoreDate => '日付';

  @override
  String get buttonClose => '閉じる';

  @override
  String get settingsAppearance => '外観';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get settingsThemeDark => 'ダーク';

  @override
  String get settingsThemeLight => 'ライト';

  @override
  String get settingsThemeSystem => 'システム';

  @override
  String get pauseHint => 'ESCまたはPキーで再開';

  @override
  String get highScorePlayPrompt => 'ゲームをプレイして記録を作ろう！';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLanguageEnglish => '英語';

  @override
  String get settingsLanguageJapanese => '日本語';
}
