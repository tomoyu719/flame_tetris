import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tetris_domain/tetris_domain.dart';
import 'package:tetris_infrastructure/tetris_infrastructure.dart';
import 'package:tetris_presentation/tetris_presentation.dart';

import 'l10n/generated/app_localizations.dart';

void main() {
  runApp(
    const ProviderScope(
      child: TetrisApp(),
    ),
  );
}

/// スコアリポジトリProvider
final scoreRepositoryProvider = Provider<ScoreRepositoryImpl>((ref) {
  return ScoreRepositoryImpl();
});

/// オーディオサービスProvider
final audioServiceProvider = Provider<AudioService>((ref) {
  return AudioServiceImpl();
});

/// アプリルーターProvider
final appRouterProvider = Provider<GoRouter>((ref) {
  return createAppRouter(
    gameBuilder: (context) => const GamePage(),
  );
});

/// テトリスアプリのルートウィジェット
class TetrisApp extends ConsumerWidget {
  /// TetrisAppを生成
  const TetrisApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Flame Tetris',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: AppTheme.toThemeMode(themeMode),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      builder: (context, child) {
        final appL10n = AppLocalizations.of(context);
        return TetrisL10nProvider(
          l10n: appL10n != null
              ? TetrisL10n(
                  appTitle: appL10n.appTitle,
                  titleTetris: appL10n.titleTetris,
                  titleSubtitle: appL10n.titleSubtitle,
                  menuStart: appL10n.menuStart,
                  menuHighScore: appL10n.menuHighScore,
                  menuSettings: appL10n.menuSettings,
                  copyright: appL10n.copyright,
                  labelScore: appL10n.labelScore,
                  labelLevel: appL10n.labelLevel,
                  labelLines: appL10n.labelLines,
                  labelNext: appL10n.labelNext,
                  labelHold: appL10n.labelHold,
                  gameOver: appL10n.gameOver,
                  newHighScore: appL10n.newHighScore,
                  buttonRetry: appL10n.buttonRetry,
                  buttonTitle: appL10n.buttonTitle,
                  paused: appL10n.paused,
                  buttonResume: appL10n.buttonResume,
                  buttonQuit: appL10n.buttonQuit,
                  settingsTitle: appL10n.settingsTitle,
                  settingsAudio: appL10n.settingsAudio,
                  settingsBgmVolume: appL10n.settingsBgmVolume,
                  settingsSeVolume: appL10n.settingsSeVolume,
                  settingsMuteAll: appL10n.settingsMuteAll,
                  settingsGameplay: appL10n.settingsGameplay,
                  settingsGhostPiece: appL10n.settingsGhostPiece,
                  settingsResetDefaults: appL10n.settingsResetDefaults,
                  settingsVersion: appL10n.settingsVersion('1.0.0'),
                  dialogResetTitle: appL10n.dialogResetTitle,
                  dialogResetContent: appL10n.dialogResetContent,
                  dialogCancel: appL10n.dialogCancel,
                  dialogReset: appL10n.dialogReset,
                  snackbarSettingsReset: appL10n.snackbarSettingsReset,
                  errorLoadSettings: appL10n.errorLoadSettings,
                  highScoreDialogTitle: appL10n.highScoreDialogTitle,
                  highScoreNoRecord: appL10n.highScoreNoRecord,
                  highScoreDate: appL10n.highScoreDate,
                  buttonClose: appL10n.buttonClose,
                  pauseHint: appL10n.pauseHint,
                  highScorePlayPrompt: appL10n.highScorePlayPrompt,
                  settingsAppearance: appL10n.settingsAppearance,
                  settingsTheme: appL10n.settingsTheme,
                  settingsThemeDark: appL10n.settingsThemeDark,
                  settingsThemeLight: appL10n.settingsThemeLight,
                  settingsThemeSystem: appL10n.settingsThemeSystem,
                  settingsLanguage: appL10n.settingsLanguage,
                  settingsLanguageEnglish: appL10n.settingsLanguageEnglish,
                  settingsLanguageJapanese: appL10n.settingsLanguageJapanese,
                )
              : const TetrisL10n(),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

/// ゲームページ
class GamePage extends ConsumerStatefulWidget {
  /// GamePageを生成
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  late TetrisGame _game;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    final controller = ref.read(gameControllerProvider);
    final audioService = ref.read(audioServiceProvider);
    _game = TetrisGame(
      controller: controller,
      autoStart: true,
      audioService: audioService,
    );

    // ゲーム状態変更時のコールバック
    _game.onStateChanged = (state) {
      if (mounted) {
        setState(() {
          _isPaused = _game.isPaused;
        });

        // ゲームオーバー時の処理
        if (_game.isGameOver) {
          unawaited(_handleGameOver(state));
        }
      }
    };
  }

  Future<void> _handleGameOver(GameState state) async {
    final repository = ref.read(scoreRepositoryProvider);

    // ハイスコア判定
    final isNewHighScore = await repository.isHighScore(state.score);

    // ハイスコアなら保存
    if (isNewHighScore) {
      await repository.saveHighScore(
        HighScore(
          score: state.score,
          level: state.level,
          linesCleared: state.linesCleared,
          achievedAt: DateTime.now(),
        ),
      );
    }

    // ゲームオーバー画面に遷移
    if (mounted) {
      context.goToGameOver(
        score: state.score,
        level: state.level,
        linesCleared: state.linesCleared,
        isNewHighScore: isNewHighScore,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameScreen(game: _game),
        if (_isPaused)
          PauseOverlay(
            onResume: () {
              _game.resumeGame();
            },
          ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
