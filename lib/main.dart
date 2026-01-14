import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tetris_presentation/tetris_presentation.dart';

void main() {
  runApp(
    const ProviderScope(
      child: TetrisApp(),
    ),
  );
}

/// テトリスアプリのルートウィジェット
class TetrisApp extends StatelessWidget {
  /// TetrisAppを生成
  const TetrisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flame Tetris',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F1F),
      ),
      home: const GamePage(),
    );
  }
}

/// ゲームページ
class GamePage extends ConsumerWidget {
  /// GamePageを生成
  const GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(tetrisGameProvider);

    return GameScreen(game: game);
  }
}
