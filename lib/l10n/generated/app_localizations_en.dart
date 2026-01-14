// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flame Tetris';

  @override
  String get titleTetris => 'TETRIS';

  @override
  String get titleSubtitle => 'FLAME EDITION';

  @override
  String get menuStart => 'START';

  @override
  String get menuHighScore => 'HIGH SCORE';

  @override
  String get menuSettings => 'SETTINGS';

  @override
  String get copyright => '© 2026 Flame Tetris';

  @override
  String get labelScore => 'SCORE';

  @override
  String get labelLevel => 'LEVEL';

  @override
  String get labelLines => 'LINES';

  @override
  String get labelNext => 'NEXT';

  @override
  String get labelHold => 'HOLD';

  @override
  String get gameOver => 'GAME OVER';

  @override
  String get newHighScore => 'NEW HIGH SCORE!';

  @override
  String get buttonRetry => 'RETRY';

  @override
  String get buttonTitle => 'TITLE';

  @override
  String get paused => 'PAUSED';

  @override
  String get buttonResume => 'RESUME';

  @override
  String get buttonQuit => 'QUIT';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get settingsAudio => 'Audio';

  @override
  String get settingsBgmVolume => 'BGM Volume';

  @override
  String get settingsSeVolume => 'SE Volume';

  @override
  String get settingsMuteAll => 'Mute All';

  @override
  String get settingsGameplay => 'Gameplay';

  @override
  String get settingsGhostPiece => 'Ghost Piece';

  @override
  String get settingsResetDefaults => 'RESET TO DEFAULTS';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get dialogResetTitle => 'Reset Settings?';

  @override
  String get dialogResetContent =>
      'This will reset all settings to their default values.';

  @override
  String get dialogCancel => 'CANCEL';

  @override
  String get dialogReset => 'RESET';

  @override
  String get snackbarSettingsReset => 'Settings reset to defaults';

  @override
  String get errorLoadSettings => 'Failed to load settings';

  @override
  String get highScoreDialogTitle => 'HIGH SCORE';

  @override
  String get highScoreNoRecord => 'No high score yet';

  @override
  String get highScoreDate => 'Date';

  @override
  String get buttonClose => 'CLOSE';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get pauseHint => 'Press ESC or P to resume';

  @override
  String get highScorePlayPrompt => 'Play a game to set your first record.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageJapanese => 'Japanese';
}
