import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/screens.dart';

/// アプリケーションのルート定義
class AppRoutes {
  /// プライベートコンストラクタ
  AppRoutes._();

  /// タイトル画面
  static const String title = '/';

  /// ゲーム画面
  static const String game = '/game';

  /// ゲームオーバー画面
  static const String gameOver = '/game-over';
}

/// アプリケーションルーターを作成
///
/// [gameBuilder]: ゲーム画面のビルダー（TetrisGameを注入するため）
GoRouter createAppRouter({
  required Widget Function(BuildContext context) gameBuilder,
}) {
  return GoRouter(
    initialLocation: AppRoutes.title,
    routes: [
      GoRoute(
        path: AppRoutes.title,
        name: 'title',
        builder: (context, state) => const TitleScreen(),
      ),
      GoRoute(
        path: AppRoutes.game,
        name: 'game',
        builder: (context, state) => gameBuilder(context),
      ),
      GoRoute(
        path: AppRoutes.gameOver,
        name: 'gameOver',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return GameOverScreen(
            score: extra?['score'] as int? ?? 0,
            level: extra?['level'] as int? ?? 1,
            linesCleared: extra?['linesCleared'] as int? ?? 0,
            isNewHighScore: extra?['isNewHighScore'] as bool? ?? false,
          );
        },
      ),
    ],
  );
}

/// ルーティング用のヘルパー拡張
extension AppRouterExtension on BuildContext {
  /// タイトル画面に戻る
  void goToTitle() {
    GoRouter.of(this).go(AppRoutes.title);
  }

  /// ゲーム画面に遷移
  void goToGame() {
    GoRouter.of(this).go(AppRoutes.game);
  }

  /// ゲームオーバー画面に遷移
  void goToGameOver({
    required int score,
    required int level,
    required int linesCleared,
    bool isNewHighScore = false,
  }) {
    GoRouter.of(this).go(
      AppRoutes.gameOver,
      extra: {
        'score': score,
        'level': level,
        'linesCleared': linesCleared,
        'isNewHighScore': isNewHighScore,
      },
    );
  }
}
