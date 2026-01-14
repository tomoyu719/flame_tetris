import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tetris_domain/tetris_domain.dart';
import 'package:tetris_infrastructure/tetris_infrastructure.dart';
import 'package:tetris_presentation/tetris_presentation.dart';

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

    return MaterialApp.router(
      title: 'Flame Tetris',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F1F),
      ),
      routerConfig: router,
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
    _game = TetrisGame(
      controller: controller,
      autoStart: true,
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
